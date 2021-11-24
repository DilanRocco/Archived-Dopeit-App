//
//  LoginViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/29/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var LastNameTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    let whiteColor = UIColor(red: 222.0/255.0, green: 226.0/255.0, blue: 237.0/255.0, alpha: 1.0)
   let blueColors = UIColor(red: 26.0/255.0, green: 149.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    var clock = Timer()
    var bottomLine1 = CALayer()
    var bottomLine2 = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = false
        overrideUserInterfaceStyle = .light
        setUpElements()
        bottomLine1.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        bottomLine1.backgroundColor = blueColors.cgColor
        firstNameTextField.borderStyle = UITextField.BorderStyle.none
        firstNameTextField.layer.addSublayer(bottomLine1)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
        attributes: [NSAttributedString.Key.foregroundColor: self.blueColors])
        
        bottomLine2.frame = CGRect(x: 0.0, y: LastNameTextField.frame.height - 1, width: LastNameTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = blueColors.cgColor
        LastNameTextField.borderStyle = UITextField.BorderStyle.none
        LastNameTextField.layer.addSublayer(bottomLine2)
        LastNameTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: self.blueColors])
        
        
        
        
        firstNameTextField.delegate = self
        LastNameTextField.delegate = self
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = whiteColor.cgColor
        addBackButton()
        // Do any additional setup after loading the view.
    }
    var layoutGuide:UILayoutGuide!
    override func viewWillAppear(_ animated: Bool) {
           addBackButton()
       }
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if firstNameTextField == textField{
        bottomLine1.backgroundColor = whiteColor.cgColor
        self.firstNameTextField.layer.addSublayer(bottomLine1)
        bottomLine1.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 2.0)
        firstNameTextField.placeholder = ""
        firstNameTextField.textColor = whiteColor
        }else{
        bottomLine2.backgroundColor = whiteColor.cgColor
        self.LastNameTextField.layer.addSublayer(bottomLine2)
        bottomLine2.frame = CGRect(x: 0.0, y: LastNameTextField.frame.height - 1, width: LastNameTextField.frame.width, height: 2.0)
        LastNameTextField.placeholder = ""
        LastNameTextField.textColor = whiteColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        bottomLine1.backgroundColor = blueColors.cgColor
        self.firstNameTextField.layer.addSublayer(bottomLine1)
        bottomLine1.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        firstNameTextField.placeholder = "Email Address"
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
        attributes: [NSAttributedString.Key.foregroundColor: blueColors])
        firstNameTextField.textColor = blueColors
        
        bottomLine2.backgroundColor = blueColors.cgColor
        self.LastNameTextField.layer.addSublayer(bottomLine2)
        bottomLine2.frame = CGRect(x: 0.0, y: LastNameTextField.frame.height - 1, width: LastNameTextField.frame.width, height: 1.0)
       LastNameTextField.placeholder = "Password"
        LastNameTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: blueColors])
        LastNameTextField.textColor = blueColors
    }
    func setUpElements(){
        //hide the error button
        errorLabel.alpha = 0
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginTapped(_ sender: Any) {
        
        //check if all fields are filled in
            
            let email = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                //couldnt sign in
                print("fdfdfdf")
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Wrong Password or Email."
            }else{
                print("logged in the user")
                self.loginButton.isEnabled = false
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "tabbar")
                viewController.modalTransitionStyle = .crossDissolve
                self.present(viewController, animated: true, completion: nil)
                   
                }
        }
        }
    
    func validateFields()->String?{
       if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Try Again, Fill In All Fields."
        }
        //validate text Fields
        return nil
        //Signing in the user
            
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        LastNameTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

