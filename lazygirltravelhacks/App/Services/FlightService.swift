import Foundation
import Combine

class FlightService: ObservableObject {
    static let shared = FlightService()
    
    @Published var isSearching = false
    @Published var searchProgress: Double = 0.0
    @Published var searchResults: [FlightDeal] = []
    @Published var flightDeals: [FlightDeal] = []
    @Published var searchError: String?
    
    private init() {
        // Initialize with some sample flight deals
        flightDeals = [
            FlightDeal(
                origin: "CVG",
                destination: "MIA",
                departDate: Date().addingTimeInterval(86400 * 7), // 1 week from now
                returnDate: Date().addingTimeInterval(86400 * 14), // 2 weeks from now
                price: 299.99,
                airline: "Delta",
                flightNumber: "DL1234",
                duration: "2h 45m",
                stops: 0
            ),
            FlightDeal(
                origin: "CVG",
                destination: "LAX",
                departDate: Date().addingTimeInterval(86400 * 10),
                returnDate: Date().addingTimeInterval(86400 * 17),
                price: 399.99,
                airline: "American",
                flightNumber: "AA5678",
                duration: "4h 15m",
                stops: 1
            ),
            FlightDeal(
                origin: "CVG",
                destination: "NYC",
                departDate: Date().addingTimeInterval(86400 * 5),
                returnDate: Date().addingTimeInterval(86400 * 12),
                price: 199.99,
                airline: "United",
                flightNumber: "UA9012",
                duration: "1h 55m",
                stops: 0
            )
        ]
    }
    
    func searchFlights(from: String, to: String, date: Date) {
        isSearching = true
        searchProgress = 0.0
        searchError = nil
        
        // Simulate flight search progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            DispatchQueue.main.async {
                self.searchProgress += 0.02
                
                if self.searchProgress >= 1.0 {
                    timer.invalidate()
                    self.isSearching = false
                    
                    // Generate some sample results
                    self.searchResults = [
                        FlightDeal(
                            origin: from,
                            destination: to,
                            departDate: date,
                            returnDate: date.addingTimeInterval(86400 * 7),
                            price: Double.random(in: 200...600),
                            airline: ["Delta", "American", "United", "Southwest"].randomElement() ?? "Delta",
                            flightNumber: "DL\(Int.random(in: 1000...9999))",
                            duration: "\(Int.random(in: 2...5))h \(Int.random(in: 0...59))m",
                            stops: Int.random(in: 0...2)
                        ),
                        FlightDeal(
                            origin: from,
                            destination: to,
                            departDate: date,
                            returnDate: date.addingTimeInterval(86400 * 7),
                            price: Double.random(in: 200...600),
                            airline: ["Delta", "American", "United", "Southwest"].randomElement() ?? "American",
                            flightNumber: "AA\(Int.random(in: 1000...9999))",
                            duration: "\(Int.random(in: 2...5))h \(Int.random(in: 0...59))m",
                            stops: Int.random(in: 0...2)
                        )
                    ]
                }
            }
        }
    }
    
    func toggleFavorite(for deal: FlightDeal) {
        if let index = flightDeals.firstIndex(where: { $0.id == deal.id }) {
            // Create a new deal with toggled favorite status
            let updatedDeal = FlightDeal(
                origin: deal.origin,
                destination: deal.destination,
                departDate: deal.departDate,
                returnDate: deal.returnDate,
                price: deal.price,
                airline: deal.airline,
                flightNumber: deal.flightNumber,
                duration: deal.duration,
                stops: deal.stops,
                isFavorite: !deal.isFavorite
            )
            flightDeals[index] = updatedDeal
        }
    }
} 