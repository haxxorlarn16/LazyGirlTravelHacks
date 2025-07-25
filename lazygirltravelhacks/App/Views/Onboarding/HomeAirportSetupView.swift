import SwiftUI

struct HomeAirportSetupView: View {
    @State private var homeAirport: String = ""
    @State private var idealDestination: String = ""
    @State private var tripLength: Int = 3
    var onComplete: ((String, String, Int) -> Void)?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pixelBackground, Color.pixelSurface]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 32) {
                Text("Let's get to know you!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.pixelPrimary)
                    .shadow(color: .pixelAccent.opacity(0.15), radius: 2, x: 0, y: 2)
                    .padding(.top, 40)
                Text("Where do you usually fly from, where do you dream of going, and how long do you want your trip to be?")
                    .font(.headline)
                    .foregroundColor(.pixelSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                VStack(spacing: 20) {
                    TextField("Home Airport (e.g., CVG)", text: $homeAirport)
                        .padding()
                        .background(Color.pixelSurface)
                        .cornerRadius(12)
                        .foregroundColor(.pixelPrimary)
                        .autocapitalization(.allCharacters)
                    TextField("Ideal Destination (e.g., LAX, Paris)", text: $idealDestination)
                        .padding()
                        .background(Color.pixelSurface)
                        .cornerRadius(12)
                        .foregroundColor(.pixelPrimary)
                        .autocapitalization(.words)
                    Picker("Trip Length", selection: $tripLength) {
                        Text("3 days (Fri-Mon)").tag(3)
                        Text("4 days (Thu-Mon)").tag(4)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 4)
                }
                .padding(.horizontal)
                Button(action: {
                    if !homeAirport.isEmpty && !idealDestination.isEmpty {
                        onComplete?(homeAirport, idealDestination, tripLength)
                    }
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background((!homeAirport.isEmpty && !idealDestination.isEmpty) ? Color.pixelPrimary : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: .pixelAccent.opacity(0.10), radius: 4, x: 0, y: 2)
                }
                .disabled(homeAirport.isEmpty || idealDestination.isEmpty)
                .padding(.horizontal)
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

struct HomeAirportSetupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeAirportSetupView() { _, _, _ in }
    }
} 