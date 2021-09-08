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
    
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    FavoritesView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationBarTitle(TabTitle.favorites.rawValue)
                }.tabItem {
                    Label(TabTitle.favorites.rawValue, systemImage: "star.fill")
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
                
                
//                NavigationView {
                    ProfileView()
                        .environmentObject(vm)
                        .environmentObject(cpVM)
                        .environment(\.defaultMinListRowHeight, 60)
//                        .navigationBarTitleDisplayMode(.large)
//                        .navigationBarTitle(TabTitle.profile.rawValue)
//                }
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                
                
            } // End TabView
            .accentColor(.black)
            
            CurrentlyPlayingMinimizedView(album: MockData.Albums().first!, song: MockData.Songs().first!)
                .environmentObject(vm)
                .environmentObject(cpVM)
                .offset(y: ((UIScreen.main.bounds.height/2) - UITabBarController().tabBar.frame.height - ViewModel.Constants.currentlyPlayingMinimizedViewHeight + 9))
            
        } // End VStack
        .edgesIgnoringSafeArea(.top)
        
        .onAppear {
            cpVM.preparePlayer()
            
//            if vm.isOpeningApp && !IAPManager.shared.isPremium() && AuthManager.shared.isSignedIn { vm.showPayWall.toggle() }
        }
        
        .sheet(isPresented: $vm.showPayWall, content: {
            PayWallView()
                .environmentObject(vm)
        })
        
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



