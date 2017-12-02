//
//  ViewController.swift
//  ONNetworkBehavior
//
//  Created by viethq on 11/20/17.
//  Copyright © 2017 viethq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        // test indicator
        ONUserIndicator.default.canTouchBackground = false
        ONUserIndicator.default.show()
        
        // get by router
//        self.load(router: ONEmployerRouter.getAll) { (result) in
//            guard case .success(let json) = result else {
//                // TODO: show error
//                return
//            }
//
//            print(json)
//        }
        
        // get by resource
        self.load(resource: ONEmployer.getAll) { (result) in
            guard case .success(let items) = result else {
                // TODO: show error
                return
            }
            
            print(items?.first?.description ?? "")
        }
        
        // add tap to test tap event after show indicator
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func tapEvent() {
        print("tap me")
        ONUserIndicator.default.hide()
    }
}
