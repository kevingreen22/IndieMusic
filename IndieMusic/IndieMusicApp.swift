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
        self.firstAppLaunch = isFirstAppRun()
        setupFirebase()
    }
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var  vm: MainViewModel = MainViewModel()
    @StateObject var cpVM: CurrentlyPlayingViewModel = CurrentlyPlayingViewModel()
    @StateObject var profileVM: ProfileViewModel = ProfileViewModel()
    
    @State private var retrycount = 0
    private let retryCacheAmount = 2
    private var firstAppLaunch = true
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(vm)
                .environmentObject(cpVM)
                .environmentObject(profileVM)
                .onAppear {
                    requestPermissionsIfNeeded()
                    cacheDataFromFirebase()
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
//                if AuthManager.shared.isSignedIn {
//                    vm.cacheUser { success in
//                        if success {
//                            print("user cached")
//                        } else {
//                            print("user NOT cached")
//                        }
//                    }
//                }
////                else {
////                    print("User not signed in.")
////                    vm.showSigninView = true
////                }
//            } else {
//                print("Error caching genres")
//            }
//        }

        enum Caches: CaseIterable {
            case genres
            case user
        }
        
        var successes: [Caches] = []
        let group = DispatchGroup()
        group.enter()
        vm.cacheGenres { _, error in
            if error == nil {
                print("Genres cached")
                successes.append(Caches.genres)
            } else {
                print("Genres NOT cached.")
            }
            group.leave()
        }

        group.enter()
        if AuthManager.shared.isSignedIn && firstAppLaunch == false {
            vm.cacheUser { success in
                if success {
                    print("User cached.")
                    successes.append(Caches.user)
                } else {
                    print("User NOT cached.")
                }
                group.leave()
            }
        } else {
            AuthManager.shared.signOutUserOnAppFirstLaunch()
            group.leave()
        }

        group.notify(queue: .global()) {
            if AuthManager.shared.isSignedIn {
                if  successes.count == Caches.allCases.count  {
                    print("Caching completed")
                } else {
                    // Something went wrong retry the query.
                    print("Caching from DB incomplete. Only completed: \(successes)")
                    retrycount += 1
                    if retrycount <= retryCacheAmount {
                        print("Retrying cacheing attempt: \(retrycount)")
                        self.cacheDataFromFirebase()
                    } else {
                        // show error, check internet connection, retry
                        
                    }
                }
            } else if successes.contains(Caches.genres) {
                print("Caching completed, no need to retry, as the user is NOT signed in.")
            }
        }
    }
    
    
    func requestPermissionsIfNeeded() {
        RQPermissions.requestPermissions(for: [.camera, .photoAndMediaLibrary], healthOptions: nil) { permissionType in
            // handel error or alert to user here
            
        }
    }
    
}
