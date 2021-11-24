//
//  TrueAndFalseActualViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 5/1/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
class TrueAndFalseActualViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
 
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var trueButtonOutlet: UIButton!
    @IBOutlet weak var falseButtonOutlet: UIButton!
    @IBOutlet weak var explainOutletLabel: UILabel!
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
 
    @IBOutlet weak var progressView: UIProgressView!
    
    var randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99].shuffled()
    var serverDates = ""
    var check = [0]
    var originalPoints = 0
    var resetBankNum = ""
    var invNumber = 0
    var whichQuestion = 0
    var whichQuestionString = ""
    var wasButtonClicked = false
    var explanation = ""
    var rightAnswer = 0
    var clock = Timer()
    var countDown = 0
    var counterForPoints = 0
    var points = 0
    var clocks = Timer()
    var countdowns = 1
    var newTotal = 0
    var right = 0
    var lives = 0
    lazy var timers = Timer()
    var totalDuration = 1000.0
    var cantClick = false
    var done = false
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var verticalCon: NSLayoutConstraint!
    @IBOutlet weak var nextBelow: NSLayoutConstraint!
    //circles
   var circle1:UIView!
   var circle2:UIView!
   var circle3:UIView!
   var circle4:UIView!
   var circle5:UIView!
   var circle6:UIView!
   var circle7:UIView!
   var circle8:UIView!
   var circle9:UIView!
    func getDataForQuestion() {
        
        let db = Firestore.firestore()
        
        
        
            //finds the month and year currently
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
            getTimeFromServer { (serverDate) in
            print(serverDate)
            self.serverDates = serverDate
            let uid = Auth.auth().currentUser?.uid
            db.collection("users").document(uid!).getDocument { (document,error) in
                      
                             if error != nil{
                                 print("cant get data")
                                 
                             }
                          if (document != nil && document!.exists){
                              if let documentdata = document?.data() {
                                
                                   self.check = documentdata["zAnsweredTF"] as! [Int]
                                
                                self.originalPoints = documentdata["points"] as! Int
                               self.resetBankNum = documentdata["monthAndYearWithQuestionBankTF"] as! String
                                self.invNumber = documentdata["indexNumber"] as! Int
                                self.clockLabel.text = "Lives: \(UserDefaults.standard.integer(forKey: "wrongTF"))"
                                    self.done = true
                                
                                self.hi()
                                
                            }
                               //print(self.check)
                           }
                       }
        }
    }
    func hi(){
        print(serverDates)
        print(resetBankNum)
        if (self.serverDates != self.resetBankNum){
          let db = Firestore.firestore()
          let uid = Auth.auth().currentUser?.uid
            print(self.randomArray)
          let wash = db.collection("users").document(uid!)
          wash.updateData([
            "zAnsweredTF": FieldValue.arrayUnion(self.randomArray),
            "monthAndYearWithQuestionBankTF":self.serverDates
              ])
            
            
            
    }
        getDataTrue()
    }
    func getDataTrue(){
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).getDocument { (document,error) in
        
               if error != nil{
                   print("cant get data")
                   
               }
            if (document != nil && document!.exists){
                if let documentdata = document?.data() {
                  
                     self.check = documentdata["zAnsweredTF"] as! [Int]
                    print(self.check)
                    self.waitUntil()
                }
            }
        }
    }
    func waitUntil(){
        print(self.check.isEmpty)
       if(self.check.isEmpty != true){
                let db = Firestore.firestore()
                self.whichQuestion = self.check[0]
                let uid = Auth.auth().currentUser?.uid
                print(self.whichQuestion)
                self.whichQuestionString = String(self.whichQuestion)
                db.collection("users").document(uid!).updateData([
                    "zAnsweredTF": FieldValue.arrayRemove([self.whichQuestion]),
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }else{
                
                //answered all the questions
                print("answered all questions field")
                self.gameOver()
                self.wasButtonClicked = true
                    
            }
            if (self.check.isEmpty != true){
                //this number is the total number of questions from end index+1 (question zero is taken into consideration)
            
        
        
            
        //self.whichQuestionString
            print(self.whichQuestionString + "fsfsf")
                let db = Firestore.firestore()
                db.collection("trueAndFalse").document(self.whichQuestionString).getDocument { (document,error) in
            
                   if error != nil{
                       print("cant get data")
                       
                   }
                   if document != nil && document!.exists{
                   if let documentdata = document?.data() {
                   self.questionLabel.text = documentdata["question"] as? String
                   self.explanation = (documentdata["explanation"] as? String)!
                   
                   self.wasButtonClicked = false
                   self.rightAnswer = documentdata["correctAnswer"] as! Int
                    
                   self.timers = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.decrementProgress), userInfo: nil, repeats: true)
                   self.enableButtons()
                    
                    
                      
                    //self.clockToEnable = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.waitToEnable), userInfo: nil, repeats: true)
                   }
           
        }
        
        }
            }
        
        
    }
    @objc func decrementProgress() {
        if totalDuration <= 0 {
         timers.invalidate()
         self.disableButtons()
         self.showRightChoice()
         let wrong:Int = UserDefaults.standard.integer(forKey: "wrongTF")
         let newWrong = wrong-1
         UserDefaults.standard.set(newWrong, forKey: "wrongTF")
         clockLabel.text = "Lives: \(newWrong)"
         self.gameOver()
         self.wasButtonClicked = true
            if (UserDefaults.standard.integer(forKey: "wrongTF") >= 1){
         nextButtonOutlet.isHidden = false
        nextButtonOutlet.isEnabled = true
            }
        }else {

            self.totalDuration -= 1
            self.progressView.setProgress(0.001 * Float(self.totalDuration) , animated: true)
        }
    }
    @objc func countDownBeforeMove(){
        countdowns -= 1
        if countdowns <= 0{
            clocks.invalidate()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "EndQuizViewController") as! EndQuizViewController
            resultViewController.modalPresentationStyle = .fullScreen
             resultViewController.hidesBottomBarWhenPushed = false
             performSegue(withIdentifier: "name", sender: self)
        }
    }
    func gameOver(){
        if UserDefaults.standard.integer(forKey: "wrongTF") <= 0 || self.check.count <= 0 {
            print("ran through gameov")
            nextButtonOutlet.isHidden = true
            if (UserDefaults.standard.integer(forKey: "wrongTF") <= 0 ){
                UserDefaults.standard.set(1, forKey: "x")
                print(UserDefaults.standard.integer(forKey: "x"))
                print("USer above")
            }else if (self.check.count <= 0){
                
                UserDefaults.standard.set(3, forKey: "x")
                print(UserDefaults.standard.integer(forKey: "x") )
                 print("USer aboves")
            }
            self.newTotal = self.points + self.originalPoints
            let uid = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            db.collection("users").document(uid!).updateData([
                "points": self.newTotal,
                "chancesTF": UserDefaults.standard.integer(forKey: "wrongTF")
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            let index = String(self.invNumber)
            db.collection("leaderboard").document(index).setData([
                "points": self.newTotal,
                "uid": uid!
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            if UserDefaults.standard.bool(forKey: "medal9") == false{
                if (self.right >= 15){
                
                db.collection("users").document(uid!).updateData([
                    "medals":FieldValue.arrayUnion(["15true"])
                    
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        UserDefaults.standard.set(true, forKey: "medal9")
                    }
                }
                }
            }
            self.clocks = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.countDownBeforeMove), userInfo: nil, repeats: true)
        }
        
    }

    @IBOutlet weak var trueToFlase: NSLayoutConstraint!
    @IBOutlet weak var topCont: NSLayoutConstraint!
    @IBOutlet weak var falseToExplain: NSLayoutConstraint!
       let monitor = NWPathMonitor()
    var seeNewPostsButton:NoConnectionHeader!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        seeNewPostsButton = NoConnectionHeader()
        view.addSubview(seeNewPostsButton)
        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        seeNewPostsButton.isHidden = true;
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
                 if path.status == .satisfied {
                     print("We're connected!")
                    
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = true
                         self.cantClick = false
                    }
                 } else {
                     print("No connection.")
            
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = false
                         self.cantClick = true
                    }
                  
                 }

                 print(path.isExpensive)
             }
        
        self.explainOutletLabel.text = ""
        clockLabel.text = "Lives: \(UserDefaults.standard.integer(forKey:"wrongTF"))"
        nextButtonOutlet.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.layer.isHidden = true
        getDataForQuestion()
        disableButtons()
        if (self.view.frame.width == 375){
        buttonHeight.constant = 75
            questionLabel.font = questionLabel.font.withSize(22)
        }
        if (self.view.frame.width == 320){
            buttonHeight.constant = 55
            questionLabel.font = questionLabel.font.withSize(20)
            topCont.constant = 30
            falseToExplain.constant = 20
            trueToFlase.constant = 30
            explainOutletLabel.font = explainOutletLabel.font.withSize(15);
            verticalCon.constant = 55
            nextBelow.constant = 60
        }
        
        circle1 = UIView(frame: CGRect(x: view.frame.size.width * 0.07, y: view.frame.size.height * 0.88, width: view.frame.size.width * 0.03, height: view.frame.size.width * 0.03))
               circle1.backgroundColor = UIColor(red: 32/255, green: 164/255, blue: 243/255, alpha: 1.0)
               circle1.layer.cornerRadius = self.circle1.frame.size.height/2
               view.addSubview(circle1)
               
               circle2 = UIView(frame: CGRect(x: view.frame.size.width * 0.11, y: view.frame.size.height * 0.93, width: view.frame.size.width * 0.05, height: view.frame.size.width * 0.05))
               circle2.backgroundColor = UIColor(red: 136/255, green: 49/255, blue: 98/255, alpha: 1.0)
               circle2.layer.cornerRadius = self.circle2.frame.size.height/2
               view.addSubview(circle2)
               
               circle3 = UIView(frame: CGRect(x: view.frame.size.width * 0.25, y: view.frame.size.height * 0.98, width: view.frame.size.width * 0.08, height: view.frame.size.width * 0.08))
               circle3.backgroundColor = UIColor(red:76/255, green: 159/255, blue: 112/255, alpha: 1.0)
               circle3.layer.cornerRadius = self.circle3.frame.size.height/2
               view.addSubview(circle3)
               
               circle4 = UIView(frame: CGRect(x: view.frame.size.width * 0.4, y: view.frame.size.height * 0.98, width: view.frame.size.width * 0.02, height: view.frame.size.width * 0.02))
               circle4.backgroundColor = UIColor(red: 142/255, green: 0/255, blue: 69/255, alpha: 1.0)
               circle4.layer.cornerRadius = self.circle4.frame.size.height/2
               view.addSubview(circle4)
               
               circle9 = UIView(frame: CGRect(x: view.frame.size.width * 0.55, y: view.frame.size.height * 0.96, width: view.frame.size.width * 0.04, height: view.frame.size.width * 0.04))
               circle9.backgroundColor = UIColor(red: 143/255, green: 203/255, blue: 155/255, alpha: 1.0)
               circle9.layer.cornerRadius = self.circle9.frame.size.height/2
               view.addSubview(circle9)
               
               circle5 = UIView(frame: CGRect(x: view.frame.size.width * 0.72, y: view.frame.size.height * 0.97, width: view.frame.size.width * 0.03, height: view.frame.size.width * 0.03))
               circle5.backgroundColor = UIColor(red: 26/255, green: 200/255, blue: 237/255, alpha: 1.0)
               circle5.layer.cornerRadius = self.circle5.frame.size.height/2
               view.addSubview(circle5)
               
               circle6 = UIView(frame: CGRect(x: view.frame.size.width * 0.86, y: view.frame.size.height * 0.90, width: view.frame.size.width * 0.015, height: view.frame.size.width * 0.015))
               circle6.backgroundColor = UIColor(red: 15/255, green: 113/255, blue: 115/255, alpha: 1.0)
               circle6.layer.cornerRadius = self.circle6.frame.size.height/2
               view.addSubview(circle6)
               
               circle7 = UIView(frame: CGRect(x: view.frame.size.width * 0.96, y: view.frame.size.height * 0.97, width: view.frame.size.width * 0.07, height: view.frame.size.width * 0.07))
               circle7.backgroundColor = UIColor(red: 126/255, green: 127/255, blue: 154/255, alpha: 1.0)
               circle7.layer.cornerRadius = self.circle7.frame.size.height/2
               view.addSubview(circle7)
               
               circle8 = UIView(frame: CGRect(x: view.frame.size.width * 0.97, y: view.frame.size.height * 0.89, width: view.frame.size.width * 0.045, height: view.frame.size.width * 0.045))
               circle8.backgroundColor = UIColor(red: 3/255, green: 29/255, blue:68/255, alpha: 1.0)
               circle8.layer.cornerRadius = self.circle8.frame.size.height/2
               view.addSubview(circle8)
               
        // Do any additional setup after loading the view.
    let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    @objc func appMovedToBackground() {
        if(wasButtonClicked != true){
      
              print(totalDuration)
              let wrong = UserDefaults.standard.integer(forKey: "wrongTF")
              let newWrong = wrong - 1
              UserDefaults.standard.set(newWrong,forKey: "wrongTF")
              clockLabel.text = "Lives: \(newWrong)"
           }
        self.clock.invalidate()
        disableButtons()
        
       
        let uid = Auth.auth().currentUser?.uid
        self.newTotal = self.points + self.originalPoints
        Firestore.firestore().collection("users").document(uid!).updateData([
               "points": self.newTotal,
               "chancesTF": UserDefaults.standard.integer(forKey: "wrongTF")])
       gameOver()

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //FALSE BUTTON
    @IBAction func falseButtonClicked(_ sender: Any) {
        disableButtons()
        timers.invalidate()
        falseButtonOutlet.layer.borderWidth = 4
       
        explainOutletLabel.text = explanation
   
        clock.invalidate()
        gameOver()
        nextButtonOutlet.isEnabled = true
        nextButtonOutlet.isHidden = false
        self.wasButtonClicked = true
        if (self.rightAnswer == 2){
           self.points += 15 - counterForPoints
            self.falseButtonOutlet.layer.borderColor = UIColor.green.cgColor
        }else{
            let wrong = UserDefaults.standard.integer(forKey: "wrongTF")
            let newWrong = wrong - 1
            UserDefaults.standard.set(newWrong,forKey: "wrongTF")
            clockLabel.text = "Lives: \(newWrong)"
            self.falseButtonOutlet.layer.borderColor = UIColor.red.cgColor
            gameOver()
        }
    }
    //TRUE BUTTON
    @IBAction func trueButtonClicked(_ sender: Any) {
        disableButtons()
        timers.invalidate()
        trueButtonOutlet.layer.borderWidth = 4
        nextButtonOutlet.isHidden = false
        explainOutletLabel.text = explanation
        
        clock.invalidate()
        gameOver()
        nextButtonOutlet.isEnabled = true
        self.wasButtonClicked = true
        if (self.rightAnswer == 1){
            self.points += 15 - counterForPoints
            self.trueButtonOutlet.layer.borderColor = UIColor.green.cgColor
            
        }else{
            let wrong = UserDefaults.standard.integer(forKey: "wrongTF")
            let newWrong = wrong - 1
            UserDefaults.standard.set(newWrong,forKey: "wrongTF")
            clockLabel.text = "Lives: \(newWrong)"
            self.trueButtonOutlet.layer.borderColor = UIColor.red.cgColor
            gameOver()
        }
    }
    @IBAction func nextButton(_ sender: Any) {
        if wasButtonClicked == true{
            if self.check.count == 0{
                gameOver()
            }else if(cantClick == true){
                
            }else{
                nextButtonOutlet.isEnabled = false
                self.totalDuration = 1000.0
                progressView.progress = 1.0
                explainOutletLabel.text = ""
                falseButtonOutlet.layer.borderWidth = 0
                trueButtonOutlet.layer.borderWidth = 0
                falseButtonOutlet.layer.borderColor = .none
                trueButtonOutlet.layer.borderColor = .none
                nextButtonOutlet.isHidden = true
                disableButtons()
                getDataForQuestion()
                explainOutletLabel.text = ""
                
               
            }
        }
    }
    func disableButtons(){
        trueButtonOutlet.isEnabled = false
        falseButtonOutlet.isEnabled = false
    }
    func enableButtons(){
        trueButtonOutlet.isEnabled = true
        falseButtonOutlet.isEnabled = true
    }
    func showRightChoice(){
        if (self.rightAnswer == 1){
                UIView.animate(withDuration:1, animations: {
                    self.trueButtonOutlet.layer.borderColor = UIColor.green.cgColor
                self.falseButtonOutlet.layer.borderColor = UIColor.red.cgColor
        },completion: nil)
        }else{
                UIView.animate(withDuration:1, animations: {
                    self.trueButtonOutlet.layer.borderColor = UIColor.red.cgColor
                    self.falseButtonOutlet.layer.borderColor = UIColor.green.cgColor
            },completion: nil)
        }
    }
  
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("dfsdfsdfsfd")
        if(segue.identifier == "name"){
     
        let displayVC = segue.destination as! EndQuizViewController
        displayVC.currentPoints = self.points
        displayVC.totalPoints = self.newTotal
    }
}

}
