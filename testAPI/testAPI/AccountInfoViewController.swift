//
//  AccountInfoViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/14/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class AccountInfoViewController: UIViewController {

  
var email = ""
    @IBOutlet weak var line: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        //self.navigationController?.navigationBar.isHidden = true
        getEmail()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.line.constant = 211
        UIView.animate(withDuration: 0.75, animations: {
            self.view.layoutIfNeeded()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func getEmail(){
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    db.collection("users").document(uid!).getDocument { (document,error) in
        
               if error != nil{
                   print("cant get data")
                   
               }
               if document != nil && document!.exists{
                
               if let documentdata = document?.data() {
                
              self.email = documentdata["email"] as! String
                self.emailLabel.text = "Email: \(self.email)"
                }
        }
        }
    }

    @IBOutlet weak var emailLabel: UILabel!
    @IBAction func resetPassword(_ sender: Any) {
      
                 let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "reset") as! ResetPasswordViewController
                 resultViewController.modalPresentationStyle = .fullScreen
                 self.show(resultViewController, sender:nil)
           
             

                // show the alert
            
        
        
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
