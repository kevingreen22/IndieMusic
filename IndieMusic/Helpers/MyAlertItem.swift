//
//  AlertItem.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/27/21.
//

import SwiftUI

/// The alert item.
/// To use this, declare a variable to hold an optional instance of AlertItem in your view/view model,
/// i.e. @Published var alertItem: MyAlertItem?
/// then when you need to display the alert, set that instance
/// to one of the alert contexts from below. Additional contexts
/// can be created for more alert options.
struct MyAlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var primaryButton: Alert.Button
    var secondaryButton: Alert.Button?

    
    
    /// This method is used in the view where .alert is used. In the view's modifier that is showing the alert, simply add this method.
    /// ex: ContentView()
    ///         .alert(item: $alertItem, content: { alertItem in
    ///             MyAlert.present(alertItem: alertItem)
    ///         })
    /// - Parameter alertItem: The alert item instance that references the above struct.
    /// - Returns: The alert instance needed for the alert item. i.e. one or two buttons.
    static func present(alertItem: MyAlertItem) -> Alert {
        if let secondaryButton = alertItem.secondaryButton {
            return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.primaryButton, secondaryButton: secondaryButton)
        } else {
            return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.primaryButton)
        }
    }
    
}



/// Standart alerts that do not have an action attached.
struct MyStandardAlertContext {
    
    static let generalErrorAlert: MyAlertItem = MyAlertItem(title: Text("Error"), message: Text("There was an error. Please try again."), primaryButton: .cancel(Text("Dismiss")))
    
    static let restoreFailedAlert: MyAlertItem = MyAlertItem(title: Text("Restore Purchace Failed"), message: Text("We were unable to restore the transaction."), primaryButton: .cancel(Text("Dismiss")))
    
    static let purchasedFailedAlert: MyAlertItem = MyAlertItem(title: Text("Purchased Failed"), message: Text("We were unable to complete the transaction. Please try again."), primaryButton: .cancel(Text("Dismiss")))
    
    static let createAccontFailedAlert: MyAlertItem = MyAlertItem(title: Text("Failed to create account"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    static let signInFailed: MyAlertItem = MyAlertItem(title: Text("Sign in failed"), message: Text("The Email or password does NOT exist."), primaryButton: .default(Text("Dismiss")))
    
    static let createOwnerArtistFailed: MyAlertItem = MyAlertItem(title: Text("Error creating Artist"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    
    static let infoIncomplete: MyAlertItem = MyAlertItem(title: Text("Info incomplete"), message: Text("All fields with an \"*\" must be filled."), primaryButton: .default(Text("Dismiss")))
    
    static let createAlbumFailed: MyAlertItem = MyAlertItem(title: Text("Error creating Album"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    static let uploadSongFailed: MyAlertItem = MyAlertItem(title: Text("Error uploading song"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    
    
    // Basic alert with action.
    static func test(action1: (() -> Void)? = { }) -> MyAlertItem {
        MyAlertItem(title: Text("Test"), message: Text("Test"), primaryButton: .default(Text("test"), action: {
            action1!()
        }))
    }
}







enum MySongError {
    case songInfoIncomplete
    case uploadSongFailied
}

struct MySongUploadErrorContext {
    
    static func getError(error: MySongError) -> MyAlertItem {
        switch error {
        case .songInfoIncomplete:
            return MySongUploadErrorContext().songInfoIncomplete
        case .uploadSongFailied:
            return MySongUploadErrorContext().uploadSongFailied
        }
    }
        
    private let songInfoIncomplete = MyAlertItem(title: Text("All fields marked with an \"*\" must be filled."), primaryButton: .default(Text("Dismiss")))
    
    private let uploadSongFailied = MyAlertItem(title: Text("Error uploading song"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
  
}
