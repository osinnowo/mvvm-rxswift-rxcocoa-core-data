//
//  CoreDataProvider.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import CoreData

protocol AutoMapper {
    associatedtype T
    associatedtype M
    func mapper (item: T, context: NSManagedObjectContext) -> M
}

protocol CoreDataProviderProtocol {
    associatedtype Record
    var context: NSManagedObjectContext { set get }
    
    func create(entity: Record) throws -> Record
    func create(multiple entities: [Record]) throws -> [Record]
    func fetchRecords() throws -> [Record]
    func update(entity with: Record) -> Record
    func delete(entity using: Record) -> Record
}

final class CoreDataProvider<Entity: NSManagedObject>: CoreDataProviderProtocol {
    typealias Record = Entity
    
    internal var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(entity: Entity) throws -> Entity {
        context.performAndWait {
            context.insert(entity)
            try? context.save()
        }
        return entity
    }
    
    func create(multiple entities: [Entity]) throws -> [Entity] {
        var createdEntities: [Entity] = []
        for entity in entities {
            let createdEntity = try create(entity: entity)
            createdEntities.append(createdEntity)
        }
        return createdEntities
    }
    
    func fetchRecords() throws -> [Entity] {
        var results: [Entity] = []
        try context.performAndWait {
            let request = fetchRequest(request: Entity())
            results = try context.fetch(request)
        }
        return results
    }
    
    func update(entity: Entity) -> Entity {
        context.performAndWait {
            context.refresh(entity, mergeChanges: true)
            try? context.save()
        }
        return entity
    }
    
    func delete(entity: Entity) -> Entity {
        context.performAndWait {
            context.delete(entity)
            try? context.save()
        }
        return entity
    }
    
    func fetchRequest(request: Entity) -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
}
