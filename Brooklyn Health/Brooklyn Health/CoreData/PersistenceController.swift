//
//  PersistenceController.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//


import CoreData
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: "BrooklynHealth")
        // FOR DEV ONLY - Reset Core Data on every launch
//        if let storeURL = container.persistentStoreDescriptions.first?.url {
//            try? FileManager.default.removeItem(at: storeURL)
//        }

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (_, error) in
            
            if let error = error as NSError? {
                fatalError("Core Data load error: \(error), \(error.userInfo)")
            }
            else{
                print("Core data local storage loaded")
            }
        }
    }
}


