//
//  AirplayList.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/15/21.
//

import SwiftUI
import AVKit
import MediaPlayer

/// Must add frame modifier with width and height of 40.
struct AirPlayButton: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        return AirPlayViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
}



class AirPlayViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isDarkMode = self.traitCollection.userInterfaceStyle == .dark

        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(scale: .large)
        let boldSearch = UIImage(systemName: "airplayaudio", withConfiguration: boldConfig)

        button.setImage(boldSearch, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.tintColor = isDarkMode ? .black : UIColor(white: 1, alpha: 0.6)

        button.addTarget(self, action: #selector(self.showAirPlayMenu(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }

    @objc func showAirPlayMenu(_ sender: UIButton) {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let routePickerView = AVRoutePickerView(frame: rect)
        routePickerView.backgroundColor = UIColor.clear
        routePickerView.activeTintColor = UIColor.red
        routePickerView.tintColor = UIColor.white
        self.view.addSubview(routePickerView)
        for view: UIView in routePickerView.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        routePickerView.removeFromSuperview()
        
// copied from https://stackoverflow.com/a/44909445/7974174
//        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
//        let airplayVolume = MPVolumeView(frame: rect)
//        airplayVolume.showsVolumeSlider = false
//        self.view.addSubview(airplayVolume)
//        for view: UIView in airplayVolume.subviews {
//            if let button = view as? UIButton {
//                button.sendActions(for: .touchUpInside)
//                break
//            }
//        }
//        airplayVolume.removeFromSuperview()
    }
}













//struct AirPlayView: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> UIView {
//        let routePickerView = AVRoutePickerView()
//        routePickerView.backgroundColor = UIColor.clear
//        routePickerView.activeTintColor = UIColor.red
//        routePickerView.tintColor = UIColor.white
//
//        return routePickerView
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//    }
//}
//
//struct AirPlayView_Preview: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            AirPlayView()
//        }
//    }
//}


