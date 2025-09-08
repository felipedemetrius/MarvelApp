//
//  ManagedCharacter.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import CoreData

@objc(ManagedCharacter)
class ManagedCharacter: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var descriptionChar: String
    @NSManaged var modified: String
    @NSManaged var resourceURI: String
    @NSManaged var imageURL: URL?
    @NSManaged var data: Data?
    @NSManaged var thumbnail: ManagedThumbnail
    @NSManaged var cache: ManagedCache
}

extension ManagedCharacter {
    static func data(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try first(with: url, in: context)?.data
    }
    
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedCharacter? {
        let request = NSFetchRequest<ManagedCharacter>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedCharacter.imageURL), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func characters(from localFeed: [LocalCharacter], in context: NSManagedObjectContext) -> NSSet {
        let images = NSSet(array: localFeed.map { local in
            let managed = ManagedCharacter(context: context)
            let thumbnail = ManagedThumbnail(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.descriptionChar = local.description
            managed.modified = local.modified
            managed.resourceURI = local.resourceURI
            managed.imageURL = URL(string: local.thumbnail.path + "." + local.thumbnail.thumbnailExtension)
            managed.data = context.userInfo[local.thumbnail.path + "." + local.thumbnail.thumbnailExtension] as? Data
            thumbnail.path = local.thumbnail.path
            thumbnail.thumbnailExtension = local.thumbnail.thumbnailExtension
            managed.thumbnail = thumbnail
            return managed
        })
        context.userInfo.removeAllObjects()
        return images
    }
    
    var local: LocalCharacter {
        return LocalCharacter(id: id, name: name, description: descriptionChar, modified: modified, resourceURI: resourceURI, thumbnail: LocalThumbnail(path: thumbnail.path, thumbnailExtension: thumbnail.thumbnailExtension))
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        
        managedObjectContext?.userInfo[thumbnail.path + "." + thumbnail.thumbnailExtension] = data
    }
}
