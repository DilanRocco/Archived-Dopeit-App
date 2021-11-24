//
//  LeaderBoardViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/16/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
class LeaderBoardViewController: UIViewController {
    struct Person{
        var placePoints:Int
        var placeNames:String
    }
    var firstPlace = Person(placePoints:2,placeNames:" ")
    var secondPlace = Person(placePoints:1,placeNames:" ")
    var thirdPlace = Person(placePoints:1,placeNames:"")
    var fourthPlace = Person(placePoints:1,placeNames:"")
    var fifthPlace = Person(placePoints:1,placeNames:"")
    var check = 0
    var uid = ""
    var uniqueNumber:Int?
    var documentdata:[String:Any]? = ["":""]
    var indexString = ""
    var x = 0
    var fullName1 = ""
    var fullName2 = ""
    var fullName3 = ""
    var fullName4 = ""
    var fullName5 = ""
    var counnt = 0
    var monthofLastMonthWinner = ""
    @IBOutlet weak var firstPlaceLabel: UILabel!
    
    @IBOutlet weak var secondPlaceLabel: UILabel!
    
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    
    @IBOutlet weak var reloadLabel: UILabel!
    
    @IBOutlet weak var firstPlacePointsLabel: UILabel!
    
    @IBOutlet weak var secondPlacePointsLabel: UILabel!
    
    @IBOutlet weak var thirdPlacePointsLabel: UILabel!
    
    @IBOutlet weak var fourthPlacePointsLabel: UILabel!
    
    @IBOutlet weak var fourthPlaceLabel: UILabel!
    
    @IBOutlet weak var fifthPlaceLabel: UILabel!
    
    @IBOutlet weak var fifthPlacePointsLabel: UILabel!
    
    @IBOutlet weak var pointsWinner: UILabel!
    var colorBlue = UIColor(red: 6/255, green: 98/255, blue: 156/255, alpha: 1.0).cgColor
    @IBOutlet weak var ViewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var viewFive: UIView!
    
    @IBOutlet weak var winnerLastMonthLabel: UILabel!
    let totalDaysInMonth = [31,29,31,30,31,30,31,31,30,31,30,31]
    let monthNames = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    @IBOutlet weak var trophyVerticalCon: NSLayoutConstraint!
    var clock = Timer()
    var counter = 2
    var winnerLastMonth = ""
    var clocks = Timer()
    var counters = 1
    
