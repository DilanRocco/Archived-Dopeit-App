//
//  Util.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/29/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//
import UIKit
import Foundation

class Util{
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with:password)
    }
    
}

class DemoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1.0)
        
}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createRectangle() {
        path = UIBezierPath()
        
        path.move(to: CGPoint(x:0.0, y: 0.0))
        
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height * 0.925))
        
        //path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        
        //self.frame.size.height
        path.addCurve(to:CGPoint(x: self.frame.size.width, y: self.frame.size.height * 0.925), controlPoint1:  CGPoint(x: self.frame.size.width/2, y: self.frame.size.height), controlPoint2:  CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        
        path.close()
    }
    
    override func draw(_ rect: CGRect) {
        self.createRectangle()

        UIColor(patternImage: UIImage(named: "home2x")!).setFill()
        path.fill()
        
        
    }
}
