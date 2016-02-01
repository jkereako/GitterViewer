//
//  RoomRequest.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

//import Foundation
import Curry
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
  struct Room: Decodable {
    let identifier: String
    let name: String
    let topic: String?
    let path: String
    let lastAccessedAt: NSDate

    static func decode(j: JSON) -> Decoded<RoomRequest.Room> {

      return curry(RoomRequest.Room.init)
        <^> j <| "id"
        <*> j <| "name"
        <*> j <|? "topic"
        <*> j <| "url"
        <*> (j <| "lastAccessTime" >>- toNSDate)
    }
  }
}

extension RoomRequest: GitterRequest {
  // We expect an array of rooms, so declare the response object as such.
  typealias ResponseObject = [RoomRequest.Room]

  var authToken: String { return "your_auth_token" }

  func baseRequest(url url: NSURL, method: RequestMethod) -> NSURLRequest {
    let request = NSMutableURLRequest(URL: url)

    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    request.HTTPMethod = method.rawValue
    return request
  }

  func makeRequest() {
    let request = RoomRequest()
    APIClient().performRequest(request) { (response: Result<ResponseObject, NSError>) in
      print(response)
    }
  }

  func build() -> NSURLRequest {
    return baseRequest(url: apiEndpointURL(route: Gitter.Rooms), method: .GET)
  }
}
