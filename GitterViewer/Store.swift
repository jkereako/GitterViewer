//
//  Store.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import CoreData

struct Store {
  let modelName: String
  let modelURL: NSURL
  // Computed property
  var storeURL: NSURL {
    do {
      let documentsDirectory = try NSFileManager.defaultManager().URLForDirectory(
        .DocumentDirectory,
        inDomain: .UserDomainMask,
        appropriateForURL: nil,
        create: true)

      return documentsDirectory.URLByAppendingPathComponent("\(modelName).sqlite")
    } catch {
      fatalError("Unable to create URL for persistent storage.")
    }
  }

  init(modelName aModelName: String ) {
    modelName = aModelName

    guard let aModelURL = NSBundle.mainBundle().URLForResource(modelName,
      withExtension: "momd") else {
        fatalError("Unable to create URL for persistent storage.")
    }

    modelURL = aModelURL
  }

  /**
   Saves changes, if any, in the managed object context to disk.

   :param: managedObjectContext
   */
  static func saveContext(managedObjectContext managedObjectContext: NSManagedObjectContext) {
    guard managedObjectContext.hasChanges else {
      return
    }

    do {
      try managedObjectContext.save()
    } catch {
      print(error)
      assertionFailure("\n\n Unable to save MOC.\n\n")
    }
  }
}
