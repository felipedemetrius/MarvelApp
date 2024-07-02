//
//  ManagedCache.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSSet
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try deleteCache(in: context)
        return ManagedCache(context: context)
    }
    
    var localFeed: [LocalCharacter] {
        return feed.compactMap { ($0 as? ManagedCharacter)?.local }
    }
}
