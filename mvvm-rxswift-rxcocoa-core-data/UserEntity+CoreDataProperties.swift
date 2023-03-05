//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var username: String?

}
