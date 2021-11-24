//
//  PostTableViewCell.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/4/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PostTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var dopePointsLabel: UILabel!
    @IBOutlet weak var addOneButton: UIButton!

    @IBOutlet weak var roundBots: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    var documentdata:[String:Any] = ["":""]
    var role = "Standard"
    var idForPost = ""
    var pointsOnLabel = 0
    var invNumber = 0
    var intFieldPoints = 0
    var points = 0
    var uidPerson = ""
    var indexNumberGuy = 0
    var pointss = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakefromNIb ")
        roundBots.layer.shadowRadius = 1
        roundBots.layer.shadowOpacity = 0.5
        roundBots.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        roundBots.layer.shadowColor = UIColor.gray.cgColor
        backgroundView?.layer.cornerRadius = 10
        getData()
        overrideUserInterfaceStyle = .light
              textFieldPoints.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    func getData() {
        
    let db = Firestore.firestore()
   let uid = Auth.auth().currentUser?.uid ?? "l"
    db.collection("users").document(uid).getDocument { (document,error) in
        
               if error != nil{
                   print("cant get data")
                   
               }
               if document != nil && document!.exists{
                
               if let documentdata = document?.data() {
               self.documentdata = documentdata
                let stringDocument = documentdata["role"] as! String
                self.role = documentdata["role"] as! String
                self.invNumber = documentdata["indexNumber"] as! Int
                self.points = documentdata["points"] as! Int
                print("insided data")
                if (stringDocument != "Admin"){
                    self.addOneButton.isHidden = true
                    self.deleteButton.isHidden = true
                    self.textFieldPoints.isHidden = true
                }
                
                
                }
        }
        }
       
        }
     weak var post:Post?
    func setPost(post:Post){
        print(role)
        self.idForPost = post.id
            UserDefaults.standard.set(false, forKey: "addedPoints")
     
//        Database.database().reference().child("posts").child(idForPost).child("author").observeSingleEvent(of: .value, with: { snapshot in
//                print("ffffffffff")
//            if !snapshot.exists() { return }
//
//            //print(snapshot)
//
//
//                let pointsL = snapshot.childSnapshot(forPath: "points").value as! Int
//            if (pointsL == 0){
//                self.dopePointsLabel.text = "+0"
//            }else{
//               self.dopePointsLabel.text = "+\(pointsL)"
//            }
//
//            print("this is the post \(self.idForPost)")
//            print("This is ran")
//        })
        
          
        
        self.post = post
        print(post.points)
        //if post.points != 0{
            print("\(String(post.points)) <- inside if statement")
            
        //}
        postTextLabel.text = post.text
        subtitleLabel.text = post.createdAt.calenderTimeSinceNow()
        dopePointsLabel.text = "+\(post.points)"
        usernameLabel.text = post.name
    }
    @IBAction func deleteButtonClicked(_ sender: Any) {
        
        Database.database().reference().child("posts").child(idForPost).removeValue()
        deleteButton.setTitle("Deleted", for: .normal)
    }
  
    
  
    @IBAction func addPointsButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "addedPoints")
        if let intFieldPoint = Int(textFieldPoints.text!){
            self.intFieldPoints = intFieldPoint
            Database.database().reference().child("posts").child(idForPost).child("author").observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.uidPerson = value?["uid"] as! String
                findData()
            }
        Database.database().reference().child("posts").child(idForPost).child("author").updateChildValues(["points": intFieldPoints]){ (Error, DatabaseReference) in
            if Error == nil{
                self.dopePointsLabel.text = "+\(self.textFieldPoints.text!)"
                self.textFieldPoints.text = "0"
                self.addOneButton.setTitle("Added", for: .normal)
                self.getData()
            }else{
                print("error updatings the points to the database")
            }
        }
    }
        func findData(){
      let db = Firestore.firestore()
      
      db.collection("users").document(uidPerson).getDocument { (document,error) in
          
                 if error != nil{
                     print("cant get data")
                     
                 }
                 if document != nil && document!.exists{
                    self.indexNumberGuy = document?["indexNumber"] as! Int
                    self.pointss = document?["points"] as! Int
                    updateFire()
        }
        }
        
            func updateFire(){
        db.collection("users").document(uidPerson).updateData([
            "points": self.intFieldPoints + self.pointss,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        let index = String(self.indexNumberGuy)
        db.collection("leaderboard").document(index).updateData([
            "points": self.intFieldPoints + self.pointss,
            "uid": uidPerson
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print(self.intFieldPoints + self.points)
                print("Document successfully updated")
            }
        }
            if (self.intFieldPoints >= 100){
            
            db.collection("users").document(uidPerson).updateData([
                "medals":FieldValue.arrayUnion(["100blog"])
                
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    UserDefaults.standard.set(true, forKey: "medal6")
                }
            }
            
        }
        }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldPoints.resignFirstResponder()
      
        return true
    }
    
    @IBOutlet weak var textFieldPoints: UITextField!
}
