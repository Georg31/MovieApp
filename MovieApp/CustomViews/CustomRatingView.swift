//
//  CustomRatingView.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/15/21.
//

import UIKit

class CustomRatingView: UIView {

    var rating: Double! {
        didSet {
            self.cofigureRatingView()
        }
    }

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemOrange, UIColor.systemRed].map {$0.cgColor}
        gradientLayer.type = .axial
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return gradientLayer
    }()

    private let ratingLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = .none
        shapeLayer.strokeColor = #colorLiteral(red: 0.1292955875, green: 0.7561361194, blue: 0.4459108114, alpha: 1)
        shapeLayer.lineWidth = 3.0
        return shapeLayer
    }()

    private let ratingLayer2: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = .none
        shapeLayer.strokeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        shapeLayer.lineWidth = 3.0
        return shapeLayer
    }()

    private lazy var ratingLabel: UILabel = {
        let lab = UILabel(frame: self.bounds)
        lab.textColor = .white
        lab.center = self.center
        lab.textAlignment = .center
        lab.contentMode = .center
        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }

    private func cofigureRatingView() {

        ratingLabel.text = String(rating)

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
                                      radius: CGFloat(20),
                                      startAngle: CGFloat(-Double.pi / 2),
                                      endAngle: CGFloat(-Double.pi / 2),
                                      clockwise: true)

        ratingLayer.path = circlePath.cgPath

        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
                                       radius: CGFloat(20),
                                       startAngle: CGFloat(0),
                                       endAngle: CGFloat(Double.pi * 2),
                                       clockwise: true)
        ratingLayer2.path = circlePath2.cgPath

        self.layer.addSublayer(gradientLayer)

        gradientLayer.frame = self.bounds
        gradientLayer.mask = ratingLabel.layer

        self.layer.addSublayer(ratingLayer2)
        self.layer.addSublayer(ratingLayer)

        labelTextAnimation()
        gradientAnimation()
        ratingAnimation()
    }

    private func percentToRadians() -> Double {
        return 2 * Double.pi / 10.0 * rating
    }

}

// MARK: Animations
extension CustomRatingView {

    private func ratingAnimation() {
        CATransaction.begin()

        let animationPath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
                                         radius: CGFloat(20),
                                         startAngle: CGFloat(-Double.pi / 2),
                                         endAngle: CGFloat(-1.55 + percentToRadians()),
                                         clockwise: true)
        ratingLayer.path = animationPath.cgPath

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1

        ratingLayer.add(animation, forKey: "myStroke")
        CATransaction.commit()
    }

    private func gradientAnimation() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor.yellow, UIColor.red].map {$0.cgColor}
        animation.toValue = [UIColor.systemOrange, UIColor.systemIndigo].map {$0.cgColor}
        animation.duration = 2
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        self.gradientLayer.add(animation, forKey: nil)
    }

    private func labelTextAnimation() {
        let ratingCount = DispatchWorkItem { [self] in
            for num in stride(from: 0, through: rating, by: 0.1) {
                DispatchQueue.main.async {
                    self.ratingLabel.text = String(format: "%.1f", num)
                }
                Thread.sleep(forTimeInterval: 1/1100)
            }
        }

        let queue: DispatchQueue = .init(label: "printQueue", qos: .background)
        queue.asyncAfter(deadline: .now(), execute: ratingCount)
    }

}
