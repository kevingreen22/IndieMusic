//
//  CreationView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/5/21.
//

import SwiftUI

struct CreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @StateObject var createVM = CreationViewModel()
    
    var body: some View {
        NavigationView {
        GeometryReader { proxy in
            VStack {
                
                    // Artist section
                    Section {
                        Form {
                            TextField("Enter Artist name*", text: $createVM.artistName)
                                .font(.system(size: 24))
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                                .offset(x: -20)
                            
                            Picker("Genre*", selection: $createVM.artistGenre) {
                                TextField("Add new genre", text: $createVM.newGenreName,  onCommit: {
                                    // add new genre to database here
                                    vm.saveNewGenre(newGenreName: createVM.newGenreName)
                                    
                                }).multilineTextAlignment(.center)
                                
                                ForEach(Genres.names.sorted(), id: \.self) { genre in
                                    Text(genre)
                                }
                            }
                            
                            
                            TextField("Enter Bio", text: $createVM.bio)
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
                                
                                Menu(content: {
                                    PickImageSourceMenuContent(picking: .albumImage)
                                }, label: {
                                    Image(uiImage: createVM.bioImage ?? UIImage(systemName: "person.circle")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 50)
                                        .clipShape(Circle())
                                        .transition(.opacity)
                                })
                            }
                            
                        }
                    } header: { Text("Add Artist") } // End Artist section
                        
                    
                    // Album section
                    Section {
                        Form {
                            HStack {
                                Spacer()
                                Menu(content: {
                                    PickImageSourceMenuContent(picking: .albumImage)
                                }, label: {
                                    Image(uiImage: createVM.selectedAlbumImage ?? UIImage.albumArtworkPlaceholder)
                                        .resizable()
                                        .frame(width: 260, height: 260)
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(5)
                                    
                                }).padding(.bottom)
                                Spacer()
                            }
                            
                            TextField("Enter Album name*", text: $createVM.albumName)
                                .font(.system(size: 24))
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Picker("Genre*", selection: $createVM.albumGenre) {
                                TextField("Add new genre", text: $createVM.newGenreName, onCommit: {
                                    // add new genre to database here
                                    vm.saveNewGenre(newGenreName: createVM.newGenreName)
                                })
                                
                                ForEach(Genres.names.sorted(), id: \.self) { genre in
                                    Text(genre)
                                }
                            }
                            
                            Picker("Year*", selection: $createVM.year) {
                                ForEach((1970...createVM.currentYear).reversed(), id: \.self) { year in
                                    Text(String(year))
                                }
                            }
                            
                        }
                    } header: { Text("Add Album") } // End Album section
                    
                    
                    // Song section
                    Section {
                        Form {
                            HStack {
                                Spacer()
                                Button(action: {
                                    createVM.activeSheet = .documentPicker(picking: .mp3)
                                }, label: {
                                    Text(createVM.songLocalFilePath != nil ? String(createVM.songLocalFilePath!.lastPathComponent) : "Attach Mp3")
                                })
                                .frame(width: 200, height: 50)
                                .foregroundColor(.white)
                                .background(Color.mainApp)
                                .cornerRadius(8)
                                Spacer()
                            }
                            
                            if #available(iOS 15.0, *) {
                                TextField("Song Title*", text: $createVM.songTitle)
                                    .font(.system(size: 24))
                                    .multilineTextAlignment(.center)
                                    .textInputAutocapitalization(.words)
                                    .padding(.bottom)
                            } else {
                                // Fallback on earlier versions
                                TextField("Song Title*", text: $createVM.songTitle)
                                    .font(.system(size: 24))
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                            }
                            
                            Picker("Album*", selection: $createVM.album) {
                                ForEach(vm.user.ownerAlbums, id: \.self) { album in
                                    HStack {
                                        Text(album.title)
                                    }
                                }
                            }
                            
                            Picker("Genre*", selection: $createVM.songGenre) {
                                TextField("Add new genre", text: $createVM.newGenreName, onCommit: {
                                    // add new genre to database here
                                    vm.saveNewGenre(newGenreName: createVM.newGenreName)
                                })
                                
                                ForEach(Genres.names.sorted(), id: \.self) { genre in
                                    Text(genre)
                                }
                            }
                            
                            TextField("Lyrics", text: $createVM.lyrics)
                                .frame(height: 200)
                            
                        }
                    } header: { Text("Add Song") } // End Song Section
                    
                    
                    .navigationBarTitle(Text("Create Artist"), displayMode: .inline)
                    .navigationBarItems(leading: Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    
                } // End Nav View
                
            LargeActionButton {
                // create stuff here
            }
                
            } // End VStack
            .ignoresSafeArea()
            
        } // End geometry reader
        
