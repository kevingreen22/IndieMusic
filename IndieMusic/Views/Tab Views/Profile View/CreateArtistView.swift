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
    @EnvironmentObject var profileVM: ProfileViewModel
    @State private var addAlbum = true
    @State private var artistName = ""
    @State private var genre = ""
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("Create Artist")
                        .padding(.top)
                        .font(.largeTitle)
                    
                    TextField("Enter Artist name", text: $artistName)
                        .font(.system(size: 24))
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(Genres.names, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    .frame(width: 200, height: 150)
                    .padding()
                    
                } // End VStack
                
            } // End Scroll View
            
            VStack {
                Spacer()
                Button(action: {
                    createArtist(completion: { success in
                        if success {
                            vm.user.isArtistOwner = success
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            vm.alertItem = MyStandardAlertContext.createOwnerArtistFailed
                        }
                    })
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
            }
            
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                    Spacer()
                }
                Spacer()
            }
            
        } // End ZStack
        
        .alert(item: $vm.alertItem) { alert in
            MyAlertItem.present(alertItem: alert)
        }
    }
    
    
    fileprivate func createArtist(completion: ((Bool) -> Void)?) {
        let ownerArtist = Artist(name: artistName, genre: genre, albums: nil)
        DatabaseManger.shared.insert(artist: ownerArtist) { success in
            if success {
                vm.user.artist = ownerArtist
                completion!(true)
            } else {
                completion!(false)
            }
        }
    }
    
    
    
}






struct CreateAlbumView: View {
    @State private var albumName = ""
    @State var genre: String?
    @State var selectedImage: UIImage?
    @State var year: Date = Date()
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            Text("Create Album")
                .font(.largeTitle)
            
            TextField("Enter Album name", text: $albumName)
                .frame(height: 50)
                .multilineTextAlignment(.center)
                .padding()
            
            Picker("Genre", selection: $genre) {
                ForEach(Genres.names, id: \.self) { genre in
                    Text(genre)
                }
            }
            .frame(width: 100, height: 150)
            .padding()
            
            Picker("Year", selection: $year) {
//                ForEach(1970...getCurrentYear()) { year in
//                    Text(year)
//                }
            }
            .padding()
            
            
            Button("Choose Album Artwork") {
                self.showImagePicker.toggle()
            }
            .frame(width: 200, height: 40, alignment: .center)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
            
            
            
        }
        
        
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(selectedImage: $selectedImage)
        })
        
    }
    
    
    
    fileprivate func getCurrentYear() -> Int {
        
        return 2021
    }
    
    
}














struct CreatArtistAlbumSongView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateArtistView()
            
            CreateAlbumView(genre: "Metal")
            
        }
    }
}
