//
//  RoundedCornerView.swift
//  dopeKit
//
//  Created by Dilan Piscatello on 5/8/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {

    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius     }
    }

}
