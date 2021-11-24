//
//  CustomSegue.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/22/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        // Declare the INITAL view and the DESTINATION view
        // This will break and be nil if you don't have a second view controller for your DESTINATION view
        let initalView = self.source.view as UIView?
        let destinationView = self.destination.view as UIView?

        // Specify the screen HEIGHT and WIDTH
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width

        // Specify the INITIAL PLACEMENT of the DESTINATION view
        initalView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        destinationView?.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)

        // Access the app's key window and add the DESTINATION view ABOVE the INITAL view
        if let appWindow = UIApplication.shared.currentWindow {
           // do whatever you want with window
        
            appWindow.insertSubview(destinationView!, aboveSubview: initalView!)

        // Animate the segue's transition
        UIView.animate(withDuration: 0.3, animations: {
            // Left/Right
            initalView?.frame = (initalView?.frame.offsetBy(dx: -screenWidth, dy: 0))!
            destinationView?.frame = (destinationView?.frame.offsetBy(dx: -screenWidth, dy: 0))!
        }) { (Bool) in
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
    }
}
extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
}
