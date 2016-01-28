//
//  Endpoints.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Swish

enum Gitter {
  case Rooms
  case Users(roomID: String)
  case Messages(roomID: String, limit: Int)
}

protocol Endpoint {
  var baseURL: NSURL { get }
  var path: String { get }
}

extension Gitter: Endpoint {
  var baseURL: NSURL { return NSURL(string: "https://api.gitter.im/v1")! }
  var path: String {
    switch self {
    case .Rooms: return "/rooms"
    case .Users(let roomID): return "/rooms/\(roomID)/users"
    case .Messages(let roomID, let limit): return "/rooms/\(roomID)/chatMessages?limit=\(limit)"
    }
  }
}

func apiEndpointURL(route route: Endpoint) -> NSURL {
  return route.baseURL.URLByAppendingPathComponent(route.path)
}
