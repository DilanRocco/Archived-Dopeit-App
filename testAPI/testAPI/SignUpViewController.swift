//
//  SignUpViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/29/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase
class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    var ref: DatabaseReference?

    
    var uniqueNumber = 0
    var uniqueNumberNew = 0
    let whiteColor = UIColor(red: 222.0/255.0, green: 226.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    let blueColors = UIColor(red: 26.0/255.0, green: 149.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    var bottomLine1 = CALayer()
    var bottomLine2 = CALayer()
    var bottomLine3 = CALayer()
    var bottomLine4 = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
            setUpElements()
        // self.navigationController?.navigationBar.isHidden = false
        
        ref = Database.database().reference()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        PasswordTextField.delegate = self
        // Do any additional setup after loading the view.
     
        SignUpButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        SignUpButton.layer.cornerRadius = 30
        SignUpButton.layer.borderWidth = 3
        SignUpButton.layer.borderColor = whiteColor.cgColor
        
        bottomLine1.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        bottomLine1.backgroundColor = blueColors.cgColor
        firstNameTextField.borderStyle = UITextField.BorderStyle.none
        firstNameTextField.layer.addSublayer(bottomLine1)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
        attributes: [NSAttributedString.Key.foregroundColor: self.blueColors])
        
        bottomLine2.frame = CGRect(x: 0.0, y: lastNameTextField.frame.height - 1, width: lastNameTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = blueColors.cgColor
        lastNameTextField.borderStyle = UITextField.BorderStyle.none
        lastNameTextField.layer.addSublayer(bottomLine2)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
        attributes: [NSAttributedString.Key.foregroundColor: self.blueColors])
        
        bottomLine3.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1.0)
        bottomLine3.backgroundColor = blueColors.cgColor
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(bottomLine3)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
        attributes: [NSAttributedString.Key.foregroundColor: self.blueColors])
        
        bottomLine4.frame = CGRect(x: 0.0, y: PasswordTextField.frame.height - 1, width: PasswordTextField.frame.width, height: 1.0)
        bottomLine4.backgroundColor = blueColors.cgColor
        PasswordTextField.borderStyle = UITextField.BorderStyle.none
        PasswordTextField.layer.addSublayer(bottomLine4)
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: self.blueColors])
        
        
        
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if firstNameTextField == textField{
        bottomLine1.backgroundColor = whiteColor.cgColor
        self.firstNameTextField.layer.addSublayer(bottomLine1)
        bottomLine1.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 2.0)
        firstNameTextField.placeholder = ""
        firstNameTextField.textColor = whiteColor
        }else if (lastNameTextField == textField){
        bottomLine2.backgroundColor = whiteColor.cgColor
        self.lastNameTextField.layer.addSublayer(bottomLine2)
        bottomLine2.frame = CGRect(x: 0.0, y: lastNameTextField.frame.height - 1, width: lastNameTextField.frame.width, height: 2.0)
        lastNameTextField.placeholder = ""
            lastNameTextField.textColor = whiteColor
        }else if emailTextField == textField{
            bottomLine3.backgroundColor = whiteColor.cgColor
            self.emailTextField.layer.addSublayer(bottomLine3)
            bottomLine3.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 2.0)
            emailTextField.placeholder = ""
                emailTextField.textColor = whiteColor
        }else if PasswordTextField == textField{
            bottomLine4.backgroundColor = whiteColor.cgColor
            self.PasswordTextField.layer.addSublayer(bottomLine4)
            bottomLine4.frame = CGRect(x: 0.0, y: PasswordTextField.frame.height - 1, width: PasswordTextField.frame.width, height: 2.0)
            PasswordTextField.placeholder = ""
                PasswordTextField.textColor = whiteColor
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        bottomLine1.backgroundColor = blueColors.cgColor
        self.firstNameTextField.layer.addSublayer(bottomLine1)
        bottomLine1.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        firstNameTextField.placeholder = "Email Address"
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
        attributes: [NSAttributedString.Key.foregroundColor: blueColors])
        firstNameTextField.textColor = blueColors
        
        bottomLine2.backgroundColor = blueColors.cgColor
        self.lastNameTextField.layer.addSublayer(bottomLine2)
        bottomLine2.frame = CGRect(x: 0.0, y: lastNameTextField.frame.height - 1, width: lastNameTextField.frame.width, height: 1.0)
       lastNameTextField.placeholder = "Password"
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
        attributes: [NSAttributedString.Key.foregroundColor: blueColors])
        lastNameTextField.textColor = blueColors
        
        bottomLine3.backgroundColor = blueColors.cgColor
         self.emailTextField.layer.addSublayer(bottomLine3)
         bottomLine3.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1.0)
       emailTextField.placeholder = "Password"
         emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
         attributes: [NSAttributedString.Key.foregroundColor: blueColors])
         emailTextField.textColor = blueColors
        
        bottomLine4.backgroundColor = blueColors.cgColor
          self.PasswordTextField.layer.addSublayer(bottomLine4)
          bottomLine4.frame = CGRect(x: 0.0, y: PasswordTextField.frame.height - 1, width: PasswordTextField.frame.width, height: 1.0)
        PasswordTextField.placeholder = "Password"
          PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
          attributes: [NSAttributedString.Key.foregroundColor: blueColors])
          PasswordTextField.textColor = blueColors
    }
    func setUpElements(){
        
        //Hide the error Label
        errorLabel.alpha = 0;
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        addBackButton()
    }
   
    var layoutGuide:UILayoutGuide!
    func addBackButton() {
       
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        let backButton = UIButton(type: .custom)
              backButton.setImage(UIImage(named: "arrow.png"), for: .normal) // Image can be downloaded from here below link
              backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
              backButton.tintColor = blueColors
        
              print("force")

              backButton.semanticContentAttribute = .forceRightToLeft
              backButton.translatesAutoresizingMaskIntoConstraints = false
              backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)

              
              let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
              view.bounds = view.bounds.offsetBy(dx: -20, dy: -20)
              view.addSubview(backButton)
              let backButtonView = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItem = backButtonView
        
        
    }
    @objc func backAction(_ sender:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //check if everything is correct or return an error
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func validateFields()->String?{
        //check if all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Try Again, Fill In All Fields."
        }
        if firstNameTextField.text?.count ?? 0 >= 14 || lastNameTextField.text?.count ?? 0 >= 16{
            return "Your first or last name is too long"
        }
            
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Util.isPasswordValid(cleanedPassword) == false{
            return "Your password must include eight letters, one special character, and one number."
        }
       let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        print(cleanedEmail);
        if isValidEmail(cleanedEmail) == false{
        return "Please enter a valid email address."
        }
        
        return nil
    }
    
    @IBAction func SignUpTap(_ sender: Any) {
        SignUpButton.isEnabled = false
        //validate the fields
        SignUpButton.setTitle("Signing Up...", for: .normal)
        
        let error = validateFields()
        if error != nil{
            //There's something wrong with eroro
            showError(error!)
            SignUpButton.isEnabled = true
            SignUpButton.setTitle("Sign Up", for: .normal)
        }
        else{
            
            //create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result,err) in
                if err != nil{
                
                    //there was an error creating the user
                    self.SignUpButton.isEnabled = true
                    self.SignUpButton.setTitle("Sign Up", for: .normal)
                    self.showError("Error Creating User")
                }
                else{
                   // Firestore.firestore
                   let db = Firestore.firestore()
                  //  let role = "Standard"
                   
                    db.collection("users").document("00UniqueNumber").getDocument { (document,error) in
                                
                                       if error != nil{
                                           print("cant get data")
                                        self.SignUpButton.isEnabled = true
                                        self.SignUpButton.setTitle("Sign Up", for: .normal)
                                           
                                       }
                                       if document != nil && document!.exists{
                                        
                                       if let documentdata = document?.data() {
                                        self.uniqueNumber = documentdata["number"] as! Int
                                        self.uniqueNumberNew = self.uniqueNumber+1
                                        }
                                        
                                       let uid = Auth.auth().currentUser?.uid
                                                          //UserDefaults.standard.set(true, forKey: "isloggedIn")
                                                          //UserDefaults.standard.synchronize()
                                        Firestore.firestore().collection("users").document(uid!).setData(["firstName":firstName, "lastName":lastName,"points":0,"role":"Standard","zAnswered":[],"indexNumber":self.uniqueNumberNew,"monthAndYearWithQuestionBank":"","chances":0,"medals":[],"zAnsweredTF":[],"monthAndYearWithQuestionBankTF":"","email":email,"monthsPlayed":0,"resetBlogEligible":"l","dateForLastReloadLives":"", "dateForLastReloadLivesTF":"","chancesTF":0])
                                        Firestore.firestore().collection("users").document("00UniqueNumber").updateData(["number":self.uniqueNumberNew]){
                                                        (error) in
                                                             if error != nil {
                                                                 self.showError("Couldn't be saved on the database,Try Again")
                                                          }
                                                          }
                                        
                                        self.transitionToHome()
                                        //self.dopePoints.text = documentdata["points"] as? String
                                  
                    }
                               
                            }
                  
                  
                    
                        
                       
                
                    
                    
                    //user was created successfully, now store first and last name
                   
                     
                }
            }
        }
        //create the user
        ///transtiiton to home screnn
    }
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
         
    }
    func transitionToHome(){
    
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "tabbar")
      viewController.modalTransitionStyle = .crossDissolve
      self.present(viewController, animated: true, completion: nil)
    }
    //empty textfield when start typing
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) 
    }
      
    }

