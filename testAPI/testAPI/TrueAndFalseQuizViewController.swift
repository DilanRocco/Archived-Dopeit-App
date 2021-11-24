//
//  TrueAndFalseQuizViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 5/1/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class TrueAndFalseQuizViewController: UIViewController {

    @IBOutlet weak var beginButtonOutlet: UIButton!
    @IBOutlet weak var backButtonOutlet: UIButton!

    @IBOutlet weak var labelStackView1: UILabel!
    @IBOutlet weak var labelStackVeiew2: UILabel!
    var firstTime = ""
    var canPlay = false
    var serverDates = ""
    var check = [0]
    var lives = 0
    var todayDate = ""
    var reloadedLives = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.beginButtonOutlet.layer.cornerRadius = 20
        self.navigationController?.navigationBar.isHidden = false
        //Can play multiple times with this command
        //only for testing
        //UserDefaults.standard.set(3, forKey: "wrongTF")
        
        
//        let currentDateTime = Date()
//
//         let formatter = DateFormatter()
//
//         formatter.dateStyle = .short
//
//         let dataTimeString = formatter.string(from: currentDateTime)
//         if (dataTimeString != UserDefaults.standard.string(forKey: "initalizedDateTF")){
//             print("it went through the if statement")
//             UserDefaults.standard.set(dataTimeString, forKey: "initalizedDateTF")
//             UserDefaults.standard.synchronize()
//             UserDefaults.standard.set(3,forKey:"wrongTF")
//             UserDefaults.standard.synchronize()
//
//
//         }
        checkIfUserCanPlay()
    }
    func checkIfUserCanPlay() {
     let db = Firestore.firestore()
    
     func getTimeFromServer(completionHandler:@escaping (_ getResDate: String) -> Void){
         let url = URL(string: "https://www.apple.com")
         let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
             let httpResponse = response as? HTTPURLResponse
             if let contentType = httpResponse!.allHeaderFields["Date"] as? String {
                 //print(httpResponse)
                 let dFormatter = DateFormatter()
                 dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                 let serverTime = dFormatter.date(from: contentType)
                 dFormatter.dateFormat = "M yyyy"
                 let myStringafd = dFormatter.string(from: serverTime!)
                 completionHandler(myStringafd)
                 
             }
         }
         task.resume()
     }
        func getTimeFromServerForLives(completionHandler:@escaping (_ getResDate: String) -> Void){
            let url = URL(string: "https://www.apple.com")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                let httpResponse = response as? HTTPURLResponse
                if let contentType = httpResponse!.allHeaderFields["Date"] as? String {
                    //print(httpResponse)
                    let dFormatter = DateFormatter()
                    dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                    let serverTime = dFormatter.date(from: contentType)
                    dFormatter.dateFormat = "d yyyy"
                    let myStringafd = dFormatter.string(from: serverTime!)
                    completionHandler(myStringafd)
                    
                }
            }
            task.resume()
        }
     getTimeFromServer { (serverDate) in
     print(serverDate)
     self.serverDates = serverDate
         }
    getTimeFromServerForLives{ (serverDate) in
        print(serverDate)
        self.todayDate = serverDate
            }
     let uid = Auth.auth().currentUser?.uid
     db.collection("users").document(uid!).getDocument { (document,error) in
        
               if error != nil{
                   print("cant get data")
                   
               }
            if (document != nil && document!.exists){
                if let documentdata = document?.data() {
                    self.check = documentdata["zAnsweredTF"] as! [Int]
                 self.firstTime = documentdata["monthAndYearWithQuestionBankTF"] as! String
                    self.reloadedLives =  documentdata["dateForLastReloadLivesTF"] as! String
                    self.lives = documentdata["chancesTF"] as! Int
                    UserDefaults.standard.set(self.lives, forKey: "wrongTF")
             }
           }
         
         print("\(self.check.count)")
        if (self.reloadedLives != self.todayDate){
            UserDefaults.standard.set(3, forKey: "wrongTF")
            self.canPlay = true
        }
         if (self.firstTime == ""){
             self.canPlay = true
             print("firsttime == 0")
            UserDefaults.standard.set(3, forKey: "wrongTF")
         }
         if (self.check.count == 0 && (self.serverDates != self.firstTime)){
             print("newest stat")
             self.canPlay = true 
            UserDefaults.standard.set(3, forKey: "wrongTF")
         }
         else if (self.check.count == 0 && self.firstTime != "" ){
             self.backButtonOutlet.isHidden = true
             self.navigationController?.navigationBar.isHidden = true
             self.labelStackView1.text = "You Have Answered All The Questions For This Month"
             self.labelStackVeiew2.text = "If You Havent, Consider Answering The Prompt!"
             self.beginButtonOutlet.setTitle("Back", for: .normal)
             self.canPlay = false
           
             
            
         
         }
        if (UserDefaults.standard.integer(forKey: "wrongTF") <= 0){
             self.backButtonOutlet.isHidden = true
             self.navigationController?.navigationBar.isHidden = true
             self.labelStackView1.text = "You Have Gotten Three Wrong Answers Today"
             self.labelStackVeiew2.text = "Come Back Tomorrow!"
             self.beginButtonOutlet.setTitle("Back", for: .normal)
             self.canPlay = false
             
         
         }
        if (UserDefaults.standard.integer(forKey: "wrongTF") > 0 && self.check.count != 0){
             self.canPlay = true
         }
        
     }
     }
    @IBAction func beginButton(_ sender: Any) {
        //this is used just for testing!!!!
        //self.canPlay = true
        if (self.canPlay == true){
            self.hidesBottomBarWhenPushed = false
            let uid = Auth.auth().currentUser?.uid
                                         //UserDefaults.standard.set(true, forKey: "isloggedIn")
                                         //UserDefaults.standard.synchronize()
                       Firestore.firestore().collection("users").document(uid!).updateData(["chancesTF":UserDefaults.standard.integer(forKey: "wrongTF"),"dateForLastReloadLivesTF":todayDate])
       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       let resultViewController = storyBoard.instantiateViewController(withIdentifier: "truefalse")
       resultViewController.modalPresentationStyle = .fullScreen
            self.show(resultViewController, sender: nil)
            
        }else{
           
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "startQuiz")
            resultViewController.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: .linear)
            transition.type = .push
            transition.subtype = .fromLeft
            //transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.view.window?.layer.add(transition, forKey: nil)
            self.show(resultViewController, sender: nil)
            
        }
    }
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "startQuiz") 
        resultViewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.show(resultViewController, sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
