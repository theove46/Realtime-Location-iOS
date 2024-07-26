//
//  Distance_App.swift
//  Realtime Location
//
//  Created by BS1098 on 25/7/24.
//

import SwiftUI

@main
struct DistanceApp: App {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.persianBlue) // Tab bar background color
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.turquoise)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.turquoise)]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(.white)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(.white)]
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
