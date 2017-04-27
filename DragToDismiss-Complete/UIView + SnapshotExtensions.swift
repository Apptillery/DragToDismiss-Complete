//
//  UIView + SnapshotExtensions.swift
//  EasyAnimatedTransition
//
//  Created by Alex Gibson on 3/30/17.
//  Copyright © 2017 AG. All rights reserved.
//

import UIKit

extension UIView{
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else{ return nil}
        context.translateBy(x: -bounds.origin.x, y: -bounds.origin.y)
        self.layoutIfNeeded()
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            let v = UIImageView(image: snapshotImage)
            v.bounds = self.bounds
            v.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            v.layer.masksToBounds = true
            return v
        } else {
            return nil
        }
    }
}
