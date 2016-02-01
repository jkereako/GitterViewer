//
//  FetchedResultsControllerDataSource.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 2/1/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//


import UIKit
import CoreData

protocol FetchedResultsControllerDataSourceDelegate {
  func configure(cell cell: AnyObject, object: AnyObject)
  func delete(object object: AnyObject)
}

class FetchedResultsControllerDataSource: NSObject {
  let fetchedResultsController: NSFetchedResultsController
  let reuseIdentifier: String
  let allowEditing: Bool
  let delegate: FetchedResultsControllerDataSourceDelegate

  init(reuseIdentifier: String,
    allowEditing edit: Bool,
    fetchedResultsController frc: NSFetchedResultsController,
    delegate aDelegate: FetchedResultsControllerDataSourceDelegate) {
      self.reuseIdentifier = reuseIdentifier
      allowEditing = edit
      fetchedResultsController = frc
      delegate = aDelegate

      super.init()

      do {
        try fetchedResultsController.performFetch()
      } catch {
        print(error)
      }
  }

  func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
    return fetchedResultsController.objectAtIndexPath(indexPath)
  }

  func resume() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print(error)
    }
  }

  func pause() {
    fetchedResultsController.delegate = nil
  }
}
