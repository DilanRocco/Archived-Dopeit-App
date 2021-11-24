//
//  InterViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/5/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class InterViewController: UIViewController {

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        super.viewDidLoad()
        transitionToHome()
        // Do any additional setup after loading the view.
    }
    func transitionToHome(){
    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? InterViewController
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
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
