//
//  CreateAlbumView.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

struct CreateAlbumView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @StateObject var createAlbumVM = CreateAlbumViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    HStack {
                        Spacer()
                        Menu(content: {
                            Button {
                                createAlbumVM.activeSheet = .imagePicker(sourceType: .photoLibrary, picking: .albumImage)
                            } label: {
                                Label("Images", systemImage: "photo")
                            }
                            
                            Button {
                                createAlbumVM.activeSheet = .imagePicker(sourceType: .camera, picking: .albumImage)
                            } label: {
                                Label("Camera", systemImage: "camera.fill")
                            }
                            
                            Button {
                                createAlbumVM.activeSheet = .documentPicker(picking: .albumImage)
                            } label: {
                                Label("Browse", systemImage: "folder.fill")
                            }
                            
                        }, label: {
                            Image(uiImage: createAlbumVM.selectedImage ?? UIImage(named: "album_artwork_placeholder")!)
                                .resizable()
                                .frame(width: 260, height: 260)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            
                        }).padding(.bottom)
                        Spacer()
                    }
                    
                    TextField("Enter Album name*", text: $createAlbumVM.albumName)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Picker("Genre*", selection: $createAlbumVM.genre) {
                        TextField("Add new genre", text: $createAlbumVM.newGenreName, onCommit: {
                            // add new genre to database here
                            vm.saveNewGenre(newGenreName: createAlbumVM.newGenreName)
                        })
                        
                        ForEach(Genres.names.sorted(), id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    
                    Picker("Year*", selection: $createAlbumVM.year) {
                        ForEach((1970...createAlbumVM.currentYear).reversed(), id: \.self) { year in
                            Text(String(year))
                        }
                    }
                    
                }
                
                .navigationBarTitle(Text("Create Album"), displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
            
            VStack {
                Spacer()
                Rectangle()
                    .background(Color.black).opacity(0.05)
                    .blur(radius: 3)
                    .frame(height: 100)
                    .ignoresSafeArea(edges: .bottom)
                    .overlay(
                        Button(action: {
                            createAlbumVM.createAlbum(viewModel: vm)
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Create")
                                .font(.system(size: 25))
                        })
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(.white)
                        .background(Color.mainApp)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                    )
            }.ignoresSafeArea(edges: .bottom)
            
        }
        
        .sheet(item: $createAlbumVM.activeSheet) { item in
            switch item {
            case .imagePicker(let sourceType, _) :
                ImagePicker(selectedImage: $createAlbumVM.selectedImage, finishedSelecting: $createAlbumVM.pickImage, sourceType: sourceType)
                
            case .documentPicker:
                DocumentPicker(filePath: $createAlbumVM.url, file: .constant(nil), contentTypes: [.image])
            }
        }
    }
}






struct CreateAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlbumView()
            .environmentObject(ViewModel())
            .environmentObject(ProfileViewModel())
    }
}
