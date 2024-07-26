//
//  Colors.swift
//  Realtime Location
//
//  Created by BS1098 on 25/7/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = scanner.string.startIndex
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


extension Color {
    static let oxfordBlue = Color(red: 0.027450980392156862, green: 0.11764705882352941, blue: 0.23921568627450981)
    static let persianBlue = Color(red: 0.03137254901960784, green: 0.2, blue: 0.34509803921568627)
    static let marianBlue = Color(red: 0.12156862745098039, green: 0.25882352941176473, blue: 0.5294117647058824)
    static let turquoise = Color(red: 0.12941176470588237, green: 0.9019607843137255, blue: 0.7568627450980392)
    static let azure = Color(red: 0.8862745098039215, green: 0.9529411764705882, blue: 0.9607843137254902)
}
