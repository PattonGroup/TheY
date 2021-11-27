//
//  SharedFunc.swift
//  University Forum
//
//  Created by Ian Talisic on 11/09/2021.
//

import Foundation
import AVKit
import UIKit
import NotificationBannerSwift
import Kingfisher

protocol SharedFuncDelegate {
    func didSelectTopItem(index: Int)
}

class SharedFunc {
    static let shared = SharedFunc()
    var delegate: SharedFuncDelegate?
    
    static func createVideoThumbnail(from url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.7)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 2)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }
    
    static func initializeCellCache(cellCache: inout [UITableViewCell?], count: Int, isDashboard: Bool = true) {
        cellCache.removeAll()
        if isDashboard {
            cellCache.append(nil) /*This is for the first cell*/
        }
        for _ in 0..<count {
            cellCache.append(nil)
        }
    }
    
    static func initializeObserver(isAdd: Bool, vc: UIViewController, cellCache: [UITableViewCell?]){
        for cell in cellCache {
            if let ncell = cell as? FeedsCell {
                if isAdd {
                    ncell.avPlayer?.addObserver(vc, forKeyPath: "rate", options: [], context: nil)
                }else{
                    ncell.avPlayer?.pause()
                    ncell.avPlayer?.removeObserver(vc, forKeyPath: "rate")
                }
            }
        }
    }
    
    //MARK: Validation Functions
    static func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "^[0-9]{6,14}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    static func isValidEmail(candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        if valid {
            valid = !candidate.contains("..")
        }
        return valid
    }
    
    static func applyTextfieldFormatting(_ textfield: UITextField){
        textfield.borderStyle = .none
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.cornerRadius = 8
        textfield.layer.masksToBounds = true
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.leftViewMode = .always
        textfield.leftView = leftPadding
        
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.rightViewMode = .always
        textfield.rightView = rightPadding
    }
    
    static func showError(title: String, errMsg: String){
        let banner = GrowingNotificationBanner(title: title, subtitle: errMsg, style: .danger)
        banner.show()
    }
    
    static func showSuccess(title: String, message: String){
        let banner = GrowingNotificationBanner(title: title, subtitle: message, style: .success)
        banner.show()
    }
    
    static func getString(_ args: Any?) -> String {
        if let val = args as? String {
            return val
        }
        
        if let val = args as? Int {
            return "\(val)"
        }
        
        if let val = args as? CGFloat {
            return "\(val)"
        }
        
        if let val = args as? Double {
            return "\(val)"
        }
        
        return ""
    }
    
    static func getMembersCount(_ val: String) -> String {
        if let value = Double(val) {
            if value.truncatingRemainder(dividingBy: 1000) == 0 {
                return String(format: "%dK", Int(value / 1000)).appending(" Members")
            }
            return value >= 1000.0 ? String(format: "%.1fK", value / 1000).appending(" Members") : String(format: "%d", Int(value)).appending(" Members")
        }
        
        return "0 Members"
    }
    
    static func generateImageNameBasedOnDate() -> String {
        let date = Date.timeIntervalBetween1970AndReferenceDate
        let timeInterval = Int(TimeInterval(date))
        return "img\(timeInterval)"
    }
    
    static func loadImage(imageView: UIImageView, urlString: String) {
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    static func getUnivesityDetails(id: String, universityList: [UniversityResponseModel]) -> UniversityResponseModel {
        for university in universityList {
            if university.id == id {
                return university
            }
        }
        
        return UniversityResponseModel()
    }
    
    
    static func logout(_ vc: UIViewController){
        let alert = UIAlertController.init(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nav = UINavigationController(rootViewController: loginVC)
            loginVC.window?.rootViewController = nav
            loginVC.window?.makeKeyAndVisible()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}

