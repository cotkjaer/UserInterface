//
//  UIViewController.swift
//  Silverback
//
//  Created by Christian Otkjær on 15/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics
import Collections

//MARK: - Cover View

public extension UIViewController
{
    fileprivate class CoverView : UIView
    {
        // MARK: - Init
        
        override init(frame: CGRect)
        {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder)
        {
            super.init(coder: aDecoder)
            setup()
        }
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        func setup()
        {
            backgroundColor = UIColor(white: 0, alpha: 0.25)
            alpha = 0
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            activityView.startAnimating()
            addSubview(activityView)
        }
        
        
        fileprivate override func layoutSubviews()
        {
            super.layoutSubviews()
            
            activityView.center = bounds.center
        }
    }
    
    func cover(_ duration: Double = 0.25, hideActivityView: Bool = false, completion: (() -> ())? = nil)
    {
        guard view.subviews(ofType: CoverView.self).isEmpty else { return }
        
        let coverView = CoverView(frame: view.bounds)

        coverView.activityView.isHidden = hideActivityView
        
        view.addSubview(coverView)
        
        UIView.animate(withDuration: duration,
            animations: {
                coverView.alpha = 1
            }, completion: { _ in completion?() }) 

    }
    
    public func uncover(_ duration: Double = 0.25, completion: (() -> ())? = nil)
    {
        let coverViews = view.subviews(ofType: CoverView.self)
        
        UIView.animate(withDuration: duration,
            animations: {
            coverViews.forEach { $0.alpha = 0 }
            }, completion: { (completed) -> Void in
                coverViews.forEach { $0.removeFromSuperview() }
                
                completion?()
        }) 
    }
}

// MARK: - On screen

extension UIViewController
{
    public func isViewLoadedAndShowing() -> Bool { return isViewLoaded && view.window != nil }
}



