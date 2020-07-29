// Copyright © 2020 Shawn James. All rights reserved.
// CoreDataManager.swift

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() // singleton
    
    // persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CellularAutomata")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return persistentContainer
    }()
    
    // view context
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Methods
    
    func save() {
        do {
            try mainContext.save()
        } catch {
            print("Error in CoreDataManager's save method : \(error)")
        }
    }
    
    func delete(_ object: NSManagedObject) {
        do {
            mainContext.delete(object)
            try mainContext.save()
        } catch {
            print("Error in CoreDataManager's delete method : \(error)")
        }
    }
    
}

