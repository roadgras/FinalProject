//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import SwiftUI

@main
struct FinalProjectApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var loginData = Login()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear(perform: setupAppearance)
        }
    }
    func setupAppearance() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
}
