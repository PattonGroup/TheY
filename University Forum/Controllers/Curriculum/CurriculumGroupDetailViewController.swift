//
//  CurriculumGroupDetailViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//

import UIKit

class CurriculumGroupDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(CurriculumCell.nib, forCellReuseIdentifier: CurriculumCell.identifier)
        }
    }
    
    var scheduleList: [AfterschoolScheduleModel] = []
    var group_id: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        
        self.title = "Schedule (Group \(group_id))"
        
        AfterschoolScheduleAPI.shared.getSchedules(id: group_id) { data in
            self.scheduleList = data
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


extension CurriculumGroupDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurriculumCell.identifier, for: indexPath) as! CurriculumCell
        cell.lblTime.text = scheduleList[indexPath.row].time
        cell.lblTitle.text = scheduleList[indexPath.row].title
        cell.lblDescription.text = scheduleList[indexPath.row].description
        
        UIView.animate(withDuration: 0) {
            cell.layoutIfNeeded()
        } completion: { _ in
            GradientColorClass.setGradiantColor(view: cell.containerView, topColor: .systemBlue, bottomColor: UIColor.systemPink.withAlphaComponent(0.7), cornerRadius: cell.frame.height / 2, gradiantDirection: .topToBottom)

        }

        return cell
    }
}
