//
//  SendButton.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/19.
//

import UIKit

@IBDesignable
class SendButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let width = bounds.width
        let height = bounds.height
        
        let circleRect = bounds.insetBy(dx: width * 0.05, dy: height * 0.05)
        
        context.setLineJoin(.round)
        context.setLineCap(.round)
        
        context.beginPath()
        context.setLineWidth(width * 0.07)
        context.setStrokeColor(ViewColor.sendButtonBackground.cgColor)
        context.setFillColor(ViewColor.sendButtonBackground.cgColor)
        context.addEllipse(in: circleRect)
        context.drawPath(using: .fillStroke)
        
        context.beginPath()
        context.setStrokeColor(ViewColor.nomalBlack.cgColor)
        context.move(to: CGPoint(x: width * 0.5, y: height * 0.3))
        context.addLine(to: CGPoint(x: width * 0.5, y: height * 0.7))
        context.drawPath(using: .stroke)
        
        context.beginPath()
        context.setStrokeColor(ViewColor.nomalBlack.cgColor)
        context.move(to: CGPoint(x: width * 0.3, y: height * 0.45))
        context.addLine(to: CGPoint(x: width * 0.5, y: height * 0.26))
        context.drawPath(using: .stroke)
        
        context.beginPath()
        context.setStrokeColor(ViewColor.nomalBlack.cgColor)
        context.move(to: CGPoint(x: width * 0.7, y: height * 0.45))
        context.addLine(to: CGPoint(x: width * 0.5, y: height * 0.26))
        context.drawPath(using: .stroke)
    }
}
