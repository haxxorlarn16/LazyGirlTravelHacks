import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showEmailAuth = false
    
    // Using the font name we established earlier
    private let pixelFontName = "PressStart2P-Regular"

    var body: some View {
        ZStack {
            // MODIFIED: Replaced the gradient with your background image
            Image("welcome-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // ADDED: This Spacer pushes everything below it to the bottom
                Spacer()
                
                // REMOVED: The "LAZY GIRL TRAVEL HACKS" and subtitle Text views
                
                // --- Action Buttons ---
                VStack(spacing: 16) {
                    // Apple Sign-In Button
                    Button(action: {
                        authManager.signInWithApple()
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Continue with Apple")
                                .font(.custom(pixelFontName, size: 12))
                        }
                        .foregroundColor(DashboardTheme.MainBox.fill) // Light text
                        .frame(maxWidth: .infinity)
                        .padding()
                        // MODIFIED: Using the pixelBoxStyle for a consistent look
                        .pixelBoxStyle(
                            fill: DashboardTheme.text, // Dark fill
                            border: DashboardTheme.text,
                            shadow: .black.opacity(0.5)
                        )
                    }
                    
                    // --- Divider ---
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.4)
                        Text("or").font(.custom(pixelFontName, size: 10)).opacity(0.8)
                        Rectangle().frame(height: 1).opacity(0.4)
                    }
                    .foregroundColor(DashboardTheme.MainBox.fill)
                    
                    // Email Sign-In Button
                    Button(action: {
                        showEmailAuth = true
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Continue with Email")
                                .font(.custom(pixelFontName, size: 12))
                        }
                        .foregroundColor(DashboardTheme.text) // Dark text
                        .frame(maxWidth: .infinity)
                        .padding()
                        // MODIFIED: Using the pixelBoxStyle for a consistent look
                        .pixelBoxStyle(
                            fill: DashboardTheme.MainBox.fill,
                            border: DashboardTheme.MainBox.border,
                            shadow: DashboardTheme.MainBox.shadow
                        )
                    }
                }
                .padding(.horizontal)
                
                // Show a progress spinner if the authManager is in a loading state
                if authManager.isLoading {
                    ProgressView()
                        .padding(.top, 12)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showEmailAuth) {
            EmailAuthView()
                .environmentObject(authManager)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthenticationManager())
    }
}
