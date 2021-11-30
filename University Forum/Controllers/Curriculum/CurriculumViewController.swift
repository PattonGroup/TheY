//
//  CurriculumViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//

import Foundation
import UIKit


class CurriculumViewController: UIViewController {
    var group_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Curriculum"
        
    }
    
    @IBAction func didTapGroup(_ sender: UIButton) {
        self.group_id = "\(sender.tag)"
        self.performSegue(withIdentifier: "showGroupDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupDetails" {
            (segue.destination as! CurriculumGroupDetailViewController).group_id = group_id
        }
    }
}
