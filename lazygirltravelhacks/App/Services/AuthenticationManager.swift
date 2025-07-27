import Foundation
import AuthenticationServices
import Combine

class AuthenticationManager: NSObject, ObservableObject {
    
    @Published var isSignedIn: Bool = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var authError: String?
    
    private let appleIDProvider = ASAuthorizationAppleIDProvider()
    
    override init() {
        super.init()
        checkSignInStatus()
    }
    
    // MARK: - User Data Management
    
    func updateHomeAirport(to airportCode: String) {
        guard var updatedUser = self.currentUser else { return }
        updatedUser.homeAirport = airportCode
        self.currentUser = updatedUser
        saveUser(updatedUser)
        print("✅ Home airport updated to \(airportCode)")
    }

    // MARK: - Apple Sign-In
    
    func signInWithApple() {
        // ... No changes needed in this function
    }
    
    // MARK: - Email Sign-In / Sign-Up
    
    func signUpWithEmail(email: String, password: String, firstName: String, lastName: String) {
        isLoading = true
        authError = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            
            let user = User(
                id: UUID().uuidString,
                email: email,
                // MODIFIED: Display name is now just the first name.
                displayName: firstName,
                homeAirport: "CVG"
            )
            
            self?.currentUser = user
            self?.isSignedIn = true
            self?.saveUser(user)
            print("✅ Simplified sign up successful for user: \(user.id)")
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        isLoading = true
        authError = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            
            let displayName = email.components(separatedBy: "@").first?.capitalized ?? "User"
            
            let user = User(
                id: UUID().uuidString,
                email: email,
                displayName: displayName,
                homeAirport: "CVG"
            )
            
            self?.currentUser = user
            self?.isSignedIn = true
            self?.saveUser(user)
            print("✅ Simplified sign in successful for user: \(user.id)")
        }
    }
    
    func signOut() {
        // ... No changes needed in this function
    }
    
    // MARK: - Persistence
    
    func saveUser(_ user: User) {
        // ... No changes needed in this function
    }
    
    private func checkSignInStatus() {
        // ... No changes needed in this function
    }
    
    // MARK: - Apple Sign-In Handler
    
    func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) async {
        await MainActor.run {
            isLoading = false
        }
        
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userID = appleIDCredential.user
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName
                
                // MODIFIED: Display name is now just the given (first) name.
                let displayName = fullName?.givenName ?? "Apple User"
                
                let user = User(
                    id: userID,
                    email: email,
                    displayName: displayName,
                    homeAirport: "CVG"
                )
                
                await MainActor.run {
                    currentUser = user
                    isSignedIn = true
                    saveUser(user)
                }
                
                print("✅ Apple Sign-In successful for user: \(userID)")
            }
        case .failure(let error):
            await MainActor.run {
                authError = error.localizedDescription
            }
            print("❌ Apple Sign-In failed: \(error.localizedDescription)")
        }
    }
}

/// In AuthenticationManager.swift

// MARK: - ASAuthorizationControllerDelegate & ContextProviding
extension AuthenticationManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task {
            await handleAppleSignIn(.success(authorization))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Task {
            await handleAppleSignIn(.failure(error))
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
