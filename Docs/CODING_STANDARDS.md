# Coding Standards: Project 25 - Meeting Notes Organizer

Applies to all Swift code in this project. Based on the project guidelines: MVVM design,
one responsibility per file, modular features, SwiftUI navigation and state management, no warnings.

## 1. Project setup
- Platform: iOS (iPhone/iPad) and macOS ("My Mac" via Mac Catalyst / native destinations).
- Language: Swift 5.9+. Deployment target: iOS 16.0 / macOS 13.0 or later.
- UI framework: SwiftUI only. No storyboards or XIBs.
- Cross-platform UI: use `#if os(iOS)` or cross-platform view helpers (`inlineNavigationBarTitle()`, `emailInputConfiguration()`, `.leadingBarItem`, `.trailingBarItem`, `secondarySystemCardBackground`) rather than platform-locked UIKit symbols (`navigationBarTitleDisplayMode`, `UIColor`).
- Every target build must finish with **0 errors and 0 warnings**.
- App icon is mandatory (AppIcon asset with a 1024 x 1024 image).
- Images: use SF Symbols or lightweight PNG/JPEG assets. Keep asset files small.

## 2. Architecture (MVVM)
| Layer | Folder | Allowed to contain | Not allowed |
|---|---|---|---|
| Model | `Core/Models` | Plain `struct`/`enum` data, computed read-only values | UI imports (SwiftUI), storage code |
| Services | `Core/Services` | Persistence, biometrics, Keychain authentication | Views, view-state |
| Utilities | `Core/Utilities` | Pure helpers (validation, string extensions, sample data) | Stored app state |
| ViewModel | `Core/Utilities/Features/<Feature>/ViewModels` | `@MainActor` `ObservableObject`, `@Published` state, validation, business rules | Layout code, `View` types |
| View | `Core/Utilities/Features/<Feature>/Views` | SwiftUI views, layout, user-event forwarding | Business rules, direct storage calls |
| Shared UI | `Shared/Components` & `Shared/Extensions` | Reusable views and cross-platform extensions | Feature-specific logic |

Rules:
- Views never write to `MeetingStore` directly. They call a ViewModel method.
- ViewModels never import SwiftUI (they use `Combine` and `Foundation` only).
- All ViewModels are annotated with `@MainActor`.
- Each feature folder is self-contained: its own `Views` and `ViewModels`.
- Do not put more than one screen or one ViewModel in a single file.

## 3. Naming
- Types: `UpperCamelCase` (`MeetingListViewModel`, `ActionStatus`).
- Properties, functions, and enum cases: `lowerCamelCase`.
- Screens end with `View` (`MeetingDetailView`). ViewModels end with `ViewModel`.
- Services describe what they do (`MeetingStore`, `BiometricService`, `LocalAuthService`).
- Boolean names read as statements: `isAuthenticated`, `showingEdit`, `isEditing`, `isOverdue`.
- Avoid abbreviations except widely known ones (`ID`, `URL`).

## 4. Formatting
- Indent with 4 spaces. One blank line between members.
- Maximum line length about 120 characters. Break long modifier chains onto separate lines.
- One type per file. File name equals the type name.
- Use trailing closures for single closure parameters.
- Use `private` for everything that is not part of a type's public surface.

## 5. Documentation
- Every type and every public or non-obvious method has a `///` documentation comment.
- Use `// MARK:` to separate sections in longer files (e.g., `// MARK: - Properties`, `// MARK: - Initialization`, `// MARK: - Actions`).
- Comments explain *why*, not *what*. Do not leave commented-out code.

## 6. SwiftUI and state management
- `@StateObject` when a view creates its ViewModel. `@ObservedObject` when a parent passes it in.
- `@EnvironmentObject` for app-wide objects (`MeetingStore`, `AuthViewModel`).
- `@State` only for view-local UI flags (for example `showingEdit`, `showingAddMeeting`).
- `@FocusState` for keyboard focus.
- Lists use stable identities (`Identifiable` with `UUID`). Never use array indices as IDs.
- Navigation uses `NavigationStack` with value-based `NavigationLink(value:)` and `navigationDestination(for:)`.
- Modal screens (Add, Edit) use `.sheet` and their own `NavigationStack` for toolbar buttons.
- Use semantic toolbar placements (`.cancellationAction`, `.confirmationAction`, `.trailingBarItem`, `.leadingBarItem`).

## 7. Data handling and errors
- Model types conform to `Codable` and `Equatable` when stored or compared.
- Use `Result` or enums with associated values for expected failures (login, biometrics).
- Use `do/catch` for I/O and decoding.
- Never use force unwrapping (`!`) or force try (`try!`).
- Use `guard let` for early exit. Avoid deep nesting.
- **Data Safety & Recovery**: If `meetings.json` exists but cannot be decoded, `MeetingStore` creates a timestamped safety backup (`meetings_backup_<timestamp>.json`) in the same folder before resetting to an empty list, and publishes `dataRecoveryNotice` with user dismissal on the Dashboard.

## 8. Validation
- All validation lives in the ViewModel (or `Validators`). Views only show the message.
- Required fields: title, attendees (at least one), owner for each action item, email, password.
- Email format is checked with `Validators.isValidEmail`.
- Password minimum length: 6 characters.

## 9. Security
- Never hard-code passwords or secrets.
- Biometric checks use `LAContext.deviceOwnerAuthenticationWithBiometrics` and handle every failure.
- Local manual credentials are encrypted using SHA-256 and stored exclusively in the Apple Keychain using `SecItemAdd`, `SecItemCopyMatching`, `SecItemDelete`, and `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`.
- Support manual account reset via `resetAccount()` to purge stored Keychain entries.
- Logging out clears the in-memory password, sets `isAuthenticated = false`, and presents the manual login form.

## 10. Unit Testing
- Unit tests live in the `MeetingNotesOrganizerTests` target.
- Test suites must cover:
  - Email format validation (`EmailValidationTests`).
  - Action item overdue calculations (`ActionItemOverdueTests`).
  - Meeting form validation & persistence on save (`MeetingFormViewModelTests`).
  - Meeting list search queries and project filtering (`MeetingListViewModelTests`).
- Tests that require storage use a temporary file URL (`NSTemporaryDirectory()`) rather than the live Documents directory.
