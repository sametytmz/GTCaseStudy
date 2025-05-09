//
//  LoginViewController.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

class LoginViewController: UIViewController {
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
        let l = UILabel()
        l.text = NSLocalizedString("Garanti BBVA\nCase Study", comment: "")
        l.font = .appTitleFont()
        l.textColor = .appBlue
        l.numberOfLines = 2
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("E-mail address", comment: "")
        tf.font = .appTextFieldFont()
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.leftView = UIImageView(image: UIImage(named: "emailIcon"))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private let emailUnderline: UIView = {
        let v = UIView()
        v.backgroundColor = .appBlue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("Password", comment: "")
        tf.font = .appTextFieldFont()
        tf.isSecureTextEntry = true
        tf.leftView = UIImageView(image: UIImage(named: "lockIcon"))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private let passwordUnderline: UIView = {
        let v = UIView()
        v.backgroundColor = .appBorder
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(NSLocalizedString("LOGIN", comment: ""), for: .normal)
        b.titleLabel?.font = .appButtonFont()
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 12
        b.clipsToBounds = true
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .appGreen
        return b
    }()
    private let forgotButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(NSLocalizedString("I FORGOT MY PASS", comment: ""), for: .normal)
        b.titleLabel?.font = .appForgotFont()
        b.setTitleColor(.appBlue, for: .normal)
        b.layer.cornerRadius = 8
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.appBlue.cgColor
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    private let facebookButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .appSocialButtonFont()
        b.setImage(UIImage(named: "facebookIcon"), for: .normal)
        b.backgroundColor = .appFacebook
        b.layer.cornerRadius = 8
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    private let twitterButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .appSocialButtonFont()
        b.setImage(UIImage(named: "twitterIcon"), for: .normal)
        b.backgroundColor = .appTwitter
        b.layer.cornerRadius = 8
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
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
    }
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(emailField)
        containerView.addSubview(emailUnderline)
        containerView.addSubview(passwordField)
        containerView.addSubview(passwordUnderline)
        containerView.addSubview(loginButton)
        containerView.addSubview(forgotButton)
        containerView.addSubview(facebookButton)
        containerView.addSubview(twitterButton)
        // Layout
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 600),
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            // Email
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            emailField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            emailField.heightAnchor.constraint(equalToConstant: 44),
            emailUnderline.topAnchor.constraint(equalTo: emailField.bottomAnchor),
            emailUnderline.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            emailUnderline.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            emailUnderline.heightAnchor.constraint(equalToConstant: 2),
            // Password
            passwordField.topAnchor.constraint(equalTo: emailUnderline.bottomAnchor, constant: 24),
            passwordField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            passwordUnderline.topAnchor.constraint(equalTo: passwordField.bottomAnchor),
            passwordUnderline.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            passwordUnderline.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            passwordUnderline.heightAnchor.constraint(equalToConstant: 2),
            // Login Button
            loginButton.topAnchor.constraint(equalTo: passwordUnderline.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            // Forgot
            forgotButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
            forgotButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            forgotButton.heightAnchor.constraint(equalToConstant: 32),
            // Facebook
            facebookButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            facebookButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            facebookButton.heightAnchor.constraint(equalToConstant: 48),
            facebookButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -8),
            // Twitter
            twitterButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            twitterButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            twitterButton.heightAnchor.constraint(equalToConstant: 48),
            twitterButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 8)
        ])
    }
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(comingSoonTapped), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(comingSoonTapped), for: .touchUpInside)
        twitterButton.addTarget(self, action: #selector(comingSoonTapped), for: .touchUpInside)
    }
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
            // Ana ekrana geçiş burada olacak (Coordinator ile yönetilecek)
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
