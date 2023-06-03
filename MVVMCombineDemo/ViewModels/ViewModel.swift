//
//  ViewModel.swift
//  MVVMCombineDemo
//
//  Created by Dmitrii Tikhomirov on 6/3/23.
//

import UIKit
import Combine

enum ViewStates {
  case loading
  case success
  case failed
  case none
}

final class ViewModel {

  @Published var email = ""
  @Published var password = ""
  @Published var state: ViewStates = .none

  var isValidEmailPublisher: AnyPublisher<Bool, Never> {
    $email
      .map { $0.isEmail }
      .eraseToAnyPublisher()
  }

  var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
    $password
      .map { !$0.isEmpty }
      .eraseToAnyPublisher()
  }

  var isLoginEnabled: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(isValidEmailPublisher, isValidPasswordPublisher)
      .map { $0 && $1 }
      .eraseToAnyPublisher()
  }

  func submitLogin() {
    state = .loading

    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
      guard let self = self else { return }
      if self.isCorrectLogin() {
        self.state = .success
      } else {
        self.state = .failed
      }
    }
  }

  func isCorrectLogin() -> Bool {
    email == "test@gmail.com" && password == "123qwe"
  }

}
