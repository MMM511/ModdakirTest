//
//  HomeViewController.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

import GoogleSignIn
import UIKit


final class HomeViewController: UIViewController {

    var user: User!

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        styleProfileImage()
        render()
    }


    @IBAction private func logoutTapped(_ sender: UIButton) {
        LogoutUseCase(repository: HomeViewController.makeRepository()).execute()
        GIDSignIn.sharedInstance.signOut()
        navigationController?.popToRootViewController(animated: true)
    }


    private func render() {
        guard let user else { return }
        nameLabel.text = user.name
        emailLabel.text = user.email
        guard let url = user.avatarURL else { return }
        loadAvatar(from: url)
    }

    private func styleProfileImage() {
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .white
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 48
        profileImageView.clipsToBounds = true
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }

    private func loadAvatar(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }.resume()
    }

    private static func makeRepository() -> AuthRepository {
        let api: AuthAPI = AlamofireAuthAPI()
        let remote: AuthRemoteDataSource = DefaultAuthRemoteDataSource(
            api: api,
            deviceUUID: UIDevice.current.identifierForVendor?.uuidString
        )
        let session: SessionStore = KeychainSessionStore()
        return AuthRepositoryImpl(remote: remote, session: session)
    }
}
