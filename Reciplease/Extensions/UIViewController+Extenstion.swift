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
    /// Present a simple message alert wit ha dismiss button.
    /// - Parameters:
    ///   - type: Alert message, Error by default.
    ///   - message: Message to display.
    func presentMessageAlert(type: AlertType = .error, with message: String) {
        let alert = UIAlertController(title: type.rawValue, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// Present an alert with a completion handler, with option to include a textfield and to user the textField value.
    /// - Parameters:
    ///   - title: Alert title..
    ///   - subtitle: Alert subtitle.
    ///   - actionTitle: Agree button title, Ok by default.
    ///   - withTextField: Bool vlaue if a textfield should be displayed , false by default.
    ///   - inputText: TextField value.
    ///   - inputPlaceholder: TextField placeholder message.
    ///   - inputKeyboardType: Default by default.
    ///   - actionHandler: Action triggered when Ok button tapped.
    func presentUserQueryAlert(title: String? = nil,
                               subtitle: String? = nil,
                               actionTitle: String? = "Ok",
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            indicator.stopAnimating()
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
}
