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
struct MyAlertItem: Identifiable, Error {
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




enum MyError: Error {
    case infoIncomplete
    case error
    case duplicate
    case unknown
}

struct MyErrorContext {
    
    static func getErrorWith(error: Error) -> MyAlertItem {
        switch error {
        case .infoIncomplete as MyError:
            return MyErrorContext().infoIncomplete
        case .error as MyError:
            return MyErrorContext().actionFailied
        case .duplicate as MyError:
            return MyErrorContext().duplicate
        default:
            return MyErrorContext().unknown
        }
    }
        
    private let infoIncomplete = MyAlertItem(title: Text("All fields marked with an \"*\" must be completed."), primaryButton: .default(Text("Dismiss")))
    
    private let actionFailied = MyAlertItem(title: Text("Error"), message: Text("An error occiured. Please try again."), primaryButton: .default(Text("Dismiss")))
  
    private let duplicate = MyAlertItem(title: Text("Duplicate"), message: Text("Duplicates are not allowed. Please try again."), primaryButton: .default(Text("Dismiss")))
  
    private let unknown = MyAlertItem(title: Text("Unknown Error"), message: Text("An unknown error has occured. Please try again."), primaryButton: .default(Text("Dismiss")))
  
    
    
    
    static let generalErrorAlert: MyAlertItem = MyAlertItem(title: Text("Error"), message: Text("There was an error. Please try again."), primaryButton: .cancel(Text("Dismiss")))
    
    static let restoreFailedAlert: MyAlertItem = MyAlertItem(title: Text("Restore Purchace Failed"), message: Text("We were unable to restore the transaction."), primaryButton: .cancel(Text("Dismiss")))
    
    static let purchasedFailedAlert: MyAlertItem = MyAlertItem(title: Text("Purchased Failed"), message: Text("We were unable to complete the transaction. Please try again."), primaryButton: .cancel(Text("Dismiss")))
    
    static let createAccontFailedAlert: MyAlertItem = MyAlertItem(title: Text("Failed to create account"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    static let signInFailed: MyAlertItem = MyAlertItem(title: Text("Sign in failed"), message: Text("The Email or password does NOT exist."), primaryButton: .default(Text("Dismiss")))
    
    static let createOwnerArtistFailed: MyAlertItem = MyAlertItem(title: Text("Error creating Artist"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    
    static let infoIncomplete: MyAlertItem = MyAlertItem(title: Text("Info incomplete"), message: Text("All fields with an \"*\" must be filled."), primaryButton: .default(Text("Dismiss")))
    
    static let createAlbumFailed: MyAlertItem = MyAlertItem(title: Text("Error creating Album"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    static let uploadSongFailed: MyAlertItem = MyAlertItem(title: Text("Error uploading song"), message: Text("Please try again."), primaryButton: .default(Text("Dismiss")))
    
    
    
    /// Basic alert with action.
    /// Creates a MyAlertItem with an action to be completed when the primary "default type" button is pressed.
    static func myAlertWith(title: String, message: String?, action: @escaping (() -> Void) = { }) -> MyAlertItem {
        MyAlertItem(title: Text(title),
                    message: message != nil ? Text(message!) : nil,
                    primaryButton: .default(Text("test"), action: { action() })
        )
    }
    
}
