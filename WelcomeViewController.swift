//
//  WelcomeViewController.swift
//  secretContactsBook
//
//  Created by Jai Telang on 01/07/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: Action Handlers

    @IBAction func didTapSignIn(_ sender: Any) {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        Authentication.shared.signIn(username: username, password: password) { [weak self] result in
            self?.handleLogin(result)
        }
    }

    @IBAction func didTapSignUp(_ sender: Any) {
        let signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        signupViewController?.modalPresentationStyle = .overFullScreen
        self.present(signupViewController!, animated: true)
    }

    // MARK: Helper Functions

    private func handleLogin(_ result: Result<String?, AuthError>) {
        guard case .success(let token) = result else {
            let alertController = UIAlertController(title: displayLoginError(for: result), message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            return
        }
        if let token = token {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let contactsViewController = storyboard.instantiateViewController(withIdentifier: "SecretContactsViewController") as! SecretContactsViewController
            contactsViewController.token = token
            contactsViewController.modalPresentationStyle = .overFullScreen
            self.present(contactsViewController, animated: true)
        }
    }

    func displayLoginError(for result: Result<String?, AuthError>) -> String {
        var errorMessage = ""
        guard case .failure(let error) = result else {
            errorMessage = "Authentication Failed"
            return errorMessage
        }
        switch error {
        case .nameTaken:
            errorMessage = "Oops! This username is already taken"
        case .phoneNumberTaken:
            errorMessage = "Oops! An account with this phone number already exists"
        case .invalidUsername:
            errorMessage = "Please check the first and last name."
        case .invalidPassword:
            errorMessage = "Please check the password"
        case .unknown:
            errorMessage = "SignUp Failed"
        }
        return errorMessage
    }

}
