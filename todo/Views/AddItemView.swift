//
//  AddItemView.swift
//  todo
//
//  Created by Chris Kimber on 9/09/22.
//

import SwiftUI

struct AddItemView: View {
    
    @State var item: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Task", text: $item)
            }
        }
    }
}
