import SwiftUI

struct SearchProgressView: View {
    @StateObject private var flightService = FlightService.shared
    @State private var showingResults = false
    let destination: String
    
    var body: some View {
        ZStack {
            Color.pixelBackground.ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()
                
                // Loading Animation
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.pixelBlue)
                    .rotationEffect(.degrees(flightService.isSearching ? 360 : 0))
                    .animation(
                        flightService.isSearching ? 
                        Animation.linear(duration: 2).repeatForever(autoreverses: false) : 
                        .default,
                        value: flightService.isSearching
                    )
                
                // Progress Text
                VStack(spacing: 16) {
                    Text("Searching for flights...")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.pixelPrimary)
                    
                    Text("Finding the best deals to \(destination)")
                        .font(.body)
                        .foregroundColor(.pixelSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Progress Bar
                VStack(spacing: 8) {
                    ProgressView(value: flightService.searchProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .pixelBlue))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                    
                    Text("\(Int(flightService.searchProgress * 100))%")
                        .font(.caption)
                        .foregroundColor(.pixelSecondary)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .onAppear {
            // Start the search when view appears
            flightService.searchFlights(from: "CVG", to: destination, date: Date())
        }
        .onChange(of: flightService.searchProgress) { oldValue, newValue in
            if newValue >= 1.0 && !showingResults {
                showingResults = true
            }
        }
        .navigationDestination(isPresented: $showingResults) {
            if let firstResult = flightService.searchResults.first {
                FlightResultsView(
                    origin: firstResult.origin,
                    destination: firstResult.destination,
                    depart: firstResult.departDate,
                    ret: firstResult.returnDate
                )
            }
        }
    }
}

struct SearchProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProgressView(destination: "Miami")
    }
} 