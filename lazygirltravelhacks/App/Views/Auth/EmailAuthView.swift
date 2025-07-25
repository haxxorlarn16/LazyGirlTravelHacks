import SwiftUI

struct EmailAuthView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isSignUp = false
    @State private var showPassword = false
    @State private var wasSignedIn = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pixelBackground, Color.pixelSurface]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text(isSignUp ? "Create Account" : "Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.pixelPrimary)
                        .shadow(color: .pixelAccent.opacity(0.15), radius: 2, x: 0, y: 2)
                    Text(isSignUp ? "Join the lazy girl travel community" : "Sign in to your account")
                        .font(.subheadline)
                        .foregroundColor(.pixelSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                ScrollView {
                    VStack(spacing: 20) {
                        // Sign Up Fields (only show for sign up)
                        if isSignUp {
                            HStack(spacing: 12) {
                                PixelTextField(
                                    text: $firstName,
                                    placeholder: "First Name",
                                    icon: "person.fill"
                                )
                                PixelTextField(
                                    text: $lastName,
                                    placeholder: "Last Name",
                                    icon: "person.fill"
                                )
                            }
                        }
                        // Email Field
                        PixelTextField(
                            text: $email,
                            placeholder: "Email",
                            icon: "envelope.fill",
                            keyboardType: .emailAddress
                        )
                        // Password Field
                        HStack {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .textFieldStyle(PixelTextFieldStyle())
                                    .padding(.leading, 40)
                            } else {
                                SecureField("Password", text: $password)
                                    .textFieldStyle(PixelTextFieldStyle())
                                    .padding(.leading, 40)
                            }
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.pixelSecondary)
                                    .padding(.trailing, 12)
                            }
                        }
                        .background(Color.pixelSurface)
                        .cornerRadius(12)
                        .overlay(
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.pixelSecondary)
                                    .padding(.leading, 12)
                                Spacer()
                            }
                        )
                        // Error Message
                        if let error = authManager.authError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.pixelPink)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                        // Action Button
                        Button(action: {
                            if isSignUp {
                                authManager.signUpWithEmail(
                                    email: email,
                                    password: password,
                                    firstName: firstName,
                                    lastName: lastName
                                )
                            } else {
                                authManager.signInWithEmail(
                                    email: email,
                                    password: password
                                )
                            }
                        }) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: isSignUp ? "person.badge.plus" : "arrow.right.circle.fill")
                                }
                                Text(isSignUp ? "Create Account" : "Sign In")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.pixelPrimary)
                            .cornerRadius(16)
                            .shadow(color: .pixelAccent.opacity(0.10), radius: 4, x: 0, y: 2)
                        }
                        .disabled(authManager.isLoading || !isValidForm)
                        .opacity(isValidForm ? 1.0 : 0.6)
                        // Toggle between Sign In and Sign Up
                        Button(action: {
                            isSignUp.toggle()
                            authManager.authError = nil
                        }) {
                            Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .font(.subheadline)
                                .foregroundColor(.pixelPrimary)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .onAppear {
            wasSignedIn = authManager.isSignedIn
        }
        .onReceive(authManager.$isSignedIn) { isSignedIn in
            if !wasSignedIn && isSignedIn {
                dismiss()
            }
        }
    }
    
    private var isValidForm: Bool {
        if isSignUp {
            return !email.isEmpty && !password.isEmpty && !firstName.isEmpty && !lastName.isEmpty && password.count >= 6
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
}

// MARK: - Pixel Text Field Style
struct PixelTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(Color.clear)
            .foregroundColor(.pixelPrimary)
    }
}

// MARK: - Pixel Text Field Component
struct PixelTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pixelSecondary)
                .frame(width: 20)
                .padding(.leading, 12)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PixelTextFieldStyle())
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .background(Color.pixelSurface)
        .cornerRadius(12)
    }
}

struct EmailAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAuthView()
    }
}
