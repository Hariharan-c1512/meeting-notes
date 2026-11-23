# Project 25: Meeting Notes Organizer (SwiftUI)

Architecture: MVVM, modular features, SwiftUI navigation and state management.
See `Docs/CODING_STANDARDS.md` for coding rules and `Explanation_and_Sample_Outputs.pdf` for the full walkthrough.

## Requirements
- Xcode 15 or later (tested on Xcode 27)
- Deployment target: iOS 16.0 or later, macOS 13.0 or later
- Supported destinations: iPhone, iPad, and "My Mac" (via Mac Catalyst / multi-platform)

## Opening and Running in Xcode
1. Open `MeetingNotesOrganizer.xcodeproj` in Xcode.
2. Select your desired destination (e.g., **iPhone 17**, **iPhone 18 Pro**, or **My Mac**).
3. Press **Cmd + R** to run the app.
4. Press **Cmd + U** to run all unit tests.

## Upgraded Architecture & Features

### 1. Keychain-Backed Authentication
- Replaced insecure `UserDefaults` storage in `LocalAuthService` with Apple's secure Keychain APIs (`SecItemAdd`, `SecItemCopyMatching`, `SecItemDelete`).
- Accessible attribute set to `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`.
- Supports resetting saved credentials via `resetAccount()` and the **Reset Saved Login** button on the manual login form.

### 2. Session Logout
- Added **Log Out** button to the Dashboard toolbar.
- Located in `AuthViewModel`, logging out sets `isAuthenticated = false`, clears the in-memory password, and immediately reveals the manual login form.

### 3. Action Item Due Dates & Overdue Tracking
- `ActionItem` now includes an optional `dueDate: Date?`, ensuring backward compatibility with older saved meetings.
- Date editor with toggle and `DatePicker` added to action item rows in `MeetingFormView`.
- Due date displays in `MeetingDetailView` in red when overdue (defined as not marked `Done` and due before the current day).
- Total overdue action items are counted and displayed on the Dashboard through `DashboardViewModel`.

### 4. Data Safety & Automatic Recovery
- If `meetings.json` exists on disk but fails to decode, `MeetingStore` automatically copies it to `meetings_backup_<timestamp>.json` before resetting in-memory meetings to an empty list.
- An alert banner is published and displayed on the Dashboard with a **Dismiss** button.

### 5. Cross-Platform Support (iOS & My Mac)
- Replaced iOS-specific modifiers (`navigationBarTitleDisplayMode`, `keyboardType`, `textInputAutocapitalization`) with cross-platform view helpers (`inlineNavigationBarTitle()`, `emailInputConfiguration()`).
- Replaced platform-specific toolbar placements (`.navigationBarLeading`, `.navigationBarTrailing`) with semantic placements (`.cancellationAction`, `.confirmationAction`, `.trailingBarItem`, `.leadingBarItem`).
- Replaced UIKit color `Color(.secondarySystemBackground)` with cross-platform semantic color `Color.secondarySystemCardBackground`.

### 6. Automated Unit Tests
A dedicated `MeetingNotesOrganizerTests` target covers:
- **Email validation**: `EmailValidationTests` verifying valid formats and malformed inputs.
- **Overdue action items**: `ActionItemOverdueTests` verifying past due, future due, today due, done, and nil due dates.
- **MeetingFormViewModel.save()**: `MeetingFormViewModelTests` verifying empty title failure, missing owner failure, and valid persistence with temporary file stores.
- **MeetingListViewModel search & filtering**: `MeetingListViewModelTests` verifying search by title, search by attendee, project filtering, and combined queries.

## Testing Face ID in the Simulator
- Enroll Face ID: **Features > Face ID > Enrolled**.
- Simulate a success: **Features > Face ID > Matching Face**.
- Simulate a failure: **Features > Face ID > Non-matching Face**.
- To test the manual fallback without enrollment, the app falls back automatically (biometry not enrolled).

## First Login
The first email and password you enter on the login screen become the local account stored securely in Keychain. Later logins must match.
Password must be at least 6 characters. Use **Reset Saved Login** at any time to establish a new local account.

## Folder Map
- `App/` entry point, root switch, tab navigation
- `Core/Models/` models (`Meeting`, `ActionItem`, `Project`)
- `Core/Services/` services (`MeetingStore`, `BiometricService`, `LocalAuthService`)
- `Core/Utilities/` validation, string extensions, sample data
- `Core/Utilities/Features/` modular feature folders (Auth, Dashboard, MeetingList, MeetingForm, AddMeeting, MeetingDetail, EditMeeting)
- `Shared/Components/` reusable UI cards and components
- `Shared/Extensions/` cross-platform modifiers and color extensions
- `Resources/` asset catalog with the app icon
- `MeetingNotesOrganizerTests/` complete unit test suite
- `Docs/` coding standards
