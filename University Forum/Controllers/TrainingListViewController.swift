//
//  TrainingListViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 29/11/2021.
//

import UIKit

class TrainingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TrainingListCell.nib, forCellReuseIdentifier: TrainingListCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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


extension TrainingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrainingListCell.identifier, for: indexPath) as! TrainingListCell
        return cell
    }
}
