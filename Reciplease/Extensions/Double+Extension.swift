//
//  Int+Extension.swift
//  Reciplease
//
//  Created by Birkyboy on 09/09/2021.
//

import Foundation

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
