//
//  App.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import Foundation
import SwiftUI

extension App {
    
    var isFirstAppRun: Bool {
        if !UserDefaults.standard.bool(forKey: "first_app_run") {
            UserDefaults.standard.set(true, forKey: "first_app_run")
            return true
        } else {
            return false
        }
    }
}
