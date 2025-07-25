import Foundation
import StoreKit
import Combine

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var isSubscribed: Bool = false
    @Published var isLoading: Bool = false
    @Published var products: [Product] = []
    @Published var subscriptionStatus: SubscriptionStatus = .none
    
    private var productIDs = ["com.lauren.lazygirltravelhacks.premium.weekly"]
    private var updateListenerTask: Task<Void, Error>?
    
    enum SubscriptionStatus {
        case none
        case active
        case expired
        case gracePeriod
        case pending
    }
    
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            print("✅ Loaded \(products.count) products")
        } catch {
            print("❌ Failed to load products: \(error)")
        }
    }
    
    func purchaseSubscription() async {
        guard let product = products.first else {
            print("❌ No products available")
            return
        }
        
        isLoading = true
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Check whether the transaction is verified
                switch verification {
                case .verified(let transaction):
                    // Deliver content to the user
                    await transaction.finish()
                    await updateSubscriptionStatus()
                    print("✅ Purchase successful: \(transaction.productID)")
                case .unverified(_, let error):
                    print("❌ Purchase verification failed: \(error)")
                }
            case .userCancelled:
                print("❌ User cancelled purchase")
            case .pending:
                print("⏳ Purchase pending")
            @unknown default:
                print("❌ Unknown purchase result")
            }
        } catch {
            print("❌ Purchase failed: \(error)")
        }
        
        isLoading = false
    }
    
    func restorePurchases() async {
        isLoading = true
        
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
            print("✅ Purchases restored successfully")
        } catch {
            print("❌ Failed to restore purchases: \(error)")
        }
        
        isLoading = false
    }
    
    func updateSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                // Check if subscription is still active
                if transaction.expirationDate != nil {
                    if transaction.expirationDate! > Date() {
                        subscriptionStatus = .active
                        isSubscribed = true
                    } else {
                        subscriptionStatus = .expired
                        isSubscribed = false
                    }
                } else {
                    // Non-expiring subscription
                    subscriptionStatus = .active
                    isSubscribed = true
                }
                print("✅ Subscription status updated: \(subscriptionStatus)")
                return
            case .unverified(_, let error):
                print("❌ Transaction verification failed: \(error)")
                subscriptionStatus = .none
                isSubscribed = false
            }
        }
        
        // No active subscriptions found
        subscriptionStatus = .none
        isSubscribed = false
        print("ℹ️ No active subscriptions found")
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handleTransactionUpdate(result)
            }
        }
    }
    
    private func handleTransactionUpdate(_ result: VerificationResult<Transaction>) async {
        switch result {
        case .verified(let transaction):
            // Handle successful transaction
            await transaction.finish()
            await updateSubscriptionStatus()
            print("✅ Transaction updated: \(transaction.productID)")
        case .unverified(_, let error):
            print("❌ Transaction verification failed: \(error)")
        }
    }
    
    // Helper method to get formatted price
    func getFormattedPrice() -> String {
        guard let product = products.first else { return "$2.99" }
        return product.displayPrice
    }
    
    // Helper method to get product description
    func getProductDescription() -> String {
        guard let product = products.first else { return "Premium Weekly Subscription" }
        return product.description
    }
} 