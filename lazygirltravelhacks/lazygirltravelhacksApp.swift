import SwiftUI

@main
struct lazygirltravelhacksApp: App {

    // This creates one instance of your manager for the entire app.
    @StateObject var authManager = AuthenticationManager()

    var body: some Scene {
        WindowGroup {
            // ContentView is now the root view.
            ContentView()
                // This makes the authManager available to ContentView
                // and any other views that need it.
                .environmentObject(authManager)
        }
    }
}
