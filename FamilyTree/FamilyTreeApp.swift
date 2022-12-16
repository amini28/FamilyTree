//
//  FamilyTreeApp.swift
//  FamilyTree
//
//  Created by Amini on 01/06/22.
//

import SwiftUI
import FirebaseCore

@main
struct FamilyTreeApp: App {
    
    init() {
      FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
