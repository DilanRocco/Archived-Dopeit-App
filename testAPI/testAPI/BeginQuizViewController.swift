//
//  BeginQuizViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/10/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class BeginQuizViewController: UIViewController {
var check = [0]
var lives = 0
    

//for nowwwww set wrong to 3(need to setup user default)

    
var firstTime = ""
var canPlay = false
var serverDates = ""
var reloadedLives = ""
var todayDate = ""
    @IBOutlet weak var firstLabelInStackView: UILabel!
    @IBOutlet weak var BeginAndBackButton: UIButton!
    @IBOutlet weak var secondLabelinStackView: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        BeginAndBackButton.layer.cornerRadius = 20
        BeginAndBackButton.layer.masksToBounds = true
        
        
    
        
        checkIfUserCanPlay()
        print(UserDefaults.standard.integer(forKey: "wrong"))
        // Do any additional setup after loading the view.
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
        getTimeFromServerForLives { (serverDate) in
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
                   self.check = documentdata["zAnswered"] as! [Int]
                self.firstTime = documentdata["monthAndYearWithQuestionBank"] as! String
                self.lives = documentdata["chances"] as! Int
                self.reloadedLives =  documentdata["dateForLastReloadLives"] as! String
                UserDefaults.standard.set(self.lives, forKey: "wrong")
                
            }
          }
        
        print("\(self.check.count)")
        if (self.reloadedLives != self.todayDate){
            UserDefaults.standard.set(3, forKey: "wrong")
            self.canPlay = true
        }
        else if (self.firstTime == ""){
            self.canPlay = true
            print("firsttime == 0")
            UserDefaults.standard.set(3, forKey: "wrong")
        }
        else if (self.check.count == 0 && (self.serverDates != self.firstTime)){
            print("newest stat")
            self.canPlay = true
            UserDefaults.standard.set(3, forKey: "wrong")
        }
        else if (self.check.count == 0 && self.firstTime != "" ){
            self.backUnderButtonOutlet.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
            self.firstLabelInStackView.text = "You Have Answered All The Questions For This Month"
            self.secondLabelinStackView.text = "If You Havent, Consider Answering The Prompt!"
            self.BeginAndBackButton.setTitle("Back", for: .normal)
            self.canPlay = false
          
            
           
        
        }
        else if (UserDefaults.standard.integer(forKey: "wrong") <= 0){
            self.backUnderButtonOutlet.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
            self.firstLabelInStackView.text = "You Have Gotten Three Wrong Answers Today"
            self.secondLabelinStackView.text = "Come Back Tomorrow!"
            self.BeginAndBackButton.setTitle("Back", for: .normal)
            self.canPlay = false
            
        
        }
        else if (UserDefaults.standard.integer(forKey: "wrong") > 0 && self.check.count != 0){
            self.canPlay = true
        }
       
    }
    }
    @IBAction func BeginAndBackButtonTap(_ sender: Any) {
        print(canPlay)
        //self.canPlay should not equal true the statment below is just for testion purposes!!!!!!!!
        //self.canPlay = true

        if (self.canPlay == true){
            self.hidesBottomBarWhenPushed = false
            let uid = Auth.auth().currentUser?.uid
            print(todayDate)
            Firestore.firestore().collection("users").document(uid!).updateData(["chances":UserDefaults.standard.integer(forKey: "wrong"),"dateForLastReloadLives":todayDate])
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

         let resultViewController = storyBoard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
            self.show(resultViewController,sender:nil)
            
            
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
    
    @IBAction func backUnderButton(_ sender: Any) {
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
    @IBOutlet weak var backUnderButtonOutlet: UIButton!
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "swipe"{
       
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        }
    }
    

}

