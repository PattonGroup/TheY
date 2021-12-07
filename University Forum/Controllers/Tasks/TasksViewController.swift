//
//  TasksViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 01/12/2021.
//

import UIKit

class TasksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TaskCell.nib, forCellReuseIdentifier: TaskCell.identifier)
        }
    }
    
    var taskList: [TaskModel] = []
    let checkedImage: UIImage = UIImage(named: "checked")!
    let uncheckedImage: UIImage = UIImage(named: "unchecked")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        self.title = "Tasks"
        TaskAPI.shared.getAllTasks { data in
            self.taskList = data
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
    func updateTaskStatus(task: TaskModel, isCompleted: Bool) {
        let status = isCompleted ? "completed" : "pending"
        TaskAPI.shared.updateTaskStatus(status: status, task: task)
    }
    
    func setImage(imageView: UIImageView, index: Int, isUpdateStatus: Bool = false) {
        UIView.animate(withDuration: 0.1) { [self] in
            if isUpdateStatus {
                if imageView.tag == 0  {
                    imageView.tag = 1
                    imageView.image = checkedImage.withRenderingMode(.alwaysTemplate)
                    taskList[index].status = "completed"
                    updateTaskStatus(task: taskList[index], isCompleted: true)
                }else{
                    imageView.tag = 0
                    imageView.image = uncheckedImage.withRenderingMode(.alwaysTemplate)
                    taskList[index].status = "pending"
                    updateTaskStatus(task: taskList[index], isCompleted: false)
                }
                
            }else{
                imageView.tag = 0
                imageView.image = ((taskList[index].status.lowercased() == "pending") ? uncheckedImage : checkedImage).withRenderingMode(.alwaysTemplate)
            }
            
        } completion: { _ in
            imageView.tintColor = .white
        }
    }

}


extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.lblTask.text = taskList[indexPath.row].title
        setImage(imageView: cell.imgCheck, index: indexPath.row)
        
        UIView.animate(withDuration: 0) {
            cell.layoutIfNeeded()
        } completion: { _ in
            GradientColorClass.setGradiantColor(view: cell.containerView, topColor: .systemBlue, bottomColor: UIColor.systemPink.withAlphaComponent(0.8), cornerRadius: cell.frame.height / 2, gradiantDirection: .topToBottom)

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            setImage(imageView: cell.imgCheck, index: indexPath.row, isUpdateStatus: true)
        }
    }
}
