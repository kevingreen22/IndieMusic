//
//  ImagePicker.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/30/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var finishedSelecting: Bool?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = sourceType
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.finishedSelecting = false
            parent.presentationMode.wrappedValue.dismiss()
            
        }
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.finishedSelecting = false
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
}


//struct PickImageFromMenu<Model: ObservableObject>: View {
//    let picking: PickingType
//    let model: Model
//    
//    var body: some View {
//        VStack {
//            Button {
//                model.activeSheet = .imagePicker(sourceType: .photoLibrary, picking: picking)
//            } label: {
//                Label("Images", systemImage: "photo")
//            }
//            
//            Button {
//                model.activeSheet = .imagePicker(sourceType: .camera, picking: picking)
//            } label: {
//                Label("Camera", systemImage: "camera.fill")
//            }
//            
//            Button {
//                model.activeSheet = .documentPicker(picking: picking)
//            } label: {
//                Label("Choose File", systemImage: "folder.fill")
//            }
//        }
//    }
//}
