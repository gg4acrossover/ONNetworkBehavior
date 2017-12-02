//
//  ONEmployer.swift
//  ONNetworkBehavior
//
//  Created by viethq on 12/2/17.
//  Copyright © 2017 viethq. All rights reserved.
//

import Foundation
import SwiftyJSON

class ONEmployer: CustomStringConvertible {
    var name: String?
    var task: String?
    var position: String?
    
    init(json: JSON) {
        self.name = json["name"].string
        self.position = json["position"].string
        self.task = json["task"].string
    }
    
    // show debug print
    var description: String {
        let str = "\(self.name ?? "") is \(self.position ?? "")"
        return str
    }
    
    static let getAll = Resource(router: ONEmployerRouter.getAll) { (json) -> [ONEmployer]? in
        let drawData = json.array
        return drawData?.map(ONEmployer.init)
    }
}
