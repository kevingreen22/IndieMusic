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
    @EnvironmentObject var vm: ViewModel
    @StateObject var profileVM = ProfileViewModel()
    
    var songsWithImages: [UIImage? : [Song]] {
        vm.user.getOwnerSongs()
    }
    var songCount: Int {
        songsWithImages.count
    }
    
    var body: some View {
        ZStack {
            VStack {
                ProfileViewHeader()
                    .environmentObject(vm)
                    .environmentObject(profileVM)
                
                ScrollView {
                    if vm.user.artist != nil {
                        VStack {
                            ForEach(0..<songCount) { element in
                                getSongCell()
                                    .environmentObject(vm)
                            }
                        }
                    }
                    
                } // End ScrollView
                .ignoresSafeArea()
 
            } // End VStack
            
            TopNavButtons()
                .environmentObject(vm)
                .environmentObject(profileVM)
                
        } // End ZStack
        
        .onAppear {
            if vm.user.artist != nil {
                profileVM.showArtistOwnerInfo = true
            }
        }
        
        .alert(item: $vm.alertItem) { alert in
            MyAlertItem.present(alertItem: alert)
        }
        
    } // End body
    
    
    
    func getSongCell() -> some View {
        struct Cell: View {
            @EnvironmentObject var vm: ViewModel
            var image: UIImage?
            var name: String = "Unknown"
            var song: Song
            var body: some View {
                HStack {
                    Image(uiImage: image ?? UIImage(systemName: "album_artwork_placeholder")!)
                        .padding(.trailing)
                    Text(name)
                }
            }
        }

        var cell: Cell?
        for element in songsWithImages {
            for song in element.value {
                cell = Cell.init(image: element.key, name: song.title, song: song)
            }
        }

        return cell
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
                Image(uiImage: profileVM.selectedImage ?? UIImage(systemName: "person.circle.fill")!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture {
                        profileVM.showImagePickerPopover.toggle()
                    }
                
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
                                vm.activeSheet = .createAlbum
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }),
                            ExpandableButtonItem(label: nil, imageName: "music.note", action: {
                                // show upload song view
                                vm.activeSheet = .uploadSong
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            })
                        ], size: 50, color: .appSecondary, isExpanded: $isExpanded)
                    }
                }.padding([.trailing, .bottom])
            }
            
        }
        .frame(height: 260)
        
        .onAppear {
            profileVM.fetchUserProfilePicture(vm.user)
        }
        
//        .sheet(isPresented: $profileVM.showImagePicker, onDismiss: {
//            guard let image = profileVM.selectedImage else { return }
//            profileVM.uploadUserProfilePicture(viewModel: vm, email: profileVM.email, image: image)
//        }, content: {
//            ImagePicker(selectedImage: $profileVM.selectedImage, finishedSelecting: .constant(nil), sourceType: profileVM.sourceType)
//        })
        
        .actionSheet(isPresented: $profileVM.showImagePickerPopover, content: {
            profileVM.imagePickerActionSheet(viewModel: vm)
        })
        
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
                vm.activeSheet = .createArtist
            } else if !changed && vm.user.artist != nil {
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
        

        .fullScreenCover(item: $vm.activeSheet, onDismiss: doStuff, content: { item in
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
                
            case .imagePicker(let sourceType):
                ImagePicker(selectedImage: $profileVM.selectedImage, finishedSelecting: .constant(nil), sourceType: sourceType)
                    
            case .documentPicker:
                EmptyView()
            }
        })
        
    }
    
    func doStuff() {
        switch vm.activeSheet {
        case .createArtist:
            if vm.user.artist == nil {
                profileVM.showArtistOwnerInfo = false
            }
            
        case .imagePicker:
            guard let image = profileVM.selectedImage else { return }
            profileVM.uploadUserProfilePicture(viewModel: vm, email: profileVM.email, image: image)
            
        case .uploadSong, .createAlbum, .documentPicker, .none:
            break
        }
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
