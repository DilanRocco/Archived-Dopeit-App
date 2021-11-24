//
//  ExtraTableViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/7/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class ExtraTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    let inside = ["FAQ","How To Win","Developers","Account Info","Contact Us","Logout"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inside.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        cell.textLabel?.text = inside[indexPath.row]
        if (indexPath.row == 5){
            cell.textLabel?.textColor = .red
           
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       if(indexPath.row == 0)
       {
  
       let resultViewController = storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
       resultViewController.modalPresentationStyle = .fullScreen
        self.show(resultViewController, sender:nil)
        
       }
        if(indexPath.row == 1)
        {
        UserDefaults.standard.set(false, forKey: "fromHomeScreen")
        let resultViewController = storyboard?.instantiateViewController(withIdentifier: "HTWViewController") as! HTWViewController
        resultViewController.modalPresentationStyle = .fullScreen
        self.show(resultViewController, sender:nil)
        }
        if(indexPath.row == 2)
           {
        
           let resultViewController = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
           resultViewController.modalPresentationStyle = .fullScreen
           self.show(resultViewController, sender:nil)
           }
        if(indexPath.row == 3)
           {
        
           let resultViewController = storyboard?.instantiateViewController(withIdentifier: "AccountInfoViewController") as! AccountInfoViewController
           resultViewController.modalPresentationStyle = .fullScreen
           self.show(resultViewController, sender:nil)
           }
        if(indexPath.row == 4){
           
           let resultViewController = storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
           resultViewController.modalPresentationStyle = .fullScreen
           self.show(resultViewController, sender:nil)
        }
        if(indexPath.row == 5){
           

                   // create the alert
                   let alert = UIAlertController(title: "Confirmation", message: "Are You Sure You Want To Logout?", preferredStyle: UIAlertController.Style.alert)
            
                   // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive, handler: {
                    action in
                     
                    let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ViewController
                    resultViewController.modalPresentationStyle = .fullScreen
                    self.show(resultViewController, sender:nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{ action in
                }))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
               
           
           
        }
        
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        myTableView.dataSource = self
        myTableView.delegate = self
        UserDefaults.standard.set(false, forKey: "fromHomeScreen")
        
        
        
        

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
