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
        VStack {
            Image(uiImage: (uploadVM.selectedImage ?? UIImage(systemName: "photo"))!)
                .resizable()
                .frame(maxWidth: 300, maxHeight: 300)
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    uploadVM.showImagePicker.toggle()
                }
            
            List {
//                Picker("", selection: $uploadVM.artist) {
//                    // get artist(s) from user
////                    ForEach(user.artist) { artist in
////                        Text(artist)
////                    }
//                }
                
                TextField("Song Title", text: $uploadVM.songTitle)
                Spacer()
                Picker("Genre", selection: $uploadVM.songGenre) {
                    ForEach(Genres.names, id: \.self) { genre in
                        Text(genre)
                    }
                }
                Spacer()
                TextField("Lyrics", text: $uploadVM.lyrics)
                Spacer()
                Picker("Album", selection: $uploadVM.album) {
                    // get all albums for artist picked above
                    ForEach(vm.user.getOwnerAlbums(), id: \.self) { album in
                        HStack {
                            Text(album.title)
                        }
                    }
                }.frame(height: 100)
            }
            

            Button(action: {
                // upload song
                uploadVM.uploadSong()
            }, label: {
                Text("Upload")
            })
            .frame(width: 300, height: 50)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(8)
        }
        
        .alert(item: $vm.alertItem, content: { alertItem in
            MyAlertItem.present(alertItem: alertItem)
        }) // End alert
        
        .sheet(isPresented: $uploadVM.showImagePicker) {
            ImagePicker(selectedImage: $uploadVM.selectedImage)
        }
        
    }
    
}





struct UploadSongVIew_Previews: PreviewProvider {
    static var previews: some View {
        UploadSongView()
            .environmentObject(ViewModel())
    }
}
