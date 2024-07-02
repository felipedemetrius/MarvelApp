//
//  ManagedThumbnail.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import CoreData

@objc(ManagedThumbnail)
class ManagedThumbnail: NSManagedObject {
    @NSManaged var path: String
    @NSManaged var thumbnailExtension: String
}
