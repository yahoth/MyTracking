//
//  CustomButton.swift
//  Speedometer
//
//  Created by TAEHYOUNG KIM on 2023/09/13.
//

import UIKit

class AnimatedRoundedButton: UIButton {

    enum CornerRadius {
        case circle
        case rounded
    }

    var cornerRadius: CornerRadius?

    init(frame: CGRect, cornerRadius: CornerRadius? = nil) {
        self.cornerRadius = cornerRadius
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius(view: self, cornerRadius: cornerRadius)
    }

    func updateCornerRadius(view: UIView, cornerRadius: CornerRadius?) {
        let size = min(view.bounds.width, view.bounds.height)
        guard let cornerRadius else { return }
        switch cornerRadius {
        case .circle:
            view.layer.cornerRadius = size / 2
        case .rounded:
            view.layer.cornerRadius = size / 8
        }

        view.clipsToBounds = true
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
}
