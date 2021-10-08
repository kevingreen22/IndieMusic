//
//  MainTabView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/7/21.
//

import SwiftUI
import AVKit

enum TabTitle: String {
    case favorites = "Favorites"
    case explore = "Explore"
    case profile = "Profile"
}

struct MainTabView: View {
    @Environment(\.defaultMinListRowHeight) var listRowHeight
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.tabBarBackground)
    }
    
    var body: some View {
        ZStack {
            TabView {
                if AuthManager.shared.isSignedIn {
                    NavigationView {
                        FavoritesView()
                            .environmentObject(vm)
                            .environmentObject(cpVM)
                            .environment(\.defaultMinListRowHeight, 60)
                            .navigationBarTitleDisplayMode(.large)
                            .navigationBarTitle(TabTitle.favorites.rawValue)
                    }.tabItem {
                        Label(TabTitle.favorites.rawValue, systemImage: "heart.fill")
                    }
                } else {
                    SignInView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                }
                
                
                NavigationView {
                    ExploreView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationBarTitle(TabTitle.explore.rawValue)
                }.tabItem {
                    Label(TabTitle.explore.rawValue, systemImage: "flashlight.on.fill")
                }

                if AuthManager.shared.isSignedIn {
                    ProfileView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                } else {
                    SignInView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                }
                
            } // End TabView
            .accentColor(.mainApp)
            .transition(.move(edge: .bottom))
            
            CurrentlyPlayingMinimizedView()
//            NewCurrentlyPlayingView()
                .environmentObject(vm)
                .environmentObject(cpVM)
                .offset(y: ((getScreenBounds().height/2) - UITabBarController().tabBar.frame.height - ViewModel.Constants.currentlyPlayingMinimizedViewHeight - 10))
            
            if vm.showNotification {
                NonObstructiveNotificationView {
                    VStack(spacing: 3) {
                        Text(vm.notificationText)
                        ProgressBarView(progress: $vm.uploadProgress, color: .mainApp)
                    }
                }
                .ignoresSafeArea()
                .offset(y: -280)
            }
            
            AnimatedSplashScreen()
                .environmentObject(vm)
                .opacity(vm.showSplash ? 1 : 0)
            
        } // End ZStack
        .edgesIgnoringSafeArea(.vertical)
        
//        .onAppear {
//            withAnimation {
//                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
//                    vm.showNotification.toggle()
//                }
//                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 4) {
//                    vm.showNotification.toggle()
//                }
//            }
//            if vm.isOpeningApp && !IAPManager.shared.isPremium() && AuthManager.shared.isSignedIn { vm.showPayWall.toggle() }
//        }
        
//        .sheet(isPresented: $vm.showPayWall, content: {
//            PayWallView()
//                .environmentObject(vm)
//        })
        
        .alert(item: $vm.alertItem) { alert in
            MyAlertItem.present(alertItem: alert)
        }
        
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainTabView()
                .environmentObject(ViewModel())
                .environmentObject(CurrentlyPlayingViewModel())
        }
    }
}



