//
//  SettingsViewController.swift
//  FotografPaylasmaApp
//
//  Created by Koray Urun on 16.07.2025.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cikisYapTiklandi(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)

        } catch {
            print("HATA")
        }
        
    }
    

}
