//
//  NSManaged+Extensions.swift
//  crypto-address-book
//
//  Created by Mario Lin on 2/24/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public static var entity: NSEntityDescription { return entity()  }
    
    public static var entityName: String { return entity.name!  }
}

extension NSManagedObjectContext {
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    public func performSaveOrRollback() {
        perform {
            _ = self.saveOrRollback()
        }
    }
}
