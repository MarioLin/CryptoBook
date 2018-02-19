//
//  CABAddress+CoreDataProperties.swift
//  
//
//  Created by Mario Lin on 2/19/18.
//
//

import Foundation
import CoreData


extension CABAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CABAddress> {
        return NSFetchRequest<CABAddress>(entityName: "CABAddress")
    }

    @NSManaged public var addressString: String?
    @NSManaged public var addressType: Int16
    @NSManaged public var name: String?

}
