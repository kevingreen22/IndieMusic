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
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.tabBarBackground)
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $vm.selectedTab) {
                NavigationView {
                    FavoritesView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationBarTitle(TabTitle.favorites.rawValue)
                }.tabItem {
                    Label(TabTitle.favorites.rawValue, systemImage: TabImage.favorites.rawValue)
                }.tag(1)
                
                
                NavigationView {
                    ExploreView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationBarTitle(TabTitle.explore.rawValue)
                }.tabItem {
                    Label(TabTitle.explore.rawValue, systemImage: TabImage.explore.rawValue)
                }.tag(2)
                
                
                ProfileView()
                    .environmentObject(vm)
                    .environmentObject(cpVM)
                    .environmentObject(profileVM)
                    .environment(\.defaultMinListRowHeight, 60)
                    .tabItem {
                        Label(TabTitle.profile.rawValue, systemImage: TabImage.profile.rawValue)
                    }.tag(3)
                
            } // End TabView
            .accentColor(.mainApp)
            .transition(.move(edge: .bottom))
            
            
            CurrentlyPlayingMinimizedView()
//            NewCurrentlyPlayingView()
                .environmentObject(vm)
                .environmentObject(cpVM)
                .offset(y: ((getScreenBounds().height/2) - UITabBarController().tabBar.frame.height - MainViewModel.Constants.currentlyPlayingMinimizedViewHeight - 10))
            
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
        
        
        .sheet(item: $vm.activeSheet, onDismiss: { profileVM.updateUsersProfilePicture(user: vm.user) }) { item in
            switch item {
            case .signIn:
                SignInView()
                    .environmentObject(vm)
                    .environmentObject(cpVM)
                
            case .paywall:
                PayWallView()
                
            case .imagePicker(let sourceType, let picking):
                switch picking {
                case .bioImage:
                    ImagePicker(selectedImage: $profileVM.selectedImage, finishedSelecting: .constant(nil), sourceType: sourceType)
                case .albumImage, .mp3:
                    EmptyView()
                }
                
            case .documentPicker(let picking):
                switch picking {
                case .bioImage, .albumImage:
                    DocumentPicker(filePath: $profileVM.url, file: .constant(nil), contentTypes: [.image])
                case .mp3:
                    EmptyView()
                }

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
                .environmentObject(MainViewModel())
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
