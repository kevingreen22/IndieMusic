//
//  IAPManager.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import Foundation
import Purchases

final class IAPManager {
    
    enum UserDefaultKeys: String {
        case premium = "premium"
    }
    
    static let shared = IAPManager()
    
    private init() {}
    
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.premium.rawValue)
    }
    
    
    public func getSubscriptionStatus(completion: ((Bool) -> Void)?) {
        Purchases.shared.purchaserInfo { info, error in
            guard let entitlements = info?.entitlements, error == nil else { return }
            if entitlements.all["Premium"]?.isActive == true {
                print("got updated status of subscribed")
                UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.premium.rawValue)
                completion?(true)
            } else {
                print("got updated status of NOT subscribed")
                UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.premium.rawValue)
                completion?(false)
            }
        }
    }
    
    
    
    public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first, error == nil else {
                completion(nil)
                return
            }
            
            completion(package)
        }
    }
    
    
    
    public func subscribe(package: Purchases.Package, completion: @escaping (Bool) -> Void) {
        guard !isPremium() else {
            print("user already subscribed")
            completion(true)
            return
        }
        
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCanceled in
            guard let transaction = transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCanceled else {
                return
            }
            
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                if entitlements.all["Premium"]?.isActive == true {
                    print("Purchaced!")
                    UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.premium.rawValue)
                    completion(true)
                } else {
                    print("Purchaced failed")
                    UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.premium.rawValue)
                    completion(false)
                }
            case .failed:
                print("failed")
            case .restored:
                print("restored")
            case .deferred:
                print("deferred")
            @unknown default:
                print("default case")
            }
            
        }
    }
    
    

    public func restorePurchaces(completion: @escaping (Bool) -> Void) {
        Purchases.shared.restoreTransactions { info, error in
            guard let entitlments = info?.entitlements, error == nil else { return }
            if entitlments.all["Premium"]?.isActive == true {
                print("restored succes")
                UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.premium.rawValue)
                completion(true)
            } else {
                print("restored failure")
                UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.premium.rawValue)
                completion(false)
            }
        }
    }
    
}
