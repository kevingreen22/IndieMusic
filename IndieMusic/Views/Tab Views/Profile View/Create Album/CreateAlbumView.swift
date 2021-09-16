//
//  CreateAlbumView.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

struct CreateAlbumView: View {
    @EnvironmentObject var vm: ViewModel
    @StateObject var createAlbumVM = CreateAlbumViewModel()
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Create Album")
                    .font(.largeTitle)
                
                TextField("Enter Album name", text: $createAlbumVM.albumName)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Picker("Genre", selection: $createAlbumVM.genre) {
                    ForEach(Genres.names, id: \.self) { genre in
                        Text(genre)
                    }
                }
                .frame(width: 100, height: 150)
                .padding()
                
                Picker("Year", selection: $createAlbumVM.year) {
//                    ForEach(1970...getCurrentYear()) { year in
//                        Text(year)
//                    }
                }
                .padding()
                
                
                Button("Choose Album Artwork") {
                    createAlbumVM.showImagePicker.toggle()
                }
                .frame(width: 200, height: 40, alignment: .center)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
                Image(uiImage: (createAlbumVM.selectedImage ?? UIImage(systemName: "photo"))!)
                    .resizable()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        createAlbumVM.showImagePicker.toggle()
                    }
                
                
            }
            
            
            .sheet(isPresented: $createAlbumVM.showImagePicker, content: {
                ImagePicker(selectedImage: $createAlbumVM.selectedImage, finishedSelecting: $createAlbumVM.pickImage)
            })
            
        }
    }
    
    
    
    
    
    
}






struct CreateAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlbumView()
    }
}
