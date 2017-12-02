//
//  ONAPIClient.swift
//  Project 03 -OnAPIClient
//
//  Created by viethq on 5/29/17.
//  Copyright © 2017 viethq. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// wrapper of alamofire
open class ONAPIClient {
    public typealias Result = Alamofire.Result
    public typealias ResultJSON = ((Result<JSON>) -> Void)
    
    // MARK: Properties
    private let sessionMng: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10.0 // default timeout
        
        return SessionManager(configuration: configuration)
    }()
    
    public static let `default` = ONAPIClient()
}

// MARK: using ONUrl
public extension ONAPIClient {
    /// response JSON
    /// using ONUrl we need programmatically parse json, pass JSON instance to complete closure
    @discardableResult
    public func call(router: ONUrl, params: [String: Any]? = nil, complete: @escaping ResultJSON) -> DataRequest {
        
        let request = sessionMng.request(router.url, method: router.method, parameters: params, headers: router.header)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    complete(.success(JSON(value)))
                case .failure(let error):
                    complete(.failure(error))
                }
        }
        
        return request
    }
}

// MARK: using Resource instance
public extension ONAPIClient {
    /// response Result
    /// using Resource we have to make Resource instance to define url, param and parse function
    /// Resource instance pass parsed model to complete closure
    @discardableResult
    public func call<A>(resource: Resource<A>, complete: @escaping (Result<A?>) -> Void) -> DataRequest {
        // get router url and farams from resource
        let router = resource.router
        let params = resource.params
        
        let request = sessionMng.request(router.url, method: router.method, parameters: params, headers: router.header)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let injectedItem = resource.parse(JSON(value))
                    complete(.success( injectedItem))
                case .failure(let error):
                    complete(.failure(error))
                }
        }
        
        return request
    }
}

// MARK: UIViewController load event
extension UIViewController {
    func load<A>(resource: Resource<A>, complete: @escaping (Result<A?>) -> Void) {
        ONUserIndicator.default.show()
        
        ONAPIClient.default.call(resource: resource) { (result) in
            DispatchQueue.main.async {
                ONUserIndicator.default.hide()
                complete(result)
            }
        }
    }
    
    func load(router: ONUrl, params: [String: Any]? = nil, complete: @escaping ONAPIClient.ResultJSON) {
        ONUserIndicator.default.show()
        
        ONAPIClient.default.call(router: router, params: params) { (result) in
            DispatchQueue.main.async {
                ONUserIndicator.default.hide()
                complete(result)
            }
        }
    }
}
