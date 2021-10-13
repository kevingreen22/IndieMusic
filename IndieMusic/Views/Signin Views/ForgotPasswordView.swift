//
//  ForgotPasswordView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/12/21.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: MainViewModel
    
    @State private var email: String = ""
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.padding(.leading)
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                Text("Enter the Email for the account you want to reset the password for.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                TextField("Email", text: $email)
                    .frame(width: 330, height: 80, alignment: .center)
                    .font(.title)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .accentColor(.gray)
                    .multilineTextAlignment(.center)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .lineLimit(1)
                    .keyboardType(.emailAddress)
                
                
                Button {
                    // reset password here
                    
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Reset Password")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 55)
                        .background(Color.mainApp)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top)
                
                
            }
        }
        
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(MainViewModel())
    }
}
