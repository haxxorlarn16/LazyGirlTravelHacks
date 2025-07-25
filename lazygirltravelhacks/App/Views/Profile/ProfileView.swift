import SwiftUI

struct ProfileView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var showingPaywall = false
    
    var body: some View {
        ZStack {
            Color.pixelBackground.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("YOUR PROFILE")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.pixelPrimary)
                
                // User Profile Card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.9))
                    .frame(height: 100)
                    .overlay(
                        HStack {
                            Circle()
                                .fill(Color.pixelPink)
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Text(authManager.currentUser?.displayName?.prefix(1).uppercased() ?? "U")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.pixelPrimary)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(authManager.currentUser?.displayName ?? "User")
                                    .font(.headline)
                                    .foregroundColor(.pixelPrimary)
                                Text(authManager.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.pixelPrimary)
                                Text("@lazygirltech")
                                    .font(.caption)
                                    .foregroundColor(.pixelGray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    )
                
                // Profile Options
                VStack(spacing: 12) {
                    ProfileRow(icon: "house.fill", title: "Home Airport:", value: authManager.currentUser?.homeAirport ?? "CVG", action: "")
                    ProfileRow(icon: "airplane", title: "Ideal Destination:", value: authManager.currentUser?.idealDestination ?? "-", action: "")
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.pixelAccent)
                        Text("Subscription:")
                            .fontWeight(.semibold)
                            .foregroundColor(.pixelPrimary)
                        Text(subscriptionManager.isSubscribed ? "Premium +" : "Free")
                            .foregroundColor(subscriptionManager.isSubscribed ? .pixelGreen : .pixelPrimary)
                        Spacer()
                        if !subscriptionManager.isSubscribed {
                            Button(action: { showingPaywall = true }) {
                                Text("UPGRADE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.pixelAccent)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                // Sign Out Button
                Button(action: {
                    authManager.signOut()
                }) {
                    Text("SIGN OUT")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pixelPink)
                        .cornerRadius(12)
                        .foregroundColor(.pixelPrimary)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let value: String
    let action: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pixelAccent)
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.pixelPrimary)
            Text(value)
                .foregroundColor(.pixelPrimary)
            Spacer()
            Button(action: {}) {
                Text(action)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.pixelAccent)
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.7))
        .cornerRadius(10)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 