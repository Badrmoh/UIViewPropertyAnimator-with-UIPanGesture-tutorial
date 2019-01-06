//
//  ViewController.swift
//  propertyAnm
//
//  Created by Badr Ibrahim on 29.12.18.
//  Copyright © 2018 Badr Ibrahim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var centerStripe: UIView!
    @IBOutlet weak var topStripe: UIView!
    @IBOutlet weak var secTopStripe: UIView!
    @IBOutlet weak var secBottomStripe: UIView!
    @IBOutlet weak var bottomStripe: UIView!
    
    
    enum color {
        case preAnm
        case postAnm
    }
    
    var animations = [UIViewPropertyAnimator]()
    var hasRotated = false
    var nextColor: color {
        return hasRotated ? .preAnm : .postAnm
    }
    var anmProgress: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.centerStripe.layer.cornerRadius = self.centerStripe.bounds.height/2
        self.topStripe.layer.cornerRadius = self.topStripe.bounds.height/2
        self.secTopStripe.layer.cornerRadius = self.secTopStripe.bounds.height/2
        self.secBottomStripe.layer.cornerRadius = self.secBottomStripe.bounds.height/2
        self.bottomStripe.layer.cornerRadius = self.bottomStripe.bounds.height/2
        setupGesture()
        
    }
    
    func setupGesture(){
        
        self.view.isUserInteractionEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.pan(sender:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc
    func pan(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            panBegan()
       case .changed:
            let change = sender.translation(in: self.view).x
            var fractionComplete = CGFloat(Double(change)/20 * (Double.pi/180))
            fractionComplete = fractionComplete > 0 ? fractionComplete : -fractionComplete
            panChanged(fractionComplete: fractionComplete)
        case .ended:
            panEnded()
        default:
            break
        }
    }
    
    func setupAnimation (duration: TimeInterval, color: color) {
        
        //configure animations
        let centerStripeAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            
            self.centerStripe.transform = CGAffineTransform(rotationAngle: CGFloat(180 * (Double.pi/180)))
            
            switch color {
            case .postAnm:
                self.centerStripe.layer.backgroundColor = UIColor.purple.cgColor
            case .preAnm:
                self.centerStripe.layer.backgroundColor = UIColor.orange.cgColor
            }
            
        }
        
        let topStripeAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.25) {
            
            self.topStripe.transform = CGAffineTransform(rotationAngle: CGFloat(180 * (Double.pi/180)))
            
            switch color {
            case .postAnm:
                self.topStripe.layer.backgroundColor = UIColor.blue.cgColor
            case .preAnm:
                self.topStripe.layer.backgroundColor = UIColor.green.cgColor
            }
            
        }
        
        let secTopStripeAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7) {
            
            self.secTopStripe.transform = CGAffineTransform(rotationAngle: CGFloat(180 * (Double.pi/180)))
            
            switch color {
            case .postAnm:
                self.secTopStripe.layer.backgroundColor = UIColor.orange.cgColor
            case .preAnm:
                self.secTopStripe.layer.backgroundColor = UIColor.blue.cgColor
            }
            
        }
        
        let secBottomStripeAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7) {
            
            self.secBottomStripe.transform = CGAffineTransform(rotationAngle: CGFloat(180 * (Double.pi/180)))
            
            switch color {
            case .postAnm:
                self.secBottomStripe.layer.backgroundColor = UIColor.yellow.cgColor
            case .preAnm:
                self.secBottomStripe.layer.backgroundColor = UIColor.purple.cgColor
            }
            
        }
        
        let bottomStripeAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.25) {
            
            self.bottomStripe.transform = CGAffineTransform(rotationAngle: CGFloat(180 * (Double.pi/180)))
            
            switch color {
            case .postAnm:
                self.bottomStripe.layer.backgroundColor = UIColor.green.cgColor
            case .preAnm:
                self.bottomStripe.layer.backgroundColor = UIColor.yellow.cgColor
            }
            
        }
        
        topStripeAnimation.addCompletion { _ in
            
            self.topStripe.transform = CGAffineTransform.identity
            self.secTopStripe.transform = CGAffineTransform.identity
            self.secBottomStripe.transform = CGAffineTransform.identity
            self.bottomStripe.transform = CGAffineTransform.identity
            self.centerStripe.transform = CGAffineTransform.identity
            
            self.animations.removeAll()
            
            self.hasRotated = !self.hasRotated
        }
        
        secTopStripeAnimation.addCompletion { _ in
            
            self.animations.removeAll()
            
            self.animations.append(topStripeAnimation)
            self.animations.append(bottomStripeAnimation)
            
            for anm in self.animations {
                anm.startAnimation()
            }
            
        }
        /*
        secBottomStripeAnimation.addCompletion { _ in
            
        }
        
        bottomStripeAnimation.addCompletion { _ in
            
        }
        */
        centerStripeAnimation.addCompletion { _ in

            self.animations.removeAll()
            
            self.animations.append(secTopStripeAnimation)
            self.animations.append(secBottomStripeAnimation)
            for anm in self.animations {
                anm.startAnimation()
            }
        }
        
        animations.append(centerStripeAnimation)
        
        for anm in animations {
            anm.startAnimation()
        }
        
        
    }
    
    func panBegan() {
        
        if animations.isEmpty {
            setupAnimation(duration: 1.5, color: nextColor)
        }
        
        for anm in animations {
            anm.pauseAnimation()
            self.anmProgress = anm.fractionComplete
        }
        
    }
    
    func panChanged(fractionComplete: CGFloat) {
        
        for anm in animations {
            anm.fractionComplete = self.anmProgress + fractionComplete
        }
    }
    
    func panEnded (){
        for anm in animations {
            anm.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }


}

