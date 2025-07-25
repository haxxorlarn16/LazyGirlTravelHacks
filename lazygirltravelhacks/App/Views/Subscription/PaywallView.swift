import SwiftUI
import StoreKit

struct PaywallView: View {
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.pixelBackground.ignoresSafeArea()
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "crown.fill")
                        .resizable()
                        .frame(width: 48, height: 32)
                        .foregroundColor(.pixelHighlight)
                    
                    Text("UPGRADE TO PREMIUM")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.pixelPrimary)
                }
                
                // Price Card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.9))
                    .frame(height: 60)
                    .overlay(
                        Text(subscriptionManager.getFormattedPrice() + "/WEEK")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.pixelPrimary)
                    )
                
                // Features List
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(text: "Unlimited destination searches")
                    FeatureRow(text: "Price alerts & notifications")
                    FeatureRow(text: "Advanced filtering options")
                    FeatureRow(text: "Priority customer support")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    // Start Free Trial Button
                    Button(action: {
                        Task {
                            await purchaseSubscription()
                        }
                    }) {
                        HStack {
                            if subscriptionManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .pixelPrimary))
                                    .scaleEffect(0.8)
                            } else {
                                Text("START FREE TRIAL")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.pixelPink)
                        .cornerRadius(12)
                        .foregroundColor(.pixelPrimary)
                    }
                    .disabled(subscriptionManager.isLoading)
                    
                    // Continue with Free Button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Continue with Free")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.pixelGray)
                            .cornerRadius(12)
                            .foregroundColor(.pixelPrimary)
                    }
                    .disabled(subscriptionManager.isLoading)
                    
                    // Restore Purchases Button
                    Button(action: {
                        Task {
                            await restorePurchases()
                        }
                    }) {
                        Text("Restore Purchases")
                            .font(.caption)
                            .foregroundColor(.pixelAccent)
                    }
                    .disabled(subscriptionManager.isLoading)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
        .alert("Subscription", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onReceive(subscriptionManager.$isSubscribed) { isSubscribed in
            if isSubscribed {
                alertMessage = "🎉 Welcome to Premium! You now have access to all features."
                showingAlert = true
                dismiss()
            }
        }
    }
    
    private func purchaseSubscription() async {
        await subscriptionManager.purchaseSubscription()
        
        if !subscriptionManager.isSubscribed {
            alertMessage = "Purchase was not completed. Please try again."
            showingAlert = true
        }
    }
    
    private func restorePurchases() async {
        await subscriptionManager.restorePurchases()
        
        if !subscriptionManager.isSubscribed {
            alertMessage = "No previous purchases found to restore."
            showingAlert = true
        }
    }
}

struct FeatureRow: View {
    let text: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.pixelGreen)
            Text(text)
                .foregroundColor(.pixelPrimary)
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
} 