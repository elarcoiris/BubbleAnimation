//
//  BubbleView.swift
//
//  Created by Prue Phillips on 15/9/18.
//  Copyright © 2018 Inspirare Tech. All rights reserved.
//

import Foundation
import UIKit

class BubbleView: UIView {
    var view: UIView = UIView()
    var viewWidth: CGFloat = 0.0
    var updateRate: CGFloat = 0.03
    var blasting: Bool = false
    
    var viewController: ExampleController?
    var yOffset: CGFloat = 0.0
    var xOffset: CGFloat = 0.0
    var xOffset2: CGFloat = 0.0
    var xSign: CGFloat = 0.0
    var blastSpeed: CGFloat = 0.0
    var maskLayer: CAShapeLayer = CAShapeLayer()
    var maskLayer2: CAShapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initBlastView(viewController: ExampleController) {
        self.viewController = viewController
        viewController.profileImage?.isUserInteractionEnabled = false
        generateBubbleMask()
        blasting = false
    }
    
    func setRevealImage(image: UIImage) {
        self.blast()
    }
    
    func generateBubbleMask() {
        prepareBlast()
        calcBubblePath()
        viewController?.profileImage?.layer.mask = maskLayer
        viewController?.profileImage?.layer.mask?.addSublayer(maskLayer2)
    }
    
    func prepareBlast() {
        let yOff = (viewController?.profileImage.bounds.height)!
        yOffset = yOff
        xOffset = 0
        xOffset2 = 0
//       xSign = 0.2
//       blastSpeed = 4.0
        xSign = 0.01
        blastSpeed = 0.2
    }
    
    func calcBubblePath() {
        let maskWidth: CGFloat = (viewController?.profileImage.bounds.width)!
        var alternator: Int = 1
        let blastBubbleRadius: CGFloat = 50.0
        let bubblePath = CGMutablePath()
        let bubblePath2 = CGMutablePath()
        
        var xPos: CGFloat = 0.0
        var yPos: CGFloat = 0.0
        var radius: CGFloat = 0.0
        var boundingRect: CGRect = CGRect(x: xPos, y: yPos, width: radius, height: radius * 0.95)

        for i in 0...30 {
            yPos = yOffset + CGFloat(i * 55)
                for j in 1...6 {
                if (CGFloat(Double(arc4random()).truncatingRemainder(dividingBy: 10)) < CGFloat(7)) {
                    xPos = maskWidth * CGFloat(j) / CGFloat(6) + CGFloat(Double(arc4random()).truncatingRemainder(dividingBy: 50)) - CGFloat(25)

                    radius = blastBubbleRadius + CGFloat(Double(arc4random()).truncatingRemainder(dividingBy: 40)) - CGFloat(30)
                    boundingRect = CGRect(x: xPos, y: yPos, width: radius, height: radius * 0.95)
                    
                    if alternator == 1 {
                        alternator = 0
                        bubblePath.addEllipse(in: boundingRect)
                    }
                    else {
                        alternator = 1
                        bubblePath2.addEllipse(in: boundingRect)
                    }
                }
            }
        }
        maskLayer.path = bubblePath
        maskLayer2.path = bubblePath2
    }
    
    func updateBlastBubbles() {
        yOffset -= blastSpeed
        xOffset += xSign
        xOffset2 -= xSign
        
        if (xOffset < -2 || xOffset > 2) {
            xSign *= -1
        }

        let value = (viewController?.profileImage.frame.height)!
        let value2 = -value - 800
        if (yOffset > value2) {
            let _ = translatePath()
            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(Int(updateRate))) {
                self.updateBlastBubbles()
            }
        }
        else {
            generateBubbleMask()
            blasting = false
        }
    }
    
    func translatePath() -> CGAffineTransform {
        var translation = CGAffineTransform(translationX: xSign, y: -blastSpeed)
        maskLayer.path = maskLayer.path?.copy(using: &translation)
        translation = CGAffineTransform(translationX: -xSign, y: -blastSpeed - 0.1)
        maskLayer2.path = maskLayer2.path?.copy(using: &translation)
        viewController?.profileImage.layer.mask = maskLayer
        viewController?.profileImage?.layer.mask?.addSublayer(maskLayer2)
        viewController?.profileImage.setNeedsDisplay()
        return translation
    }
    
    func blast() {
        if (!blasting && viewController?.profileImage?.image != nil) {
            prepareBlast()
            updateBlastBubbles()
            blasting = true
        } 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
}
