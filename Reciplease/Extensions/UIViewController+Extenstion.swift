//
//  UIView+Extension.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//
import Foundation
import UIKit

extension UIViewController {

    // MARK: - Alerts
    func presentErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    func presentUserQueryAlert(title: String,
                               message: String?,
                               okBtnTitle: String,
                               style: UIAlertAction.Style,
                               completion: (() -> Void)?) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: okBtnTitle, style: style) { _ in
            guard let completion = completion else { return }
            completion()
        }
        alert.addAction(actionOK)
        alert.view.tintColor = .label
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        return alert
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
