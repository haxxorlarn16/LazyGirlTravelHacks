import SwiftUI
import AuthenticationServices

// A helper class to manage the Apple Sign-In flow.
// This allows us to use a custom button while still using the official Apple Sign-In process.
class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var authManager: AuthenticationManager
    private var currentNonce: String?

    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }
    
    // Provides the window to present the Apple Sign-In sheet.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // This is the modern way to get the main window, resolving the deprecation warning.
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            fatalError("No window was found to present the Apple Sign In sheet.")
        }
        return window
    }

    // Starts the Apple Sign-In process.
    func signIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    // Handles the successful sign-in.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task {
            // The handleAppleSignIn function from your authManager is called here.
            await authManager.handleAppleSignIn(.success(authorization))
        }
    }

    // Handles any errors during sign-in.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Task {
            // The handleAppleSignIn function is also called on failure.
            await authManager.handleAppleSignIn(.failure(error))
        }
    }
}


struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showEmailAuth = false
    @State private var appleSignInCoordinator: AppleSignInCoordinator?
    
    // Custom colors from the image provided
    let appleButtonColor = Color(red: 253/255, green: 191/255, blue: 171/255)
    let emailButtonColor = Color(red: 254/255, green: 226/255, blue: 200/255)
    let emailButtonStrokeColor = Color(red: 239/255, green: 123/255, blue: 123/255)

    var body: some View {
        ZStack {
            // Use the actual welcome background image
            Image("welcome-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                Spacer()
                
                // Sign-in buttons
                VStack(spacing: 16) {
                    // Custom Apple Sign-In Button
                    Button(action: {
                        // Initialize and start the sign-in process
                        self.appleSignInCoordinator = AppleSignInCoordinator(authManager: authManager)
                        appleSignInCoordinator?.signIn()
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Sign in with Apple")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(appleButtonColor)
                        .cornerRadius(27.5)
                    }
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black.opacity(0.2))
                        Text("or")
                            .foregroundColor(.black.opacity(0.6))
                            .font(.caption)
                            .padding(.horizontal, 16)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black.opacity(0.2))
                    }
                    .padding(.horizontal, 20)
                    
                    // Custom Email Sign-In Button
                    Button(action: {
                        showEmailAuth = true
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Sign up with Email")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(emailButtonStrokeColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(emailButtonColor)
                        .cornerRadius(27.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 27.5)
                                .stroke(emailButtonStrokeColor, lineWidth: 1.5)
                        )
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showEmailAuth) {
            // This now correctly calls your existing EmailAuthView
            EmailAuthView()
        }
        .overlay(
            // Loading indicator
            Group {
                if authManager.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        )
    }
}

// The placeholder EmailAuthView has been removed to fix the redeclaration error.

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
