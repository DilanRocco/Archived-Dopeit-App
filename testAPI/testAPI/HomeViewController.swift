//
//  HomeViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/29/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
class HomeViewController: UIViewController {

    
    
    @IBOutlet weak var ThemeLabel: UILabel!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var nextMonthLabel: UILabel!

   
    //@IBOutlet weak var imageview: UIImageView!
    var popupText = ""
    var documentdata:[String:Any] = ["":""]
    var thisMonth = ""
    var nextMonth = ""
    var questionBlogWord = ""
    let totalDaysInMonth = [31,29,31,30,31,30,31,31,30,31,30,31]
    let monthNames = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var currentPoints = 0
    var clock = Timer()
    var dayNowForRewarded = 0
    var invNumber = 0
    var shouldRunPopUp = true
    @IBOutlet weak var buttonClickMiddle: UIButton!
    var index = 0
    @IBOutlet weak var viewPlaceholder: UIView!

    @IBOutlet weak var dopepointsLabel: UILabel!
    @IBOutlet weak var dopepointsNumberLabel: UILabel!
    @IBOutlet weak var viewPrizePool: UIView!
    @IBOutlet weak var labelAboutWinning: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var clickToLearnMorePrizePool: UIButton!
    @IBOutlet weak var topicThisMonth: UILabel!
    @IBOutlet weak var topicNextMonth: UILabel!
    @IBOutlet weak var upcomingThemes: UIView!
    @IBOutlet weak var dailyRewardOutlet: UIButton!
    @IBOutlet weak var viewPlaceForDollarLabel: UIView!
    @IBOutlet weak var imageViewDollarView: UIImageView!
    @IBOutlet weak var clickHereToLearnMoreButtonOutlet: UIButton!
    @IBOutlet weak var currentThemesLabel: UILabel!
    var seeNewPostsButton:NoConnectionHeader!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!

    
    @IBOutlet weak var constraintBetweenThisMonthAndTopic: NSLayoutConstraint!
    @IBOutlet weak var constraintBetweenNextMonthAndTopic: NSLayoutConstraint!
    
    @IBOutlet weak var viewW: NSLayoutConstraint!
    @IBOutlet weak var viewH: NSLayoutConstraint!
    
