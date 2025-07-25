import SwiftUI

struct ContentView: View {
    // This view will get the AuthenticationManager from the environment.
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        ZStack {
            // If the user is signed in, show the new dashboard.
            if authManager.isSignedIn {
                DashboardView()
            } else {
                // Otherwise, show the sign-in view.
                // Make sure your sign-in view is named SignInView,
                // or change the name here to match.
                SignInView()
            }
        }
    }
}
