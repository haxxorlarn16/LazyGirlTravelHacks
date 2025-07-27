import SwiftUI

struct DashboardView: View {
    let pixelFontName = "PressStart2P-Regular"
    let helveticaNeueFontName = "HelveticaNeue-Bold"

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
                    Image("MyTravelDashboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 10)
                    .foregroundColor(DashboardTheme.text)
                    .padding(.top, 60).padding(.bottom, 10)
                    
                    // --- Standalone Avatar Image ---
                    Image("girlWidget")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 2)
                    
                    // --- Profile Info Card (now text only) ---
                    VStack(alignment: .center, spacing: 4) {
                        Text((authManager.currentUser?.displayName ?? "LAZY GIRL").uppercased())
                            .font(.custom(pixelFontName, size: 14))
                        Text("TRAVEL HACKS")
                            .font(.custom(pixelFontName, size: 14))
                        Text("@lazygirltech")
                            .font(.custom(pixelFontName, size: 10)).opacity(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .foregroundColor(DashboardTheme.text)
                    .pixelImageBorderStyle(imageName: "pixel-box-resizable")
                    
                    // --- Action Rows ---
                    DashboardRow(
                        iconName: "iconHouse",
                        title: "Home Airport:",
                        subtitle: authManager.currentUser?.homeAirport ?? "Not Set",
                        buttonText: "EDIT",
                        buttonImageAsset: "pixel-box-blue",
                        buttonTextColor: Color(hex: "#fceab3"),
                        titleFont: helveticaNeueFontName,
                        subtitleFont: helveticaNeueFontName,
                        titleColor: Color(hex: "#b97b59"),
                        subtitleColor: Color(hex: "#73c0b8"),
                        titleFontSize: 18,
                        subtitleFontSize: 18
                    ) {
                        self.isShowingAirportSearch = true
                    }
                    
                    DashboardRow(iconName: "iconCrown", title: "Subscription:", subtitle: "Premium", buttonText: "VIEW", buttonImageAsset: "pixel-box-orange", buttonTextColor: Color(hex: "#fceab3"), titleFont: helveticaNeueFontName, subtitleFont: helveticaNeueFontName, titleColor: Color(hex: "#b97b59"), subtitleColor: Color(hex: "#73c0b8"),titleFontSize: 18, subtitleFontSize: 18) {}
                    DashboardRow(iconName: "iconChecklist", title: "Saved Searches:", subtitle: "3 active", buttonText: "VIEW", buttonImageAsset: "pixel-box-orange", buttonTextColor: Color(hex: "#fceab3"), titleFont: helveticaNeueFontName, subtitleFont: helveticaNeueFontName, titleColor: Color(hex: "#b97b59"), subtitleColor: Color(hex: "#73c0b8"),titleFontSize: 18, subtitleFontSize: 18) {}
                    DashboardRow(iconName: "iconBell", title: "Price Alerts:", subtitle: "2 watching", buttonText: "SETTINGS", buttonImageAsset: "pixel-box-orange", buttonTextColor: Color(hex: "#fceab3"), titleFont: helveticaNeueFontName, subtitleFont: helveticaNeueFontName, titleColor: Color(hex: "#b97b59"), subtitleColor: Color(hex: "#73c0b8"),titleFontSize: 18, subtitleFontSize: 18) {}

                    Spacer()
                    
                    // --- Sign Out Button ---
                    Button(action: { authManager.signOut() }) {
                        Text("SIGN OUT")
                            .font(.custom(pixelFontName, size: 12))
                            .foregroundColor(Color(hex: "#fceab3"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .pixelImageBorderStyle(imageName: "pixel-box-orange")
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
    let buttonImageAsset: String
    
    var buttonTextColor: Color = DashboardTheme.text
    var titleFont: String?
    var subtitleFont: String?
    var buttonFont: String?
    var titleColor: Color?
    var subtitleColor: Color?
    var titleFontSize: CGFloat?
    var subtitleFontSize: CGFloat?
    
    var action: () -> Void
    
    private let defaultPixelFont = "PressStart2P-Regular"
    private let defaultFontSize: CGFloat = 12

    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable().interpolation(.none).aspectRatio(contentMode: .fit).frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom(titleFont ?? defaultPixelFont, size: titleFontSize ?? defaultFontSize))
                    .foregroundColor(titleColor ?? DashboardTheme.text)
                Text(subtitle)
                    .font(.custom(subtitleFont ?? defaultPixelFont, size: subtitleFontSize ?? defaultFontSize))
                    .foregroundColor(subtitleColor ?? DashboardTheme.text.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: action) {
                Text(buttonText)
                    .font(.custom(buttonFont ?? defaultPixelFont, size: 10))
                    .foregroundColor(buttonTextColor)
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .pixelImageBorderStyle(imageName: buttonImageAsset)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .pixelImageBorderStyle(imageName: "pixel-box-resizable")
    }
}

// Helper for using hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// Previews
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(AuthenticationManager())
            .environmentObject(SubscriptionManager())
    }
}
