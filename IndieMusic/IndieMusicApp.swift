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
    @StateObject var vm: ViewModel = ViewModel()
    @StateObject var cpVM: CurrentlyPlayingViewModel = CurrentlyPlayingViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(vm)
                .environmentObject(cpVM)
                .onAppear {
                    if !AuthManager.shared.isSignedIn {
                        vm.showSigninView = true
                    } else {
                        vm.setUser()
                    }
                }
                .fullScreenCover(isPresented: $vm.showSigninView) {
                    SignInView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                }
            
//            if AuthManager.shared.isSignedIn {
//                MainTabView()
//                    .environmentObject(vm)
//                    .environmentObject(cpVM)
//            } else {
//                SignInView()
//                    .environmentObject(vm)
//                    .environmentObject(cpVM)
//            }
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
}




private extension IndieMusicApp {
    func setupFirebase() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "GobhVybjkizZSkHJxoQlEBCESnHHAjGC")
        IAPManager.shared.getSubscriptionStatus(completion: nil)
    }
}
