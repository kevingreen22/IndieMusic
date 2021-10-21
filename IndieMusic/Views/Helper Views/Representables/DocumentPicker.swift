//
//  DocumentPicker.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/19/21.
//

import SwiftUI
import UniformTypeIdentifiers
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var filePath: URL?
    @Binding var fileData: Data?
    var contentTypes: [UTType] = [.audio, .mp3]
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) { }
    
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(parent1: DocumentPicker){
            self.parent = parent1
        }
        
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("Document picker url(s): \(urls)")
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            
            defer {
                DispatchQueue.main.async {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            do {
                let data = try Data(contentsOf: url.absoluteURL)
                parent.fileData = data
                parent.filePath = url
            } catch {
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    
}
