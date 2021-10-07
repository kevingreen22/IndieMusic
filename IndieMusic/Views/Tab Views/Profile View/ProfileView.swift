//
//  ProfileView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/20/21.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var vm: ViewModel
    @StateObject var profileVM = ProfileViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    ProfileViewHeader()
                        .environmentObject(vm)
                        .environmentObject(profileVM)
                    
                    List {
                        ForEach(vm.user.ownerSongs, id: \.self) { song in
                            HStack {
                                Image(uiImage: profileVM.getAlbumArtworkFor(song: song))
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .leading)
                                    .padding(.trailing)
                                VStack(alignment: .leading) {
                                    Text(song.title)
                                        .font(.title3)
                                    Text(song.albumTitle)
                                        .foregroundColor(.appSecondary)
                                }
                            }
                        }
                    }
                } // End VStack
                
                TopNavButtons()
                    .environmentObject(vm)
                    .environmentObject(profileVM)
                
            } // End ZStack
            
            .navigationBarHidden(true)
            
            .onAppear {
                if vm.user.artist != nil {
                    profileVM.showArtistOwnerInfo = true
                }
            }
        }
        
        .fullScreenCover(item: $vm.activeFullScreen, onDismiss: doStuff, content: { item in
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
            }
        })
        
    } // End body
    
    func doStuff() {
        switch vm.activeFullScreen {
        case .createArtist:
            if vm.user.artist == nil {
                profileVM.showArtistOwnerInfo = false
            }
            
        case .uploadSong, .createAlbum, .none:
            break
        }
    }
    
}




fileprivate struct ProfileViewHeader: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.mainApp)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 260)
                
            VStack {
                Menu(content: {
                    Button {
                        profileVM.activeSheet = .imagePicker(sourceType: .photoLibrary, picking: .bioImage)
                    } label: {
                        Label("Images", systemImage: "photo")
                    }
                    
                    Button {
                        profileVM.activeSheet = .imagePicker(sourceType: .camera, picking: .bioImage)
                    } label: {
                        Label("Camera", systemImage: "camera.fill")
                    }
                    
                    Button {
                        profileVM.activeSheet = .documentPicker(picking: .bioImage)
                    } label: {
                        Label("Browse", systemImage: "folder.fill")
                    }
                }, label: {
                    Image(uiImage: profileVM.selectedImage ?? UIImage(systemName: "person.circle.fill")!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                })
                
                Text(vm.user.name)
                    .foregroundColor(.white)
                    .font(.title)
            }
            
            VStack {
                Spacer()
                HStack {
                    UseAsArtistProfileButton()
                        .environmentObject(vm)
                        .environmentObject(profileVM)
                    
                    Spacer()
                }
            }.padding([.leading, .bottom])
            
            if vm.user.artist != nil {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ExpandableButtonPanel(primaryItem: ExpandableButtonItem(label: nil, imageName: "plus", action: nil), secondaryItems: [
                            ExpandableButtonItem(label: nil, imageName: "rectangle.stack.fill.badge.plus", action: {
                                // show create album view
                                vm.activeFullScreen = .createAlbum
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }),
                            ExpandableButtonItem(label: nil, imageName: "music.note", action: {
                                // show upload song view
                                vm.activeFullScreen = .uploadSong
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            })
                        ], size: 50, color: .appSecondary, isExpanded: $isExpanded)
                    }
                }.padding([.trailing, .bottom])
            }
        }.frame(height: 260)
        
        .onAppear {
            profileVM.fetchUserProfilePicture(vm.user)
        }
        
        .sheet(item: $profileVM.activeSheet, onDismiss: { profileVM.updateUsersProfilePicture(user: vm.user) }) { item in
            switch item {
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
        
    }
}

fileprivate struct SignOutButton: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        Button(action: {
            vm.alertItem = MyAlertItem(title: Text("Sign Out?"), message: Text("Are you sure you want to sign out?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Sign Out"), action: {
                profileVM.signOut()
                vm.showSigninView.toggle()
            }))
        }, label: {
            Text("Sign Out")
                .foregroundColor(.white)
                .bold()
        })
    }
}

fileprivate struct SettingsButton: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        Button(action: {
            profileVM.showSettings.toggle()
        }, label: {
            Image(systemName: "gear")
                .foregroundColor(.white)
        })
    }
}

// Add this at the end of ZStack.
fileprivate struct TopNavButtons: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                SettingsButton()
                    .environmentObject(vm)
                    .environmentObject(profileVM)
                
                Spacer()
                
                SignOutButton()
                    .environmentObject(vm)
                    .environmentObject(profileVM)
            }
            Spacer()
        }.padding([.top, .horizontal])
    }
}

fileprivate struct UseAsArtistProfileButton: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    private let shadowColor = Color.black.opacity(0.4)
    private let shadowPosition: (x: CGFloat, y: CGFloat) = (x: 2, y: 2)
    private let shadowRadius: CGFloat = 3
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                profileVM.showArtistOwnerInfo.toggle()
            }
        }, label: {
            Image(systemName: profileVM.showArtistOwnerInfo ? "music.mic" : "person.fill")
                .foregroundColor(.white)
                .rotationEffect(.degrees(profileVM.showArtistOwnerInfo ? 0 : 360))
        })
            .frame(width: 50, height: 50)
            .background(Color.appSecondary)
            .cornerRadius(50 / 2)
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowPosition.x,
                y: shadowPosition.y
            )
        
        
        .onChange(of: profileVM.showArtistOwnerInfo, perform: { changed in
            if changed && vm.user.artist == nil {
                vm.activeFullScreen = .createArtist
            } else
            if !changed && vm.user.artist != nil {
                /* Alert user if they turn off "Artist Profile" that all of their albums/songs including thier artist will be deleted from the service, and they'll have to re-upload everything if they want to turn it back on. i.e. no one will be able to listen to it anymore */
                vm.alertItem = MyAlertItem(
                    title: Text("Are you sure?"),
                    message: Text("This will delete all of your albums/songs including your artist profile from the service. Everyone will no longer be able to listen to your uploaded song(s)"),
                    primaryButton: .cancel(Text("Cancel"), action: {
                        profileVM.showArtistOwnerInfo = true
                    }),
                    secondaryButton: .destructive(Text("Confirm"), action: {
                        profileVM.removeUsersOwnerPrivilage(viewModel: vm)
                    })
                )
            }
        })
    }
}





struct ProfileView_Previews: PreviewProvider {
    static let vm = ViewModel()
    
    static var previews: some View {
        vm.user = MockData.user
        
        return ProfileView()
            .environmentObject(vm)
    }
}