//        .alert(item: $vm.alertItem) { alert in
//            MyAlertItem.present(alertItem: alert)
//        }
        
//        .sheet(item: $createVM.activeSheet) { item in
//            switch item {
//            case .imagePicker(let sourceType, let picking):
//                switch picking {
//                case .bioImage:
//                    ImagePicker(selectedImage: $createVM.bioImage, finishedSelecting: $createVM.finishedPickingImage)
//
//                case .albumImage:
//                    ImagePicker(selectedImage: $createVM.selectedAlbumImage, finishedSelecting: $createVM.finishedPickingImage, sourceType: sourceType)
//                case .mp3:
//                    EmptyView()
//                }
//
//            case .documentPicker(let picking):
//                switch picking {
//                case .bioImage, .albumImage:
//                    DocumentPicker(filePath: $createVM.url, file: .constant(nil), contentTypes: [.image])
//
//                case .mp3:
//                    DocumentPicker(filePath: $createVM.songLocalFilePath, file: $createVM.songFileData, contentTypes: [.mp3, .audio])
//                }
//
//            case .createArtist, .createAlbum, .uploadSong:
//                EmptyView()
//            }
//        }
    }
    
    private func PickImageSourceMenuContent(picking: PickingType) -> some View {
        VStack {
            Button {
                createVM.activeSheet = .imagePicker(sourceType: .photoLibrary, picking: picking)
            } label: {
                Label("Images", systemImage: "photo")
            }
            
            Button {
                createVM.activeSheet = .imagePicker(sourceType: .camera, picking: picking)
            } label: {
                Label("Camera", systemImage: "camera.fill")
            }
            
            Button {
                createVM.activeSheet = .documentPicker(picking: picking)
            } label: {
                Label("Choose File", systemImage: "folder.fill")
            }
        }
    }
    
}




struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}






struct PickImageSourceMenuContent: View {
    @State private var activeSheet: ActiveSheet?
    var picking: PickingType
    
    var body: some View {
        VStack {
            Button {
                self.activeSheet = .imagePicker(sourceType: .photoLibrary, picking: picking)
            } label: {
                Label("Images", systemImage: "photo")
            }
            
            Button {
                self.activeSheet = .imagePicker(sourceType: .camera, picking: picking)
            } label: {
                Label("Camera", systemImage: "camera.fill")
            }
            
            Button {
                self.activeSheet = .documentPicker(picking: picking)
            } label: {
                Label("Choose File", systemImage: "folder.fill")
            }
        }
    }
}







struct LargeActionButton: View {
    let action: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .background(Color.black).opacity(0.05)
                .blur(radius: 3)
                .frame(height: 100)
                .ignoresSafeArea(edges: .bottom)
                .overlay(
                    Button(action: {
                        action()
//                        createArtistVM.createArtist(viewModel: vm)
//                        self.presentationMode.wrappedValue.dismiss()
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
}


struct LargeNavigationButton<Destination: View>: View {
    let destination: Destination
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.black).opacity(0.05)
                .blur(radius: 3)
                .frame(height: 100)
                .ignoresSafeArea(edges: .bottom)
            
            NavigationLink {
                destination
            } label: {
                Text("Next")
                    .font(.largeTitle)
            }
            .frame(width: 300, height: 55)
            .foregroundColor(.white)
            .background(Color.mainApp)
            .cornerRadius(8)
            .shadow(radius: 10)
        }.ignoresSafeArea(edges: .bottom)
    }
}
