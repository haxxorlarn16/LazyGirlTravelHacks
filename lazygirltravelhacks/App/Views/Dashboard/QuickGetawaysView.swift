import SwiftUI

struct SuggestedWeekend: Identifiable, Hashable {
    let id = UUID()
    let dateRange: String
    let departDate: Date
    let returnDate: Date
    var price: String? // e.g., "$299" or nil while loading
}

struct QuickGetawaysView: View {
    @StateObject private var flightService = FlightService.shared
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var showingSearchProgress = false
    @State private var selectedDestination = ""
    @State private var weekends: [SuggestedWeekend] = []
    @State private var isLoadingPrices: Bool = false
    @State private var selectedWeekend: SuggestedWeekend? = nil
    var onNavigate: ((AppScreen) -> Void)? = nil
    
    var body: some View {
        let user = authManager.currentUser
        let homeAirport = user?.homeAirport ?? "CVG"
        let destination = user?.idealDestination ?? ""
        let tripLength = 3 // Default to 3 days
        
        NavigationStack {
            ZStack {
                Color.pixelBackground.ignoresSafeArea()
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.pixelPrimary)
                        Text(homeAirport)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.pixelPrimary)
                        Spacer()
                        Circle()
                            .fill(Color.pixelPink)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.pixelPrimary)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Title
                    Text("QUICK GETAWAYS")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.pixelPrimary)
                    
                    if !destination.isEmpty {
                        Text("Best weekends to travel from \(homeAirport) to \(destination) for a \(tripLength)-day trip:")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    if isLoadingPrices {
                        ProgressView("Finding best prices...")
                            .padding()
                    } else if weekends.isEmpty {
                        Text("No suggested weekends found. Try updating your preferences.")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        List(weekends) { weekend in
                            Button(action: {
                                selectedWeekend = weekend
                                if let onNavigate = onNavigate {
                                    onNavigate(.flightResults(origin: homeAirport, destination: destination, depart: weekend.departDate, ret: weekend.returnDate))
                                }
                            }) {
                                HStack {
                                    Text(weekend.dateRange)
                                    Spacer()
                                    if let price = weekend.price {
                                        if price == "N/A" {
                                            Text("N/A")
                                                .foregroundColor(.pixelGray)
                                        } else {
                                            Text(price)
                                                .foregroundColor(.pixelGreen)
                                        }
                                    } else {
                                        ProgressView()
                                            .scaleEffect(0.7)
                                    }
                                    Image(systemName: "calendar")
                                        .foregroundColor(.pixelAccent)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: 300)
                    }
                    
                    Spacer()
                    
                    // Bottom Navigation
                    HStack(spacing: 20) {
                        NavigationButton(icon: "house.fill", title: "Home", isActive: true, action: { onNavigate?(.dashboard) })
                        NavigationButton(icon: "magnifyingglass", title: "Search", action: { onNavigate?(.searchProgress(destination: "")) })
                        NavigationButton(icon: "heart.fill", title: "Saved", action: { onNavigate?(.savedSearches) })
                        NavigationButton(icon: "person.fill", title: "Profile", action: { onNavigate?(.profile) })
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                loadWeekendsAndPrices(tripLength: tripLength, homeAirport: homeAirport, destination: destination)
            }
            .navigationDestination(item: $selectedWeekend) { weekend in
                FlightResultsView(
                    origin: homeAirport,
                    destination: destination,
                    depart: weekend.departDate,
                    ret: weekend.returnDate
                )
            }
        }
    }

    // Mock logic to suggest weekends for the next 6 weeks
    func suggestedWeekends(tripLength: Int) -> [SuggestedWeekend] {
        let calendar = Calendar.current
        let today = Date()
        var weekends: [SuggestedWeekend] = []
        var startDate = today
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        for _ in 1...6 {
            var depart: Date?
            var ret: Date?
            if tripLength == 3 {
                // Friday to Monday
                depart = calendar.nextDate(after: startDate, matching: DateComponents(weekday: 6), matchingPolicy: .nextTime) // Friday
                if let depart = depart {
                    ret = calendar.date(byAdding: .day, value: 3, to: depart) // Monday
                }
            } else {
                // Thursday to Monday
                depart = calendar.nextDate(after: startDate, matching: DateComponents(weekday: 5), matchingPolicy: .nextTime) // Thursday
                if let depart = depart {
                    ret = calendar.date(byAdding: .day, value: 4, to: depart) // Monday
                }
            }
            if let depart = depart, let ret = ret {
                weekends.append(SuggestedWeekend(dateRange: "\(formatter.string(from: depart)) - \(formatter.string(from: ret))", departDate: depart, returnDate: ret))
                startDate = calendar.date(byAdding: .day, value: 7, to: depart) ?? depart
            }
        }
        return weekends
    }

    func loadWeekendsAndPrices(tripLength: Int, homeAirport: String, destination: String) {
        isLoadingPrices = true
        weekends = suggestedWeekends(tripLength: tripLength)
        // For now, just assign a mock price for each weekend
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            weekends = weekends.map { weekend in
                var updated = weekend
                updated.price = "$\(Int.random(in: 200...600))"
                return updated
            }
            isLoadingPrices = false
        }
    }
}

struct NavigationButton: View {
    let icon: String
    let title: String
    var isActive: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(isActive ? .pixelAccent : .pixelGray)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(isActive ? .pixelAccent : .pixelGray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickGetawaysView_Previews: PreviewProvider {
    static var previews: some View {
        QuickGetawaysView()
    }
} 