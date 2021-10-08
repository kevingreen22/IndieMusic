//
//  IndieMusicApp.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/7/21.
//

import SwiftUI
import Firebase
import Purchases
import RQPermissions

@main
struct IndieMusicApp: App {
    
    init() {
        setupFirebase()
        cacheDataFromFirebase()
    }
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var  vm: ViewModel = ViewModel()
    @StateObject var cpVM: CurrentlyPlayingViewModel = CurrentlyPlayingViewModel()
    
    @State private var retrycount = 0
    private let retryCacheAmount = 2
    
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(vm)
                .environmentObject(cpVM)
                .fullScreenCover(isPresented: $vm.showSigninView, onDismiss: requestPermissionsIfNeeded) {
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
    
}




private extension IndieMusicApp {
    
    func setupFirebase() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "GobhVybjkizZSkHJxoQlEBCESnHHAjGC")
        IAPManager.shared.getSubscriptionStatus(completion: nil)
    }
    
    func cacheDataFromFirebase() {
//        vm.cacheGenres { _, error in
//            if error == nil {
//                vm.initProgress += 0.5
//                if AuthManager.shared.isSignedIn {
//                    vm.cacheUser { success in
//                        if success {
//                            print("user cached")
//                            vm.initProgress += 0.5
//                            cpVM.initialize(with: vm.user)
//                            completion(true)
//                        } else {
//                            print("user NOT cached")
//                            completion(false)
//                        }
//                    }
//                } else {
//                    print("User not signed in.")
//                    vm.showSigninView = true
//                    completion(true)
//                }
//            } else {
//                print("Error caching genres")
//                completion(false)
//            }
//        }

        var successes = 0
        let group = DispatchGroup()
        group.enter()
        vm.cacheGenres { _, error in
            if error == nil {
                print("genres cached")
                successes += 1
            }
            group.leave()
        }

        group.enter()
        if AuthManager.shared.isSignedIn {
            vm.cacheUser { success in
                if success {
                    print("user cached")
                    successes += 1
                } else {
                    print("user NOT cached")
                }
                group.leave()
            }
        }
//        else {
//            vm.showSigninView = true
//            group.leave()
//        }

        group.notify(queue: .global()) {
            if  successes == 2 {
                print("Caching completed")
            } else {
                // Something went wrong retry the query.
                print("Error caching from DB")
                retrycount += 1
                if retrycount <= retryCacheAmount {
                    self.cacheDataFromFirebase()
                } else {
                    // show error, check internet connection, retry
                    
                }
            }
        }
    }
    
    
    func requestPermissionsIfNeeded() {
        RQPermissions.requestPermissions(for: [.camera, .photoAndMediaLibrary], healthOptions: nil) { permissionType in
            // handel error or alert to user here
            
        }
    }
    
}
