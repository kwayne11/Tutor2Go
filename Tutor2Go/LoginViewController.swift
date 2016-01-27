//
//  LoginViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 12/22/15.
//  Copyright © 2015 Kevin Wayne. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ECU.PNG")!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReturnToLoginViewController(segue:UIStoryboardSegue) {
    }

    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        // Check if both text fields were filled out
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            //displayMyAlertMessage("Please fill in both the Pirate ID and Password!")
            SCLAlertView().showError("Login Error", subTitle: "Please fill in both the Pirate ID and Password") // Error
        }
        else
        {
            let myURL = NSURL(string: "http://40.122.160.224/login.php");
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
                    print("result: \(resultValue!)");
                    let dataArray : NSArray = parseJSON.valueForKey("User_Info") as! NSArray
                    let tutorID: String? = dataArray[0].valueForKey("tutor_id") as? String

                    print("tutorID: \(tutorID!)");
                    
                    if(resultValue! == 1)// 1 if successful, 0 if not successful
                    {
                        
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().setObject(tutorID!, forKey: "tutorID")
                        NSUserDefaults.standardUserDefaults().synchronize()

                        self.dismissViewControllerAnimated(true, completion: nil)

                    }
                    //else
                    //{
                        //SCLAlertView().showError("Login Error", subTitle: "Please fill in both the Pirate ID and Password") // Error
                    //}
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        // Display alert with confirmation.
                        let myAlert = UIAlertController(title: "Alert", message: "Incorrect Login Credentials", preferredStyle: UIAlertControllerStyle.Alert);
                        
                        //let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                            self.dismissViewControllerAnimated(true, completion: nil);
                        }
                        myAlert.addAction(okAction);
                        
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    })

                }
                
            }
            task.resume()
        }
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
