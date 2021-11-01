//
//  ProfileView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/20/21.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var editMode = EditMode.inactive
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    let user: User
        
    var body: some View {
        ZStack {
            //                if let user = vm.user, AuthManager.shared.isSignedIn {
            VStack(alignment: .leading, spacing: 0) {
                profileViewHeader
                ownerSongsList
            }
            topNavButtons
            
            //                } else { showSignInViewButton }
            
            if profileVM.showLoader { LoaderView() }
        }.frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
        
            .onAppear { profileVM.prepare(user) }
    }
    
    fileprivate func onDelete(offsets: IndexSet) {
        guard let index = offsets.first, let user = vm.user else { return }
        let song = user.songListData[index]
        StorageManager.shared.delete(song: song) { error in
            if error == nil {
                user.songListData.remove(at: index)
                user.delete(song: song)
                DatabaseManger.shared.update(user: user) { success, error in
                    
                }
            }
        }
    }
    
}


extension ProfileView {
    
    private var profileViewHeader: some View {
        ZStack {
            Rectangle()
                .fill(Color.theme.primary)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 260)
            
            VStack {
                Menu(content: {
                    Button {
                        vm.activeSheet = .imagePicker(sourceType: .photoLibrary, picking: .bioImage)
                    } label: {
                        Label("Images", systemImage: "photo")
                    }
                    
                    Button {
                        vm.activeSheet = .imagePicker(sourceType: .camera, picking: .bioImage)
                    } label: {
                        Label("Camera", systemImage: "camera.fill")
                    }
                    
                    Button {
                        vm.activeSheet = .documentPicker(picking: .bioImage)
                    } label: {
                        Label("Browse", systemImage: "folder.fill")
                    }
                }, label: {
                    Image(uiImage: profileVM.selectedImage ?? UIImage(systemName: "person.circle.fill")!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                })
                
                Text(user.name)
                    .foregroundColor(.white)
                    .font(.title)
            }
            
            VStack {
                Spacer()
                HStack {
                    useAsArtistProfileButton
                        .environmentObject(vm)
                        .environmentObject(profileVM)
                    
                    Spacer()
                }
            }.padding([.leading, .bottom])
            
            if user.artist != nil {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ExpandableButtonPanel(primaryItem: ExpandableButtonItem(label: nil, imageName: "plus", action: nil), secondaryItems: [
                            ExpandableButtonItem(label: nil, imageName: "rectangle.stack.fill.badge.plus", action: {
                                // show create album view
                                vm.activeFullScreen = .createAlbum
                                withAnimation {
                                    profileVM.isExpanded.toggle()
                                }
                            }),
                            ExpandableButtonItem(label: nil, imageName: "music.note", action: {
                                // show upload song view
                                vm.activeFullScreen = .uploadSong
                                withAnimation {
                                    profileVM.isExpanded.toggle()
                                }
                            })
                        ], size: 50, color: Color.theme.primary, isExpanded: $profileVM.isExpanded)
                    }
                }.padding([.trailing, .bottom])
            }
        }.frame(height: 260)
    }
    
    private var useAsArtistProfileButton: some View {
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
            .background(Color.theme.primary)
            .cornerRadius(50 / 2)
            .shadow(color: Color.black.opacity(0.4), radius: 3, x: 2, y: 2)
        
        .onChange(of: profileVM.showArtistOwnerInfo, perform: { changed in
            if changed && user.artist == nil {
                vm.activeFullScreen = .createArtist
            } else
            if !changed && user.artist != nil {
                /* Alert user if they turn off "Artist Profile" that all of their albums/songs including thier artist will be deleted from the service, and they'll have to re-upload everything if they want to turn it back on. i.e. no one will be able to listen to it anymore */
                profileVM.alertItem = MyAlertItem(
                    title: Text("Are you sure?"),
                    message: Text("This will delete all of your albums/songs including your artist profile from the service. Everyone will no longer be able to listen to your uploaded song(s)"),
                    primaryButton: .cancel(Text("Cancel"), action: {
                        profileVM.showArtistOwnerInfo = true
                    }),
                    secondaryButton: .destructive(
                        Text("Confirm"),
                        action: {
                            profileVM.showLoader.toggle()
                            profileVM.removeUsersOwnerPrivilage(viewModel: vm, completion: { success in
                                if success {
                                    profileVM.showLoader.toggle()
                                }
                            })
                        }
                    )
                )
            }
        })
    }
    
    private var ownerSongsList: some View {
        ZStack {
            colorScheme == .light ? Color.white : Color.black
            VStack(spacing: 0) {
                if let artist = user.artist {
                    HStack {
                        Image(uiImage: profileVM.artistBioImage ?? UIImage(systemName: "person.3.fill")!)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.leading, 11)
                        Text(artist.name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.leading)
                        Spacer()
                        EditButton().padding(.trailing)
                    }.padding(4)
                }
                
                List {
                    ForEach(user.ownerSongs, id: \.self) { song in
                        HStack {
                            Image(uiImage: profileVM.getAlbumArtworkFor(song: song))
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .leading)
                                .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text(song.title)
                                    .font(.title3)
                                Text(song.albumTitle)
                                    .foregroundColor(Color.theme.primary)
                            }
                        }
                    }
                    .onDelete(perform: onDelete)
                    
                }
                .listStyle(PlainListStyle())
                .padding(0)
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    // Add this at the end of ZStack.
    private var topNavButtons: some View {
        VStack {
            HStack {
                dismissButton
                Spacer()
                signOutButton
            }
            Spacer()
        }.padding([.top, .horizontal])
    }
    
    private var dismissButton: some View {
        Button(action: {
            vm.showProfile.toggle()
        }, label: {
            Image(systemName: "xmark.circle")
                .foregroundColor(.white)
                .font(.system(size: 20))
        })
    }
    
    private var signOutButton: some View {
        Button(action: {
            profileVM.alertItem = MyAlertItem(
                title: Text("Sign Out?"),
                message: Text("Are you sure you want to sign out?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(
                    Text("Sign Out"),
                    action: {
                        withAnimation {
                            profileVM.showLoader.toggle()
                        }
                        profileVM.signOut(viewModel: vm) { success in
                            profileVM.showLoader.toggle()
                            vm.selectedTab = 1
                            self.presentationMode.wrappedValue.dismiss()
                            vm.user = nil
                            
                        }
                    }
                )
            )
        }, label: {
            Text("Sign Out")
                .foregroundColor(.white)
                .bold()
        })
    }
    
    private var showSignInViewButton: some View {
        Button {
            vm.activeSheet = .signIn
        } label: {
            Text("Sign In")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 300, height: 55)
                .background(Color.theme.primary)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}


    


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView(user: dev.user!)
                .environmentObject(dev.mainVM)
                .environmentObject(dev.profileVM)
            
            ProfileView(user: dev.user!)
                .environmentObject(dev.mainVM)
                .environmentObject(dev.profileVM)
                .preferredColorScheme(.dark)
        }
    }
}


