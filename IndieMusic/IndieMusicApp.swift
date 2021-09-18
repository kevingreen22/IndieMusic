//
//  IndieMusicApp.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/7/21.
//

import SwiftUI
import Firebase
import Purchases

@main
struct IndieMusicApp: App {
    
    init() { setupFirebase() }
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var  vm: ViewModel = ViewModel()
    @StateObject var cpVM: CurrentlyPlayingViewModel = CurrentlyPlayingViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(vm)
                .environmentObject(cpVM)
                .onAppear {
                    cacheDataFromFirebase(completion: { success in
                        if success {
                            // turn loader off
                            print("Caching completed")
                        } else {
                            // alert the user something went wrong and then retry the query
                            print("Error caching from DB")
                        }
                    })
                }
                .fullScreenCover(isPresented: $vm.showSigninView) {
                    SignInView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                }
        }
        
        
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                break
            case .background:
                break
            case .inactive:
                UserDefaults.standard.setValue(true, forKey: "openingApp")
            @unknown default:
                print("Unknown scenePhase")
                fatalError("Unknown scenePhase")
                break
            }
        }
    }
    
    
    fileprivate func cacheDataFromFirebase(completion: @escaping (Bool) -> Void) {
        vm.cacheGenres { _, _ in
            if AuthManager.shared.isSignedIn {
                vm.cacheUser { success in
                    if success {
                        print("user cached")
                        cpVM.initialize(with: vm.user)
                        completion(true)
                    } else {
                        print("user NOT cached")
                        completion(false)
                    }
                }
            } else {
                vm.showSigninView = true
                completion(true)
            }
        }
        
    }
    
    
}




private extension IndieMusicApp {
    func setupFirebase() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "GobhVybjkizZSkHJxoQlEBCESnHHAjGC")
        IAPManager.shared.getSubscriptionStatus(completion: nil)
    }
}
