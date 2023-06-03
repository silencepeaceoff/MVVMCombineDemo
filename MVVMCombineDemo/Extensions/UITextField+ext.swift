//
//  UITextField+ext.swift
//  MVVMCombineDemo
//
//  Created by Dmitrii Tikhomirov on 6/3/23.
//

import UIKit

extension UITextField {

  func indent(size:CGFloat) {
    self.leftView = UIView(
      frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height)
    )

    self.leftViewMode = .always
  }
  
}
