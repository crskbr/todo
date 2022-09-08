//
//  TodoRowEntryView.swift
//  todo
//
//  Created by Chris Kimber on 7/09/22.
//

import SwiftUI
import CoreData

struct TodoRowEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var item: TodoEntity
    var isToday: Bool
    
    @State var showEdit = false
    @State var text = ""
    
    var body: some View {
        HStack {
            HStack {
                if self.isToday {
                    Text(item.completed ? "✅" : "🔄")
                } else {
                    if item.migrated {
                        Text("➡️")
                    } else {
                        Text(item.completed ? "✅" : "❌")
                    }
                }
                
                Text(item.item!)
                    .strikethrough(item.completed)
            }
        }
    }
}
