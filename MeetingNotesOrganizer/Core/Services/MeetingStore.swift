import Combine
import Foundation

// MARK: - Meeting Store

/// Single source of truth for meeting persistence and state.
/// Keeps meetings in memory (published to SwiftUI views) and saves them to disk as JSON.
@MainActor
final class MeetingStore: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var meetings: [Meeting] = []
    @Published private(set) var dataRecoveryNotice: String?

    // MARK: - Storage Properties

    private let fileURL: URL

    // MARK: - Initialization

    /// Initializes the store with a given file destination.
    /// - Parameter fileURL: Where to save data. Defaults to Documents/meetings.json. Custom URLs can be passed for unit tests.
    init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? MeetingStore.defaultFileURL
        load()
    }

    /// Resolves the default storage URL in the user's Documents directory without force unwrapping.
    static var defaultFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        return documentsDirectory.appendingPathComponent("meetings.json")
    }

    // MARK: - Notice Dismissal

    /// Dismisses the data recovery notice once acknowledged by the user.
    func dismissRecoveryNotice() {
        dataRecoveryNotice = nil
    }

    // MARK: - Meeting Mutations

    /// Adds a new meeting and keeps the list sorted newest first.
    /// - Parameter meeting: The meeting to insert.
    func add(_ meeting: Meeting) {
        meetings.append(meeting)
        sortAndSave()
    }

    /// Replaces the meeting matching the same identifier. Does nothing if not found.
    /// - Parameter meeting: The meeting containing updated values.
    func update(_ meeting: Meeting) {
        guard let index = meetings.firstIndex(where: { $0.id == meeting.id }) else { return }
        meetings[index] = meeting
        sortAndSave()
    }

    /// Removes a meeting permanently.
    /// - Parameter meeting: The meeting to delete.
    func delete(_ meeting: Meeting) {
        meetings.removeAll { $0.id == meeting.id }
        save()
    }

    // MARK: - Persistence

    /// Loads meetings from disk.
    /// If the file does not exist, seeds with SampleData.
    /// If the file exists but fails to decode, creates a safety backup before resetting to an empty list.
    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            meetings = SampleData.meetings
            sortAndSave()
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            meetings = try JSONDecoder().decode([Meeting].self, from: data)
            meetings.sort { $0.date > $1.date }
        } catch {
            print("Failed to decode meetings: \(error). Creating backup.")
            let timestamp = Int(Date().timeIntervalSince1970)
            let backupFileName = "meetings_backup_\(timestamp).json"
            let backupURL = fileURL.deletingLastPathComponent().appendingPathComponent(backupFileName)

            do {
                if FileManager.default.fileExists(atPath: backupURL.path) {
                    try FileManager.default.removeItem(at: backupURL)
                }
                try FileManager.default.copyItem(at: fileURL, to: backupURL)
                dataRecoveryNotice = "Corrupted meeting data was detected. A backup was saved to '\(backupFileName)' and an empty list was started."
            } catch {
                print("Failed to create safety backup: \(error)")
                dataRecoveryNotice = "Corrupted meeting data was detected. Starting with an empty list."
            }

            meetings = []
        }
    }

    /// Sorts meetings by descending date and saves to disk.
    private func sortAndSave() {
        meetings.sort { $0.date > $1.date }
        save()
    }

    /// Encodes and atomically writes the current meeting list to disk.
    private func save() {
        do {
            let data = try JSONEncoder().encode(meetings)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save meetings: \(error)")
        }
    }
}
