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
            .padding(.top, 50)
            
            dismissButton
            
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
    
    var dismissButton: some View {
        VStack {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
            }
            Spacer()
        }.padding([.leading, .top])
    }
    
    var mainImage: some View {
        Image("record_player")
            .resizable()
            .frame(width: 300, height: 300)
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
//                    vm.alertItem = MyErrorContext.signInFailed
                }
            })
        } label: {
            Text("Sign In")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 300, height: 55)
                .background(Color.theme.primary)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .buttonStyle(ActivityIndicatorButtonStyle(start: signinVM.isSigningIn))
        .padding(.top)
    }
    
    var forgotPassword: some View {
        Button("Forgot Password?") {
            signinVM.activeFullScreen = .forgotPassword
        }.padding(.top, 20)
        
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
        }.padding(.top, 20)
    }
    
    
}




struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.signinVM)
            
            SignInView()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.signinVM)
                .preferredColorScheme(.dark)
        }
    }
}
