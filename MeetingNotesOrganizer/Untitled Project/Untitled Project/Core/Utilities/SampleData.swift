import Foundation

/// Demo meetings used on the first launch and in SwiftUI previews.
enum SampleData {
    static let meetings: [Meeting] = [
        Meeting(
            id: UUID(),
            title: "Q4 Sprint Planning",
            date: Date().addingTimeInterval(-86_400 * 1),
            project: .wiproCoE,
            attendees: ["Asha Rao", "Vikram Shah", "Neha Iyer"],
            discussionPoints: ["Review sprint velocity", "Prioritise onboarding module"],
            decisions: ["Onboarding module moves to Sprint 3"],
            actionItems: [
                ActionItem(id: UUID(), description: "Share updated backlog", owner: "Vikram Shah", status: .inProgress),
                ActionItem(id: UUID(), description: "Book design review", owner: "Neha Iyer", status: .open)
            ]
        ),
        Meeting(
            id: UUID(),
            title: "Research Findings Review",
            date: Date().addingTimeInterval(-86_400 * 4),
            project: .research,
            attendees: ["Asha Rao", "Rahul Menon"],
            discussionPoints: ["Survey results on usability"],
            decisions: ["Run a second round of interviews"],
            actionItems: [
                ActionItem(id: UUID(), description: "Draft interview script", owner: "Rahul Menon", status: .done)
            ]
        ),
        Meeting(
            id: UUID(),
            title: "Annual Day Logistics",
            date: Date().addingTimeInterval(-86_400 * 9),
            project: .events,
            attendees: ["Neha Iyer", "Priya Nair"],
            discussionPoints: ["Venue shortlist", "Budget approval"],
            decisions: ["Venue: Main Auditorium"],
            actionItems: [
                ActionItem(id: UUID(), description: "Confirm catering quote", owner: "Priya Nair", status: .open)
            ]
        )
    ]
}
