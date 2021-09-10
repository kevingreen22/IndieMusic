//
//  CreateAccountView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/15/21.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @StateObject var createAccountVM = CreateAccountVM()
    
    var body: some View {
        ZStack {
            NavigationView {
                // Create accont fields
                VStack {
                    Group {
                        TextField("Name", text: $createAccountVM.name)
                            .frame(width: 330, height: 60, alignment: .center)
                            .background(Color.blue)
                            .font(.title)
                            .foregroundColor(.white)
                            .accentColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                        
                        TextField("Email", text: $createAccountVM.email)
                            .frame(width: 330, height: 60, alignment: .center)
                            .background(Color.blue)
                            .font(.title)
                            .foregroundColor(.white)
                            .accentColor(.gray)
                            .multilineTextAlignment(.center)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .lineLimit(1)
                        
                        SecureField("Password", text: $createAccountVM.password)
                            .frame(width: 330, height: 60, alignment: .center)
                            .background(Color.blue)
                            .font(.title)
                            .foregroundColor(.white)
                            .accentColor(.gray)
                            .multilineTextAlignment(.center)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .lineLimit(1)
                    }
                    
                    ZStack {
                        Button(action: {
                            createAccountVM.createAccount(completion: { success in
                                if success {
                                    vm.cacheUser()
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    self.vm.alertItem = MyStandardAlertContext.createAccontFailedAlert
                                }
                            })
                        }, label: {
                            Text("Create Account")
                                .font(.title)
                        })
                        .padding(.top)
                        .opacity(createAccountVM.isSigningIn ? 0.0 : 1.0)
                        
                        if createAccountVM.isSigningIn {
                            ProgressView()
                        }
                    }
                    
                    Spacer()
                    
                } // End Main VStack
                
                .padding(.top)
                
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }).foregroundColor(.blue)
                
                .navigationBarTitle(Text("Create Account"), displayMode: .inline)
                
            } // End Nav View
            
        } // End ZStack
        
        .alert(item: $vm.alertItem, content: { alertItem in
            MyAlertItem.present(alertItem: alertItem)
        })
        
    } // End Body
    
} // End Struct








struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(ViewModel())
    }
}
