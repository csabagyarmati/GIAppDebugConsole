//
//  GIToast.swift
//
//  Created by Csaba Gyarmati on 25/03/2024.
//

import UIKit

final public class GIToast: UIView {
    
    private let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .darkText
        lbl.font = .systemFont(ofSize: 13)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var dispatchWorkItem: DispatchWorkItem?
    private var isVisible = false

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
        self.layer.masksToBounds = true
    }
    
    func setupBackground() {
        self.addSubview(bgView)
        bgView.pin(to: self)
    }
    
    func setupLabel() {
        self.addSubview(label)
        label.pin(to: self, edges: .createWith(inset: 8))
    }

    func addToast(on parentView: UIView) {
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: self.topAnchor, constant: -8),
            parentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -8),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -8)
        ])
    }
}

public extension GIToast {
    
    public func showToast(with text: String, hideAfter delay: TimeInterval = 2) {
        label.text = text
        showToast(hideAfter: delay)
    }
    
    public func showToast(with attributedText: NSAttributedString, hideAfter delay: TimeInterval = 2) {
        label.attributedText = attributedText
        showToast(hideAfter: delay)
    }
    
}

private extension GIToast {
    
    private func showToast(hideAfter delay: TimeInterval) {
        if isVisible {
            self.dispatchWorkItem?.cancel()
            self.dispatchWorkItem = nil
            self.layer.removeAllAnimations()
        }
        
        self.alpha = 0
        self.isHidden = false
        self.isVisible = true

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.alpha = 1
        } completion: { finished in
            if finished {
                self.dispatchWorkItem = DispatchWorkItem(block: {
                    self.hideToast()
                })
                if let dispatchWorkItem = self.dispatchWorkItem {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: dispatchWorkItem)
                }
            }
        }

    }
    
    func hideToast() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.alpha = 0
        } completion: { finished in
            self.isHidden = true
            self.isVisible = false
        }
    }

}
