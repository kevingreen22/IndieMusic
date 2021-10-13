//
//  CreateAccountView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/15/21.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: MainViewModel
    @StateObject var createAccountVM = CreateAccountVM()
    
    var body: some View {
        ZStack {
            NavigationView {
                // Create accont fields
                VStack {
                    Group {
                        TextField("Name", text: $createAccountVM.name)
                            .frame(width: 330, height: 60, alignment: .center)
                            .font(.title)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .accentColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                        
                        TextField("Email", text: $createAccountVM.email)
                            .frame(width: 330, height: 60, alignment: .center)
                            .font(.title)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .accentColor(.gray)
                            .multilineTextAlignment(.center)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .lineLimit(1)
                        
                        SecureField("Password", text: $createAccountVM.password1)
                            .frame(width: 330, height: 60, alignment: .center)
                            .font(.title)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .accentColor(.gray)
                            .multilineTextAlignment(.center)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .lineLimit(1)
                        
                        SecureField("Re-enter Password", text: $createAccountVM.password2)
                            .frame(width: 330, height: 60, alignment: .center)
                            .font(.title)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .accentColor(.gray)
                            .multilineTextAlignment(.center)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .lineLimit(1)
                    }
                    
                    ZStack {
                        Button {
                            createAccountVM.isSigningIn.toggle()
                            createAccountVM.createAccount(completion: { success in
                                if success {
                                    vm.cacheUser(completion:  { _ in })
                                    createAccountVM.isSigningIn.toggle()
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    createAccountVM.isSigningIn.toggle()
                                    self.vm.alertItem = MyErrorContext.createAccontFailedAlert
                                }
                            })
                        } label: {
                            Text("Create")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 300, height: 55)
                                .background(Color.mainApp)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(ActivityIndicatorButtonStyle(start: createAccountVM.isSigningIn))
                        .padding(.top)
                        
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
        Group {
            CreateAccountView()
                .environmentObject(MainViewModel())
            CreateAccountView()
                .preferredColorScheme(.dark)
                .environmentObject(MainViewModel())
        }
    }
}
