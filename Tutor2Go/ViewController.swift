//
//  ViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 12/20/15.
//  Copyright © 2015 Kevin Wayne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   // MARK: Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    override func viewDidAppear(animated: Bool) {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if(!isUserLoggedIn)
        {
            self.performSegueWithIdentifier("LoginViewSegue", sender: self);
        }
        else
        {
            self.performSegueWithIdentifier("UserHomeSegue", sender: self);
        }
    }
}

