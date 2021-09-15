//
//  SignInView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/14/21.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @StateObject var signinVM = SigninViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                // Sign in fields
                VStack {
                    TextField("Email", text: $signinVM.email)
                        .frame(width: 330, height: 80, alignment: .center)
                        .background(Color.blue)
                        .font(.title)
                        .foregroundColor(.white)
                        .accentColor(.gray)
                        .multilineTextAlignment(.center)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .lineLimit(1)
                    
                    SecureField("Password", text: $signinVM.password)
                        .frame(width: 330, height: 80, alignment: .center)
                        .background(Color.blue)
                        .font(.title)
                        .foregroundColor(.white)
                        .accentColor(.gray)
                        .multilineTextAlignment(.center)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .lineLimit(1)
                    
                    ZStack {
                        Button(action: {
                            signinVM.signIn(completion: { success in
                                if success == true {
                                    vm.showSigninView.toggle()
                                    vm.cacheUser(completion: { _ in })
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    vm.alertItem = MyStandardAlertContext.signInFailed
                                }
                            })
                        }, label: {
                            Text("Sign In")
                                .font(.title)
                        })
                        .padding(.top)
                        .opacity(signinVM.isSigningIn ? 0.0 : 1.0)
                        
                        if signinVM.isSigningIn {
                            ProgressView()
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text("Dont have an account?")
                        Spacer()
                        Button(action: {
                            signinVM.showCreateAccount.toggle()
                        }, label: {
                            Text("Create One")
                        })
                        Spacer()
                    }.offset(y: 20)
                    
                    Spacer()
                    
                } // End main VStack
                
                .padding(.top)
                
                .navigationBarTitle(Text("Indie Music"), displayMode: .inline)
                
                .fullScreenCover(isPresented: $signinVM.showCreateAccount, onDismiss: {
                    // dismiss sign in view if account was created
                    signinVM.showCreateAccount = false
                }, content: {
                    CreateAccountView()
                        .environmentObject(vm)
                })
                
            } // End Nav View
            
        } // End ZStack
        
        
        .alert(item: $vm.alertItem, content: { alertItem in
            MyAlertItem.present(alertItem: alertItem)
        }) // End alert
        
    }
    
}




struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(ViewModel())
    }
}
