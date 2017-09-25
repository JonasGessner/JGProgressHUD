//
//  ViewController.swift
//  JGProgressHUD-Tests-Swift
//
//  Created by Jonas Gessner on 25.09.17.
//  Copyright © 2017 Jonas Gessner. All rights reserved.
//

import UIKit
import JGProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Simple example in Swift. See JGProgressHUD-Tests for more examples"
        hud.show(in: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

