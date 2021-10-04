//
//  UploadSongView.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/6/21.
//

/** UPLOADS A SONG ONLY TO AN EXISTING ALBUM/ARTIST */


import SwiftUI

struct UploadSongView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @StateObject var uploadVM = UploadSongViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    HStack {
                        Spacer()
                        Button(action: {
                            uploadVM.showDocumentPicker.toggle()
                        }, label: {
                            Text(uploadVM.localFilePath != nil ? String(uploadVM.localFilePath!.lastPathComponent) : "Attach Mp3")
                        })
                        .frame(width: 200, height: 50)
                        .foregroundColor(.white)
                        .background(Color.mainApp)
                        .cornerRadius(8)
                        Spacer()
                    }
                    
                    if #available(iOS 15.0, *) {
                        TextField("Song Title*", text: $uploadVM.songTitle)
                            .font(.system(size: 24))
                            .multilineTextAlignment(.center)
                            .textInputAutocapitalization(.words)
                            .padding(.bottom)
                    } else {
                        // Fallback on earlier versions
                        TextField("Song Title*", text: $uploadVM.songTitle)
                            .font(.system(size: 24))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    }
                    
                    Picker("Album*", selection: $uploadVM.album) {
                        ForEach(vm.user.ownerAlbums, id: \.self) { album in
                            HStack {
                                Text(album.title)
                            }
                        }
                    }
                    
                    Picker("Genre*", selection: $uploadVM.songGenre) {
                        TextField("Add new genre", text: $uploadVM.newGenreName, onCommit: {
                            // add new genre to database here
                            vm.saveNewGenre(newGenreName: uploadVM.newGenreName)
                        })
                        
                        ForEach(Genres.names.sorted(), id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    
                    TextField("Lyrics", text: $uploadVM.lyrics)
                        .frame(height: 200)
                    
                    
                    
                } // End Form
                
                .navigationBarTitle(Text("Upload Song"), displayMode: .inline)
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
                            uploadVM.uploadSong(viewModel: vm)
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Upload")
                        })
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color.mainApp)
                            .cornerRadius(8)
                    )
            }.ignoresSafeArea(edges: .bottom)
        }
        
        .sheet(isPresented: $uploadVM.showDocumentPicker) {
            DocumentPicker(filePath: $uploadVM.localFilePath, file: $uploadVM.fileData, contentTypes: [.mp3, .audio])
        }
        
    }
    
    
    
}





struct UploadSongView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSongView()
            .environmentObject(ViewModel())
            .environmentObject(ProfileViewModel())
    }
}
