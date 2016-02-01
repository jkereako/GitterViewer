//
//  RoomTableViewController.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 2/1/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import UIKit
import CoreData

class RoomTableViewController: UITableViewController {
  var managedObjectContext: NSManagedObjectContext!
  var fetchedResultsControllerDataSource: TableViewFetchedResultsControllerDataSource!
  // MARK: View delegate
  override func viewDidLoad() {
    guard let tv = tableView else {
      assertionFailure("Table view is nil")
      return
    }

    super.viewDidLoad()

    // TODO: Check the managed object context for nil
    let request = NSFetchRequest(entityName: Room.entityName)
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]

    let controller = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)

    fetchedResultsControllerDataSource = TableViewFetchedResultsControllerDataSource(
      tableView: tv,
      reuseIdentifier: "room",
      allowEditing: false,
      fetchedResultsController: controller,
      delegate: self)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let frc = fetchedResultsControllerDataSource {
      frc.resume()
    }
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)

    if let frc = fetchedResultsControllerDataSource {
      frc.pause()
    }
  }
}

extension RoomTableViewController {
  @IBAction func refreshAction(sender: UIRefreshControl) {
    let request = RoomRequest(managedObjectContext: managedObjectContext)
    request.makeRequest({(success: Bool) in
      assert(NSThread.isMainThread())
      sender.endRefreshing()
    })
  }
}


// MARK: Fetched results controller data source delegate
extension RoomTableViewController: TableViewFetchedResultsControllerDataSourceDelegate {

  func headerTitle(section section: Int) -> String {
    return "TEST"
    /*
    guard let frc = fetchedResultsControllerDataSource, let entry =
      frc.fetchedResultsController.objectAtIndexPath(
        NSIndexPath(forRow: 0, inSection: section)) as? JournalEntry else {
          assertionFailure(
            "\n\n  The retrieved object was not a JournalEntry.\n\n"
          )
          return ""
    }

    let oldDateFormat = dateFormatter.dateFormat
    dateFormatter.dateFormat = "MMMM Y"
    let title = dateFormatter.stringFromDate(entry.entryDate.date)
    dateFormatter.dateFormat = oldDateFormat

    return title
    */
  }


  func configure(cell cell: AnyObject, object: AnyObject) {

    guard let room = object as? Room, let theCell = cell as? UITableViewCell else {
      assertionFailure(
        "\n\n  The parameter, object, is not a JournalEntry. \n\n"
      )
      return
    }

    theCell.textLabel?.text = room.name
  }

  func delete(object object: AnyObject) {
    // code
  }
}