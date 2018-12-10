//
//  BouncyView.swift
//  Papr
//
//  Created by Joan Disho on 22.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

// https://github.com/GitHawkApp/GitHawk/blob/212529d4661d4245586147a9934b603b9e367ea6/Classes/Notifications/NoNewNotificationsCell.swift

class BouncyView: UIView {

    // MARK: Private
    private let emojiLabel = UILabel()
    private let messageLabel = UILabel()
    private let shadow = CAShapeLayer()

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)

        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .clear
        emojiLabel.font = .systemFont(ofSize: 60)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emojiLabel)
        emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -35.0).isActive = true

        shadow.fillColor = UIColor(white: 0, alpha: 0.05).cgColor
        layer.addSublayer(shadow)

        messageLabel.textAlignment = .center
        messageLabel.backgroundColor = .clear
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.textColor = UIColor(hexString: "a3aab1")
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        messageLabel.centerXAnchor.constraint(equalTo: emojiLabel.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 35.0).isActive = true

        resetAnimations()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let width: CGFloat = 30
        let height: CGFloat = 12
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        shadow.path = UIBezierPath(ovalIn: rect).cgPath

        let bounds = self.bounds
        shadow.bounds = rect
        shadow.position = CGPoint(
            x: bounds.width/2,
            y: bounds.height/2 + 15
        )
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        resetAnimations()
    }

    func configure(emoji: String, message: String) {
        emojiLabel.text = emoji
        messageLabel.text = message
    }

    // MARK: Helper
    @objc private func resetAnimations() {
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let duration: TimeInterval = 1

        let emojiBounce = CABasicAnimation(keyPath: "transform.translation.y")
        emojiBounce.toValue = -10
        emojiBounce.repeatCount = .greatestFiniteMagnitude
        emojiBounce.autoreverses = true
        emojiBounce.duration = duration
        emojiBounce.timingFunction = timingFunction

        emojiLabel.layer.add(emojiBounce, forKey: "noresultcell.emoji")

        let shadowScale = CABasicAnimation(keyPath: "transform.scale")
        shadowScale.toValue = 0.9
        shadowScale.repeatCount = .greatestFiniteMagnitude
        shadowScale.autoreverses = true
        shadowScale.duration = duration
        shadowScale.timingFunction = timingFunction

        shadow.add(shadowScale, forKey: "noresultcell.shadow")
    }


}
