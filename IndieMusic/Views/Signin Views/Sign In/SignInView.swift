//
//  SignInView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/14/21.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @StateObject var signinVM = SigninViewModel()
    
    
    var body: some View {
        ZStack {
            VStack {
                
                Image(systemName: "play.rectangle")
                    .font(.system(size: 200))
                    .foregroundColor(.mainApp)
                    .shadow(radius: 5)
                
                TextField("Email", text: $signinVM.email)
                    .frame(width: 330, height: 80, alignment: .center)
                    .font(.title)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .accentColor(.gray)
                    .multilineTextAlignment(.center)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .lineLimit(1)
                
                SecureField("Password", text: $signinVM.password)
                    .frame(width: 330, height: 80, alignment: .center)
                    .font(.title)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .accentColor(.gray)
                    .multilineTextAlignment(.center)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .lineLimit(1)
                
                Button {
                    signinVM.isSigningIn.toggle()
                    signinVM.signIn(completion: { success in
                        if success == true {
                            vm.showSigninView.toggle()
                            vm.cacheUser(completion: { _ in })
                            signinVM.isSigningIn.toggle()
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            signinVM.isSigningIn.toggle()
                            vm.alertItem = MyErrorContext.signInFailed
                        }
                    })
                } label: {
                    Text("Sign In")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 55)
                        .background(Color.mainApp)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .buttonStyle(ActivityIndicatorButtonStyle(start: signinVM.isSigningIn))
                .padding(.top)
                
                
                Button("Forgot Password?") {
                    //
                }.offset(y: 20)
                
                
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
                }.offset(y: 40)
                
                Spacer()
                
            } // End main VStack
            
            .padding(.top)
            
        } // End ZStack
        
        .fullScreenCover(isPresented: $signinVM.showCreateAccount, onDismiss: {
            // dismiss sign in view if account was created
            signinVM.showCreateAccount = false
        }, content: {
            CreateAccountView()
                .environmentObject(vm)
        })
        
        .alert(item: $vm.alertItem, content: { alertItem in
            MyAlertItem.present(alertItem: alertItem)
        }) // End alert
        
    }
    
}




struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .environmentObject(ViewModel())
            SignInView()
                .environmentObject(ViewModel())
        }
    }
}
