//
//  ProfileView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/20/21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: ViewModel
    @StateObject var profileVM = ProfileViewModel()
    
    
    var body: some View {
        ZStack {
            VStack {
                ProfileViewHeader()
                    .environmentObject(vm)
                    .environmentObject(profileVM)
                
                ScrollView {
                    Toggle("Use as artist profile", isOn: $profileVM.showArtistOwnerInfo)
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
                    
                    if vm.user.artist != nil {
                        Button(action: {
                            profileVM.activeSheet = .createAlbum
                        }, label: {
                            Text("Create Album")
                        })
                        .frame(width: 300, height: 50)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                        
                        Spacer()
                        
                        Button(action: {
                            profileVM.activeSheet = .uploadSong
                        }, label: {
                            Text("Upload Song")
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
                    
                } // End ScrollView
                .ignoresSafeArea()
 
            } // End VStack
            
            TopNavButtons()
                .environmentObject(vm)
                .environmentObject(profileVM)
                
                        
            .sheet(item: $profileVM.activeSheet, onDismiss: doStuff, content: { item in
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
            
            .alert(item: $vm.alertItem) { alert in
                MyAlertItem.present(alertItem: alert)
            }
            
        } // End ZStack
    } // End body
    
    
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




fileprivate struct ProfileViewHeader: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
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
            
            .sheet(isPresented: $profileVM.showImagePicker, onDismiss: {
                guard let image = profileVM.selectedImage else { return }
                profileVM.uploadUserProfilePicture(email: profileVM.email, image: image)
            }, content: {
                ImagePicker(selectedImage: $profileVM.selectedImage, finishedSelecting: .constant(nil), sourceType: profileVM.sourceType)
            })
            
            .actionSheet(isPresented: $profileVM.showImagePickerPopover, content: {
                profileVM.imagePickerActionSheet()
            })
            
        }
        
        .frame(height: 260)
        
        .onAppear {
            profileVM.fetchUserProfilePicture(vm.user)
        }
        
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







struct ProfileView_Previews: PreviewProvider {
    static let vm = ViewModel()
    
    static var previews: some View {
        vm.user = MockData.user
        
        return ProfileView()
            .environmentObject(vm)
            .environmentObject(ProfileViewModel())
        
        
    }
}
