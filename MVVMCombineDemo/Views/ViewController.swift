//
//  ViewController.swift
//  MVVMCombineDemo
//
//  Created by Dmitrii Tikhomirov on 6/3/23.
//

import UIKit
import Combine

final class ViewController: UIViewController {

  private let titleLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Login Screen"
    lbl.font = .systemFont(ofSize: 32, weight: .semibold)
    lbl.textColor = .black
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  private let logLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Login"
    lbl.font = .systemFont(ofSize: 16, weight: .regular)
    lbl.textColor = .systemGray
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  private let passLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Password"
    lbl.font = .systemFont(ofSize: 16, weight: .regular)
    lbl.textColor = .systemGray
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  private let statusLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = ""
    lbl.font = .systemFont(ofSize: 16, weight: .regular)
    lbl.textColor = .systemGray
    lbl.isHidden = true
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  private let loginTxtFld: UITextField = {
    let txtFld = UITextField()
    txtFld.indent(size: 8)
    txtFld.layer.cornerRadius = 8
    txtFld.layer.borderColor = UIColor.systemGray4.cgColor
    txtFld.layer.borderWidth = 1
    txtFld.translatesAutoresizingMaskIntoConstraints = false
    return txtFld
  }()

  private let passwordTxtFld: UITextField = {
    let txtFld = UITextField()
    txtFld.indent(size: 8)
    txtFld.layer.cornerRadius = 8
    txtFld.layer.borderColor = UIColor.systemGray4.cgColor
    txtFld.layer.borderWidth = 1
    txtFld.translatesAutoresizingMaskIntoConstraints = false
    return txtFld
  }()

  private let loginBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("Login", for: .normal)
    btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    btn.setTitleColor(.white, for: .normal)
    btn.layer.cornerRadius = 8
    btn.isEnabled = false
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.makeSystem(btn)
    btn.addTarget(self, action: #selector(loginDidTouch), for: .touchUpInside)
    return btn
  }()

  var viewModel = ViewModel()
  var subscription = Set<AnyCancellable>()

  var isActive: Bool = false {
    didSet {
      loginBtn.backgroundColor = isActive ? .systemBlue : .systemGray2
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    bindViewModel()
  }

  func bindViewModel() {
    NotificationCenter
      .default
      .publisher(for: UITextField.textDidChangeNotification, object: loginTxtFld)
      .map { ($0.object as? UITextField)?.text ?? "" }
      .assign(to: \.email, on: viewModel)
      .store(in: &subscription)

    NotificationCenter
      .default
      .publisher(for: UITextField.textDidChangeNotification, object: passwordTxtFld)
      .map { ($0.object as? UITextField)?.text ?? "" }
      .assign(to: \.password, on: viewModel)
      .store(in: &subscription)

    viewModel.isLoginEnabled
      .assign(to: \.isEnabled, on: loginBtn)
      .store(in: &subscription)

    viewModel.isLoginEnabled
      .assign(to: \.isActive, on: self)
      .store(in: &subscription)

    viewModel.$state
      .sink { [weak self] state in
        switch state {
        case .loading:
          self?.statusLabel.isHidden = true
          self?.loginBtn.isEnabled = false
          self?.loginBtn.setTitle("Loading...", for: .normal)
        case.success:
          self?.statusLabel.isHidden = false
          self?.statusLabel.text = "Login Success!"
          self?.statusLabel.textColor = .systemGreen
          self?.loginBtn.isEnabled = true
          self?.loginBtn.setTitle("Login", for: .normal)
        case.failed:
          self?.statusLabel.isHidden = false
          self?.statusLabel.text = "Login Failed!"
          self?.statusLabel.textColor = .systemRed
          self?.loginBtn.isEnabled = true
          self?.loginBtn.setTitle("Login", for: .normal)
        case .none:
          break
        }
      }
      .store(in: &subscription)
  }

  @objc func loginDidTouch() {
    viewModel.submitLogin()
  }

}

extension ViewController {

  func setup() {
    view.backgroundColor = .systemBackground

    view.addSubview(titleLabel)

    view.addSubview(logLabel)
    view.addSubview(loginTxtFld)

    view.addSubview(passLabel)
    view.addSubview(passwordTxtFld)

    view.addSubview(loginBtn)

    view.addSubview(statusLabel)

    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

      logLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      logLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

      loginTxtFld.topAnchor.constraint(equalTo: logLabel.bottomAnchor, constant: 8),
      loginTxtFld.leadingAnchor.constraint(equalTo: logLabel.leadingAnchor),
      loginTxtFld.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      loginTxtFld.heightAnchor.constraint(equalToConstant: 44),

      passLabel.topAnchor.constraint(equalTo: loginTxtFld.bottomAnchor, constant: 20),
      passLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

      passwordTxtFld.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 8),
      passwordTxtFld.leadingAnchor.constraint(equalTo: passLabel.leadingAnchor),
      passwordTxtFld.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      passwordTxtFld.heightAnchor.constraint(equalToConstant: 44),

      loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginBtn.topAnchor.constraint(equalTo: passwordTxtFld.bottomAnchor, constant: 20),
      loginBtn.heightAnchor.constraint(equalToConstant: 44),
      loginBtn.widthAnchor.constraint(equalToConstant: 132),

      statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      statusLabel.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20)
    ])
  }

}
