import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    // State variables to manage the form
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isSignUp = false
    
    private let pixelFontName = "PressStart2P-Regular"

    var body: some View {
        ZStack {
            Image("welcome-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    
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
                    .padding(.top, 20)
                    // --- Divider ---
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.4)
                        Text("or").font(.custom(pixelFontName, size: 10)).opacity(0.8)
                        Rectangle().frame(height: 1).opacity(0.4)
                    }
                    .foregroundColor(DashboardTheme.MainBox.fill)
                    .padding(.vertical)
                    .padding(.horizontal)
                    .padding(.top, 140)
                    .padding(.bottom, 100)                }
                    
                    .safeAreaInset(edge: .bottom) {
                    // --- Apple Sign-In Button ---
                    Button(action: {
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
                        .pixelImageBorderStyle(imageName: "pixel-box-blue") // Using blue style
                    }
                }
                .padding(.horizontal)
                .padding(.top, 320) // Push content down from the top
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

// NOTE: It is best practice to move this helper component into its own file.
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
        .pixelImageBorderStyle(imageName: "pixel-box-resizable")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthenticationManager())
    }
}
