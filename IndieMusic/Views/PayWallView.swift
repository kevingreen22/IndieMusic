//
//  PayWallView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/21/21.
//

import SwiftUI

struct PayWallView: View {
    @EnvironmentObject var vm: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
            VStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                    .overlay(
                        Image(systemName: "crown.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: .center)
                            .foregroundColor(.white)
                    )
                
                
                
                Text("Purchace Premium\nAd Free listening all day everyday.")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("$4.99 Monthly")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                
                Spacer()
                
                Button(action: {
                    // Revenue Cat
                    // buy premium here
                    IAPManager.shared.fetchPackages { package in
                        guard let package = package else { return }
                        print("Got Package!")
                        IAPManager.shared.subscribe(package: package) { success in
                            print("Purchace \(success)")
                            DispatchQueue.main.async {
                                if success == false {
                                    vm.alertItem = MyErrorContext.purchasedFailedAlert
                                }
                            }
                        }
                    }
                }, label: {
                    Text("Purchace Premium")
                        .font(.title2)
                })
                .frame(width: 270, height: 60)
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // Revenue Cat
                    // restore purchaces here
                    IAPManager.shared.restorePurchaces { success in
                        print("Restored \(success)")
                        DispatchQueue.main.async {
                            if success == false {
                                vm.alertItem = MyErrorContext.restoreFailedAlert
                            }
                        }
                    }
                }, label: {
                    Text("Restore Purchaces")
                })
                .foregroundColor(.blue)
                
                Spacer()
                
                Text("This is an auto-renewable subscription. It will be charged to your iTunes account before each pay period. You can cancel at any time by going into your Setting > Subscriptions. Restore purchaces if previously subscribed.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                    .foregroundColor(.white)
                }.padding()
                Spacer()
            }
            
            .navigationTitle("Indie Music Premium")
        }
        
        .alert(item: $vm.alertItem, content: { alertItem in
            MyAlertItem.present(alertItem: alertItem)
        }) // End alert
    }
}












struct PayWallView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PayWallView()
                .environmentObject(dev.mainVM)
                .preferredColorScheme(.light)
            
            PayWallView()
                .environmentObject(dev.mainVM)
                .preferredColorScheme(.dark)
        }
    }
}
