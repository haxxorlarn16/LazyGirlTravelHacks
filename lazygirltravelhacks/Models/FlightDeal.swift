import Foundation

struct FlightDeal: Identifiable, Codable {
    let id: UUID
    let origin: String
    let destination: String
    let departDate: Date
    let returnDate: Date
    let price: Double
    let airline: String
    let flightNumber: String
    let duration: String
    let stops: Int
    let isFavorite: Bool
    
    init(id: UUID = UUID(), origin: String, destination: String, departDate: Date, returnDate: Date, price: Double, airline: String, flightNumber: String, duration: String, stops: Int, isFavorite: Bool = false) {
        self.id = id
        self.origin = origin
        self.destination = destination
        self.departDate = departDate
        self.returnDate = returnDate
        self.price = price
        self.airline = airline
        self.flightNumber = flightNumber
        self.duration = duration
        self.stops = stops
        self.isFavorite = isFavorite
    }
} 