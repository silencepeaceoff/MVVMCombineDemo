//
//  UIView+ext.swift
//  MVVMCombineDemo
//
//  Created by Dmitrii Tikhomirov on 6/3/23.
//

import UIKit

extension UIView {
  
  func makeSystem(_ button: UIButton) {
    button.addTarget(self, action: #selector(handleIn), for: [
      .touchDown,
      .touchDragInside
    ])
    
    button.addTarget(self, action: #selector(handleOut), for: [
      .touchDragOutside,
      .touchUpInside,
      .touchUpOutside,
      .touchDragExit,
      .touchCancel
    ])
  }
  
  @objc func handleIn() {
    UIView.animate(withDuration: 0.15, animations: { self.alpha = 0.55 })
  }
  
  @objc func handleOut() {
    UIView.animate(withDuration: 0.15, animations: { self.alpha = 1 })
  }
  
}
