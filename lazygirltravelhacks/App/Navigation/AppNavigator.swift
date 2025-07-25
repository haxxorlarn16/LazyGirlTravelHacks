import SwiftUI

enum AppScreen: Hashable {
    case welcome
    case signIn
    case dashboard
    case onboarding
    case searchProgress(destination: String)
    case flightResults(origin: String, destination: String, depart: Date, ret: Date)
    case profile
    case paywall
    case savedSearches
    case priceAlerts
}

struct AppNavigator: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var path: [AppScreen] = []
    @State private var currentScreen: AppScreen = .welcome
    @State private var needsOnboarding: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                screenView(for: currentScreen)
                    .navigationDestination(for: AppScreen.self) { screen in
                        screenView(for: screen)
                    }
            }
        }
        .onAppear {
            updateScreenOnAppear()
        }
        .onReceive(authManager.$isSignedIn) { isSignedIn in
            if isSignedIn {
                if let user = authManager.currentUser,
                   (user.homeAirport?.isEmpty == true || user.idealDestination?.isEmpty == true) {
                    needsOnboarding = true
                    currentScreen = .onboarding
                } else {
                    needsOnboarding = false
                    currentScreen = .dashboard
                }
            } else {
                needsOnboarding = false
                currentScreen = .welcome
            }
        }
    }

    private func updateScreenOnAppear() {
        if let user = authManager.currentUser,
           (user.homeAirport?.isEmpty == true || user.idealDestination?.isEmpty == true) {
            needsOnboarding = true
            currentScreen = .onboarding
        } else if authManager.isSignedIn {
            needsOnboarding = false
            currentScreen = .dashboard
        } else {
            needsOnboarding = false
            currentScreen = .welcome
        }
    }

    @ViewBuilder
    func screenView(for screen: AppScreen) -> some View {
        switch screen {
        case .welcome:
            WelcomeView()
        case .signIn:
            SignInView()
        case .dashboard:
            QuickGetawaysView(onNavigate: { screen in
                currentScreen = screen
            })
        case .onboarding:
            if let user = authManager.currentUser {
                HomeAirportSetupView { homeAirport, idealDestination, tripLength in
                    var updatedUser = user
                    updatedUser.homeAirport = homeAirport
                    updatedUser.idealDestination = idealDestination
                    updatedUser.tripLength = tripLength
                    authManager.currentUser = updatedUser
                    authManager.saveUser(updatedUser)
                    needsOnboarding = false
                    currentScreen = .profile
                }
            }
        case .searchProgress(let destination):
            SearchProgressView(destination: destination)
        case .flightResults(let origin, let destination, let depart, let ret):
            FlightResultsView(origin: origin, destination: destination, depart: depart, ret: ret)
        case .profile:
            ProfileView()
        case .paywall:
            PaywallView()
        case .savedSearches:
            SavedSearchesView()
        case .priceAlerts:
            PriceAlertsView()
        }
    }
}

struct AppNavigator_Previews: PreviewProvider {
    static var previews: some View {
        AppNavigator()
    }
} 