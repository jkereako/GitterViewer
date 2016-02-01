//
//  RoomRequest.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

//import Foundation
import CoreData
import Argo
import Result
import Swish

// TODO: Put somewhere else
let jsonDateFormatter: NSDateFormatter = {
  let dateFormatter = NSDateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
  return dateFormatter
}()

let toNSDate: String -> Decoded<NSDate> = {
  .fromOptional(jsonDateFormatter.dateFromString($0))
}

struct RoomRequest {
  let managedObjectContext: NSManagedObjectContext
}

extension RoomRequest: GitterRequest {
  // We expect an array of rooms, so declare the response object as such.
  typealias ResponseObject = [DecodedRoom]

  var authToken: String { return "" }

  func baseRequest(url url: NSURL, method: RequestMethod) -> NSURLRequest {
    let request = NSMutableURLRequest(URL: url)

    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    request.HTTPMethod = method.rawValue
    return request
  }

  func makeRequest() {
    APIClient().performRequest(self) { (response: Result<ResponseObject, NSError>) in

      switch response {
      case let .Success(decodedRooms):
        for decodedRoom in decodedRooms {
          Room(managedObjectContext: self.managedObjectContext, decodedRoom: decodedRoom)
        }

      case .Failure(_):
        print("Unable to parse.")
      }
    }
  }

  func build() -> NSURLRequest {
    return baseRequest(url: apiEndpointURL(route: Gitter.Rooms), method: .GET)
  }
}
