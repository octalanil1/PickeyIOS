//
//  DashedBorderView.swift
//  Pickey
//
//  Created by Sunil Pradhan on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import Foundation
import UIKit

class DashedBorderView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var borderColor: UIColor = UIColor.init(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1.0)
    @IBInspectable var dashPaintedSize: Int = 4
    @IBInspectable var dashUnpaintedSize: Int = 2
    
    let dashedBorder = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        //custom initialization
        self.layer.addSublayer(dashedBorder)
        applyDashBorder()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        applyDashBorder()
    }
    
    func applyDashBorder() {
        dashedBorder.strokeColor = borderColor.cgColor
        dashedBorder.lineDashPattern = [NSNumber(value: dashPaintedSize), NSNumber(value: dashUnpaintedSize)]
        dashedBorder.fillColor = nil
        dashedBorder.cornerRadius = cornerRadius
        dashedBorder.lineWidth = 1
        dashedBorder.path = UIBezierPath(rect: self.bounds).cgPath
        dashedBorder.frame = self.bounds
    }
}
