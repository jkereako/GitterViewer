//
//  Room.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import CoreData
import Argo
import Curry

struct DecodedRoom: Decodable {
  let identifier: String
  let name: String
  let topic: String?
  let path: String
  let lastAccessedAt: NSDate

  static func decode(j: JSON) -> Decoded<DecodedRoom> {
    return curry(DecodedRoom.init)
      <^> j <| "id"
      <*> j <| "name"
      <*> j <|? "topic"
      <*> j <| "url"
      <*> (j <| "lastAccessTime" >>- toNSDate)
  }
}

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
    managedObjectContext: NSManagedObjectContext, decodedRoom: DecodedRoom) {
      let entityDescription = NSEntityDescription.entityForName(
        Room.entityName, inManagedObjectContext: managedObjectContext
        )!

      self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)

      self.identifier = decodedRoom.identifier
      self.name = decodedRoom.name
      self.topic = decodedRoom.topic
      self.path = decodedRoom.path
      self.lastAccessedAt = decodedRoom.lastAccessedAt

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
