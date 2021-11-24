//
//  WritePostViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/5/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore
protocol  NewPostVCDelegate {
    func didUploadPost(withID id:String)
}

class WritePostViewController: UIViewController,UITextViewDelegate {
    var documentdata:[String:Any] = ["":""]
    var questionBlogWord = ""
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    var name = ""
    var delegate:NewPostVCDelegate?
    var dateReloadedEligible = ""
    var realServerDate = ""
    var realServerDates = ""
    var val1 = ""
    var val2 = ""
    var val3 = ""
    var val4 = ""
    var val5 = ""
    var val6 = ""
    var val7 = ""
    var val8 = ""

  func getTimeFromServer(completionHandler:@escaping (_ getResDate: String) -> Void){
        if (UserDefaults.standard.bool(forKey: "nowifi") == false){
        let url = URL(string: "https://www.apple.com")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if let contentType = httpResponse!.allHeaderFields["Date"] as? String {
                //print(httpResponse)
                let dFormatter = DateFormatter()
                dFormatter.timeZone = NSTimeZone(abbreviation: "EST") as TimeZone?
                dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                let serverTime = dFormatter.date(from: contentType)
                dFormatter.dateFormat = "My"
                let myStringafd = dFormatter.string(from: serverTime!)
                completionHandler(myStringafd)
            
                
            }
        }
        task.resume()
    }
    }
    func getTimeFromServer2(completionHandler:@escaping (_ getResDate: String) -> Void){
           if (UserDefaults.standard.bool(forKey: "nowifi") == false){
           let url = URL(string: "https://www.apple.com")
           let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
               let httpResponse = response as? HTTPURLResponse
               if let contentType = httpResponse!.allHeaderFields["Date"] as? String {
                   //print(httpResponse)
                   let dFormatter = DateFormatter()
                   dFormatter.timeZone = NSTimeZone(abbreviation: "EST") as TimeZone?
                   dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                   let serverTime = dFormatter.date(from: contentType)
                   dFormatter.dateFormat = "d"
                   let myStringafd = dFormatter.string(from: serverTime!)
                   completionHandler(myStringafd)
                   
                   
               }
           }
           task.resume()
       }
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
       
        
        postTextView.text = "Respond Here"
        postTextView.textColor = .lightGray
        getData()
                postTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.text == ("Respond Here"){
            postTextView.text = ""
            postTextView.textColor = UIColor.white
            
        }
 
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTimeFromServer { (serverDate) in
            self.realServerDate = serverDate
        }
        self.getTimeFromServer2 { (serverDate) in
            self.realServerDates = serverDate
        }
        
        getName()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            postTextView.resignFirstResponder()
        }
        return true
    }
   
    func getData() {
            let db = Firestore.firestore()
     
            db.collection("blog").document("question").getDocument { (document,error) in
                
                       if error != nil{
                           print("cant get data")
                           
                       }
                       if document != nil && document!.exists{
                        
                       if let documentdata = document?.data() {
                       self.documentdata = documentdata
                    
                         self.questionBlogWord = self.documentdata["question"] as! String
                        self.labelQuestion.text =  self.questionBlogWord
                         
                        }
                        
                       
                        
                        
                        
    }
               
            }
             
     }
    @IBAction func postButton(_ sender: Any) {
        print(UserDefaults.standard.bool(forKey: "Finshed"))
        print("USER DEFAULT")
       
       
        let uid = Auth.auth().currentUser?.uid ?? "l"
        
        
         if (realServerDates == "1" || realServerDates == "2"  || realServerDates == "3" ||
             realServerDates == "4" || realServerDates == "5" || realServerDates == "6" ||
             realServerDates == "7"){
             val1 = "1"+realServerDate
             val2 = "2"+realServerDate
             val3 = "3"+realServerDate
             val4 = "4"+realServerDate
             val5 = "5"+realServerDate
             val6 = "6"+realServerDate
             val7 = "7"+realServerDate
         
         }else if (realServerDates == "8" || realServerDates == "9"  || realServerDates == "10" ||
             realServerDates == "11" || realServerDates == "12" || realServerDates == "13" ||
             realServerDates == "14" || realServerDates == "15"){
             val1 = "8"+realServerDate
             val2 = "9"+realServerDate
             val3 = "10"+realServerDate
             val4 = "11"+realServerDate
             val5 = "12"+realServerDate
             val6 = "13"+realServerDate
             val7 = "14"+realServerDate
             val8 = "15"+realServerDate
         
         }
         else if (realServerDates == "16"  || realServerDates == "17" ||
             realServerDates == "18" || realServerDates == "19" || realServerDates == "20" ||
             realServerDates == "21" || realServerDates == "22" || realServerDates == "23"){
             val1 = "16"+realServerDate
             val2 = "17"+realServerDate
             val3 = "18"+realServerDate
             val4 = "19"+realServerDate
             val5 = "20"+realServerDate
             val6 = "21"+realServerDate
             val7 = "22"+realServerDate
             val8 = "23"+realServerDate
             
         
         }
         else if (realServerDates == "24" ||
                    realServerDates == "25" || realServerDates == "26" || realServerDates == "27" ||
                    realServerDates == "28" || realServerDates == "29" || realServerDates == "30" || realServerDates == "31"){
                    val1 = "24"+realServerDate
                    val2 = "25"+realServerDate
                    val3 = "26"+realServerDate
                    val4 = "27"+realServerDate
                    val5 = "28"+realServerDate
                    val6 = "29"+realServerDate
                    val7 = "30"+realServerDate
                    val8 = "31"+realServerDate
                
                }
         print("dateReloadedEligible")
                   print(dateReloadedEligible)
                   print("realServerDate")
                   print(realServerDate)
                   print("realServerDates")
                   print(realServerDates)
                   print("val3")
                   print(val3)
         if (dateReloadedEligible == val1 || dateReloadedEligible == val2 || dateReloadedEligible == val3 || dateReloadedEligible == val4 || dateReloadedEligible == val5 || dateReloadedEligible == val6 || dateReloadedEligible == val7 || dateReloadedEligible == val8){

            let alert = UIAlertController(title: "Ineligible", message: "You have already posted this week. You must wait for next week.", preferredStyle: UIAlertController.Style.alert)
            
                   // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler:{ action in
                }))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
            
            
        }else{
        let alert = UIAlertController(title: "Are You Sure?", message: "Make sure you check over all gramatic errors and you have answered the prompt completely as you wont be able to edit once you click post and you wont be able to post again.", preferredStyle: UIAlertController.Style.alert)
                // add the actions (buttons)
            
               print("ran here")
                
            
          
            alert.addAction(UIAlertAction(title: "Post", style: UIAlertAction.Style.default, handler: {
                action in
                let postRef = Database.database().reference().child("posts").childByAutoId()
                
                
                if (self.postTextView.text.isEmpty == true || self.postTextView.text == "Respond Here"){
                    print("No Text In Text View")
                    
                    
                }else{
                    
                    UserDefaults.standard.set(true, forKey: "Ineligible")
                    UserDefaults.standard.set(true, forKey: "Finshed")
                    let postObject = [
                        "author":[
                            "uid":Auth.auth().currentUser?.uid as Any,
                            "name":self.name,
                            "points":0
                            //"childID"
                                  ],
                              "text": self.postTextView.text as Any,
                              "timestamp": [".sv":"timestamp"]
                          ] as [String:Any]
                          postRef.setValue(postObject, withCompletionBlock: { error, ref in
                      if error == nil{
                        Firestore.firestore().collection("users").document(uid).setData(["resetBlogEligible":self.realServerDates + self.realServerDate], merge: true)
                          self.delegate?.didUploadPost(withID: ref.key!)
                          self.dismiss(animated: true, completion: nil)
                      }
                      else{
                          //handle error
                      }
                  })
                   
            }
        
            }))
            
        //}else{
        //    self.dismiss(animated: true, completion: nil)
       // }
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{ action in
            }))

               // show the alert
               self.present(alert, animated: true, completion: nil)
        }
        }
       
    

    func getName() {
               let db = Firestore.firestore()
               let uid = Auth.auth().currentUser?.uid
               db.collection("users").document(uid!).getDocument { (document,error) in
                   
                          if error != nil{
                              print("cant get data")
                              
                          }
                          if document != nil && document!.exists{
                           
                          if let documentdata = document?.data() {
                            self.dateReloadedEligible = documentdata["resetBlogEligible"] as! String
                           let firstName = documentdata["firstName"] as! String
                           let LastName = documentdata["lastName"] as! String
                           self.name  = "\(firstName) \(LastName)"
                            
                           }
                     
       }
                  
               }
                
               }
    @IBAction func backButton(_ sender: Any) {
           if (postTextView.text != "Respond Here" || postTextView.text != ""){
        let alert = UIAlertController(title: "All Your Progress With Be Lost", message: "", preferredStyle: UIAlertController.Style.alert)
               
                      // add the actions (buttons)
               alert.addAction(UIAlertAction(title: "Discard", style: UIAlertAction.Style.default, handler: {
                       action in
                     self.dismiss(animated: true, completion: nil)
                     
                       
                   }))
                   alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{ action in
                   }))

                      // show the alert
                      self.present(alert, animated: true, completion: nil)
    
    }else{
        self.dismiss(animated: true, completion: nil)
    }
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
extension UIView {
func addTopBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
    self.layer.addSublayer(border)
}
}
