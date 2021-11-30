//
//  TrainingListViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 29/11/2021.
//

import UIKit
import SafariServices
import MBProgressHUD

class TrainingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TrainingListCell.nib, forCellReuseIdentifier: TrainingListCell.identifier)
        }
    }
    
    var trainingList: [TrainingModel] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        self.title = "SKILL ENHANCERS"
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TrainingAPI.shared.getAllTrainings { data in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.trainingList = data
            self.tableView.reloadData()
        }
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
        return trainingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrainingListCell.identifier, for: indexPath) as! TrainingListCell
        cell.lblText.text = trainingList[indexPath.row].title
        cell.lblDescription.text = trainingList[indexPath.row].description
        cell.lblLocation.text = trainingList[indexPath.row].location
        cell.btnRegister.accessibilityLabel = trainingList[indexPath.row].registration_url
        cell.delegate = self
        
        UIView.animate(withDuration: 0) {
            cell.layoutIfNeeded()
        } completion: { _ in
            GradientColorClass.setGradiantColor(view: cell.containerView, topColor: .systemBlue, bottomColor: UIColor.systemPink.withAlphaComponent(0.7), cornerRadius: cell.frame.height / 2, gradiantDirection: .topToBottom)

        }

        return cell
    }
}


extension TrainingListViewController: TrainingListCellDelegate {
    func didTapRegister(urlString: String) {
        if let url = URL(string: urlString) {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true

               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true)
           }
    }
}
