//
//  UIView+Extension.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//
import Foundation
import UIKit
import UserNotifications

extension UIViewController {

    // MARK: - Alerts
    func presentMessageAlert(type: AlertType = .error, with message: String) {
        let alert = UIAlertController(title: type.rawValue, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    func presentUserQueryAlert(title: String? = nil,
                               subtitle: String? = nil,
                               actionTitle: String?,
                               withTextField: Bool = false,
                               inputText: String? = nil,
                               inputPlaceholder: String? = nil,
                               inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                               actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        if withTextField {
            alert.addTextField { (textField:UITextField) in
                textField.text = inputText
                textField.placeholder = inputPlaceholder
                textField.keyboardType = inputKeyboardType
            }
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard
    func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
            view.endEditing(true)
    }

    // MARK: - Activity Indicator
    func showIndicator(_ indicator: UIActivityIndicatorView) {
        let barButton = UIBarButtonItem(customView: indicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        indicator.startAnimating()
    }

    func hideIndicator(_ indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        navigationItem.setRightBarButton(nil, animated: true)
    }

}
