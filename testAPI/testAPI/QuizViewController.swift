//
//  QuizViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/31/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import Network
class QuizViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButtonTwo: UIButton!
    @IBOutlet weak var answerButtonOne: UIButton!
    @IBOutlet weak var answerButtonThree: UIButton!
    @IBOutlet weak var answerButtonFour: UIButton!
    var check = [0]
    
   
    @IBOutlet weak var livesText: UILabel!
    @IBOutlet weak var viewBehindButtons: UIView!
    @IBOutlet weak var nextButton: UIButton!

 
    @IBOutlet weak var progressView: UIProgressView!
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
    
    var borderButtonColor = UIColor(red: 43/255, green: 71/255, blue: 104/255, alpha: 1).cgColor
    var backButtonColor = UIColor(red: 43/255, green: 71/255, blue: 104/255, alpha: 0.2).cgColor
    var isLast = false
    var wrong = 0
    var whichQuestion = 0
    var whichQuestionString = ""
    var documentdata:[String:Any] = ["":""]
    var wasButtonClicked = false
    var x = 0
    var countDown = 15
    var countss = 1
    var randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99].shuffled()
    var points = 0
    var originalPoints = 0
    var newTotal = 0
    var resetBankNum = ""
    var checkMonth = ""
    var counter = 2
    var countDownClock = Timer()
    var clockToEnable = Timer()
    var rightAnswer = 0
    var serverDates = ""
    var invNumber = 0
    var monthsPlayed = 0
    var counterForPoints = 0
    var right = 0
    var lives = 0
    lazy var timer = Timer()
    var cantClick = false
    var totalDuration = 1500.0
    var done = false
    var seeNewPostsButton:NoConnectionHeader!
       var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    let monitor = NWPathMonitor()
    
    override func viewDidLoad(){
        super.viewDidLoad()
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
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.layer.isHidden = true
        livesText.text = "Lives: \(UserDefaults.standard.integer(forKey:"wrong"))"
        setupElements()
        getDataForQuestion()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
        @objc func appMovedToBackground() {
         self.timer.invalidate()
         disableButtons()
         if (wasButtonClicked != true){
         let wrong = UserDefaults.standard.integer(forKey: "wrong")
         let newWrong = wrong - 1
         
         UserDefaults.standard.set(newWrong,forKey: "wrong")
         livesText.text = "Lives: \(newWrong)"
            }
            self.newTotal = self.points + self.originalPoints
            let uid = Auth.auth().currentUser?.uid
            Firestore.firestore().collection("users").document(uid!).updateData([
                "points": self.newTotal,
                "chances": UserDefaults.standard.integer(forKey: "wrong")
            ])
         gameOver()
            if (UserDefaults.standard.integer(forKey: "wrong") >= 1){
                
            
         nextButton.isHidden = false
         nextButton.isEnabled = true
            }
         progressView.progress = 1
         self.wasButtonClicked = true
         showRightChoice()
           
    }
    override func viewWillLayoutSubviews() {
           questionLabel.sizeToFit()
       }
    func setupElements(){
        overrideUserInterfaceStyle = .light
        disableButtons()
        nextButton.isHidden = true
        answerButtonOne.setTitle("", for:.normal)
        answerButtonTwo.setTitle("", for:.normal)
        answerButtonThree.setTitle("", for:.normal)
        answerButtonFour.setTitle("", for:.normal)
        
        questionLabel.text = ""
        answerButtonOne.layer.borderColor = borderButtonColor
        answerButtonOne.layer.borderWidth = 4
        answerButtonOne.layer.backgroundColor = backButtonColor
        answerButtonOne.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        answerButtonOne.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)


        answerButtonTwo.layer.borderColor = borderButtonColor
        answerButtonTwo.layer.borderWidth = 4
        answerButtonTwo.layer.backgroundColor = backButtonColor
        answerButtonTwo.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        answerButtonTwo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        answerButtonThree.layer.borderColor = borderButtonColor
        answerButtonThree.layer.borderWidth = 4
        answerButtonThree.layer.backgroundColor = backButtonColor
        answerButtonThree.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        answerButtonThree.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
        answerButtonFour.layer.borderColor = borderButtonColor
        answerButtonFour.layer.borderWidth = 4
        answerButtonFour.layer.backgroundColor = backButtonColor
        answerButtonFour.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        answerButtonFour.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        answerButtonOne.layer.cornerRadius = 15
        answerButtonOne.layer.masksToBounds = true
        answerButtonTwo.layer.cornerRadius = 15
        answerButtonTwo.layer.masksToBounds = true
        answerButtonThree.layer.cornerRadius = 15
        answerButtonThree.layer.masksToBounds = true
        answerButtonFour.layer.cornerRadius = 15
        answerButtonFour.layer.masksToBounds = true
    
        
        //CIRCLES
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
        
      
        if(self.view.frame.width == 320){
            aboveMult.constant = 15
            aboveNext.constant = 20
            questionLabel.font = questionLabel.font.withSize(19)
            heightOfButtons.constant = 43
        }
        if(self.view.frame.width == 375){
            aboveMult.constant = 55
            aboveNext.constant = 25
            questionLabel.font = questionLabel.font.withSize(21)
         
        }
        
        //FOR NOW //REMEMBER TO DELETE THIS!!!!!!!!!!!!!!!!
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //UserDefaults.standard.set(3, forKey: "wrong")
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    }
    @IBOutlet weak var heightOfButtons: NSLayoutConstraint!
    @IBOutlet weak var aboveMult: NSLayoutConstraint!
    @IBOutlet weak var aboveNext: NSLayoutConstraint!
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
                                
                                   self.check = documentdata["zAnswered"] as! [Int]
                                
                                self.originalPoints = documentdata["points"] as! Int
                               self.resetBankNum = documentdata["monthAndYearWithQuestionBank"] as! String
                                self.invNumber = documentdata["indexNumber"] as! Int
                                self.monthsPlayed = documentdata["monthsPlayed"] as! Int
                                self.livesText.text = "Lives: \(UserDefaults.standard.integer(forKey: "wrong"))"
                                    self.done = true;
                                
                                self.hi()
                                
                            }
                               //print(self.check)
                           }
                       }
        }
    }
            //checks if it's a new month and gives more points
            
                
    func hi(){
        
        if (self.serverDates != self.resetBankNum){
          let db = Firestore.firestore()
          let uid = Auth.auth().currentUser?.uid
            print(self.randomArray)
          let wash = db.collection("users").document(uid!)
          wash.updateData([
            "zAnswered": FieldValue.arrayUnion(self.randomArray),
            "monthAndYearWithQuestionBank":self.serverDates,
            "monthsPlayed": monthsPlayed+1
              ])
            
            
            
    }
        whack()
    }
    func whack(){
      let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).getDocument { (document,error) in
        
               if error != nil{
                   print("cant get data")
                   
               }
            if (document != nil && document!.exists){
                if let documentdata = document?.data() {
                  
                     self.check = documentdata["zAnswered"] as! [Int]
                    print(self.check)
                    waitUntil()
                }
            }
        }
        func waitUntil(){
       if(self.check.isEmpty != true){
        
                self.whichQuestion = self.check[0]
                let uid = Auth.auth().currentUser?.uid
                print(self.whichQuestion)
                self.whichQuestionString = String(self.whichQuestion)
                db.collection("users").document(uid!).updateData([
                    "zAnswered": FieldValue.arrayRemove([self.whichQuestion]),
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
                db.collection("quizs").document(self.whichQuestionString).getDocument { (document,error) in
            
                   if error != nil{
                       print("cant get data")
                       
                   }
                   if document != nil && document!.exists{
                   if let documentdata = document?.data() {
                   self.documentdata = documentdata
                    self.questionLabel.sizeToFit()
                   self.questionLabel.text = documentdata["Question"] as? String
                   self.answerButtonOne.setTitle(documentdata["Answer1"] as? String, for:.normal)
                    let answer1 = documentdata["Answer1"] as? String
                    if answer1?.count ?? 0 > 20{
                        self.answerButtonOne.titleLabel?.font = .systemFont(ofSize: 14)
                    }
                    let answer2 = documentdata["Answer2"] as? String
                   self.answerButtonTwo.setTitle(documentdata["Answer2"] as? String, for:.normal)
                    if answer2?.count ?? 0 > 20{
                        self.answerButtonTwo.titleLabel?.font = .systemFont(ofSize: 14)
                    }
                    
                    let answer3 = documentdata["Answer3"] as? String
                    
                   self.answerButtonThree.setTitle(documentdata["Answer3"] as? String, for:.normal)
                  
                   
                    print(answer3?.count ?? 0)
                    if answer3?.count ?? 0 > 20{
                        self.answerButtonThree.titleLabel?.font = .systemFont(ofSize: 14)
                    }
                    let answer4 = documentdata["Answer4"] as? String
                   self.answerButtonFour.setTitle(documentdata["Answer4"] as? String, for:.normal)
                    if answer4?.count ?? 0 > 20{
                        self.answerButtonFour.titleLabel?.font = .systemFont(ofSize: 14)
                    }
                   self.wasButtonClicked = false
                   self.rightAnswer = documentdata["correctAnswer"] as! Int
                    
                   self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.decrementProgress), userInfo: nil, repeats: true)
                    
                    
                    
                    
                    self.enableButtons()
                    //self.progressView.progress = 0.01
                    
                    //UIView.animate(withDuration: 15, animations: {
                    //self.progressView.setProgress(0.0, animated: true)
                       // self.progressView.layoutIfNeeded()
                        //if (self.answerButtonOne.isSelected == true || self.answerButtonTwo.isSelected == true || self.answerButtonThree.isSelected == true || self.answerButtonFour.isSelected == true  ){
                            //self.view.layer.removeAllAnimations()
                        //}
                   // }, completion: { (Bool) in
                     //   if Bool == true{
                        //   self.disableButtons()
                      //      self.showRightChoice()
                        //    let wrong:Int = UserDefaults.standard.integer(forKey: "wrong")
                        //    let newWrong = wrong-1
                         //   UserDefaults.standard.set(newWrong, forKey: "wrong")
                          //  self.whichImage(newWrong: newWrong)
                          //  self.gameOver()
                           // self.wasButtonClicked = true

                        //}
                        
                    //})
                    
                      
                    //self.clockToEnable = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.waitToEnable), userInfo: nil, repeats: true)
                   }
           
        }
        
        }
            }
        
        
           
    }

    }
    @objc func decrementProgress() {
           if totalDuration <= 0 {
            timer.invalidate()
            self.disableButtons()
                 self.showRightChoice()
                  let wrong:Int = UserDefaults.standard.integer(forKey: "wrong")
                  let newWrong = wrong-1
                  UserDefaults.standard.set(newWrong, forKey: "wrong")
                 livesText.text = "Lives: \(newWrong)"
                  self.gameOver()
                  self.wasButtonClicked = true
           
           }else {

               self.totalDuration -= 1
               self.progressView.setProgress(0.00066 * Float(self.totalDuration) , animated: true)
           }
       }
   @IBAction func AnswerOneTap(_ sender: Any) {
        let rightAnswer:Int = documentdata["correctAnswer"] as! Int
        disableButtons()
    timer.invalidate()
    nextButton.isEnabled = true
    print(self.rightAnswer)
    nextButton.isHidden = false
    if (rightAnswer == 1){
            self.points += 25 - counterForPoints
            self.wasButtonClicked = true
            showRightChoice()
            right+=1
    }
        if(rightAnswer == 2 || rightAnswer == 3 || rightAnswer == 4){
         
                let wrong = UserDefaults.standard.integer(forKey: "wrong")
                let newWrong = wrong-1
                UserDefaults.standard.set(newWrong, forKey: "wrong")
                livesText.text = "Lives: \(newWrong)"
                answerButtonOne.layer.borderColor = UIColor.red.cgColor
              
                gameOver()
                self.wasButtonClicked = true
                showRightChoice()
                
            }
        }
        
    
    @IBAction func AnswerTwoTap(_ sender: Any) {
        let rightAnswer:Int = documentdata["correctAnswer"] as! Int
        disableButtons()
        timer.invalidate()
        nextButton.isEnabled = true
        nextButton.isHidden = false
        if (rightAnswer == 2){
            self.points += 25 - counterForPoints
            self.wasButtonClicked = true
        
            showRightChoice()
            right+=1
        }
            if(rightAnswer == 1 || rightAnswer == 3 || rightAnswer == 4){
                let wrong = UserDefaults.standard.integer(forKey: "wrong")
                let newWrong = wrong-1
                UserDefaults.standard.set(newWrong, forKey: "wrong")
                answerButtonTwo.layer.borderColor = UIColor.red.cgColor
                livesText.text = "Lives: \(newWrong)"
                
                gameOver()
                self.wasButtonClicked = true
                showRightChoice()
                
                
                
            
        }
        
    }
    @IBAction func AnswerThreeTap(_ sender: Any) {
        let rightAnswer:Int = documentdata["correctAnswer"] as! Int
        disableButtons()
        timer.invalidate()
        nextButton.isHidden = false
        nextButton.isEnabled = true
        if (rightAnswer == 3){
            self.points += 25 - counterForPoints
          
            self.wasButtonClicked = true
            right+=1
            showRightChoice()
        }
        if(rightAnswer == 2 || rightAnswer == 1 || rightAnswer == 4){
            let wrong = UserDefaults.standard.integer(forKey: "wrong")
            let newWrong = wrong-1
            UserDefaults.standard.set(newWrong, forKey: "wrong")
            print(newWrong)
            livesText.text = "Lives: \(newWrong)"
          
            gameOver()
            self.wasButtonClicked = true
            answerButtonThree.layer.borderColor = UIColor.red.cgColor
            showRightChoice()
            
            
        }
    }
    @IBAction func AnswerFourTap(_ sender: Any) {
        let rightAnswer:Int = documentdata["correctAnswer"] as! Int
        disableButtons()
        timer.invalidate()
        nextButton.isEnabled = true
        nextButton.isHidden = false
        if (rightAnswer == 4){
            self.points += 25 - counterForPoints
            
            self.wasButtonClicked = true
            right+=1
            showRightChoice()
            
        }
        if(rightAnswer == 2 || rightAnswer == 3 || rightAnswer == 1){
            let wrong:Int = UserDefaults.standard.integer(forKey: "wrong")
            let newWrong = wrong-1
            UserDefaults.standard.set(newWrong, forKey: "wrong")
           livesText.text = "Lives: \(newWrong)"
            answerButtonFour.layer.borderColor = UIColor.red.cgColor
            
            gameOver()
            self.wasButtonClicked = true
            
        }
    }
   
    @IBAction func NextorEndButton(_ sender: Any) {
        //go back to the main home page all the questions have been answered or display a completion stage/view
        if(wasButtonClicked == true){
            
            if (self.check.count == 0){
                print("all questions done")
                gameOver()
                
                
                
                }
            else if (cantClick == true){
                
            }
            else{
           //go to the next question\
                nextButton.isEnabled = false
                self.totalDuration = 1500.0
                progressView.progress = 1.0
                questionLabel.text = ""
                answerButtonOne.setTitle("", for: .normal)
                answerButtonTwo.setTitle("", for: .normal)
                answerButtonThree.setTitle("", for: .normal)
                answerButtonFour.setTitle("", for: .normal)
                answerButtonFour.layer.borderWidth = 4
                answerButtonThree.layer.borderWidth = 4
                answerButtonTwo.layer.borderWidth = 4
                answerButtonOne.layer.borderWidth = 4
                answerButtonOne.layer.borderColor = borderButtonColor
                answerButtonTwo.layer.borderColor = borderButtonColor
                answerButtonThree.layer.borderColor = borderButtonColor
                answerButtonFour.layer.borderColor = borderButtonColor
                disableButtons()
                getDataForQuestion()
                nextButton.isHidden = true
                
            }
        }
    }
    func hideButtons(whichAnswerChoice:Int){
        if (whichAnswerChoice == 1){
            
        }
    }
    func disableButtons(){
        answerButtonOne.isEnabled = false
        answerButtonTwo.isEnabled = false
        answerButtonThree.isEnabled = false
        answerButtonFour.isEnabled = false
    }
    func enableButtons(){
        answerButtonOne.isEnabled = true
        answerButtonTwo.isEnabled = true
        answerButtonThree.isEnabled = true
        answerButtonFour.isEnabled = true
    }
    func gameOver(){
        if (UserDefaults.standard.integer(forKey: "wrong") <= 0 || self.check.isEmpty == true){
            self.nextButton.isHidden = true
            
            if (UserDefaults.standard.integer(forKey: "wrong") <= 0) {
                UserDefaults.standard.set(1, forKey: "x")
            }
            if (self.check.isEmpty == true) {
                UserDefaults.standard.set(2, forKey: "x")
            }
            self.newTotal = self.points + self.originalPoints
            let uid = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            db.collection("users").document(uid!).updateData([
                "points": self.newTotal,
                "chances": UserDefaults.standard.integer(forKey: "wrong")
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
            if UserDefaults.standard.bool(forKey: "medal8") == false{
                if (self.right >= 10){
                
                db.collection("users").document(uid!).updateData([
                    "medals":FieldValue.arrayUnion(["10multiple"])
                    
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        UserDefaults.standard.set(true, forKey: "medal8")
                    }
                }
                }
            }

           //var clockLabel = Timer()
         
           
             self.countDownClock = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.countdownDisplayText), userInfo: nil, repeats: true)
                
            }else{
            self.nextButton.isHidden = false
            self.nextButton.isEnabled = true
        }
        
    }
    @objc func pauseWhenBackground(noti:Notification){
        self.timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(),forKey:"savedTime")
        print(Date())
    }
    
    func showRightChoice(){
        let rightAnswer:Int = documentdata["correctAnswer"] as! Int
        if rightAnswer == 1{
            UIView.animate(withDuration:1, animations: {
            self.answerButtonOne.layer.borderColor = UIColor.green.cgColor
                
        },completion: nil)
        }
        if rightAnswer == 2{
            UIView.animate(withDuration:1, animations: {
                self.answerButtonTwo.layer.borderColor = UIColor.green.cgColor
            
        },completion: nil)
        }
        if rightAnswer == 3{
            UIView.animate(withDuration:1, animations: {
            
                self.answerButtonThree.layer.borderColor = UIColor.green.cgColor
            
        },completion: nil)
        }
        if rightAnswer == 4{
            UIView.animate(withDuration:0.7, animations: {
                self.answerButtonFour.layer.borderColor = UIColor.green.cgColor
        },completion: nil)
        }
    }
  

    
   
    @objc func countdownDisplayText(){
        
        countss-=1
        if countss == 0{
            
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            print("CountdownDisplayText")
            
            print(self.newTotal)
            
           let resultViewController = storyBoard.instantiateViewController(withIdentifier: "EndQuizViewController") as! EndQuizViewController
           resultViewController.modalPresentationStyle = .fullScreen
            resultViewController.hidesBottomBarWhenPushed = false
            performSegue(withIdentifier: "name", sender: self)
      
        
           gameOver()
        }
    }
   
    
    // MARK: - Navigation    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "name"){
                print("ran through segue")
                let displayVC = segue.destination as! EndQuizViewController
                displayVC.currentPoints = self.points
                displayVC.totalPoints = self.newTotal
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
extension CGRect {

    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {

        self.init(x:x, y:y, width:w, height:h)
    }
}

