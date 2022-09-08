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
            Section {
                TextField("Task", text: $item.wrappedItem)
                    .disabled(item.completed)
                    .onChange(of: item.wrappedItem) { newValue in
                        try? viewContext.save()
                    }
            }
            
            Section {
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
        }
    }
    
    func completeTask() {
        item.completed.toggle()
        try? viewContext.save()
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
