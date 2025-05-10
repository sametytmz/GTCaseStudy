//
//  LoginViewController.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

// LoginCoordinator protokolü
protocol LoginCoordinator: AnyObject {
    func showMainTabBar()
}

class LoginViewController: UIViewController {
    // MARK: - Coordinator
    weak var coordinator: LoginCoordinator?
    // MARK: - UI
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.15
        v.layer.shadowOffset = CGSize(width: 0, height: 8)
        v.layer.shadowRadius = 24
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let titleLabel: UILabel = {
        let l = UILabel.appLabel(font: .appHeadline(), textColor: .appBlue, numberOfLines: 2)
        l.text = NSLocalizedString("Garanti BBVA\nCase Study", comment: "")
        l.textAlignment = .center
        return l
    }()
    private let emailField: UITextField = {
        let tf = UITextField.appTextField(placeholder: NSLocalizedString("E-mail address", comment: ""), font: .appSubheading(), isSecure: false, icon: UIImage(named: "emailIcon"))
        tf.keyboardType = .emailAddress
        return tf
    }()
    private let emailUnderline: UIView = {
        let v = UIView()
        v.backgroundColor = .appBorder
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let passwordField: UITextField = {
        let tf = UITextField.appTextField(placeholder: NSLocalizedString("Password", comment: ""), font: .appSubheading(), isSecure: true, icon: UIImage(named: "lockIcon"))
        return tf
    }()
    private let passwordUnderline: UIView = {
        let v = UIView()
        v.backgroundColor = .appBorder
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let loginButton: UIButton = {
        let b = UIButton.appButton(title: NSLocalizedString("LOGIN", comment: ""), font: .appButton())
        return b
    }()
    private let forgotButton: UIButton = {
        let b = UIButton.appButton(title: NSLocalizedString("I FORGOT MY PASS", comment: ""), font: .appCapsXS(), titleColor: .appDark, bgColor: .clear, cornerRadius: 8)
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.appBlue.cgColor
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        b.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return b
    }()
    private let facebookImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "facebookIcon"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let twitterImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "twitterIcon"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    // MARK: - ViewModel
    private let viewModel = LoginViewModel()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        setupUI()
        setupActions()
        bindViewModel()
        emailField.delegate = self
        passwordField.delegate = self
        // Başlangıçta ikisi de pasif renk
        emailUnderline.backgroundColor = .appBorder
        passwordUnderline.backgroundColor = .appBorder
    }
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubviews(
            titleLabel,
            emailField,
            emailUnderline,
            passwordField,
            passwordUnderline,
            loginButton,
            forgotButton,
            facebookImageView,
            twitterImageView
        )
        containerView.anchor(
            leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: view.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24),
            size: CGSize(width: 0, height: 600)
        )
        titleLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 48, left: 24, bottom: 0, right: 24)
        )
        emailField.anchor(
            top: titleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 48, left: 24, bottom: 0, right: 24),
            size: CGSize(width: 0, height: 44)
        )
        emailUnderline.anchor(
            top: emailField.bottomAnchor,
            leading: emailField.leadingAnchor,
            trailing: emailField.trailingAnchor,
            size: CGSize(width: 0, height: 2)
        )
        passwordField.anchor(
            top: emailUnderline.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24),
            size: CGSize(width: 0, height: 44)
        )
        passwordUnderline.anchor(
            top: passwordField.bottomAnchor,
            leading: passwordField.leadingAnchor,
            trailing: passwordField.trailingAnchor,
            size: CGSize(width: 0, height: 2)
        )
        loginButton.anchor(
            top: passwordUnderline.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 80, left: 24, bottom: 0, right: 24),
            size: CGSize(width: 0, height: 48)
        )
        forgotButton.anchor(
            top: loginButton.bottomAnchor,
            centerX: containerView.centerXAnchor,
            padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 0, height: 28)
        )
        facebookImageView.anchor(
            top: forgotButton.bottomAnchor,
            trailing: containerView.centerXAnchor,
            padding: UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 8),
            size: CGSize(width: 140, height: 40)
        )
        twitterImageView.anchor(
            top: forgotButton.bottomAnchor,
            leading: containerView.centerXAnchor,
            padding: UIEdgeInsets(top: 24, left: 8, bottom: 0, right: 0),
            size: CGSize(width: 140, height: 40)
        )
    }
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(comingSoonTapped), for: .touchUpInside)
        let facebookTap = UITapGestureRecognizer(target: self, action: #selector(comingSoonTapped))
        facebookImageView.addGestureRecognizer(facebookTap)
        let twitterTap = UITapGestureRecognizer(target: self, action: #selector(comingSoonTapped))
        twitterImageView.addGestureRecognizer(twitterTap)
    }
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
            // Yönlendirme artık coordinator üzerinden
            self?.coordinator?.showMainTabBar()
        }
        viewModel.onLoginError = { [weak self] error in
            self?.showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
        }
    }
    @objc private func loginTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Lütfen tüm alanları doldurun", comment: ""))
            return
        }
        viewModel.login(email: email, password: password)
    }
    @objc private func comingSoonTapped() {
        showComingSoonAlert()
    }
}
// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailField {
            emailUnderline.backgroundColor = .appBlue
            passwordUnderline.backgroundColor = .appBorder
        } else if textField == passwordField {
            passwordUnderline.backgroundColor = .appBlue
            emailUnderline.backgroundColor = .appBorder
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailField.isFirstResponder {
            emailUnderline.backgroundColor = .appBlue
            passwordUnderline.backgroundColor = .appBorder
        } else if passwordField.isFirstResponder {
            passwordUnderline.backgroundColor = .appBlue
            emailUnderline.backgroundColor = .appBorder
        } else {
            emailUnderline.backgroundColor = .appBorder
            passwordUnderline.backgroundColor = .appBorder
        }
    }
} 
