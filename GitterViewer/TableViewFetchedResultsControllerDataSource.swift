//
//  TableViewFetchedResultsControllerDataSource.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 2/1/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation


import UIKit
import CoreData

protocol TableViewFetchedResultsControllerDataSourceDelegate: FetchedResultsControllerDataSourceDelegate {
  func headerTitle(section section: Int) -> String
}

final class TableViewFetchedResultsControllerDataSource: FetchedResultsControllerDataSource {
  let tableView: UITableView

  init(tableView: UITableView,
    reuseIdentifier: String,
    allowEditing: Bool,
    fetchedResultsController: NSFetchedResultsController,
    delegate: TableViewFetchedResultsControllerDataSourceDelegate) {
      self.tableView = tableView

      super.init(reuseIdentifier: reuseIdentifier, allowEditing: allowEditing, fetchedResultsController: fetchedResultsController, delegate: delegate)

      self.fetchedResultsController.delegate = self
      self.tableView.dataSource = self

      do {
        try fetchedResultsController.performFetch()
      } catch {
        print(error)
      }
  }

  func selectedObject() -> AnyObject {
    let indexPath = tableView.indexPathForSelectedRow!

    return fetchedResultsController.objectAtIndexPath(indexPath)
  }

  override func resume() {
    fetchedResultsController.delegate = self

    do {
      try fetchedResultsController.performFetch()
    } catch {
      print(error)
    }

    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension TableViewFetchedResultsControllerDataSource: UITableViewDataSource {
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let aDelegate = delegate as? TableViewFetchedResultsControllerDataSourceDelegate else {
      return ""
    }

    return aDelegate.headerTitle(section: section)
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    guard fetchedResultsController.sections != nil else {
      return 0
    }

    return fetchedResultsController.sections!.count
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let aSection: NSFetchedResultsSectionInfo

    aSection = (fetchedResultsController.sections?[section])!

    return aSection.numberOfObjects
  }

  func tableView(
    tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let object = fetchedResultsController.objectAtIndexPath(indexPath)
      let cell = tableView.dequeueReusableCellWithIdentifier(
        reuseIdentifier,
        forIndexPath: indexPath)

      delegate.configure(cell: cell, object: object)

      return cell
  }
}

// MARK: Table view delegate
extension TableViewFetchedResultsControllerDataSource: UITableViewDelegate {
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return allowEditing
  }

  func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath) {

      if editingStyle == .Delete {
        delegate.delete(
          object: fetchedResultsController.objectAtIndexPath(indexPath)
        )
      }
  }
}

// MARK: Fetched results controller delegate
extension TableViewFetchedResultsControllerDataSource: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    tableView.beginUpdates()
  }

  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    tableView.endUpdates()
  }

  func controller(controller: NSFetchedResultsController, didChangeObject
    anObject: AnyObject,
    atIndexPath indexPath: NSIndexPath?,
    forChangeType type: NSFetchedResultsChangeType,
    newIndexPath: NSIndexPath?) {
      switch type {

      case .Insert:
        tableView.insertRowsAtIndexPaths([newIndexPath!],
          withRowAnimation: UITableViewRowAnimation.Automatic)

      case .Update:
        delegate.configure(
          cell: tableView.cellForRowAtIndexPath(indexPath!)!,
          object: anObject)

      case .Move:
        tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)

      case .Delete:
        tableView.deleteRowsAtIndexPaths([indexPath!],
          withRowAnimation: UITableViewRowAnimation.Automatic)
      }
  }
}
