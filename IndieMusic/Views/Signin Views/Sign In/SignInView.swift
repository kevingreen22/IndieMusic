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
    @EnvironmentObject var vm: MainViewModel
    @StateObject var signinVM = SigninViewModel()
    
    
    var body: some View {
        ZStack {
            VStack {
                mainImage
               
                emailField
                
                secureField
                
                signInButton
                
                forgotPassword
                
                createAccount
                
                Spacer()
                
            } // End main VStack
            
            .padding(.top)
            
        } // End ZStack
        
//        .fullScreenCover(item: $signinVM.activeFullScreen, onDismiss: {
//             //dismiss sign in view if account was created
//            signinVM.activeFullScreen = nil
//        }, content: { item in
//            switch item {
//            case .forgotPassword:
//                ForgotPasswordView()
//                    .environmentObject(vm)
//            case .createAccount:
//                CreateAccountView()
//                    .environmentObject(vm)
//            default:
//                EmptyView()
//            }
//        })
        
        .alert(item: $vm.alertItem, content: { alertItem in
            MyAlertItem.present(alertItem: alertItem)
        }) // End alert
        
    }
    
}

extension SignInView {
    
    var mainImage: some View {
        Image(systemName: "play.rectangle")
            .font(.system(size: 200))
            .foregroundColor(.mainApp)
            .shadow(radius: 5)
    }
    
    var emailField: some View {
        TextField("Email", text: $signinVM.email, onCommit: {
            hideKeyboard()
        })
            .frame(width: 330, height: 80, alignment: .center)
            .font(.title)
            .foregroundColor(colorScheme == .light ? .black : .white)
            .accentColor(.gray)
            .multilineTextAlignment(.center)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .lineLimit(1)
            .keyboardType(.emailAddress)
        
    }
    
    var secureField: some View {
        SecureField("Password", text: $signinVM.password, onCommit:  {
            hideKeyboard()
        })
            .frame(width: 330, height: 80, alignment: .center)
            .font(.title)
            .foregroundColor(colorScheme == .light ? .black : .white)
            .accentColor(.gray)
            .multilineTextAlignment(.center)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .lineLimit(1)
    }
    
    var signInButton: some View {
        Button {
            signinVM.isSigningIn.toggle()
            signinVM.signIn(completion: { success in
                if success == true {
                    vm.cacheUser(completion: { success in
                        signinVM.isSigningIn.toggle()
                        self.presentationMode.wrappedValue.dismiss()
                    })
                } else {
                    signinVM.isSigningIn.toggle()
//                            vm.alertItem = MyErrorContext.signInFailed
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
    }
    
    var forgotPassword: some View {
        Button("Forgot Password?") {
            signinVM.activeFullScreen = .forgotPassword
        }.offset(y: 20)
        
    }
    
    var createAccount: some View {
        HStack {
            Spacer()
            Text("Dont have an account?")
            Spacer()
            Button(action: {
                signinVM.activeFullScreen = .createAccount
            }, label: {
                Text("Create One")
            })
            Spacer()
        }.offset(y: 40)
    }
    
    
}




struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .environmentObject(MainViewModel())
                .environmentObject(SigninViewModel())
            SignInView()
                .preferredColorScheme(.dark)
                .environmentObject(MainViewModel())
                .environmentObject(SigninViewModel())
        }
    }
}
