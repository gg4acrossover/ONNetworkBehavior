//
//  ONUserIndicator.swift
//  ONNetworkBehavior
//
//  Created by viethq on 11/20/17.
//  Copyright © 2017 viethq. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class ONWindowHitTest: UIWindow {
    var on_isEnableTouch: Bool = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if !on_isEnableTouch {
            return nil
        }
        
        return hitView
    }
}

final class ONViewHitTest: UIView {
    var on_isEnableTouch: Bool = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if !on_isEnableTouch {
            return nil
        }
        
        return hitView
    }
}

final class ONUserIndicator {
    static let `default` = ONUserIndicator()
    
    func show() {
        self.counter += 1
    }
    
    func hide() {
        self.counter -= 1
    }
    
    var canTouchBackground : Bool = false {
        didSet {
            if let window = self.window as? ONWindowHitTest,
                let parentView = self.parentIndicator.view as? ONViewHitTest {
                window.on_isEnableTouch = canTouchBackground
                parentView.on_isEnableTouch = canTouchBackground
            }
        }
    }
    
    // MARK: Private
    /// hide init
    private init() {}
    
    private var counter: Int = 0 {
        didSet {
            if oldValue == 0, self.counter > 0 {
                self.window.isHidden = false
                self.activity.startAnimating()
            } else if oldValue == 1, self.counter == 0 {
                self.window.isHidden = true
                self.activity.stopAnimating()
            }
        }
    }
    
    private var parentIndicator: UIViewController = {
        let parent = UIViewController()
        parent.view = ONViewHitTest()
        return parent
    }()
    
    private lazy var window: UIWindow = {
        let window = ONWindowHitTest(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = true
        window.rootViewController = self.parentIndicator
        return window
    }()
    
    private lazy var activity: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0.0,y: 0.0, width: 40.0, height: 40.0),type: .lineScaleParty, color: .red)
        let screenSize = UIScreen.main.bounds.size
        let center = CGPoint(x: screenSize.width*0.5,y: screenSize.height*0.5)
        view.center = center
        
        self.window.addSubview(view)
        
        return view
    }()
}
