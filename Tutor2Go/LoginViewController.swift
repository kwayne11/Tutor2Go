//
//  LoginViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 12/22/15.
//  Copyright © 2015 Kevin Wayne. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        // Check if both text fields were filled out
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            displayMyAlertMessage("Please fill in both the Pirate ID and Password!")
        }
        
        let myURL = NSURL(string: "http://40.78.144.135/login.php");
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
            
            var myJSON: NSDictionary?;
            do {
                
                myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary;
                
            }
            catch {
                // failure
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            
            if let parseJSON = myJSON {
                let resultValue = parseJSON["success"] as? Int
                print("result: \(resultValue)");
                
                if(resultValue! == 1)// 1 if successful, 0 if not successful
                {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()

                    self.dismissViewControllerAnimated(true, completion: nil)

                }
                else
                {
                    self.displayMyAlertMessage("Incorrect Login Credentials")
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Display alert with confirmation.
                    let myAlert = UIAlertController(title: "Alert", message: "Incorrect Login Credentials", preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
                    self.presentViewController(myAlert, animated: true, completion: nil)
                })

            }
            
        }
        
        task.resume()
        
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
