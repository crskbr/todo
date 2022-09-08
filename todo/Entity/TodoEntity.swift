//
//  TodoEntity.swift
//  todo
//
//  Created by Chris Kimber on 7/09/22.
//

import Foundation

extension TodoEntity {
    
    public var wrappedItem: String{
        get {item ?? "New Entry"}
        set {item = newValue}
    }
    
    func clone(_ original: TodoEntity) {
        self.item = original.item
    }
}
