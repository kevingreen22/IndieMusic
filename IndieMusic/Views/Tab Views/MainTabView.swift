//
//  MainTabView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/7/21.
//

import SwiftUI
import AVKit

struct MainTabView: View {
    @Environment(\.defaultMinListRowHeight) var listRowHeight
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.tabBarBackground)
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $vm.selectedTab) {
                NavigationView {
                    ExploreView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationBarTitle(TabTitle.explore.rawValue)
                }.tabItem {
                    Label(TabTitle.explore.rawValue, systemImage: TabImage.explore.rawValue)
                }
                
                
                NavigationView {
                    FavoritesView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationBarTitle(TabTitle.favorites.rawValue)
                }.tabItem {
                    Label(TabTitle.favorites.rawValue, systemImage: TabImage.favorites.rawValue)
                        .gesture(ShowSignInGesture())
                        .environmentObject(vm)
                }
                
                
                ProfileView()
                    .environmentObject(vm)
                    .environmentObject(cpVM)
                    .environment(\.defaultMinListRowHeight, 60)
                    .tabItem {
                        Label(TabTitle.profile.rawValue, systemImage: TabImage.profile.rawValue)
                            .gesture(ShowSignInGesture())
                            .environmentObject(vm)
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
        
        
        .sheet(item: $vm.activeSheet) { item in
            switch item {
            case .signIn:
                SignInView()
            case .paywall:
                PayWallView()
            case .imagePicker(sourceType: _, picking: _), .documentPicker(picking: _):
                EmptyView()
            }
        }
        
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




fileprivate enum TabTitle: String {
    case favorites = "Favorites"
    case explore = "Explore"
    case profile = "Profile"
}

fileprivate enum TabImage: String {
    case favorites = "heart.fill"
    case explore = "flashlight.on.fill"
    case profile = "person.fill"
}

fileprivate struct ShowSignInGesture: Gesture {
    @EnvironmentObject var vm: ViewModel
    
    var body: some Gesture {
        TapGesture()
            .onEnded { _ in
                if !AuthManager.shared.isSignedIn {
                    vm.activeSheet = .signIn
                }
            }
    }
}
