//
//  PopUpViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 3/31/21.
//  Copyright © 2021 Dilan Piscatello. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var textBox: UITextView!
    
    var PopUpTextFinal = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.text = PopUpTextFinal
        UserDefaults.standard.set(false, forKey: "runPopUp")
           
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
