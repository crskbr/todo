//
//  CardBackView.swift
//  todo
//
//  Created by Chris Kimber on 8/09/22.
//

import SwiftUI

struct CardBackView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var item: TodoEntity
    @State var isToday: Bool
    
    @State var itemText: String = ""
    
    var body: some View {
        Form {
            Group {
                TextField("Task", text: $item.wrappedItem)
            }
            
            Group {
                if isToday {
                    Button(action: completeTask) {
                        Text("Complete")
                    }
                } else if !item.completed && !item.migrated {
                    Button(action: migrateTask) {
                        Text("Migrate")
                    }
                }
            }
        }.onDisappear {
            try? viewContext.save()
        }
    }
    
    func completeTask() {
        item.completed.toggle()
    }
    
    func migrateTask() {
        item.migrated = true
        
        let newItem = TodoEntity(context: viewContext)
        newItem.clone(item)
        newItem.day = DateHelper.now().date
        
        try? viewContext.save()
        dismiss()
    }
}
