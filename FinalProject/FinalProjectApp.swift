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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
