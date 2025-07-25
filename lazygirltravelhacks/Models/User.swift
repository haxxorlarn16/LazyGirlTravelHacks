import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String?
    let displayName: String?
    var homeAirport: String?
    var idealDestination: String?
    var tripLength: Int?
    
    init(id: String, email: String? = nil, displayName: String? = nil, homeAirport: String? = nil, idealDestination: String? = nil, tripLength: Int? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.homeAirport = homeAirport
        self.idealDestination = idealDestination
        self.tripLength = tripLength
    }
} 