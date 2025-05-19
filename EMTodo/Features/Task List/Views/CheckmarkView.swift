
import UIKit

class CheckmarkView: UIView {
    
    var isSelected: Bool = false { didSet { animateCheckmarkSelection() } }
    
    private let backgroundLayer: CAShapeLayer = CAShapeLayer()
    private let foregroundLayer: CAShapeLayer = CAShapeLayer()
    private let checkmarkLayer: CAShapeLayer = CAShapeLayer()
    
    private let lineWidth: CGFloat = 2
    private var radius: CGFloat {
        return min(bounds.width, bounds.height) / 2
    }
    
    var checkmarkBackgroundColor: UIColor = .systemGray4
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.tintColor = UIColor.systemYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer)
        layer.addSublayer(checkmarkLayer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateBackgroundLayer()
        updateForegroundLayer()
        updateCheckmarkPath()
    }
    
    private func updateBackgroundLayer() {
        backgroundLayer.path = getBackgroundPath()
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = checkmarkBackgroundColor.cgColor
    }
    
    private func updateForegroundLayer() {
        foregroundLayer.path = getBackgroundPath()
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = tintColor.cgColor
    }
    
    private func updateCheckmarkPath() {
        checkmarkLayer.path = getCheckmarkPath()
        checkmarkLayer.lineWidth = lineWidth
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.strokeColor = tintColor.cgColor
    }
    
    private func getBackgroundPath() -> CGPath {
        let path = UIBezierPath(roundedRect: getMiddleSquare(), cornerRadius: radius - lineWidth)
        return path.cgPath
    }
    
    private func getMiddleSquare() -> CGRect {
        let x = self.bounds.midX - radius
        let y = self.bounds.midY - radius
        let width = radius * 2
        let height = radius * 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func getCheckmarkPath() -> CGPath {
        let square = getMiddleSquare()
        let width = square.width
        let height = square.height
        let point1 = CGPoint(x: width / 4, y: square.midY)
        let point2 = CGPoint(x: width * (5/12), y: height * (2/3))
        let point3 = CGPoint(x: width * (3/4), y: height * (1/3))
        
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        
        
        return path.cgPath
    }
    
    private func animateCheckmarkSelection() {
        animateForeground()
        animateCheckmark()
    }
    
    private func animateForeground() {
        let targetValue = isSelected ? 1.0 : 0
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = foregroundLayer.strokeEnd
        anim.toValue = targetValue
        anim.duration = 0.6
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        foregroundLayer.add(anim, forKey: "strokeEnd")
        foregroundLayer.strokeEnd = targetValue
    }
    
    private func animateCheckmark() {
        let targetValue = isSelected ? 1.0 : 0
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = checkmarkLayer.strokeEnd
        anim.toValue = targetValue
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        checkmarkLayer.add(anim, forKey: "strokeEnd")
        checkmarkLayer.strokeEnd = targetValue
    }
}
