// Copyright © 2020 Shawn James. All rights reserved.
// UserPreset+Init.swift

import CoreData

extension UserPreset {
    
    @discardableResult convenience init(name: String, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.timestamp = timestamp
    }
    
}
