//
//  CurriculumViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//

import Foundation
import UIKit


class CurriculumViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func didTapGroup(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showGroupDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupDetails" {
            
        }
    }
}
