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
    
    /// Updates the current user's home airport and saves the change.
    func updateHomeAirport(to airportCode: String) {
        guard var updatedUser = self.currentUser else { return }
        
        updatedUser.homeAirport = airportCode
        self.currentUser = updatedUser
        saveUser(updatedUser)
        
        print("✅ Home airport updated to \(airportCode)")
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
    
    // MARK: - Email Sign-In / Sign-Up
    
    func signUpWithEmail(email: String, password: String, firstName: String, lastName: String) {
        isLoading = true
        authError = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            
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
        UserDefaults.standard.removeObject(forKey: "currentUser")
        print("✅ User signed out")
    }
    
    // MARK: - Persistence
    
    func saveUser(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
    }
    
    private func checkSignInStatus() {
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
