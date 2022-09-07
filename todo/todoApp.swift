//
//  todoApp.swift
//  todo
//
//  Created by Chris Kimber on 7/09/22.
//

import SwiftUI

@main
struct todoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
