//
//  LoginViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 06/09/2021.
//

import UIKit

class LoginViewController: UIViewController, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("\(error?.localizedDescription)")
    }
    
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        let trackLayer = CAShapeLayer()
//        let circularPath = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
//        trackLayer.path = circularPath.cgPath
//        trackLayer.strokeColor = UIColor.lightGray.cgColor
//        trackLayer.lineWidth = 10
//        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.lineCap = .round
//        view.layer.addSublayer(trackLayer)
//        // Do any additional setup after loading the view.
//
//        shapeLayer.path = circularPath.cgPath
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.lineWidth = 10
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineCap = .round
//        shapeLayer.strokeEnd = 0
//        view.layer.addSublayer(shapeLayer)
//        view .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func beginDownloading(urlString: String){
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    private func animateProgress(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .backwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic_animation")
    }
    
    @objc private func handleTap(){
        beginDownloading(urlString: "https://www.youtube.com/watch?v=UFhKqICXqlc")
        animateProgress()
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
