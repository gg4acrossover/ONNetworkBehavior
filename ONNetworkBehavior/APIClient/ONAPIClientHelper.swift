//
//  ONAPIClientHelper.swift
//  Project 03 -OnAPIClient
//
//  Created by viethq on 5/29/17.
//  Copyright © 2017 viethq. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: Router protocol (paths of ONURL)
public protocol ONPath {
    var path : String { get }
}


public protocol ONToken {
    /// example: "Bearer", "Basic", etc
    var tokenKind : String { get }
    var tokenStr : String { get }
    var isAuthorization : Bool { get }
}

/// default implement ONToken
public extension ONToken {
    var tokenKind : String {
        return "Bearer"
    }
    
    var tokenStr : String {
        return ""
    }
    
    var isAuthorization : Bool {
        return false
    }
}

public protocol ONMethod {
    var method : Alamofire.HTTPMethod { get }
}

public protocol ONHeader : ONToken {
    var header : Alamofire.HTTPHeaders { get }
}

/// default implement ONHeader
extension ONHeader {
    var header : Alamofire.HTTPHeaders {
        var header = ["Accept" : "application/json,charset=utf-8,text/html"]
        
        if self.isAuthorization {
            header["Authorization"] = "\(self.tokenKind) \(self.tokenStr)"
            return header
        }
        
        return header
    }
}

// MARK: ONURL
public protocol ONUrl : ONPath, ONMethod, ONHeader {
    var baseURL : String { get }
    var url : String { get }
}

public extension ONUrl {
    var url : String {
        return self.baseURL.appending(self.path).addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

// MARK: Resource
public struct Resource<A> {
    var router : ONUrl
    var parse: (JSON) -> A?
    var params: [String: Any]?
}

/// default implement Resource
public extension Resource {
    init(router: ONUrl, params: [String: Any]? = nil, parse: @escaping (JSON) -> A?) {
        self.router = router
        self.parse = parse
    }
}
