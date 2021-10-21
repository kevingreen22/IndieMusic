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
    @StateObject var profileVM: ProfileViewModel = ProfileViewModel()

    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.theme.tabBarBackground)
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
                
                if let user = vm.user {
                    ProfileView(user: user)
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environmentObject(profileVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .tabItem {
                            Label(TabTitle.profile.rawValue, systemImage: TabImage.profile.rawValue)
                        }.tag(3)
                } else {
                    SignInView()
                }
                
            } // End TabView
            .accentColor(.primary)
            .transition(.move(edge: .bottom))
            .onChange(of: vm.selectedTab) { newValue in
                if newValue == 2 && AuthManager.shared.isSignedIn == false {
                    vm.user = nil
                }
            }
            
            CurrentlyPlayingMinimizedView()
//            NewCurrentlyPlayingView()
                .environmentObject(vm)
                .environmentObject(cpVM)
                .offset(y: ((getScreenBounds().height/2) - UITabBarController().tabBar.frame.height - MainViewModel.Constants.currentlyPlayingMinimizedViewHeight - 10))
            
            if vm.showNotification {
                NonObstructiveNotificationView {
                    VStack(spacing: 3) {
                        Text(vm.notificationText)
                        ProgressBarView(progress: $vm.uploadProgress, color: .primary)
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
//                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 4) {
//                    vm.showNotification.toggle()
//                }
//            }
        
//            if vm.isOpeningApp && !IAPManager.shared.isPremium() && AuthManager.shared.isSignedIn { vm.showPayWall.toggle() }
//        }
        
        
        .sheet(item: $vm.activeSheet, onDismiss: onDismissOfActiveSheet) { item in
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
                    DocumentPicker(filePath: $profileVM.userProfileImageURL, fileData: .constant(nil), contentTypes: [.image])
                case .mp3:
                    EmptyView()
                }

            }
        }
        
        
        .fullScreenCover(item: $vm.activeFullScreen, onDismiss: onDismissOfActiveFullScreenCover, content: { item in
            switch item {
            case .createArtist:
                CreateArtistView()
                    .environmentObject(vm)
                
            case .createAlbum:
                CreateAlbumView()
                    .environmentObject(vm)
                
            case .uploadSong:
                UploadSongView()
                    .environmentObject(vm)
                
            case .forgotPassword:
                ForgotPasswordView()
                    .environmentObject(vm)
                
            case .createAccount:
                CreateAccountView()
                    .environmentObject(vm)
            }
        })
        
        .alert(item: $vm.alertItem) { alert in
            MyAlertItem.present(alertItem: alert)
        }
        
    }
    
    
    func onDismissOfActiveSheet() {
        switch vm.activeSheet {
        case .imagePicker(sourceType: _, picking: _):
            guard let user = vm.user else { return }
            profileVM.updateUsersProfilePicture(user: user)
            
        default:
            break
            
        }
    }
    
    func onDismissOfActiveFullScreenCover() {
        switch vm.activeFullScreen {
        case .createArtist:
            guard let user = vm.user, user.artist == nil else { return }
            profileVM.showArtistOwnerInfo = false
            
        case .uploadSong, .createAlbum, .forgotPassword, .createAccount, .none:
            break
        }
    }
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainTabView()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
            
            MainTabView()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .preferredColorScheme(.dark)
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
