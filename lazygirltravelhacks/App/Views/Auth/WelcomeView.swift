import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    // State variables to manage the form, moved from EmailAuthView
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isSignUp = true // Default to Sign Up on the welcome screen
    
    private let pixelFontName = "PressStart2P-Regular"

    var body: some View {
        ZStack {
            // Use the welcome background image
            Image("welcome-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    
                    Text(isSignUp ? "Create Account" : "Welcome Back")
                        .font(.custom(pixelFontName, size: 24))
                        .foregroundColor(DashboardTheme.text)
                        .padding(.bottom, 20)
                    
                    // --- Form Fields ---
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
                    
                    // --- Main Action Button ---
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
                        .pixelImageBorderStyle(imageName: "pixel-box-orange")
                    }
                    .disabled(authManager.isLoading || !isValidForm)
                    .opacity(isValidForm ? 1.0 : 0.6)
                    .padding(.top)
                    
                    // --- Toggle Sign Up/Sign In ---
                    Button(action: {
                        isSignUp.toggle()
                        authManager.authError = nil
                    }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .font(.custom(pixelFontName, size: 10))
                            .foregroundColor(DashboardTheme.text)
                            .underline()
                    }
                    
                    // --- Divider ---
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.4)
                        Text("or").font(.custom(pixelFontName, size: 10)).opacity(0.8)
                        Rectangle().frame(height: 1).opacity(0.4)
                    }
                    .foregroundColor(DashboardTheme.MainBox.fill)
                    .padding(.vertical)
                    
                    // --- Apple Sign-In Button ---
                    Button(action: {
                        // MODIFIED: Simplified to call the manager directly
                        authManager.signInWithApple()
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Continue with Apple")
                                .font(.custom(pixelFontName, size: 12))
                        }
                        .foregroundColor(DashboardTheme.MainBox.fill)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .pixelImageBorderStyle(imageName: "pixel-box-blue")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 60)
            }
        }
    }
    
    // Form validation logic moved from EmailAuthView
    private var isValidForm: Bool {
        if isSignUp {
            return !email.isEmpty && !password.isEmpty && !firstName.isEmpty && !lastName.isEmpty && password.count >= 6
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
}

// NOTE: The AppleSignInCoordinator class has been removed from this file.
// Its logic is now correctly handled by your AuthenticationManager.

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(AuthenticationManager())
    }
}
