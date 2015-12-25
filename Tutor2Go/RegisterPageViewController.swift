//
//  RegisterPageViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 12/22/15.
//  Copyright © 2015 Kevin Wayne. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {
    @IBOutlet var userEmailTextField: UITextField!
    @IBOutlet var userPasswordTextField: UITextField!
    @IBOutlet var repeatPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let repeatPassword = repeatPasswordTextField.text;
        
        // Check for empty fields
        if(userEmail!.isEmpty || userPassword!.isEmpty || repeatPassword!.isEmpty)
        {
            // Display Alert Message
            displayMyAlertMessage("All Fields Are Required!");
            return;
        }
        
        // Check if passwords match
        if(userPassword != repeatPassword)
        {
            // Display Alert Message
            displayMyAlertMessage("Passwords Entered Do Not Match!");
            return;
        }
        
        // Store Data
        let myURL = NSURL(string: "http://40.78.144.135/register.php");
        let request = NSMutableURLRequest(URL: myURL!);
        request.HTTPMethod = "POST";
        
        let postString = "username=\(userEmail!)&password=\(userPassword!)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            if (error != nil)
            {
                print("error=\(error)")
                return
            }
            
            //Let’s convert response sent from a server side script to a NSDictionary object:
            
            //var err: ErrorType?;
            var myJSON: NSDictionary?;
            do {
                
                myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary;
                
            }
            catch {
                // failure
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            
            if let parseJSON = myJSON {
                let resultValue = parseJSON["status"] as? String
                print("result: \(resultValue)");
                
                var isUserRegistered:Bool = false;
                if(resultValue=="Success")
                {
                    isUserRegistered = true;
                }
                
                var messageToDisplay:String = parseJSON["message"] as! String;
                if(!isUserRegistered)
                {
                    messageToDisplay = parseJSON["message"] as! String;
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Display alert with confirmation.
                    let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
                    self.presentViewController(myAlert, animated: true, completion: nil)
                })
                
                
            }
            
        }
        
        task.resume()
        
        
        
        // Display confirmation message to user
        displayMyAlertMessage("Registration is completed.  Thank you for registering!");
    }
    
    func displayMyAlertMessage(msg: String) {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
