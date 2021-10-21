//
//  TimeInterval.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import Foundation
import SwiftUI

extension TimeInterval {
    
    /// Formatter for currently playing views
    func timeFormat(unitsAllowed: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = unitsAllowed
        formatter.zeroFormattingBehavior = .pad
        guard let output = formatter.string(from: self) else { return "0:00" }
        return output
    }

}
