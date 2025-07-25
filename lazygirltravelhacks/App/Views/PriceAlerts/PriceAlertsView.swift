import SwiftUI

struct PriceAlertsView: View {
    var body: some View {
        ZStack {
            Color.pixelBackground.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("PRICE ALERTS")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.pixelPrimary)
                List {
                    ForEach(0..<2) { i in
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.pixelAccent)
                            Text("Alert #\(i+1)")
                                .foregroundColor(.pixelPrimary)
                            Spacer()
                            Button(action: {}) {
                                Text("SETTINGS")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.pixelAccent)
                            }
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                    }
                }
                .listStyle(PlainListStyle())
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct PriceAlertsView_Previews: PreviewProvider {
    static var previews: some View {
        PriceAlertsView()
    }
} 