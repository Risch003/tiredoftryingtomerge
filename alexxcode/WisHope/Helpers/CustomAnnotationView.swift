//
//  CustomAnnotationView.swift
//  WisHope
//
//  Created by Alex Moeller on 10/24/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    var address : String?
    var zip : String?
    var website : String?
    var city : String?
    var phone : String?
    var state : String?
    var name : String?
    var type : String?
   
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point)
                if isInside
                {
                    break
                }
            }
        }
        return isInside
    }
}
