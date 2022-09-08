//
//  ContentView.swift
//  todo
//
//  Created by Chris Kimber on 7/09/22.
//

import SwiftUI
import CoreData
import SwiftDate

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TodoEntity.day, ascending: true)],
        predicate: NSPredicate(format: "day >= %@ AND day < %@", DateHelper.now().dateAt(.startOfDay).date as CVarArg, DateHelper.now().dateAt(.endOfDay).date as CVarArg),
        animation: .default)
    private var items: FetchedResults<TodoEntity>
    
    @State var day: DateInRegion = DateHelper.now()
    @State var dayIsToday: Bool = true
    
    @State var showAddItem: Bool = false
    
    @State var editItem: TodoEntity?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    TodoRowEntryView(item: item, isToday: dayIsToday)
                        .swipeActions(edge: .trailing) {
                            if dayIsToday {
                                
                                Button(item.completed ? "Un-Complete" : "Complete") {
                                    item.completed.toggle()
                                }.tint(item.completed ? .red : .green)
                            } else {
                                if !item.completed && !item.migrated {
                                    Button("Migrate") {
                                        moveToToday(item)
                                    }
                                }
                            }
                        }
                        .onTapGesture(count: 2) {
                            item.completed.toggle()
                        }
                        .onLongPressGesture {
                            if dayIsToday && !item.completed {
                                editItem = item
                            }
                        }
                }
            }
            .popover(isPresented: $showAddItem) {
                AddItemView()
            }
            .popover(item: $editItem) { detail in
                CardBackView(item: detail, isToday: dayIsToday)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: previousDay) {
                        Label("Previous Day", systemImage: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(action: nextDay) {
                        Label("Next Day", systemImage: "chevron.right")
                    }.disabled(dayIsToday)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Label("Add", systemImage: "plus")
                    }.disabled(!dayIsToday)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(day.toFormat("dd MMM yyyy"))
        }
    }
    
    private func updateFilter() {
        items.nsPredicate = NSPredicate(format: "day >= %@ AND day < %@", day.dateAt(.startOfDay).date as CVarArg, day.dateAt(.endOfDay).date as CVarArg)
    }
    
    func moveToToday(_ item: TodoEntity) {
        item.migrated = true
        
        let newItem = TodoEntity(context: viewContext)
        newItem.clone(item)
        newItem.day = DateHelper.now().date
        
        try? viewContext.save()
    }
    
    func previousDay() {
        day = day.dateByAdding(-1, .day)
        dayIsToday = DateHelper.isToday(day)
        updateFilter()
    }
    
    func nextDay() {
        day = day.dateByAdding(1, .day)
        dayIsToday = DateHelper.isToday(day)
        updateFilter()
    }
    
    func addItem() {
        showAddItem.toggle()
    }
}

/*
 .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
     .onEnded { value in
         print(value.translation)
         switch(value.translation.width, value.translation.height) {
             case (...0, -30...30):  print("left swipe")
             case (0..., -30...30):  print("right swipe")
             case (-100...100, ...0):  print("up swipe")
             case (-100...100, 0...):  print("down swipe")
             default:  print("no clue")
         }
     }
 )
 */
