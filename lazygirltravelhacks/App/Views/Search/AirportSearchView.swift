import SwiftUI

// A simple model for an airport
struct Airport: Identifiable {
    let id: String // e.g., "CVG"
    let name: String // e.g., "Cincinnati/Northern Kentucky"
}

// The search view that will be presented as a sheet.
struct AirportSearchView: View {
    // This is a "callback" function that the view will call when an airport is selected.
    // It allows this view to send data back to the DashboardView.
    let onAirportSelected: (Airport?) -> Void

    // Dummy data for the example list. You can replace this later.
    let sampleAirports = [
        Airport(id: "LAX", name: "Los Angeles International"),
        Airport(id: "JFK", name: "John F. Kennedy International"),
        Airport(id: "CVG", name: "Cincinnati/Northern Kentucky"),
        Airport(id: "LHR", name: "London Heathrow"),
        Airport(id: "HND", name: "Tokyo Haneda")
    ]
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List(sampleAirports) { airport in
                Button(action: {
                    // When a row is tapped, call the completion handler with the selected airport.
                    onAirportSelected(airport)
                }) {
                    VStack(alignment: .leading) {
                        Text(airport.id)
                            .font(.headline)
                        Text(airport.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Select Airport")
            .navigationBarItems(leading: Button("Cancel") {
                // If cancelled, call the handler with nil to pass no data back.
                onAirportSelected(nil)
            })
        }
    }
}

struct AirportSearchView_Previews: PreviewProvider {
    static var previews: some View {
        // Example of how to call it for the preview
        AirportSearchView { selectedAirport in
            print("Preview selected: \(selectedAirport?.id ?? "None")")
        }
    }
}
