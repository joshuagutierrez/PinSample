//
//  UIViewController+Extension.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/24/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    @objc func didTapAddButton() {
        //TODO: implement add button tap
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        rootVC.title = "Add Location"
        let navVC = UINavigationController(rootViewController: rootVC)
//        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true, completion: nil)
        
    }
    
//    @objc func didTapRefreshButton() {
//        //TODO: implement refresh button tap
////        OTMClient.getStudentLocation(completion: handleRefreshStudentsLocation(location:error:))
//
//
//    }
    
    @objc func didTapLogoutButton() {
        //TODO: implement logout button tap
        OTMClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTapCancelButton() {
        //TODO: implement cancel button tap
        
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    
}
