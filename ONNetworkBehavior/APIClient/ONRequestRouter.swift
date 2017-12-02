//
//  ONRequestRouter.swift
//  ONChart
//
//  Created by viethq on 8/1/17.
//  Copyright © 2017 viethq. All rights reserved.
//

import Foundation
import enum Alamofire.HTTPMethod

//: `python -m SimpleHTTPServer 8000`

// build url router with ONURL protocol
enum ONEmployerRouter : ONUrl {
    case getAll
    
    var baseURL: String {
        return "http://localhost:8000/"
    }
    
    var path: String {
        switch self {
        case .getAll: return "employ.json"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAll: return .get
        }
    }
}

