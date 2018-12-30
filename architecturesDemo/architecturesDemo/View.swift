//
//  View.swift
//  architecturesDemo
//
//  Created by ac on 2018/12/30.
//  Copyright © 2018年 ac. All rights reserved.
//

import UIKit

class View: UIView {

    var commit: (() -> Void)?
    var textFieldValue: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let commitButton = UIButton()

    init(title: String) {
        super.init(frame: CGRect.zero)

        commitButton.setTitle("commit", for: .normal)
        commitButton.addTarget(self, action: #selector(commitButtonDidClicked), for: .touchUpInside)
        textField.backgroundColor = .white
        titleLabel.text = title
        titleLabel.textColor = .white

        addSubview(titleLabel)
        addSubview(textField)
        addSubview(commitButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: commitButton.leadingAnchor, constant: -20).isActive = true

        commitButton.translatesAutoresizingMaskIntoConstraints = false
        commitButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        commitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        commitButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func commitButtonDidClicked() {
        commit?()
    }
}
