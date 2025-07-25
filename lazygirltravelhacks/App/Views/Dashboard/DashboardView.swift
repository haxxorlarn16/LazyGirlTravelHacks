import SwiftUI

struct DashboardView: View {
    // The font name you confirmed
    let pixelFontName = "PressStart2P-Regular"
    
    // Gives this view access to the shared AuthenticationManager instance
    @EnvironmentObject var authManager: AuthenticationManager
    
    // Controls whether the airport search pop-up is visible
    @State private var isShowingAirportSearch = false

    var body: some View {
        ZStack {
            // Using your background image asset
            Image("cloud-bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    
                    // --- Header ---
                    HStack(spacing: 0) {
                        Text("MY TRAVEL")
                        // You can add a pixel airplane icon to your assets and use its name here
                        Image("iconHouse") // Using house icon as a placeholder
                            .resizable().interpolation(.none).aspectRatio(contentMode: .fit)
                            .frame(height: 20).padding(.horizontal, 4).offset(y: -2)
                        Text("DASHBOARD")
                    }
                    .font(.custom(pixelFontName, size: 24))
                    .foregroundColor(DashboardTheme.text)
                    .padding(.top, 40)
                    
                    // --- Profile Header Card ---
                    HStack(spacing: 12) {
                        Image("girlWidget")
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 60)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("LAZY GIRL").font(.custom(pixelFontName, size: 14))
                            Text("TRAVEL HACKS").font(.custom(pixelFontName, size: 14))
                            Text("@lazygirltech").font(.custom(pixelFontName, size: 10)).opacity(0.8)
                        }
                        .foregroundColor(DashboardTheme.text)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .pixelBoxStyle(fill: DashboardTheme.MainBox.fill, border: DashboardTheme.MainBox.border, shadow: DashboardTheme.MainBox.shadow)

                    // --- Action Rows with Functional Buttons ---
                    DashboardRow(iconName: "iconHouse", title: "Home Airport:", subtitle: "CVG - Cincinnati", buttonText: "EDIT") {
                        // This action triggers the pop-up sheet
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
                    
                    // --- Sign Out Button ---
                    Button(action: {
                        authManager.signOut()
                    }) {
                        Text("SIGN OUT")
                            .font(.custom(pixelFontName, size: 12))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .pixelBoxStyle(
                                fill: Color.pink.opacity(0.9),
                                border: Color.pink,
                                shadow: Color.red.opacity(0.7)
                            )
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isShowingAirportSearch) {
            AirportSearchView { selectedAirport in
                if let airport = selectedAirport {
                    // This is where you would save the new airport
                    print("User selected new Home Airport: \(airport.id)")
                    // Example: authManager.updateHomeAirport(to: airport)
                }
                // Dismiss the sheet
                isShowingAirportSearch = false
            }
        }
    }
}

// Reusable View for the Dashboard Rows
// This version accepts an `action` to make the buttons work.
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

// This makes the preview work correctly with the EnvironmentObject
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(AuthenticationManager())
    }
}
