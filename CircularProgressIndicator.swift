//
//  CircularProgressIndicator.swift
//  Version 0.1
//  Created by Oliver Poole on 23.04.16.
//

// This code is distributed under the terms and conditions of the MIT license. 

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class CircularProgressIndicator: UIView {
  
  /// The title label, should not change.
  private let completedTitleLabel = UILabel()
  
  /// The label containing the total number of objectives completed
  private let totalCompletedLabel = UILabel()
  
  /// The percentage of objectives completed
  private let percentageLabel = UILabel()
  
  private var totalAttempted = Int()
  private var totalCompleted = Int()
  
  // Paths
  private var backgroundBezierPath = UIBezierPath()
  private var progressBezierPath = UIBezierPath()
  
  // Layer
  private let progressLayer = CAShapeLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    drawSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(frame: CGRectMake(0, 0, 0, 0))
    drawSubviews()
  }
  
  private func drawSubviews() {
    backgroundColor = UIColor.whiteColor()
    
    
    addSubview(completedTitleLabel)
    
    
    // Add label for total attempted
    totalCompletedLabel.font = ThemeManager.Fonts.UltraLight(56)
    addSubview(totalCompletedLabel)
    
    percentageLabel.font = ThemeManager.Fonts.Book(20)
    percentageLabel.alpha = 0.5
    addSubview(percentageLabel)
    
    addConstraints()
  }
  
  override func drawRect(rect: CGRect) {
    // Draw dial
    let center = CGPointMake(rect.width / 2, rect.height / 2)
    let radius = (rect.height / 2) - 10 // for some side padding
    
    backgroundBezierPath = UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: degreesToRadians(degrees: 0),
      endAngle: degreesToRadians(degrees: 360),
      clockwise: true)
    
    backgroundBezierPath.lineWidth = 10.0
    ThemeManager.Colors.LightGreyColor().setStroke()
    
    backgroundBezierPath.stroke()
    
    let percentComplete = Float(totalCompleted) / Float(totalAttempted)
    let startAngle = degreesToRadians(degrees: -90.0)
    
    progressBezierPath = UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: startAngle + degreesToRadians(degrees: CGFloat(Float(360.0) * percentComplete)),
      clockwise: true)
    
    progressBezierPath.lineJoinStyle = .Round
    
    progressLayer.path = progressBezierPath.CGPath
    progressLayer.fillColor = UIColor.clearColor().CGColor
    progressLayer.strokeColor = ThemeManager.Colors.LightGreenColor().CGColor
    progressLayer.lineWidth = 10
    
    layer.addSublayer(progressLayer)
    
    let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
    progressAnimation.duration = 1.0
    progressAnimation.fromValue = 0.0
    progressAnimation.toValue = 1.0
    progressAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    
    progressLayer.addAnimation(progressAnimation, forKey: "strokeEndAnimation")
  }
  
  private func addConstraints() {
    completedTitleLabel.snp_makeConstraints { (make) -> Void in
      make.centerX.equalTo(self)
      make.centerY.equalTo(self).offset(-50)
    }
    
    totalCompletedLabel.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self)
    }
    
    percentageLabel.snp_makeConstraints { (make) -> Void in
      make.centerX.equalTo(self)
      make.centerY.equalTo(self).offset(50)
    }
  }
  
  private func degreesToRadians(degrees degrees: CGFloat) -> CGFloat {
    return degrees * CGFloat(M_PI) / 180.0
  }
}

// MARK: - Public Interface
extension CircularProgressIndicator {
  
  /**
   Sets the current state of the dial
   
   - parameter completed: The number of objectives completed
   - parameter attempted: The number of objectives attemped
   - parameter animated:  If the dial should animate when updating.
   */
  func setNumberOfObjectivesCompleted(completed: Int, outOf attempted: Int, animated: Bool = true) {
    if completed == 0 || attempted == 0 {
      print("Completed/Attemped cannot be nil"); return
    }
    
    let percentage = Int((Float(completed) / Float(attempted)) * 100)
    
    totalCompletedLabel.text = "\(completed)"
    percentageLabel.attributedText = ThemeManager.TextStyles.WideTextSpacing(textToShow: "\(percentage)%")
    
    totalCompletedLabel.sizeToFit()
    percentageLabel.sizeToFit()
    
    totalCompleted = completed
    totalAttempted = attempted
    
    setNeedsDisplay()
  }
  
  /**
   Sets the font of the main label, by default displaying "COMPLETED"
   
   - parameter font: The font to use
   */
  func setCompletedTitleFont(font: UIFont) {
    completedTitleLabel.font = font
    completedTitleLabel.sizeToFit()
  }
  
  
  /**
   Sets the font for the secondary label, by default showing the total completed
   
   - parameter font: the font to use
   */
  func setTotalCompletedFont(font: UIFont) {
    totalCompletedLabel.font = font
    totalCompletedLabel.sizeToFit()
  }
  
  
  /**
   Set the attributed text of the main label, by default set to "COMPLETED"
   
   - parameter text: The attributed text to use
   */
  func setCompletedLabelAttributedText(text: NSAttributedString) {
    completedTitleLabel.attributedText = text
    completedTitleLabel.sizeToFit()
  }
  
  
  /**
   Set the text of the main label, by default set to "COMPLETED"
   
   - parameter text: The text to use
   */
  func setCompletedLabelText(text: String) {
    completedTitleLabel.text = text
    totalCompletedLabel.sizeToFit()
  }
}
