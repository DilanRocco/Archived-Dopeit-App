//
//  Post.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/4/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import Foundation


class Post{
    var id:String
    var name:String
    var text:String
    var createdAt:Date
    var uid:String
    var points:Int
    
    init(id:String,name:String,text:String,timestamp:Double,uid:String,pts:Int) {
        self.id = id
        self.name = name
        self.text = text
        self.createdAt = Date(timeIntervalSince1970: timestamp/1000)
        self.uid = uid
        self.points = pts
    }
    static func parse(_ key:String, _ dict:[String:Any]) -> Post?{
        
                  if let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let name = author["name"] as? String,
                    let text = dict["text"] as? String,
                    let points = author["points"] as? Int,
                    let timestamp = dict["timestamp"] as? Double{
                    
                    return Post(id:key, name: name, text: text, timestamp: timestamp, uid: uid, pts: points)
        }
        return nil
    }
    
}
class question{
    var question:String
    
    init(question:String){
        self.question = question
    }
    
}
