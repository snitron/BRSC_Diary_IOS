//
//  RoundButton.swift
//  GeoConverter
//
//  Created by bm4 on 06.07.2019.
//  Copyright © 2019 Nitron Apps. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

@IBDesignable
class RoundButton: UIButton {
    public var isLooping = false
    public var isEnabledCustom = false
//    private let loopImage = UIImage(named: "baseline_autorenew_white_48pt")!.withRenderingMode(.alwaysTemplate)
    public var saveImage: UIImage? = nil
  
    lazy var border: UIColor = UIColor("#405F5E")
    lazy var background: UIColor = UIColor("#313153")
    
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    public func setSize(_ v: CGFloat){
        self.constraints.filter({$0.firstAttribute == .height}).first!.constant = v
        self.constraints.filter({$0.firstAttribute == .width}).first!.constant = v
        self.updateConstraints()
        self.cornerRadius = v / 2
    }
}


extension RoundButton { // Main view and Choose language view's button
    
    /*public func startLooping(){
        if(layer.animation(forKey: "rotationAnimation") == nil){
            saveImage = currentImage
            
            setImage(loopImage, for: UIControl.State.normal)
            setImage(loopImage, for: UIControl.State.selected)
            
            let anim = CABasicAnimation(keyPath: "transform.rotation")
            anim.toValue = NSNumber(value: Double.pi * 2)
            anim.duration = 1
            anim.isCumulative = true
            anim.repeatCount = Float.infinity
            
            layer.add(anim, forKey: "rotationAnimation")
            isLooping = true
        }
    }
    
    public func stopLooping(){
        if(layer.animation(forKey: "rotationAnimation") != nil){
            layer.removeAllAnimations()
        }
        setImage(saveImage, for: UIControl.State.normal)
        setImage(saveImage, for: UIControl.State.selected)
        
        isLooping = false
        
    }*/
}

extension RoundButton{ // Subscription view's buttons
    func enable(){
        self.backgroundColor = background
        self.borderColor = border
        self.borderWidth = 2
        self.isEnabledCustom = true
        
        self.setNeedsDisplay()
    }
    
    func disable(){
        self.backgroundColor = UIColor.clear
        self.borderColor = UIColor.clear
        self.isEnabledCustom = false
        
        self.setNeedsDisplay()
    }
}
