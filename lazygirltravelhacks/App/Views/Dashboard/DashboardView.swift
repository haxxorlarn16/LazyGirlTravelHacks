import SwiftUI

struct DashboardView: View {
    let pixelFontName = "PressStart2P-Regular"
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var isShowingAirportSearch = false

    var body: some View {
        ZStack {
            Image("cloud-bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    
                    // --- Header ---
                    HStack(spacing: 0) {
                        Text("MY TRAVEL")
                        Image("iconHouse") // Replace with your airplane icon name
                            .resizable().interpolation(.none).aspectRatio(contentMode: .fit)
                            .frame(height: 20).padding(.horizontal, 4).offset(y: -2)
                        Text("DASHBOARD")
                    }
                    .font(.custom(pixelFontName, size: 24))
                    .foregroundColor(DashboardTheme.text)
                    .padding(.top, 60)
                    .padding(.bottom, 10)
                    
                    // --- Standalone Avatar Image ---
                    Image("girlWidget")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        // By removing the .frame() modifier, the image expands to fill the available width
                        .padding(.vertical, 10)

                    // --- Profile Info Card (now text only) ---
                    VStack(alignment: .center, spacing: 4) {
                        Text((authManager.currentUser?.displayName ?? "LAZY GIRL").uppercased())
                            .font(.custom(pixelFontName, size: 14))
                        Text("TRAVEL HACKS")
                            .font(.custom(pixelFontName, size: 14))
                        Text("@lazygirltech")
                            .font(.custom(pixelFontName, size: 10)).opacity(0.8)
                    }
                    .foregroundColor(DashboardTheme.text)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .pixelBoxStyle(fill: DashboardTheme.MainBox.fill, border: DashboardTheme.MainBox.border, shadow: DashboardTheme.MainBox.shadow)
                    
                    // --- Action Rows ---
                    DashboardRow(iconName: "iconHouse", title: "Home Airport:", subtitle: authManager.currentUser?.homeAirport ?? "Not Set", buttonText: "EDIT") {
                        self.isShowingAirportSearch = true
                    }
                    DashboardRow(iconName: "iconCrown", title: "Subscription:", subtitle: "Premium", buttonText: "VIEW") {
                        print("View Subscription Tapped")
                    }
                    DashboardRow(iconName: "iconChecklist", title: "Saved Searches:", subtitle: "3 active", buttonText: "VIEW") {
                        print("View Searches Tapped")
                    }
                    DashboardRow(iconName: "iconBell", title: "Price Alerts:", subtitle: "2 watching", buttonText: "SETTINGS") {
                        print("Settings Tapped")
                    }
                    
                    Spacer()
                    
                    // --- Sign Out Button ---
                    Button(action: {
                        authManager.signOut()
                    }) {
                        Text("SIGN OUT")
                            .font(.custom(pixelFontName, size: 12))
                            .foregroundColor(DashboardTheme.text)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .pixelBoxStyle(
                                fill: DashboardTheme.ActionButton.fill,
                                border: DashboardTheme.ActionButton.border,
                                shadow: DashboardTheme.ActionButton.shadow
                            )
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isShowingAirportSearch) {
            AirportSearchView { selectedAirport in
                if let airport = selectedAirport {
                    authManager.updateHomeAirport(to: airport.id)
                }
                isShowingAirportSearch = false
            }
            .environmentObject(authManager)
        }
    }
}

// Reusable View for the Dashboard Rows
struct DashboardRow: View {
    let iconName: String
    let title: String
    let subtitle: String
    let buttonText: String
    let action: () -> Void
    
    private let pixelFontName = "PressStart2P-Regular"

    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable().interpolation(.none).aspectRatio(contentMode: .fit).frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.custom(pixelFontName, size: 12))
                Text(subtitle).font(.custom(pixelFontName, size: 12)).opacity(0.8)
            }
            
            Spacer()
            
            Button(action: action) {
                Text(buttonText)
                    .font(.custom(pixelFontName, size: 10))
                    .padding(.horizontal, 10).padding(.vertical, 8)
                    .pixelBoxStyle(fill: DashboardTheme.ActionButton.fill, border: DashboardTheme.ActionButton.border, shadow: DashboardTheme.ActionButton.shadow)
            }
        }
        .foregroundColor(DashboardTheme.text)
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .pixelBoxStyle(fill: DashboardTheme.MainBox.fill, border: DashboardTheme.MainBox.border, shadow: DashboardTheme.MainBox.shadow)
    }
}

// This provides the preview in Xcode's canvas.
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(AuthenticationManager())
    }
}
