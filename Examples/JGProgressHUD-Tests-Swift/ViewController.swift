//
//  ViewController.swift
//  JGProgressHUD-Tests-Swift
//
//  Created by Jonas Gessner on 25.09.17.
//  Copyright © 2017 Jonas Gessner. All rights reserved.
//

import UIKit
import JGProgressHUD

final class GradientView: UIView {
    init(startColor: UIColor, endColor: UIColor) {
        super.init(frame: .zero)
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.0, 1.0]
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

final class ViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func loadView() {
        self.view = GradientView(startColor: UIColor(rgb: 0x24C6DC), endColor: UIColor(rgb: 0x514A9D))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.showPieHUD()
        }
    }
    
    func showSimpleHUD() {
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Simple example in Swift"
        hud.detailTextLabel.text = "See JGProgressHUD-Tests for more examples"
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.show(in: self.view)
    }
    
    func showHUDWithTransform() {
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading..."
        hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 30.0)
                hud.textLabel.text = "Done"
                hud.position = .bottomCenter
            }
        }
        
        hud.dismiss(afterDelay: 4.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.showSimpleHUD()
        }
    }
    
    func showPieHUD() {
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.detailTextLabel.text = "0% Complete"
        hud.textLabel.text = "Downloading..."
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.incrementHUD(hud, progress: 0)
        }
    }
    
    func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
        let progress = previousProgress + 1
        hud.progress = Float(progress)/100.0
        hud.detailTextLabel.text = "\(progress)% Complete"
        
        if progress == 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                UIView.animate(withDuration: 0.1, animations: {
                    hud.textLabel.text = "Success"
                    hud.detailTextLabel.text = nil
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                
                hud.dismiss(afterDelay: 1.0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.showHUDWithTransform()
                }
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
                self.incrementHUD(hud, progress: progress)
            }
        }
    }
}
