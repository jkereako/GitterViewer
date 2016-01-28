//
//  PersistentStack.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import CoreData

struct PersistentStack {
  private let modelURL: NSURL
  private let storeURL: NSURL
  let managedObjectContext: NSManagedObjectContext

  init(modelURL aModelURL: NSURL, storeURL aStoreURL: NSURL) {
    // Make sure we can create a managed object model, else kill the app
    guard let model = NSManagedObjectModel(contentsOfURL: aModelURL) else {
      fatalError("Unable to create a managed object model. App cannot continue.")
    }

    modelURL = aModelURL
    storeURL = aStoreURL
    managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.undoManager = NSUndoManager()

    let options = [NSMigratePersistentStoresAutomaticallyOption: true,
      NSInferMappingModelAutomaticallyOption: true]
    managedObjectContext.persistentStoreCoordinator = NSPersistentStoreCoordinator(
      managedObjectModel: model)

    do {
      try managedObjectContext.persistentStoreCoordinator?
        .addPersistentStoreWithType(NSSQLiteStoreType,
          configuration: nil,
          URL: aStoreURL,
          options: options)
    } catch {
      print(error)
      assertionFailure("\n\n There was an error.\n\n")
    }
  }
}
