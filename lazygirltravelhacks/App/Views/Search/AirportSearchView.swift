// In AirportSearchView.swift
import SwiftUI

struct Airport: Identifiable, Hashable {
    let id: String // e.g., "CVG"
    let name: String
}

struct AirportSearchView: View {
    let onAirportSelected: (Airport?) -> Void
    
    // A larger, static list of airports to search from.
    // In a real app, this might come from a database or API.
    static let allAirports: [Airport] = [
        Airport(id: "JFK", name: "New York - John F. Kennedy"),
        Airport(id: "LGA", name: "New York - LaGuardia"),
        Airport(id: "LAX", name: "Los Angeles International"),
        Airport(id: "ORD", name: "Chicago O'Hare"),
        Airport(id: "ATL", name: "Atlanta Hartsfield-Jackson"),
        Airport(id: "DFW", name: "Dallas/Fort Worth"),
        Airport(id: "DEN", name: "Denver International"),
        Airport(id: "SFO", name: "San Francisco International"),
        Airport(id: "MCO", name: "Orlando International"),
        Airport(id: "MIA", name: "Miami International"),
        Airport(id: "LHR", name: "London Heathrow"),
        Airport(id: "CDG", name: "Paris Charles de Gaulle"),
        Airport(id: "HND", name: "Tokyo Haneda"),
        Airport(id: "CVG", name: "Cincinnati/Northern Kentucky")
    ]
    
    // State to hold the user's search text
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
            VStack {
                // The search bar
                TextField("Search by code or city...", text: $searchText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // The list now displays the filtered results
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
            }
            .navigationTitle("Select Airport")
            .navigationBarItems(leading: Button("Cancel") {
                onAirportSelected(nil)
            })
        }
    }
}
