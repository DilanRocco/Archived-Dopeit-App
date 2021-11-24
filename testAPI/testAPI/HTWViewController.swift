//
//  HTWViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/14/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class HTWViewController: UIViewController {

   
    @IBOutlet weak var okButton: UIButton!
    
    
    @IBOutlet weak var obj: UILabel!
    @IBOutlet weak var objt: UILabel!
    @IBOutlet weak var triv: UILabel!
    @IBOutlet weak var trivt: UILabel!
    @IBOutlet weak var bl: UILabel!
    @IBOutlet weak var blt: UILabel!
    @IBOutlet weak var dt: UILabel!
    @IBOutlet weak var dtr: UILabel!
    @IBOutlet weak var dis: UILabel!
    @IBOutlet weak var dist: UILabel!
    
    
    
    @IBOutlet weak var frequentlyAskedButton: UIButton!
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        if (self.view.frame.width == 320){
            obj.font = obj.font.withSize(17)
            objt.font = objt.font.withSize(16)
            triv.font = triv.font.withSize(17)
            trivt.font = trivt.font.withSize(16)
            bl.font = bl.font.withSize(17)
            blt.font = blt.font.withSize(16)
            dt.font = dt.font.withSize(17)
            dtr.font = dtr.font.withSize(16)
            dis.font = dtr.font.withSize(16)
            dist.font = dtr.font.withSize(15)
        }
        if UserDefaults.standard.bool(forKey: "fromHomeScreen") == false{
            okButton.isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var lines: NSLayoutConstraint!
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("TTV")
        self.lines.constant = 197
        UIView.animate(withDuration: 0.75, animations: {
                  
                  self.view.layoutIfNeeded()
              })
    }
    @IBAction func okButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC")
        resultViewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.show(resultViewController, sender: nil)
    }
    @IBAction func freqButton(_ sender: Any) {
        let resultViewController = storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        resultViewController.modalPresentationStyle = .fullScreen
        self.show(resultViewController, sender:nil)
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
