//
//  NoConnectionHeader.swift
//  testAPI
//
//  Created by Dilan Piscatello on 5/16/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit



    class NoConnectionHeader:UIView {
        
        var view:UILabel!
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        func setup() {
            view = UILabel()
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            view.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
            view.backgroundColor = .red
            view.text = "No Connection"
            view.textColor = .white
            view.textAlignment = .center
           // view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            view.sizeToFit()
            
           
          
        }
        
      
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


