//
//  GitterRequest.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Swish

public protocol GitterRequest: Request {
  var authToken: String { get }

  func baseRequest(url url: NSURL, method: RequestMethod) -> NSURLRequest
  func makeRequest()
}