import SwiftUI

/// Launch screen: waits for Face ID, then shows the manual login form if needed.
struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @FocusState private var focusedField: LoginField?

    private enum LoginField {
        case email
        case password
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.tint)

                Text("Meeting Notes Organizer")
                    .font(.title2.bold())

                if viewModel.isBiometricFallbackVisible {
                    loginForm
                } else {
                    ProgressView("Waiting for Face ID…")
                }
            }
            .padding(24)
        }
    }

    private var loginForm: some View {
        VStack(spacing: 14) {
            Text("Face ID is unavailable or did not succeed. Log in manually.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .password)

            if let message = viewModel.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button("Log In") {
                viewModel.loginWithCredentials()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)

            Button("Try Face ID Again") {
                Task { await viewModel.authenticateAtLaunch() }
            }
            .buttonStyle(.bordered)
        }
        .onAppear {
            focusedField = .email
        }
    }
}
