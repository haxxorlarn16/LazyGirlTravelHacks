import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        ZStack {
            if authManager.isSignedIn {
                // MODIFIED: Show the DashboardView when signed in.
                DashboardView()
            } else {
                SignInView()
            }
        }
    }
}
