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
    }
    
    @objc func didTapRefreshButton() {
        //TODO: implement refresh button tap
    }
    
    @objc func didTapLogoutButton() {
        //TODO: implement logout button tap
        OTMClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
