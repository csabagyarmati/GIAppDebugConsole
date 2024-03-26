//
//  GIToast.swift
//
//  Created by Csaba Gyarmati on 25/03/2024.
//

import UIKit

final public class GIToast: UIView {
    
    private let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    }
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.font = .systemFont(ofSize: 13)
        lbl.lines = 0
        return lbl
    }()

    // MARK: - Init
    
    init(parentView: UIView) {
        super.init(frame: .zero)
        
        configUI()
        setupBackground()
        setupLabel()
        addToast(on: parentView)
        
        hideToast()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Config View
private extension GIToast {
    
    func configUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.layer.cornerRadius = 12
    }
    
    func setupBackground() {
        self.addSubview(bgView)
        bgView.pin(to self)
    }
    
    func setupLabel() {
        self.addSubview(label)
        label.pin(to: self,
                  edges: .init(top: 8, left: 8, bottom: 8, right: 8))
    }

    func addToast(on parentView: UIView) {
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            parentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 8)
        ])
    }
}

private extension GIToast {
    
    func showToast(with text: String, hideAfter delay: TimeInterval = 2) {
        label.text = text
        showToast(hideAfter: delay)
    }
    
    func showToast(with attributedText: NSAttributedString, hideAfter delay: TimeInterval = 2) {
        label.attributedText = attributedText
        showToast(hideAfter: delay)
    }
    
    private func showToast(hideAfter delay: TimeInterval) {
        self.alpha = 0
        self.isHidden = false

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.alpha = 1
        } completion: { finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    self.hideToast()
                })
            }
        }

    }
    
    func hideToast() {
        self.isHidden = true
    }

}