    let monitor = NWPathMonitor()
    override func viewDidAppear(_ animated: Bool) {
        firstPlace = Person(placePoints:2,placeNames:" ")
         secondPlace = Person(placePoints:1,placeNames:" ")
         thirdPlace = Person(placePoints:1,placeNames:"")
         fourthPlace = Person(placePoints:1,placeNames:"")
        fifthPlace = Person(placePoints:1,placeNames:"")
        counnt = 0
        counter = 2
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
        createLeaderboard()
        getMinutesLeft()
        getTheDate()
    }
     var layoutGuide:UILayoutGuide!
  
    
    var seeNewPostsButton:NoConnectionHeader!
       var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.isHidden = true
        setViewsUp()
      
       
     
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
//
        seeNewPostsButton = NoConnectionHeader()
               view.addSubview(seeNewPostsButton)
               seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
               seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
               seeNewPostsButtonTopAnchor.isActive = true
               seeNewPostsButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        seeNewPostsButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setViewsUp(){
        //ViewOne.backgroundColor = .blue
        
       //ViewOne.layer.addSublayer(bottomLine)
        if (self.view.frame.height == 736) {
          
            trophyVerticalCon.constant = -27.83
        }
        if (self.view.frame.height == 667) {
          
            trophyVerticalCon.constant = -24.75
        }
        if (self.view.frame.height == 568) {
            trophyVerticalCon.constant = -16
            winnerAboveLabel.font = winnerAboveLabel.font.withSize(17)
            trophyImage.image = UIImage(named:"trophyse")!
            winnerLastMonthLabel.font = winnerLastMonthLabel.font.withSize(16)
            reloadLabel.font = reloadLabel.font.withSize(14)
            thisSeasonLabel.font = thisSeasonLabel.font.withSize(15)
            pointsWinner.font = pointsWinner.font.withSize(25)
            daysLeft.font = daysLeft.font.withSize(15)
            pointsWinner.font = pointsWinner.font.withSize(16)
            
        }
        
       
    }
    @IBOutlet weak var thisSeasonLabel: UILabel!
    @IBOutlet weak var trophyImage: UIImageView!
    
    
    func getTimeFromServer(completionHandler:@escaping (_ getResDate: String) -> Void){
        if (UserDefaults.standard.bool(forKey: "nowifi") == false){
        let url = URL(string: "https://www.apple.com")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if let contentType = httpResponse!.allHeaderFields["Date"] as? String {
                //print(httpResponse)
                let dFormatter = DateFormatter()
                dFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
                dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                let serverTime = dFormatter.date(from: contentType)
                dFormatter.dateFormat = "HH d M yyyy"
                let myStringafd = dFormatter.string(from: serverTime!)
                completionHandler(myStringafd)
                
            }
        }
        task.resume()
    }
    }
    func createLeaderboard(){
        let db = Firestore.firestore()
        db.collection("users").document("0UniqueNumber").getDocument { (document,error) in
                  
                           if error != nil{
                               print("cant get data")
                               
                           }
                           if document != nil && document!.exists{
                            print("its here")
                           if let documentdata = document?.data() {
                            self.uniqueNumber = documentdata["tally"] as? Int
                            let dateReloaded = documentdata["dateReloaded"] as? String
                            let winner = documentdata["winnerLastMonth"]
                            let pointsTheWinner = documentdata["winnerLastMonthPoints"]
                            self.pointsWinner.text = pointsTheWinner as? String
                            self.winnerLastMonthLabel.text = winner as? String
                           // print(self.uniqueNumber)
                            print("FDSFSF")
                            
                            
                            
                            self.getTimeFromServer { (serverDate) in
                            
                            
                            if (dateReloaded != serverDate){
                             print("ran here")
                                Firestore.firestore().collection("users").document("0UniqueNumber").setData(["dateReloaded":serverDate], merge: true)
                            self.rat()
                            
                            }else{
                            print("rann heree")
                                 DispatchQueue.main.async {
                            self.firstPlaceLabel.text = documentdata["firstPlaceName"] as? String
                            self.firstPlacePointsLabel.text = documentdata["firstPlacePoints"] as? String
                            self.secondPlaceLabel.text = documentdata["secondPlaceName"] as? String
                            self.secondPlacePointsLabel.text = documentdata["secondPlacePoints"] as? String
                            self.thirdPlaceLabel.text = documentdata["thirdPlaceName"] as? String
                            self.thirdPlacePointsLabel.text = documentdata["thirdPlacePoints"] as? String
                                    self.fourthPlaceLabel.text = documentdata["fourthPlaceName"] as? String
                                    self.fourthPlacePointsLabel.text = documentdata["fourthPlacePoints"] as? String
                                    self.fifthPlaceLabel.text = documentdata["fifthPlaceName"] as? String
                                    self.fifthPlacePointsLabel.text = documentdata["fifthPlacePoints"] as? String
                                    print("inside getters")
                                    self.firstPlace.placeNames = documentdata["firstPlaceUID"] as? String ?? ""
                                    self.secondPlace.placeNames = documentdata["secondPlaceUID"] as? String ?? ""
                                    self.thirdPlace.placeNames = documentdata["thirdPlaceUID"] as? String ?? ""
                                    self.fourthPlace.placeNames = documentdata["fourthPlaceUID"] as? String ?? ""
                                    self.fifthPlace.placeNames = documentdata["fifthPlaceUID"] as? String ?? ""
                                    self.checkIfInLeaderboard()
                             
                                }
                                print("outside getters")
                                
                            }
                            }
        }
        }
    }
    }
        func rat(){
    let db = Firestore.firestore()
                db.collection("leaderboard").getDocuments()
                    {(querySnapshot,err) in
                        if let err = err{
                            print("The error was \(err)")
                        }
                    else
                        {
                            var count = 0
                            for document in querySnapshot!.documents {
                                count += 1
                               // print("\(document.documentID) => \(document.data())");
                                        self.check = document["points"] as! Int
                                        self.uid = document["uid"] as! String
                                        //print(self.uid)
                                           self.x = self.x+1
                                           //print(self.x)
                                        //print("The user's ID was\(self.uid)")
                                        if (self.check > self.firstPlace.placePoints){
                                            self.fifthPlace.placeNames = self.fourthPlace.placeNames
                                            self.fifthPlace.placePoints = self.fourthPlace.placePoints
                                            self.fourthPlace.placeNames = self.thirdPlace.placeNames
                                            self.fourthPlace.placePoints = self.thirdPlace.placePoints
                                            self.thirdPlace.placeNames = self.secondPlace.placeNames
                                            self.thirdPlace.placePoints = self.secondPlace.placePoints
                                            self.secondPlace.placePoints = self.firstPlace.placePoints
                                            self.secondPlace.placeNames = self.firstPlace.placeNames
                                            self.firstPlace.placePoints = self.check
                                            self.firstPlace.placeNames = self.uid
                                            
                                            print("First Place was set to:\(self.firstPlace.placeNames)")
                                        }else if(self.check <= self.firstPlace.placePoints && self.secondPlace.placePoints < self.check){
                                            
                                            self.fifthPlace.placeNames = self.fourthPlace.placeNames
                                            self.fifthPlace.placePoints = self.fourthPlace.placePoints
                                            self.fourthPlace.placeNames = self.thirdPlace.placeNames
                                            self.fourthPlace.placePoints = self.thirdPlace.placePoints
                                            self.thirdPlace.placePoints = self.secondPlace.placePoints
                                            self.thirdPlace.placeNames = self.secondPlace.placeNames
                                            self.secondPlace.placePoints = self.check
                                            self.secondPlace.placeNames = self.uid
                                            print("Second Place was set to:\(self.firstPlace.placeNames)")
                                        }else if(self.check <= self.secondPlace.placePoints && self.thirdPlace.placePoints < self.check){
                                            self.fifthPlace.placeNames = self.fourthPlace.placeNames
                                            self.fifthPlace.placePoints = self.fourthPlace.placePoints
                                            self.fourthPlace.placeNames = self.thirdPlace.placeNames
                                            self.fourthPlace.placePoints = self.thirdPlace.placePoints
                                            self.thirdPlace.placePoints = self.check
                                            self.thirdPlace.placeNames = self.uid
                                            print("Third Place was set to:\(self.firstPlace.placeNames)")
                                        }
                                else if(self.check <= self.thirdPlace.placePoints && self.fourthPlace.placePoints < self.check){
                                            self.fifthPlace.placeNames = self.fourthPlace.placeNames
                                            self.fifthPlace.placePoints = self.fourthPlace.placePoints
                                            self.fourthPlace.placePoints = self.check
                                            self.fourthPlace.placeNames = self.uid
                                        }
                                else if(self.check <= self.fourthPlace.placePoints && self.fifthPlace.placePoints < self.check){
                                    self.fifthPlace.placePoints = self.check
                                    self.fifthPlace.placeNames = self.uid
                                    
                                }
                                print("This is it")
                                print(self.uid)
                                print(self.check)
                                print(self.fourthPlace.placePoints)
                                print(self.fifthPlace.placePoints)
                            }
                                            
                                             print("This is the escape out")
                            self.setGuys()
                            
                            
                            
                                           
                                        
                            print("Count = \(count)");
                                }
                            }

                            
                        }
                 
    
    func setGuys(){
        
        let db = Firestore.firestore()
        print(self.firstPlace.placeNames)
        
        db.collection("users").document(self.firstPlace.placeNames).getDocument { (document,error) in
                
                       if error != nil{
                           print("cant get data")
                           
                       }
                       if document != nil && document!.exists{
                        
                       if let documentdata = document?.data() {
                        let firstName = documentdata["firstName"] as! String
                        let secondName = documentdata["lastName"]  as! String
                        self.fullName1 = "\(firstName) \(secondName)"
                        self.firstPlaceLabel.text = self.fullName1
                        self.firstPlacePointsLabel.text = "\(self.firstPlace.placePoints)"
                        self.counnt+=1
                        }
    }
    }
        print(self.secondPlace.placeNames)
        print("dsfsdfs")
        db.collection("users").document(secondPlace.placeNames).getDocument { (document,error) in
                    
                        if error != nil{
                               print("cant get data")
                               
                           }
                           if document != nil && document!.exists{
                            
                           if let documentdata = document?.data() {
                            let firstName = documentdata["firstName"] as! String
                            let secondName = documentdata["lastName"]  as! String
                            self.fullName2 = "\(firstName) \(secondName)"
                            self.secondPlaceLabel.text = self.fullName2
                            self.secondPlacePointsLabel.text = "\(self.secondPlace.placePoints)"
                            self.counnt+=1
                            }
        }
        }
        print("right before third")
        print(self.thirdPlace.placeNames)
        db.collection("users").document(thirdPlace.placeNames).getDocument { (document,error) in
                
                       if error != nil{
                           print("cant get data")
                           
                       }
                       if document != nil && document!.exists{
                        
                       if let documentdata = document?.data() {
                        let firstName = documentdata["firstName"] as! String
                        let secondName = documentdata["lastName"]  as! String
                        self.fullName3 = "\(firstName) \(secondName)"
                        self.thirdPlaceLabel.text = self.fullName3
                        self.thirdPlacePointsLabel.text = "\(self.thirdPlace.placePoints)"
                        self.counnt+=1
                        
                       
                        }
    }
    }
        db.collection("users").document(fourthPlace.placeNames).getDocument { (document,error) in
                    
                           if error != nil{
                               print("cant get data")
                               
                           }
                           if document != nil && document!.exists{
                            
                           if let documentdata = document?.data() {
                            let firstName = documentdata["firstName"] as! String
                            let secondName = documentdata["lastName"]  as! String
                            self.fullName4 = "\(firstName) \(secondName)"
                            self.fourthPlaceLabel.text = self.fullName4
                            self.fourthPlacePointsLabel.text = "\(self.fourthPlace.placePoints)"
                            self.counnt+=1
                            
                           
                            }
        }
        }
        db.collection("users").document(fifthPlace.placeNames).getDocument { (document,error) in
                    
                           if error != nil{
                               print("cant get data")
                               
                           }
                           if document != nil && document!.exists{
                            
                           if let documentdata = document?.data() {
                            let firstName = documentdata["firstName"] as! String
                            let secondName = documentdata["lastName"]  as! String
                            self.fullName5 = "\(firstName) \(secondName)"
                            self.fifthPlaceLabel.text = self.fullName5
                            self.fifthPlacePointsLabel.text = "\(self.fifthPlace.placePoints)"
                            self.counnt+=1
                            
                           
                            }
        }
        }
        self.clock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.waitToEnable), userInfo: nil, repeats: true)
        
}
    func setFirebase(){
        let thirdPPoints = String(thirdPlace.placePoints)
        let secondPPoints = String(secondPlace.placePoints)
        let firstPPoints = String(firstPlace.placePoints)
        let fourthPPoints = String(fourthPlace.placePoints)
        let fifthPPoints = String(fifthPlace.placePoints)
        let db = Firestore.firestore()
        db.collection("users").document("0UniqueNumber").updateData(["firstPlaceName":self.fullName1,"firstPlacePoints":firstPPoints,"firstPlaceUID":firstPlace.placeNames,"secondPlaceName":self.fullName2,"secondPlacePoints":secondPPoints,"secondPlaceUID":secondPlace.placeNames,"thirdPlaceName":self.fullName3,"thirdPlacePoints":thirdPPoints,"thirdPlaceUID":thirdPlace.placeNames,"fourthPlaceName":self.fullName4,"fourthPlacePoints":fourthPPoints,"fourthPlaceUID":fourthPlace.placeNames,"fifthPlaceName":self.fullName5,"fifthPlacePoints":fifthPPoints,"fifthPlaceUID":fifthPlace.placeNames,])
        print("here is is,the updated")
        print(firstPlace.placeNames)
        print(secondPlace.placeNames)
        print(thirdPlace.placeNames)
        print(fourthPlace.placeNames)
        print(fifthPlace.placeNames)
        checkIfInLeaderboard()
    }
    @objc func waitToEnable(){
        
        self.counter-=1
        if counter == 0{
            setFirebase()
            clock.invalidate()
            
            
           
        }
    }
    @objc func waitToEnableCheckIfLeader(){
        
        self.counters-=1
        if counters == 0{
            clock.invalidate()
            checkIfInLeaderboard()
            
            
            
           
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        clock.invalidate()
    }
    func checkIfInLeaderboard(){
        
        
        let uid = Auth.auth().currentUser?.uid
        print(firstPlace.placeNames)
        if (firstPlace.placeNames == uid){
           ViewOne.backgroundColor = .green
        }
        else if (secondPlace.placeNames == uid){
            viewTwo.backgroundColor = .green
        }
        else if (thirdPlace.placeNames == uid){
            viewThree.backgroundColor = .green
        }
        else if (fourthPlace.placeNames == uid){
            viewFour.backgroundColor = .green
        }
        else if (fifthPlace.placeNames == uid){
            viewFive.backgroundColor = .green
        }
        print("leaderboard")
    }
    func getMinutesLeft(){
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let minuteNumber = dateFormatter.string(from: now)
        guard var hour = Int(minuteNumber) else {return}
        hour += 1
        if (hour > 0 && hour < 12){
        self.reloadLabel.text = "Reloads: \(hour):00 AM"
        }else if(hour == 24){
        self.reloadLabel.text = "Relaods: 12:00 AM"
        }else if(hour > 12 && hour < 24){
           
            hour -= 12
        self.reloadLabel.text = "Reloads: \(hour):00 PM"
        }else if(hour == 12){
        self.reloadLabel.text = "Reloads: \(hour):00 PM"
        }
        else{
        hour = 1
        self.reloadLabel.text = "Reloads: \(hour):00 AM"
            
        }
        print("Reloaded Time")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.selectedIndex = 1
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeViewController {
        self.navigationController?.popToViewController(vc, animated: true)
    }
    }
    func getTheDate(){
    let now = Date()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "M"
     
      
     // let DaysLeft:Int = self.totalDaysInMonth[MonthNumberInt-1] - dayNowInt
    
      //current month
      dateFormatter.dateFormat = "M"
        
        var monthNow = dateFormatter.string(from: now)
 
        guard var MonthNowInt = Int(monthNow) else { return  }
       
        if Int(monthNow) == 1{
            self.monthofLastMonthWinner = "December"
        }else if Int(monthNow) == 2{
            self.monthofLastMonthWinner = "January"
        }else{
      let monthNowP:String = self.monthNames[MonthNowInt-2]
            self.monthofLastMonthWinner = monthNowP
        }
     
      //next month
      //let monthNextP:String = self.monthNames[monthNowInt]
      self.winnerAboveLabel.text = "Winner For The Month Of \(monthofLastMonthWinner)"

        dateFormatter.dateFormat = "M"
        let MonthNumber = dateFormatter.string(from: now)
        guard let MonthNumberInt = Int(MonthNumber) else {return}
        let day = DateFormatter()
        day.dateFormat = "d"
        let dayNow = day.string(from: now)
        guard let dayNowInt = Int(dayNow) else { return }
        let DaysLeft:Int = self.totalDaysInMonth[MonthNumberInt-1] - dayNowInt
        self.daysLeft.text = "Days Left: \(DaysLeft)"
        
    }
    
    @IBOutlet weak var winnerAboveLabel: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    


}
extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
}
