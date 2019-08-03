//
//  ViewController.swift
//  AlertFactory
//
//  Created by brennoumobi on 08/03/2019.
//  Copyright (c) 2019 brennoumobi. All rights reserved.
//

import UIKit
import AlertFactory

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            self?.presentUIAlertController()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentUIAlertController() {
        AlertFactory<UIAlertController>(viewController: self)
            .with(title: "Hello World!")
            .with(text: "This is the message to share to the world")
            .cancelButton(title: "Cancel")
            .otherButton(title: "Say Bye", onTap: { [weak self] in
                self?.sayBye()
            }).present()
    }
    
    func sayBye() {
        AlertFactory<UIAlertController>(viewController: self)
            .with(title: "Bye!")
            .present()
    }
}

