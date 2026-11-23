import Combine
import Foundation

/// Single source of truth for meeting data.
/// Keeps the list in memory (published to observers) and saves it as JSON in the Documents folder.
@MainActor
final class MeetingStore: ObservableObject {
    @Published private(set) var meetings: [Meeting] = []

    private let fileURL: URL

    /// - Parameter fileURL: Where to save data. Defaults to Documents/meetings.json. Pass a custom URL in tests.
    init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? MeetingStore.defaultFileURL
        load()
    }

    static var defaultFileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("meetings.json")
    }

    /// Adds a new meeting and keeps the list sorted by date (newest first).
    func add(_ meeting: Meeting) {
        meetings.append(meeting)
        sortAndSave()
    }

    /// Replaces the meeting with the same id. Does nothing if it does not exist.
    func update(_ meeting: Meeting) {
        guard let index = meetings.firstIndex(where: { $0.id == meeting.id }) else { return }
        meetings[index] = meeting
        sortAndSave()
    }

    /// Removes a meeting permanently.
    func delete(_ meeting: Meeting) {
        meetings.removeAll { $0.id == meeting.id }
        save()
    }

    // MARK: - Persistence

    private func load() {
        // First launch: no file yet, so seed sample data so the screens are not empty.
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
            print("Failed to load meetings: \(error)")
        }
    }

    private func sortAndSave() {
        meetings.sort { $0.date > $1.date }
        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(meetings)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save meetings: \(error)")
        }
    }
}
