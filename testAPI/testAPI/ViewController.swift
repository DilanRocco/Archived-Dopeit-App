//
//  ViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/29/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

       //trivia
       //blogging and global issues
       //segements on different categories(music,sports,political,memes,science,drama)
       //motivational quotes, feel connected
        
import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    
    @IBOutlet weak var signUp: UIButton!
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var background: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setUpElements()
        print("gg")
        UserDefaults.standard.set(false, forKey: "medal1")
        UserDefaults.standard.set(false, forKey: "medal2")
        UserDefaults.standard.set(false, forKey: "medal3")
        UserDefaults.standard.set(false, forKey: "medal4")
        UserDefaults.standard.set(false, forKey: "medal5")
        UserDefaults.standard.set(false, forKey: "medal6")
        UserDefaults.standard.set(false, forKey: "medal7")
        UserDefaults.standard.set(false, forKey: "medal8")
        UserDefaults.standard.set(false, forKey: "medal9")
        self.tabBarController?.tabBar.layer.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        stackview.layer.zPosition = 1;
        signUp.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        login.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        login.layer.cornerRadius = 30
        signUp.layer.cornerRadius = 30
        login.layer.borderWidth = 3
        signUp.layer.borderWidth = 3
        let whiteColor = UIColor(red: 222.0/255.0, green: 226.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        login.layer.borderColor = whiteColor.cgColor
        signUp.layer.borderColor = whiteColor.cgColor
        do {
            try Auth.auth().signOut()
            } catch let err {
                print(err)
        }
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    // Hide the Navigation Bar
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    
   // override func viewWillDisappear(_ animated: Bool) {
      //  super.viewWillDisappear(true)
    // Show the Navigation Bar
        //    self.navigationController?.setNavigationBarHidden(false, animated: false)
        //}
    func setUpElements(){
        
    }
   
}



