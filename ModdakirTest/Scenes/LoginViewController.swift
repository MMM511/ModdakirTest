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
            let result = await makeEmailLoginUseCase().execute(identifier: identifier, password: password)
            handle(result)
        }
    }

    @IBAction private func googleTapped(_ sender: UIButton) {
        guard let clientID = googleClientID() else {
            showError("Google sign-in is not configured.")
            return
        }
        hideError()
        setLoading(true)
        Task {
            let provider = GoogleLoginProvider(clientID: clientID)
            let profile = await provider.signIn(presenting: self)
            switch profile {
            case .success(let value):
                let result = await makeSocialLoginUseCase().execute(provider: .google, profile: value)
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
            let provider = AppleLoginProvider()
            let profile = await provider.signIn(presenting: self)
            switch profile {
            case .success(let value):
                let result = await makeSocialLoginUseCase().execute(provider: .apple, profile: value)
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
                showError("Your account needs a few more details to be completed.")
            } else {
                // TODO: Navigate to Home once HomeViewController lands.
                showError("Signed in as \(user.name). Home screen is next.")
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

    
   
    /// Styles the XIB-designed Google button and fills the Apple container
    /// with the official Apple button. The Google flow itself still runs
    /// through `GoogleLoginProvider` — only the button widget changed.
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


    private func makeRepository() -> AuthRepository {
        let api: AuthAPI = AlamofireAuthAPI()
        let remote: AuthRemoteDataSource = DefaultAuthRemoteDataSource(
            api: api,
            deviceUUID: UIDevice.current.identifierForVendor?.uuidString
        )
        let session: SessionStore = KeychainSessionStore()
        return AuthRepositoryImpl(remote: remote, session: session)
    }

    private func makeEmailLoginUseCase() -> EmailLoginUseCase {
        EmailLoginUseCase(repository: makeRepository())
    }

    private func makeSocialLoginUseCase() -> SocialLoginUseCase {
        SocialLoginUseCase(repository: makeRepository())
    }

    private func googleClientID() -> String? {
        guard let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            return nil
        }
        return plist["CLIENT_ID"] as? String
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
