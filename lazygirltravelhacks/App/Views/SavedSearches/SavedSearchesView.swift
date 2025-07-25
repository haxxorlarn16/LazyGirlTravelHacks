import SwiftUI

struct SavedSearchesView: View {
    var body: some View {
        ZStack {
            Color.pixelBackground.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("SAVED SEARCHES")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.pixelPrimary)
                List {
                    ForEach(0..<3) { i in
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.pixelAccent)
                            Text("Search #\(i+1)")
                                .foregroundColor(.pixelPrimary)
                            Spacer()
                            Button(action: {}) {
                                Text("VIEW")
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

struct SavedSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesView()
    }
} 