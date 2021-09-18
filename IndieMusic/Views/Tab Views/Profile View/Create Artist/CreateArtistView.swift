//
//  CreatArtistAlbumSongView.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/1/21.
//

import SwiftUI

struct CreateArtistView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @StateObject var createArtistVM = CreateArtistViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                NavigationView {
                    Form {
                        TextField("Enter Artist name*", text: $createArtistVM.artistName)
                            .font(.system(size: 24))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                            .offset(x: -20)
                        
                        
                        Picker("Album*", selection: $createArtistVM.album) {
                            ForEach(vm.user.getOwnerAlbums(), id: \.self) { album in
                                Text(album.title)
                            }
                        }
                        
                        Picker("Genre*", selection: $createArtistVM.genre) {
                            TextField("Add new genre", text: $createArtistVM.newGenreName,  onCommit: {
                                
                                Genres.names.append(createArtistVM.newGenreName)
                                // add new genre to database here
                                
                                createArtistVM.newGenreName = ""
                            }).multilineTextAlignment(.center)
                            
                            ForEach(Genres.names, id: \.self) { genre in
                                Text(genre)
                            }
                        }
                        
                        
                        TextField("Enter Bio", text: $createArtistVM.bio)
                            .frame(height: 200)
                            .padding(.bottom)
                        
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Choose Artist Image")
                                Text("Optional")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(uiImage: createArtistVM.bioImage ?? UIImage(systemName: "person.circle")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                                .clipShape(Circle())
                                .transition(.opacity)
                                .onTapGesture {
                                    createArtistVM.showImagePicker.toggle()
                                }
                        }
                        
                    } // End Form
                    
                    .navigationBarTitle(Text("Create Artist"), displayMode: .inline)
                    .navigationBarItems(leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    })
                    
                } // End Nav View
                
                
                VStack {
                    Spacer()
                    Rectangle()
                        .background(Color.black).opacity(0.05)
                        .blur(radius: 3)
                        .frame(height: 100)
                        .ignoresSafeArea(edges: .bottom)
                        .overlay(
                            Button(action: {
                                createArtistVM.createArtist(viewModel: vm)
                            }, label: {
                                Text("Create")
                                    .font(.system(size: 25))
                            })
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                        )
                }.ignoresSafeArea(edges: .bottom)
                
                
                
            } // End ZStack
        } // End geometry reader
        
        .alert(item: $vm.alertItem) { alert in
            MyAlertItem.present(alertItem: alert)
        }
        
        .sheet(isPresented: $createArtistVM.showImagePicker, content: {
            ImagePicker(selectedImage: $createArtistVM.bioImage, finishedSelecting: .constant(nil))
        })
    }
    
}




struct CreatArtistAlbumSongView_Previews: PreviewProvider {
    static var previews: some View {
        CreateArtistView()
            .environmentObject(ViewModel())
    }
}
