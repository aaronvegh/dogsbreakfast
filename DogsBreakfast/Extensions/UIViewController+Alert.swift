//
//  UIViewController+Alert.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?, cancelButtonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
