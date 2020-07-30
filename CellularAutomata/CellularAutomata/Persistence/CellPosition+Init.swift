// Copyright © 2020 Shawn James. All rights reserved.
// CellPosition+Init.swift

import CoreData

extension CellPosition {
    
    @discardableResult convenience init(x: Int, y: Int, context: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.init(context: context)
        self.x = Int64(x)
        self.y = Int64(y)
    }
    
}
