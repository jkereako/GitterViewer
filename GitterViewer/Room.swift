//
//  Room.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation
import CoreData


final class Room: NSManagedObject {

  static var entityName: String { return "Room" }

  /**
   Inserts a new `Room` object in the managed object context.

   :param: managedObjectContext
   :param: identifier
   :param: name
   :param: topic
   :param: path
   :param: lastAccessed
   */
  convenience init(
    managedObjectContext: NSManagedObjectContext, identifier: String, name: String, topic: String?,
    path: String, lastAccessed: NSDate?
    ) {
      let entityDescription = NSEntityDescription.entityForName(
        Room.entityName, inManagedObjectContext: managedObjectContext
        )!

      self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)

      self.identifier = identifier
      self.name = name
      self.topic = topic
      self.path = path
      self.lastAccessedAt = lastAccessed

      createdAt = NSDate()
      modifiedAt = createdAt
  }

  override init(
    entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?
    ) {
      super.init(entity: entity, insertIntoManagedObjectContext: context)
  }
}

extension Room {
  @NSManaged var name: String
  @NSManaged var topic: String?
  @NSManaged var path: String
  @NSManaged var lastAccessedAt: NSDate?
  @NSManaged var identifier: String
  @NSManaged var createdAt: NSDate
  @NSManaged var modifiedAt: NSDate
}
