//
//  LineView.swift
//  DrawingApp
//
//  Created by Jiwoo Seo on 6/29/20.
//  Copyright © 2020 Jiwoo Seo. All rights reserved.
//

import UIKit

class LineView: UIView {
    var theLine:Line? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineStored: [Line] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func drawLine (_ line: Line){
        var path = UIBezierPath()
        line.color.setStroke()
        line.color.setFill()
        path.addArc(withCenter: line.line, radius: line.width/6.5, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        if line.lines.count <= 2 {
            // draw dot
            path.fill()
        }
        else {
            // draw line
            path = createQuadPath(points: line.lines)
        }
        path.lineWidth = line.width
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.stroke()
    }
    
    private func midpoint(first: CGPoint, second: CGPoint) -> CGPoint {
        // implement this function here
        return CGPoint(x: (first.x + second.x)/2, y: (first.y + second.y)/2)
    }
    
    private func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath() //Create the path object
        if(points.count < 2){
            return path
        }
        path.move(to: points[0]) //Start the path on the first point
        for i in 1..<points.count - 1{
            let firstMidpoint = midpoint(first: path.currentPoint, second: points[i])
            let secondMidpoint = midpoint(first: points[i], second: points[i+1])
            path.addCurve(to: secondMidpoint, controlPoint1: firstMidpoint, controlPoint2: points[i])
        }
        return path
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //     Only override draw() if you perform custom drawing.
    //     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for line in lineStored {
            drawLine(line)
        }
        if (theLine != nil) {
            drawLine(theLine!)
        }
    }
}
