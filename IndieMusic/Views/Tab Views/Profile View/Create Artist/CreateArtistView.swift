//
//  CreatArtistAlbumSongView.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/1/21.
//

import SwiftUI

struct CreateArtistView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: MainViewModel
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
                        
                        Picker("Genre*", selection: $createArtistVM.genre) {
                            TextField("Add new genre", text: $createArtistVM.newGenreName,  onCommit: {
                                // add new genre to database here
                                vm.saveNewGenre(newGenreName: createArtistVM.newGenreName)
                                 
                            }).multilineTextAlignment(.center)
                            
                            ForEach(Genres.names.sorted(), id: \.self) { genre in
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
                            
                            Menu(content: {
                                Button {
                                    createArtistVM.activeSheet = .imagePicker(sourceType: .photoLibrary, picking: .bioImage)
                                } label: {
                                    Label("Images", systemImage: "photo")
                                }
                                
                                Button {
                                    createArtistVM.activeSheet = .imagePicker(sourceType: .camera, picking: .bioImage)
                                } label: {
                                    Label("Camera", systemImage: "camera.fill")
                                }
                                
                                Button {
                                    createArtistVM.activeSheet = .documentPicker(picking: .bioImage)
                                } label: {
                                    Label("Browse", systemImage: "folder.fill")
                                }
                            }, label: {
                                Image(uiImage: createArtistVM.bioImage ?? UIImage(systemName: "person.circle")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 50)
                                    .clipShape(Circle())
                                    .transition(.opacity)
                            })
//                            Image(uiImage: createArtistVM.bioImage ?? UIImage(systemName: "person.circle")!)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 50)
//                                .clipShape(Circle())
//                                .transition(.opacity)
//                                .onTapGesture {
//                                    createArtistVM.showImagePicker.toggle()
//                                }
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
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Create")
                                    .font(.system(size: 25))
                                    .frame(width: 300, height: 50)
                                    .foregroundColor(.white)
                                    .background(Color.mainApp)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            })
                            .padding()
                            .shadow(radius: 10)
                        )
                }.ignoresSafeArea(edges: .bottom)
                
                
                
            } // End ZStack
        } // End geometry reader
        
        .sheet(item: $createArtistVM.activeSheet) { item in
            switch item {
            case .imagePicker(let sourceType, _) :
                ImagePicker(selectedImage: $createArtistVM.bioImage, finishedSelecting: .constant(nil), sourceType: sourceType)
                
            case .documentPicker:
                DocumentPicker(filePath: $createArtistVM.url, file: .constant(nil), contentTypes: [.image])
            case .signIn, .paywall:
                EmptyView()
            }
        }
    }
    
}




struct CreatArtistAlbumSongView_Previews: PreviewProvider {
    static var previews: some View {
        CreateArtistView()
            .environmentObject(MainViewModel())
            .environmentObject(ProfileViewModel())
    }
}
