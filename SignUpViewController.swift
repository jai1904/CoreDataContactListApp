//
//  SignUpViewController.swift
//  secretContactsBook
//
//  Created by Jai Telang on 02/07/23.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var password1Field: UITextField!

    // MARK: Action Handlers

    @IBAction func didTapOnboardMeButton(_ sender: Any) {
        guard let username = usernameField.text,
              let phoneNumber = phoneNumberField.text,
              let password1 = passwordField.text,
              let password2 = password1Field.text else {
            return
        }
        guard password1 == password2 else {
            let alertController = UIAlertController(title: "Re-entered password dosen't match the original one.", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            return
        }
        Authentication.shared.signUp(username: username, phoneNumber: phoneNumber, password: password1) { [weak self] result in
            self?.handleLogin(result)
        }
    }

    // MARK: Helper Functions

    private func handleLogin(_ result: Result<String?, AuthError>) {
        guard case .success(let token) = result else {
            let alertController = UIAlertController(title: WelcomeViewController().displayLoginError(for: result), message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            return
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signinVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.modalPresentationStyle = .overFullScreen
        self.present(signinVC, animated: true)

        let alertController = UIAlertController(title: "Signed up Successfully", message: "Please sign in again", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        signinVC.present(alertController, animated: false)
    }
}
