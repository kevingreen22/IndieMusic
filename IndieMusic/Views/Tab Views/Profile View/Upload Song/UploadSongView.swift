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
    @StateObject var uploadVM = UploadSongViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    TextField("Song Title", text: $uploadVM.songTitle)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    Picker("Album", selection: $uploadVM.album) {
                        // get all albums for artist picked above
                        ForEach(vm.user.getOwnerAlbums(), id: \.self) { album in
                            HStack {
                                Text(album.title)
                            }
                        }
                    }
                    
                    Picker("Genre", selection: $uploadVM.songGenre) {
                        ForEach(Genres.names, id: \.self) { genre in
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
                            // upload song
                            uploadVM.uploadSong(viewModel: vm)
                        }, label: {
                            Text("Upload")
                        })
                        .frame(width: 300, height: 50)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                    )
            }.ignoresSafeArea(edges: .bottom)
        }
        
        .alert(item: $vm.alertItem, content: { alertItem in
            MyAlertItem.present(alertItem: alertItem)
        }) // End alert
        
        .sheet(isPresented: $uploadVM.showImagePicker) {
            ImagePicker(selectedImage: $uploadVM.selectedImage, finishedSelecting: .constant(nil))
        }
        
    }
    
}





struct UploadSongVIew_Previews: PreviewProvider {
    static var previews: some View {
        UploadSongView()
            .environmentObject(ViewModel())
    }
}