    @IBOutlet weak var dollarW: NSLayoutConstraint!
    @IBOutlet weak var dollarWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var aboveMonth: NSLayoutConstraint!
    @IBOutlet weak var aboveSports: NSLayoutConstraint!
    var layoutGuide:UILayoutGuide!
    override func viewDidLoad() {
        dopepointsNumberLabel.text = ""
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        //MAKE SURE TO COMMENT BEFORE RELEASE BELOW
       //UserDefaults.standard.set(0, forKey: "dailyReward")
        //MAKE SURE TO COMMENT BEFORE RELEASE ABOVE
        //USED TO TEST ONLLYYYYYY\\
        
        viewPlaceForDollarLabel.layer.cornerRadius = 5
        viewPlaceForDollarLabel.layer.masksToBounds = true
        imageViewDollarView.layer.cornerRadius = 10
        dollarLabel.layer.shadowColor = UIColor.white.cgColor
        dollarLabel.layer.shadowOpacity = 0.6
        dollarLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        dollarLabel.layer.shadowRadius = 10
        viewPlaceForDollarLabel.layer.masksToBounds = false
        
        dopepointsLabel.textColor = .white
        dopepointsNumberLabel.textColor = .white
    
        buttonClickMiddle.showsTouchWhenHighlighted = true
        topicNextMonth.text = ""
        topicThisMonth.text = ""
        self.navigationController?.navigationBar.isHidden = true
        print(UserDefaults.standard.integer(forKey: "dailyReward"))
        if (self.view.frame.width == 320) {
            aboveSports.constant = 19
            aboveMonth.constant = 22
            dollarW.constant = 35
            viewH.constant = 35
            viewW.constant = 78
            dollarWidth.constant = 70
            dollarLabel.font = dollarLabel.font.withSize(25)
            labelAboutWinning.font = labelAboutWinning.font.withSize(13)
          clickToLearnMorePrizePool.titleLabel?.font =  UIFont(name: "HelveticaNeue", size: 13)
            //clickToLearnMorePrizePool.isHidden = true
            //
            topicThisMonth.font = topicThisMonth.font.withSize(18)
            topicNextMonth.font = topicNextMonth.font.withSize(18)
            nextMonthLabel.font = nextMonthLabel.font.withSize(13)
            thisMonthLabel.font = thisMonthLabel.font.withSize(13)
            currentThemesLabel.font.withSize(13)
        
            //
            imageViewDollarView.frame = CGRect(x: 98, y: 9, width: 90, height: 43)
            dollarLabel.frame = CGRect(x: 4, y: 0, width: 82, height: 43)
            
        } else if (self.view.frame.width == 375) {
            dollarLabel.font = dollarLabel.font.withSize(27)
           labelAboutWinning.font = labelAboutWinning.font.withSize(15)
           clickToLearnMorePrizePool.titleLabel?.font =  UIFont(name: "HelveticaNeue", size: 15)
            topicThisMonth.font = topicThisMonth.font.withSize(18)
                                            topicNextMonth.font = topicNextMonth.font.withSize(18)
                                            nextMonthLabel.font = nextMonthLabel.font.withSize(16)
                                            thisMonthLabel.font = thisMonthLabel.font.withSize(16)
                                           currentThemesLabel.font = currentThemesLabel.font.withSize(16)
            constraintBetweenNextMonthAndTopic.constant = 35
            constraintBetweenThisMonthAndTopic.constant = 35
        }
        else if (self.view.frame.height == 896){
           print("ran")
                                 dollarLabel.font = dollarLabel.font.withSize(27)
                                 labelAboutWinning.font = labelAboutWinning.font.withSize(18)
                                 clickToLearnMorePrizePool.titleLabel?.font =  UIFont(name: "HelveticaNeue", size: 18)
                                 topicThisMonth.font = topicThisMonth.font.withSize(25)
                                 topicNextMonth.font = topicNextMonth.font.withSize(25)
                                 nextMonthLabel.font = nextMonthLabel.font.withSize(20)
                                 thisMonthLabel.font = thisMonthLabel.font.withSize(20)
                                currentThemesLabel.font = currentThemesLabel.font.withSize(19)
        }
        
        
        
        let height: CGFloat = 0.3668 * self.view.frame.size.height
       
               let demoView = DemoView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.size.width,
                                                     height: height))
               
        self.view.insertSubview(demoView, at:0)
        
        
        viewPrizePool.layer.cornerRadius = 10
        upcomingThemes.layer.cornerRadius = 10
        viewPlaceholder.layer.zPosition = 1
        viewPlaceholder.backgroundColor = .none
        dopepointsNumberLabel.layer.zPosition = 2
        dopepointsLabel.layer.zPosition = 2
        //demoView.backgroundColor = .white
        //print(Auth.auth().currentUser?.uid)
       if #available(iOS 11.0, *) {
                  layoutGuide = view.safeAreaLayoutGuide
              } else {
                  // Fallback on earlier versions
                  layoutGuide = view.layoutMarginsGuide
              }
        seeNewPostsButton = NoConnectionHeader()
        view.addSubview(seeNewPostsButton)
        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        seeNewPostsButton.isHidden = true;
       
       if Auth.auth().currentUser?.uid == nil {
        print("whent through")
                    let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "vcs") as! UINavigationController 
                    resultViewController.modalPresentationStyle = .fullScreen
                    self.show(resultViewController, sender:nil)
       }else {
         getDaysLeft()
         getData()
        }
        
        
        
        print(isLoggedIn())
        //print(Auth.auth().currentUser?.uid)
        self.tabBarController?.tabBar.layer.isHidden = false
        print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        self.dailyRewardOutlet.isEnabled = false
        
        
       
        
        }
    
    
    
    
    
    
    
    
    
    
    @IBAction func buttonInsidePoolLarge(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "fromHomeScreen")
        let resultViewController = storyboard?.instantiateViewController(withIdentifier: "HTWViewController") as! HTWViewController
        resultViewController.modalPresentationStyle = .fullScreen
        self.show(resultViewController, sender:nil)
    }
    
    let monitor = NWPathMonitor()
    override func viewWillAppear(_ animated: Bool) {
        seeNewPostsButton.isHidden = true
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
                 if path.status == .satisfied {
                     print("We're connected!")
                    UserDefaults.standard.set(false, forKey: "nowifi")
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = true
                    }
                 } else {
                     print("No connection.")
                    UserDefaults.standard.set(true, forKey: "nowifi")
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = false
                    }
                  
                 }

                 print(path.isExpensive)
             }
       getData()
        
        
        getDaysLeft()
    }
    override func viewDidDisappear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    fileprivate func isLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
        
    }
    
   func getData() {
           let db = Firestore.firestore()
           let uid = Auth.auth().currentUser?.uid ?? "l"
           db.collection("blog").document("question").getDocument { (document,error) in
               
                      if error != nil{
                          print("cant get data")
                          
                      }
                      if document != nil && document!.exists{
                       
                      if let documentdata = document?.data() {
                      self.documentdata = documentdata
                   
                        self.questionBlogWord = self.documentdata["question"] as! String
                        self.thisMonth = self.documentdata["thisMonth"] as! String
                        print(self.thisMonth)
                        self.nextMonth = self.documentdata["nextMonth"] as! String
                        
                        self.topicThisMonth.text = "\(self.thisMonth)"
                        self.popupText = self.documentdata["popupText"] as! String
                        self.shouldRunPopUp = self.documentdata["shoudlRunPopup"] as! Bool
                        self.topicNextMonth.text = "\(self.nextMonth)"
                        if self.shouldRunPopUp == true{
                        self.runPopup()
                        }
                       }
                       }
              
           }
        db.collection("users").document(uid).getDocument { (document,error) in
    
           if error != nil{
               print("cant get data")
               
           }
           if document != nil && document!.exists{
            
           if let documentdata = document?.data() {
            self.dopepointsNumberLabel.text = String(documentdata["points"] as! Int)
            self.dailyRewardOutlet.isEnabled = true
            self.invNumber = documentdata["indexNumber"] as! Int
            }
            }
    }
   
    }
    func runPopup(){
        //UserDefaults.Bool
        //self.popupText = ""
        if UserDefaults.standard.bool(forKey: "runPopUp") == true{
                performSegue(withIdentifier: "PopUp", sender: self)
                UserDefaults.standard.set(false, forKey: "runPopUp")
    }
    }
    func getDaysLeft(){
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        //let MonthNumber = dateFormatter.string(from: now)
        //guard let MonthNumberInt = Int(MonthNumber) else {return}
        let day = DateFormatter()
       // day.dateFormat = "d"
        //let dayNow = day.string(from: now)
       // guard let dayNowInt = Int(dayNow) else { return }
       // let DaysLeft:Int = self.totalDaysInMonth[MonthNumberInt-1] - dayNowInt
      
        //current month
        day.dateFormat = "M"
        let monthNow = day.string(from: now)
        guard let monthNowInt = Int(monthNow) else { return }
        let monthNowP:String = self.monthNames[monthNowInt-1]
        //next month
        print(monthNowInt)
        print("monthNowInt")
        if monthNowInt == 12{
            //if month is december, go back to january
            self.thisMonthLabel.text = "\(monthNowP)"
            self.nextMonthLabel.text = "January"
        }else{
            let monthNextP:String = self.monthNames[monthNowInt]
            self.thisMonthLabel.text = "\(monthNowP)"
            self.nextMonthLabel.text = "\(monthNextP)"
        }
       
        //checking if you can get daily reward again
        day.dateFormat = "Mdy"
        let stringdayNowForRewarded = day.string(from: now)
        print(stringdayNowForRewarded)
        self.dayNowForRewarded = Int(stringdayNowForRewarded) ?? 00
        print("now have data")
        print(dayNowForRewarded)
    
        checkDailySetup()
    }
    @IBAction func clickHereToLearnMoreButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "fromHomeScreen")
        let resultViewController = storyboard?.instantiateViewController(withIdentifier: "HTWViewController") as! HTWViewController
        resultViewController.modalPresentationStyle = .fullScreen
        self.show(resultViewController, sender:nil)
        
    }
    @IBAction func dailyReward(_ sender: Any) {
        let hi = checkDaily()
        if hi == 1{
        //dailyRewardOutlet.setTitleColor(.gray, for: .normal)
        let uid = Auth.auth().currentUser?.uid
           let db = Firestore.firestore()
        guard let newT1 = self.dopepointsNumberLabel.text else { return }
        let newTotal1 = Int(newT1)!
           db.collection("users").document(uid!).updateData([
            "points": newTotal1 + 5,
           ]) { err in
               if let err = err {
                   print("Error updating document: \(err)")
               } else {
                   print("Document successfully updated")
               }
           }
            let index = String(self.invNumber)
        guard let newT = self.dopepointsNumberLabel.text else { return }
        let newTotal = Int(newT)!
        db.collection("leaderboard").document(index).setData([
         "points": newTotal + 5,
         "uid": uid!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    }
    func checkDaily() -> Int{
        if (self.dayNowForRewarded != UserDefaults.standard.integer(forKey: "dailyReward")){
            UserDefaults.standard.set(dayNowForRewarded, forKey: "dailyReward")
            print("it ran through getDayNowForRewarded")
            dailyRewardOutlet.isEnabled = false
            self.index = 0
            self.clock = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.addFive), userInfo: nil, repeats: true)
            return 1
            
        }
        return 0
    }
    func checkDailySetup(){
        if (self.dayNowForRewarded != UserDefaults.standard.integer(forKey: "dailyReward")){
            dailyRewardOutlet.setTitleColor(.white, for: .normal)
            print("ran through check daily white")
        }else{
            dailyRewardOutlet.isEnabled = false
            dailyRewardOutlet.setTitleColor(.gray, for: .normal)
            print("ran through check daily gray")
        }
    }
    @objc func addFive(){
        
        guard var number = Int(self.dopepointsNumberLabel.text ?? "") else { return  }
        number += 1
        self.dopepointsNumberLabel.text = String(number)
        self.index += 1
        if self.index == 5{
                clock.invalidate()
            dailyRewardOutlet.setTitleColor(.gray, for: .normal)
            }
    }
    
    // UserDefaults.standard.bool(forKey: "isloggedIn") == true
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PopUp"){
            let vc = segue.destination as! PopUpViewController
            print("ran through prepare")
            print(popupText)
            vc.PopUpTextFinal = self.popupText
        }
      
        
           // if(segue.identifier == "segue"){
              //     print("ran through segue")
               //     let displayVC = segue.destination as! BlogViewController
              //      displayVC.questions = self.questionBlogWord
           // }
        }
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    


