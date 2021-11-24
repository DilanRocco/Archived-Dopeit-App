//
//  TabBarViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/28/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
       self.selectedIndex = 2
        tabBar.unselectedItemTintColor = .black
        overrideUserInterfaceStyle = .light
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
            // Do any additional setup after loading the view.
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
