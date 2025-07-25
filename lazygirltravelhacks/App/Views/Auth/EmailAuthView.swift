import SwiftUI

struct EmailAuthView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isSignUp = false
    
    private let pixelFontName = "PressStart2P-Regular"

    var body: some View {
        ZStack {
            // The background image
            Image("cloud-bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // The main container that allows scrolling
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text(isSignUp ? "Create Account" : "Welcome Back")
                        .font(.custom(pixelFontName, size: 24))
                        .foregroundColor(DashboardTheme.text)
                        .padding(.bottom, 20)
                    
                    if isSignUp {
                        PixelTextField(text: $firstName, placeholder: "First Name", icon: "person.fill")
                        PixelTextField(text: $lastName, placeholder: "Last Name", icon: "person.fill")
                    }
                    
                    PixelTextField(text: $email, placeholder: "Email", icon: "envelope.fill", keyboardType: .emailAddress)
                    PixelTextField(text: $password, placeholder: "Password", icon: "lock.fill", isSecure: true)

                    if let error = authManager.authError {
                        Text(error)
                            .font(.custom(pixelFontName, size: 10))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    
                    // Action Button
                    Button(action: {
                        if isSignUp {
                            authManager.signUpWithEmail(email: email, password: password, firstName: firstName, lastName: lastName)
                        } else {
                            authManager.signInWithEmail(email: email, password: password)
                        }
                    }) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                            } else {
                                Text(isSignUp ? "CREATE ACCOUNT" : "SIGN IN")
                                    .font(.custom(pixelFontName, size: 12))
                            }
                        }
                        .foregroundColor(DashboardTheme.text)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .pixelBoxStyle(fill: DashboardTheme.ActionButton.fill, border: DashboardTheme.ActionButton.border, shadow: DashboardTheme.ActionButton.shadow)
                    }
                    .disabled(authManager.isLoading || !isValidForm)
                    .opacity(isValidForm ? 1.0 : 0.6)
                    .padding(.top)
                    
                    // Toggle between Sign In and Sign Up
                    Button(action: {
                        isSignUp.toggle()
                        authManager.authError = nil
                    }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .font(.custom(pixelFontName, size: 10))
                            .foregroundColor(DashboardTheme.text)
                            .underline()
                            .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 60) // This pushes all content down from the top safe area
            }
        }
        .onReceive(authManager.$isSignedIn) { isSignedIn in
            if isSignedIn {
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


// MARK: - Reusable Pixel Text Field Component
struct PixelTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    private let pixelFontName = "PressStart2P-Regular"
    @State private var showPassword: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(DashboardTheme.text.opacity(0.8))
                .frame(width: 20, alignment: .center)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom(pixelFontName, size: 12))
                        .foregroundColor(DashboardTheme.text.opacity(0.6))
                }
                
                if isSecure && !showPassword {
                    SecureField("", text: $text)
                        .font(.custom(pixelFontName, size: 12))
                } else {
                    TextField("", text: $text)
                        .font(.custom(pixelFontName, size: 12))
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }

            if isSecure {
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(DashboardTheme.text.opacity(0.8))
                }
            }
        }
        .foregroundColor(DashboardTheme.text)
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .pixelBoxStyle(fill: DashboardTheme.MainBox.fill, border: DashboardTheme.MainBox.border, shadow: DashboardTheme.MainBox.shadow)
    }
}


// MARK: - Preview Provider
struct EmailAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAuthView()
            .environmentObject(AuthenticationManager())
    }
}
