//
//  User.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import UIKit
import CoreData

struct User: Decodable {
    var name: String
    var username: String
}

extension User: AutoMapper  {
    func mapper(item: User, context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity(context: context)
        entity.name = item.name; entity.username = item.username
        return entity
    }
    
    typealias T = User
    typealias M = UserEntity
}
