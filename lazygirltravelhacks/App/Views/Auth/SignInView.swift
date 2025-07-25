import SwiftUI
import AuthenticationServices

struct SignInView: View {
    // MODIFIED: Receives the shared authManager from the environment
    // instead of creating its own instance.
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var showEmailAuth = false
    
    var body: some View {
        ZStack {
            // Assuming custom colors are defined elsewhere (e.g., in PixelBoxStyle.swift)
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // --- Main Title ---
                Text("LAZY GIRL\nTRAVEL HACKS")
                    .font(.largeTitle) // You can use your .custom pixel font here
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .foregroundColor(DashboardTheme.text) // Using theme color
                
                Text("Weekend getaways\nmade effortless")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(DashboardTheme.text.opacity(0.8))
                
                Spacer()
                
                // --- Action Buttons ---
                VStack(spacing: 16) {
                    // Apple Sign-In Button
                    Button(action: {
                        // MODIFIED: This now calls the method directly on the shared manager.
                        authManager.signInWithApple()
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .foregroundColor(.white)
                            Text("Continue with Apple")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.black)
                        .cornerRadius(16)
                    }
                    
                    // --- Divider ---
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.2)
                        Text("or").font(.caption).opacity(0.5)
                        Rectangle().frame(height: 1).opacity(0.2)
                    }
                    .foregroundColor(DashboardTheme.text)
                    .padding(.horizontal)
                    
                    // Email Sign-In Button
                    Button(action: {
                        showEmailAuth = true
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(DashboardTheme.text)
                            Text("Continue with Email")
                                .fontWeight(.semibold)
                                .foregroundColor(DashboardTheme.text)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                
                // Show a progress spinner if the authManager is in a loading state
                if authManager.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.2)
                        .padding(.top, 12)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showEmailAuth) {
            // Present the EmailAuthView
            EmailAuthView()
                // MODIFIED: Pass the shared authManager to the sheet
                .environmentObject(authManager)
        }
        // The .onReceive block is no longer needed here, as the ContentView handles the navigation.
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            // Provide a dummy manager for the preview to work
            .environmentObject(AuthenticationManager())
    }
}
