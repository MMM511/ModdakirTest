//
//  LoginViewController.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import UIKit

final class LoginViewController: UIViewController {


    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var googleContainer: UIView!
    @IBOutlet private weak var appleContainer: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
        configureSocialPlaceholders()
        configureDismissKeyboard()
        activityIndicator.hidesWhenStopped = true
    }

 

    @IBAction private func loginTapped(_ sender: UIButton) {
        guard validateInput() else { return }
        showError("Sign-in is not wired yet.")
    }

    @objc private func googleTapped() {
        showError("Google sign-in is not wired yet.")
    }

    @objc private func appleTapped() {
        showError("Apple sign-in is not wired yet.")
    }


    private func configureFields() {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.textContentType = .username
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self

        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        passwordTextField.returnKeyType = .go
        passwordTextField.delegate = self

        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }

    
    private func configureSocialPlaceholders() {
        let googleButton = makePlaceholderButton(
            title: "Continue with Google",
            backgroundColor: .white,
            foregroundColor: .black,
            action: #selector(googleTapped)
        )
        let appleButton = makePlaceholderButton(
            title: "Continue with Apple",
            backgroundColor: .black,
            foregroundColor: .white,
            action: #selector(appleTapped)
        )
        embed(googleButton, in: googleContainer)
        embed(appleButton, in: appleContainer)
    }

    private func makePlaceholderButton(
        title: String,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        action: Selector
    ) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = foregroundColor
        configuration.cornerStyle = .medium
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func embed(_ button: UIButton, in container: UIView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.topAnchor.constraint(equalTo: container.topAnchor),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }

    private func configureDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }


    private func validateInput() -> Bool {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        if email.isEmpty || !email.contains("@") {
            showError("Please enter a valid email address.")
            return false
        }
        if password.isEmpty {
            showError("Please enter your password.")
            return false
        }
        hideError()
        return true
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    private func hideError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
}



extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginTapped(loginButton)
        }
        return true
    }
}
