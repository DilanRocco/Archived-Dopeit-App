//
//  HelperExt.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/8/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import Foundation
import UIKit
import Firebase
extension Date
{
    func calenderTimeSinceNow() -> String
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        } else if months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        } else if days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return seconds == 1 ? "1 second ago" : "\(seconds) seconds ago"
        }
    }
 
   
        }
public extension UIView {

  /**
  Fade in a view with a duration

  - parameter duration: custom animation duration
  */
    func fadeIn(duration: TimeInterval = 1.0,delay:TimeInterval = 3.0) {
        
        UIView.animate(withDuration: duration, delay:delay,animations: {
        self.alpha = 1.0
    })
  }

  /**
  Fade out a view with a duration

  - parameter duration: custom animation duration
  */
    func fadeOut(duration: TimeInterval = 1.0,delay:TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
        self.alpha = 0.0
            
    })
  }
    
}
