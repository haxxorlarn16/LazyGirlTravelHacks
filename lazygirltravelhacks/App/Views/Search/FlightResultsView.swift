import SwiftUI

struct FlightResultsView: View {
    @StateObject private var flightService = FlightService.shared
    @State private var showingPriceAlert = false
    @State private var selectedFlight: FlightDeal?
    
    let origin: String
    let destination: String
    let depart: Date
    let ret: Date

    var filteredDeals: [FlightDeal] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let departStr = formatter.string(from: depart)
        let returnStr = formatter.string(from: ret)
        return flightService.flightDeals.filter { deal in
            let dealDepartDate = formatter.string(from: deal.departDate)
            let dealReturnDate = formatter.string(from: deal.returnDate)
            return dealDepartDate == departStr && dealReturnDate == returnStr
        }
    }

    var body: some View {
        ZStack {
            Color.pixelBackground.ignoresSafeArea()
            VStack(spacing: 24) {
                // Header
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.pixelPrimary)
                    Text("\(origin) → \(destination)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pixelPrimary)
                    Spacer()
                }
                .padding(.horizontal)
                // Flight Results List
                if filteredDeals.isEmpty {
                    Spacer()
                    Text("No flights found for these dates.")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredDeals) { flight in
                                FlightResultCard(flight: flight) {
                                    selectedFlight = flight
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                // Price Alert Button
                Button(action: {
                    showingPriceAlert = true
                }) {
                    HStack {
                        Image(systemName: "bell.fill")
                        Text("SET PRICE ALERT")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.pixelPink)
                    .cornerRadius(12)
                    .foregroundColor(.pixelPrimary)
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingPriceAlert) {
            PriceAlertSheet(origin: origin, destination: destination)
        }
        .sheet(item: $selectedFlight) { flight in
            FlightDetailSheet(flight: flight)
        }
    }
}

struct FlightResultCard: View {
    let flight: FlightDeal
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(flight.airline)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.pixelPrimary)
                    
                    Text("\(formattedDate(flight.departDate)) - \(formattedDate(flight.returnDate))")
                        .font(.caption)
                        .foregroundColor(.pixelGray)
                    
                    HStack {
                        if flight.stops == 0 {
                            Text("DIRECT")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.pixelGreen)
                        } else {
                            Text("\(flight.stops) STOP\(flight.stops > 1 ? "S" : "")")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.pixelAccent)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", flight.price))")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.pixelGreen)
                    
                    Text("per person")
                        .font(.caption)
                        .foregroundColor(.pixelGray)
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct PriceAlertSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var targetPrice = ""
    let origin: String
    let destination: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pixelBackground.ignoresSafeArea()
                VStack(spacing: 24) {
                    Text("PRICE ALERT")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.pixelPrimary)
                    
                    Text("Get notified when prices drop for \(origin) → \(destination)")
                        .font(.subheadline)
                        .foregroundColor(.pixelPrimary)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Price")
                            .font(.headline)
                            .foregroundColor(.pixelPrimary)
                        TextField("$150", text: $targetPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: Implement price alert
                        dismiss()
                    }) {
                        Text("CREATE ALERT")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.pixelPink)
                            .cornerRadius(12)
                            .foregroundColor(.pixelPrimary)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FlightDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let flight: FlightDeal
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pixelBackground.ignoresSafeArea()
                VStack(spacing: 24) {
                    Text("FLIGHT DETAILS")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.pixelPrimary)
                    
                    VStack(spacing: 16) {
                        DetailRow(title: "Airline", value: flight.airline)
                        DetailRow(title: "Price", value: "$\(String(format: "%.2f", flight.price))")
                        DetailRow(title: "Dates", value: "\(formattedDate(flight.departDate)) - \(formattedDate(flight.returnDate))")
                        DetailRow(title: "Route", value: "\(flight.origin) → \(flight.destination)")
                        DetailRow(title: "Type", value: flight.stops == 0 ? "Direct" : "\(flight.stops) Stop(s)")
                        DetailRow(title: "Flight #", value: flight.flightNumber)
                        DetailRow(title: "Duration", value: flight.duration)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: Implement booking
                        dismiss()
                    }) {
                        Text("BOOK FLIGHT")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.pixelGreen)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.pixelPrimary)
            Spacer()
            Text(value)
                .foregroundColor(.pixelPrimary)
        }
    }
}

struct FlightResultsView_Previews: PreviewProvider {
    static var previews: some View {
        FlightResultsView(origin: "CVG", destination: "LAS", depart: Date(), ret: Date())
    }
} 