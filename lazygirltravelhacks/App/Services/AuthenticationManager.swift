import Foundation
import AuthenticationServices
import Combine
// import FirebaseAuth
// import FirebaseCore

class AuthenticationManager: NSObject, ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isSignedIn: Bool = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var authError: String?
    
    private let appleIDProvider = ASAuthorizationAppleIDProvider()
    
    override init() {
        super.init()
        checkSignInStatus()
    }
    
    // MARK: - Apple Sign-In
    func signInWithApple() {
        isLoading = true
        authError = nil
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signUpWithEmail(email: String, password: String, firstName: String, lastName: String) {
        isLoading = true
        authError = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            
            // Create a simple user object
            let user = User(
                id: UUID().uuidString,
                email: email,
                displayName: "\(firstName) \(lastName)",
                homeAirport: "CVG" // Default
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
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            
            // Create a simple user object
            let user = User(
                id: UUID().uuidString,
                email: email,
                displayName: "User Name",
                homeAirport: "CVG" // Default
            )
            
            self?.currentUser = user
            self?.isSignedIn = true
            self?.saveUser(user)
            
            print("✅ Simplified sign in successful for user: \(user.id)")
        }
    }
    
    func signOut() {
        isSignedIn = false
        currentUser = nil
        authError = nil
        // Clear any stored user data
        UserDefaults.standard.removeObject(forKey: "currentUser")
        print("✅ User signed out")
    }
    
    func saveUser(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
    }
    
    private func checkSignInStatus() {
        // Check if user is already signed in via UserDefaults
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isSignedIn = true
        }
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
                
                // Create user object
                let displayName = fullName != nil ? "\(fullName!.givenName ?? "") \(fullName!.familyName ?? "")" : "Apple User"
                let user = User(
                    id: userID,
                    email: email,
                    displayName: displayName,
                    homeAirport: "CVG" // Default
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

// MARK: - ASAuthorizationControllerDelegate
extension AuthenticationManager: ASAuthorizationControllerDelegate {
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
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthenticationManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
} 