//
//  LoginViewController.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import AuthenticationServices
import UIKit

final class LoginViewController: UIViewController {


    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var googleButton: UIButton!
    @IBOutlet private weak var appleContainer: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
        configureSocialButtons()
        configureDismissKeyboard()
        activityIndicator.hidesWhenStopped = true
    }



    @IBAction private func loginTapped(_ sender: UIButton) {
        hideError()
        let identifier = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        setLoading(true)
        Task {
            let result = await AppDependencies.shared.makeEmailLoginUseCase().execute(identifier: identifier, password: password)
            handle(result)
        }
    }

    @IBAction private func googleTapped(_ sender: UIButton) {
        guard let provider = AppDependencies.shared.makeGoogleProvider() else {
            showError("Google sign-in is not configured.")
            return
        }
        hideError()
        setLoading(true)
        Task {
            let profile = await provider.signIn(presenting: self)
            switch profile {
            case .success(let value):
                let result = await AppDependencies.shared.makeSocialLoginUseCase().execute(provider: .google, profile: value)
                handle(result)
            case .failure(let error):
                handle(.failure(error))
            }
        }
    }

    @objc private func appleTapped() {
        hideError()
        setLoading(true)
        Task {
            let provider = AppDependencies.shared.makeAppleProvider()
            let profile = await provider.signIn(presenting: self)
            switch profile {
            case .success(let value):
                let result = await AppDependencies.shared.makeSocialLoginUseCase().execute(provider: .apple, profile: value)
                handle(result)
            case .failure(let error):
                handle(.failure(error))
            }
        }
    }


    private func handle(_ result: Result<User, AuthError>) {
        setLoading(false)
        switch result {
        case .success(let user):
            if user.isPending {
                showError(AuthError.pendingCompletion(missingFields: user.missingFields).userMessage)
            } else {
                let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
                home.user = user
                navigationController?.pushViewController(home, animated: true)
            }
        case .failure(let error):
            showError(error.userMessage)
        }
    }

    private func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        loginButton.isEnabled = !loading
        emailTextField.isEnabled = !loading
        passwordTextField.isEnabled = !loading
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
    
    private func configureSocialButtons() {
        googleButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        if var configuration = googleButton.configuration {
            configuration.imagePadding = 12
            configuration.cornerStyle = .medium
            googleButton.configuration = configuration
        }

        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleButton.cornerRadius = 8
        appleButton.addTarget(self, action: #selector(appleTapped), for: .touchUpInside)
        embed(appleButton, in: appleContainer)
    }

    private func embed(_ control: UIControl, in container: UIView) {
        control.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(control)
        NSLayoutConstraint.activate([
            control.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            control.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            control.topAnchor.constraint(equalTo: container.topAnchor),
            control.bottomAnchor.constraint(equalTo: container.bottomAnchor)
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
