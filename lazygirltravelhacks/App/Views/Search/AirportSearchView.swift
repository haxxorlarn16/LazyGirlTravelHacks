import SwiftUI

struct Airport: Identifiable, Hashable {
    let id: String // e.g., "CVG"
    let name: String
}

struct AirportSearchView: View {
    let onAirportSelected: (Airport?) -> Void
    
    // A comprehensive list of major US airports
    static let allAirports: [Airport] = [
        Airport(id: "ATL", name: "Atlanta - Hartsfield-Jackson"),
        Airport(id: "DFW", name: "Dallas/Fort Worth International"),
        Airport(id: "DEN", name: "Denver International"),
        Airport(id: "ORD", name: "Chicago O'Hare International"),
        Airport(id: "LAX", name: "Los Angeles International"),
        Airport(id: "JFK", name: "New York - John F. Kennedy"),
        Airport(id: "LAS", name: "Las Vegas - Harry Reid"),
        Airport(id: "CVG", name: "Cincinnati/Northern Kentucky"),
        Airport(id: "MCO", name: "Orlando International"),
        Airport(id: "MIA", name: "Miami International"),
        Airport(id: "CLT", name: "Charlotte Douglas International"),
        Airport(id: "SEA", name: "Seattle-Tacoma International"),
        Airport(id: "PHX", name: "Phoenix Sky Harbor International"),
        Airport(id: "EWR", name: "Newark Liberty International"),
        Airport(id: "SFO", name: "San Francisco International"),
        Airport(id: "IAH", name: "Houston - George Bush Intercontinental"),
        Airport(id: "BOS", name: "Boston Logan International"),
        Airport(id: "FLL", name: "Fort Lauderdale-Hollywood"),
        Airport(id: "MSP", name: "Minneapolis-Saint Paul"),
        Airport(id: "LGA", name: "New York - LaGuardia"),
        Airport(id: "DTW", name: "Detroit Metropolitan Airport"),
        Airport(id: "PHL", name: "Philadelphia International"),
        Airport(id: "SLC", name: "Salt Lake City International"),
        Airport(id: "IAD", name: "Washington Dulles International"),
        Airport(id: "DCA", name: "Washington - Reagan National"),
        Airport(id: "BWI", name: "Baltimore/Washington International"),
        Airport(id: "TPA", name: "Tampa International"),
        Airport(id: "SAN", name: "San Diego International"),
        Airport(id: "AUS", name: "Austin-Bergstrom International"),
        Airport(id: "HNL", name: "Honolulu - Daniel K. Inouye"),
        Airport(id: "PDX", name: "Portland International")
    ]
    
    @State private var searchText = ""
    
    // A computed property that filters the list based on the search text
    var filteredAirports: [Airport] {
        if searchText.isEmpty {
            return AirportSearchView.allAirports
        } else {
            return AirportSearchView.allAirports.filter {
                $0.id.localizedCaseInsensitiveContains(searchText) ||
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredAirports) { airport in
                Button(action: {
                    onAirportSelected(airport)
                }) {
                    VStack(alignment: .leading) {
                        Text(airport.id).font(.headline)
                        Text(airport.name).font(.subheadline).foregroundColor(.secondary)
                    }
                    .foregroundColor(.primary)
                }
            }
            .searchable(text: $searchText, prompt: "Search by airport code or city...")
            .navigationTitle("Select Airport")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                onAirportSelected(nil)
            })
        }
    }
}
