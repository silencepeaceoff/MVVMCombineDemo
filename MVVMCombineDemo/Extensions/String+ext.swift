//
//  String+ext.swift
//  MVVMCombineDemo
//
//  Created by Dmitrii Tikhomirov on 6/3/23.
//

import UIKit

extension String {

  var isEmail: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

    return emailTest.evaluate(with: self)
  }

}
