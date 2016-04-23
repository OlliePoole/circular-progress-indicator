//
//  ObjectivesCompletedView.swift
//  appy
//
//  Created by Oliver Poole on 25/02/2016.

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
    totalCompletedLabel.font = ThemeManager.Fonts.Light(56)
    addSubview(totalCompletedLabel)
    
    percentageLabel.font = ThemeManager.Fonts.Book(20)
    percentageLabel.alpha = 0.5
    addSubview(percentageLabel)
    
    addConstraints()
  }
  
  override func drawRect(rect: CGRect) {
    // Draw dial
    let center = CGPointMake(rect.width / 2, rect.height / 2)
    let radius = (rect.width / 2) - 30 // for some side padding
    
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
extension ObjectivesCompletedView {
  
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
