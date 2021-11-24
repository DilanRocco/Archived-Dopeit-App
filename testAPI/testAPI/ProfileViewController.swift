//
//  ProfileViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/30/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth
import Network
class ProfileViewController: UIViewController {
   
    @IBOutlet weak var dopepointsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var medal1: UIButton!
    @IBOutlet weak var medal2: UIButton!
    @IBOutlet weak var medal3: UIButton!
    @IBOutlet weak var medal4: UIButton!
    @IBOutlet weak var medal5: UIButton!
    @IBOutlet weak var medal6: UIButton!
    @IBOutlet weak var medal7: UIButton!
    @IBOutlet weak var medal8: UIButton!
    @IBOutlet weak var medal9: UIButton!
    @IBOutlet weak var daysLeft: UILabel!
    var documentdata:[String:Any] = ["":""]
    var yellowColors = UIColor(red: 231.0/255.0, green: 197.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    var blackColors = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var awards:[String] = ["dfs","dfg"]
    let totalDaysInMonth = [31,29,31,30,31,30,31,31,30,31,30,31]
    var monthsPlayed = 0
    let longTitleLabel = UILabel()
    var email = ""
    lazy var popUpWindow: PopupWindow = {
        let view = PopupWindow()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var seeNewPostsButton:NoConnectionHeader!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
     var layoutGuide:UILayoutGuide!

    
    
    @IBOutlet weak var crownsLabel: UILabel!
    @IBOutlet weak var viewUnderCrowns: UIView!
    @IBOutlet weak var quoteLabel: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        if (self.view.frame.width == 320) {
            nameLabel.font = nameLabel.font.withSize(26)
            
            quoteLabel.font = quoteLabel.font.withSize(15)
            
            crownsLabel.font = crownsLabel.font.withSize(22)
        }
        getDaysLeft()
        medal2.setImage(UIImage(named: "Image"), for: .normal)
        medal3.setImage(UIImage(named: "Image"), for: .normal)
        medal4.setImage(UIImage(named: "Image"), for: .normal)
        medal5.setImage(UIImage(named: "Image"), for: .normal)
        medal6.setImage(UIImage(named: "Image"), for: .normal)
        medal7.setImage(UIImage(named: "Image"), for: .normal)
        medal8.setImage(UIImage(named: "Image"), for: .normal)
        medal9.setImage(UIImage(named: "Image"), for: .normal)
        medal2.imageView?.tintColor = .gray
        medal3.imageView?.tintColor = .gray
        medal4.imageView?.tintColor = .gray
        medal5.imageView?.tintColor = .gray
        medal6.imageView?.tintColor = .gray
        medal7.imageView?.tintColor = .gray
        medal8.imageView?.tintColor = .gray
        medal9.imageView?.tintColor = .gray
        viewUnderCrowns.layer.borderColor = blackColors.cgColor
        viewUnderCrowns.layer.borderWidth = 4
        viewUnderCrowns.layer.cornerRadius = 5
       
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
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 0)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        seeNewPostsButton.isHidden = true;
        getData()
        getData2()
        
        
        longTitleLabel.text = "Profile"
        //longTitleLabel.font = ................
        longTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 31)
        

        longTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        if let navigationBar = self.navigationController?.navigationBar {
           navigationBar.addSubview(longTitleLabel)
           navigationBar.shadowImage = UIImage()
           navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           navigationBar.isTranslucent = true
           longTitleLabel.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 22).isActive = true
           longTitleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
           longTitleLabel.heightAnchor.constraint(equalTo: navigationBar.heightAnchor, constant: 5).isActive = true
        }
        
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.alpha = 0
        }
      let monitor = NWPathMonitor()
    override func viewWillAppear(_ animated: Bool) {
        seeNewPostsButton.isHidden = true
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
                 if path.status == .satisfied {
                     print("We're connected!")
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = true
                    }
                 } else {
                     print("No connection.")
                
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = false
                    }
                  
                 }

                 print(path.isExpensive)
             }
    }
    func getData2(){
        let db = Firestore.firestore()
                                 let uid = Auth.auth().currentUser?.uid
                                 db.collection("blog").document("question").getDocument { (document,error) in
                                     
                                            if error != nil{
                                                print("cant get data")
                                                
                                            }
                                            if document != nil && document!.exists{
                                             
                                            if let documentdata = document?.data() {
                                            self.documentdata = documentdata
                                             
                                               self.quoteLabel.text = documentdata["quoteOfMonth"] as? String
                                               }
                                   }
                           }
    }
    func getData() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).getDocument { (document,error) in
            
                   if error != nil{
                       print("cant get data")
                       
                   }
                   if document != nil && document!.exists{
                    
                   if let documentdata = document?.data() {
                   self.documentdata = documentdata
                    
                 
                    let firstName = documentdata["firstName"] as! String
                    let LastName = documentdata["lastName"] as! String
                    self.awards = documentdata["medals"] as! [String]
                    let hi = documentdata["points"] as! Int
                    
                    self.monthsPlayed = documentdata["monthsPlayed"] as! Int
                    
                    
                    
                   
                    if UserDefaults.standard.bool(forKey: "medal2") == false{
                        if (hi > 100){
                            
                            db.collection("users").document(uid!).updateData([
                                "medals":FieldValue.arrayUnion(["100points"])
                                
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                    UserDefaults.standard.set(true, forKey: "medal2")
                                }
                            }
                            }
                        }
                    if UserDefaults.standard.bool(forKey: "medal3") == false{
                    if (hi > 1000){
                        
                        db.collection("users").document(uid!).updateData([
                            "medals":FieldValue.arrayUnion(["1000points"])
                            
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                                UserDefaults.standard.set(true, forKey: "medal3")
                            }
                        }
                        }
                    }
                    if UserDefaults.standard.bool(forKey: "medal5") == false{
                        if (self.monthsPlayed >= 4){
                        
                        db.collection("users").document(uid!).updateData([
                            "medals":FieldValue.arrayUnion(["4month"])
                            
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                                UserDefaults.standard.set(true, forKey: "medal5")
                            }
                        }
                        }
                    }
                    if UserDefaults.standard.bool(forKey: "medal7") == false{
                        if (self.monthsPlayed >= 4){
                        
                        db.collection("users").document(uid!).updateData([
                            "medals":FieldValue.arrayUnion(["6month"])
                            
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                                UserDefaults.standard.set(true, forKey: "medal7")
                            }
                        }
                        }
                    }
                
                    self.nameLabel.text = "\(firstName) \(LastName)"
                    }
                    for x in self.awards{
                        if x == "signup"{
                           // medal
                            self.medal1.setImage(UIImage(named: "crown2xYellow"), for: .normal)
                           
                        }else if x == "100points"{
                            self.medal2.setImage(UIImage(named: "100Points2x"), for: .normal)
                        }else if x == "1000points"{
                            self.medal3.setImage(UIImage(named: "Crown10002X"), for: .normal)
                        }else if x == "win"{
                            self.medal4.setImage(UIImage(named: "crownsWin2xpng"), for: .normal)
                        }else if x == "4month"{
                            self.medal5.setImage(UIImage(named: "tryHard2x"), for: .normal)
                        }else if x == "100blog"{
                            self.medal6.setImage(UIImage(named: "orator2x"), for: .normal)
                        }else if x == "6month"{
                            self.medal7.setImage(UIImage(named: "pro2x"), for: .normal)
                        }else if x == "10multiple"{
                            self.medal8.setImage(UIImage(named: "genius2x"), for: .normal)
                        }else if x == "15true"{
                            self.medal9.setImage(UIImage(named: "intellect2x"), for: .normal)
                        }
                    }
                    }
                    
                   
                    
                    
                    //self.dopePoints.text = documentdata["points"] as? String
              
}
           
        }
        
        
    func getDaysLeft(){
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let MonthNumber = dateFormatter.string(from: now)
        guard let MonthNumberInt = Int(MonthNumber) else {return}
        let day = DateFormatter()
        day.dateFormat = "d"
        let dayNow = day.string(from: now)
        guard let dayNowInt = Int(dayNow) else { return }
        let DaysLeft:Int = self.totalDaysInMonth[MonthNumberInt-1] - dayNowInt
        //self.daysLeft.text = "Days Left this season: \(DaysLeft)"
       }
    
    @IBAction func medalOneButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 1
        }
    
    @IBAction func medalTwoButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 2
    }
    @IBAction func medalThreeButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 3
    }
    @IBAction func medalFourButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 4
    }
    @IBAction func medalFiveButton(_ sender: Any) {
       viewForButtons()
       self.popUpWindow.shouldShowSuccess = 5
        
    }
    @IBAction func medalSixButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 6
    }
    @IBAction func medalSevenButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 7
    }
    @IBAction func medalEightButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 8
    }
    @IBAction func medalNineButton(_ sender: Any) {
        viewForButtons()
        self.popUpWindow.shouldShowSuccess = 9
    }
    func viewForButtons(){
        view.addSubview(popUpWindow)
        popUpWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        popUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        popUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpWindow.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.popUpWindow.alpha = 1
            self.popUpWindow.transform = CGAffineTransform.identity
            
        }
    }
    
    @IBAction func helpButton(_ sender: Any) {
       viewForButtons()
        self.popUpWindow.shouldShowSuccess = 10
    }
    override func viewDidAppear(_ animated: Bool) {
        self.longTitleLabel.text = "Profile"
        let height: CGFloat = 25
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
}

extension ProfileViewController:PopUpDelegate{
    func handleDismissal() {
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpWindow.removeFromSuperview()
            print("it worked and removed popup")
            
        }
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        self.longTitleLabel.text = ""
        // Pass the selected object to the new view controller.
    }
    
}


