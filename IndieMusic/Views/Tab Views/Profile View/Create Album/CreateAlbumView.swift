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
        ZStack {
            NavigationView {
                Form {
                    Image(uiImage: (createAlbumVM.selectedImage ?? UIImage(systemName: "photo"))!)
                        .resizable()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            createAlbumVM.showImagePicker.toggle()
                        }
                    
                    TextField("Enter Album name", text: $createAlbumVM.albumName)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Picker("Genre", selection: $createAlbumVM.genre) {
                        ForEach(Genres.names, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    
                    Picker("Year", selection: $createAlbumVM.year) {
    //                    ForEach(1970...getCurrentYear()) { year in
    //                        Text(year)
    //                    }
                    }
                    
                    
                    
                }
                
                
                .sheet(isPresented: $createAlbumVM.showImagePicker, content: {
                    ImagePicker(selectedImage: $createAlbumVM.selectedImage, finishedSelecting: $createAlbumVM.pickImage)
                })
                
                .navigationBarTitle(Text("Create Album"), displayMode: .inline)
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
                            createAlbumVM.createAlbum(viewModel: vm, completion: { success in
                                if success {
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    vm.alertItem = MyStandardAlertContext.
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
                    )
            }.ignoresSafeArea(edges: .bottom)
            
            
        }
    }
    
    
    
    
    
    
}






struct CreateAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlbumView()
    }
}
