//
//  ProfileView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/20/21.
//

import SwiftUI


struct ProfileView: View {
//    @Environment(\.defaultMinListRowHeight) var listRowHeight
    @EnvironmentObject var vm: ViewModel
    @StateObject var profileVM = ProfileViewModel()
    
    
    var body: some View {
        ScrollView {
            ProfileViewHeader()
                .environmentObject(vm)
                .environmentObject(profileVM)
            
            Toggle("Artist Profile", isOn: $profileVM.showArtistOwnerInfo)
                .padding()
                .onChange(of: profileVM.showArtistOwnerInfo, perform: { value in
                    if value {
                        profileVM.activeSheet = .createArtist
                    } else if !value && vm.user.artist != nil {
                        // Alert user if they turn off "Artist Profile" that
                        // all of their albums/songs including thier artist
                        // will be deleted from the service, and they'll have to
                        // re-upload everything if they want to turn it back on.
                        // i.e. no one will be able to listen to it anymore
                        vm.alertItem = MyAlertItem(
                            title: Text("Are you sure?"),
                            message: Text("This will delete all of your albums/songs including your artist profile from the service. Everyone will no longer be able to listen to your uploaded song(s)"),
                            primaryButton: .cancel(),
                            secondaryButton: .destructive(Text("Confirm"),
                                                                action: {
                                                                    profileVM.removeUsersOwnerPrivelage()
                                                                })
                        )
                    }
                })
            
            if profileVM.showArtistOwnerInfo && vm.user.isArtistOwner {
                Button(action: {
                    profileVM.activeSheet = .uploadSong
                }, label: {
                    Text("Upload Song/Album")
                })
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(8)
                .shadow(radius: 10)
                
                Spacer()

                VStack {
                    Text("Song name")
                    Text("Song name")
                    Text("Song name")
                    Text("Song name")
                    Text("Song name")
                    Text("Song name")
                }

            }
            
        }.edgesIgnoringSafeArea(.top)
        
        
        .navigationBarItems(trailing: Button(action: {
            vm.alertItem = MyAlertItem(title: Text("Sign Out?"), message: Text("Are you sure you want to sign out?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Sign Out"), action: {
                profileVM.signOut()
                vm.showSigninView.toggle()
            }))
        }, label: {
            Text("Sign Out")
        }))

        
        .sheet(item: $profileVM.activeSheet, onDismiss: doStuff, content: { item in
            switch item {
            case .createArtist:
                CreateArtistView()
                    .environmentObject(vm)
                    .environmentObject(profileVM)
                
            case .createAlbum:
                CreateAlbumView()
                    .environmentObject(vm)
                    .environmentObject(profileVM)
                
            case .uploadSong:
                UploadSongView()
                    .environmentObject(vm)
            }
        })
        
        .alert(item: $vm.alertItem) { alert in
            MyAlertItem.present(alertItem: alert)
        }
        
        
    }
    
    
    func doStuff() {
        switch profileVM.activeSheet {
        case .createArtist:
            if vm.user.artist == nil {
                profileVM.showArtistOwnerInfo = false
            }
        
        case .createAlbum:
            break
            
        case .uploadSong:
            break
        
        case .none:
            break
        }
    }
}




struct ProfileViewHeader: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(height: 360)
            
            Image(uiImage: profileVM.selectedImage ?? UIImage(systemName: "person.circle.fill")!)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .offset(y: 40)
                .onTapGesture {
                    profileVM.showImagePickerPopover.toggle()
                }
            
            VStack {
                Spacer()
                Text(vm.user.name)
                    .foregroundColor(.white)
                    .font(.title)
                    .offset(y: -30)
            }
            
            .sheet(isPresented: $profileVM.showImagePicker, onDismiss: {
                guard let image = profileVM.selectedImage else { return }
                profileVM.uploadUserProfilePicture(email: profileVM.email, image: image)
            }, content: {
                ImagePicker(selectedImage: $profileVM.selectedImage, sourceType: profileVM.sourceType)
            })
            
            .actionSheet(isPresented: $profileVM.showImagePickerPopover, content: {
                profileVM.imagePickerActionSheet()
            })
            
        }
        
        .onAppear {
            profileVM.fetchUserProfilePicture()
        }
        
    }
    
}






struct ProfileView_Previews: PreviewProvider {
    static let vm = ViewModel()
    
    static var previews: some View {
        vm.user = MockData.user
        
        return ProfileView()
            .environmentObject(vm)
            .environmentObject(ProfileViewModel())
        
        
    }
}
