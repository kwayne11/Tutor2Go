//
//  IndividualAvailableViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 1/5/16.
//  Copyright © 2016 Kevin Wayne. All rights reserved.
//

import UIKit

class IndividualAvailableViewController: UIViewController {

    @IBOutlet var ItemAvailableName: UILabel!
    //@IBOutlet var ItemName: UILabel!
    @IBOutlet var CheckItemOutButton: UIButton!
    
    var ItemString : String!
    var ItemID : String!
    //var DateCheckedOut : String!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.CheckItemOutButton.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Purple.png")!)
        self.ItemAvailableName.text = ItemString
        
        let myURL = NSURL(string : "http://40.122.160.224/getAvailableTechID.php");
        let request = NSMutableURLRequest(URL: myURL!);
        request.HTTPMethod = "POST";
        let TID : NSString! = "\(ItemString)"
        let postString = "tech_name=\(TID!)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
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
                print("resultGet: \(resultValue!)");
                
                if(resultValue! == 1)// 1 if successful, 0 if not successful
                {
                    let dataArray : NSArray = parseJSON.valueForKey("User_Info") as! NSArray
                    for(var i = 0; i < dataArray.count; i++)
                    {
                        let techItem: String? = dataArray[i].valueForKey("tech_id") as? String
                        print("techItemID: \(techItem!)");
                        self.ItemID = techItem
 
                        dispatch_async(dispatch_get_main_queue()) {
                            self.CheckItemOutButton.enabled = true
                        }

                        
                    }
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Display alert with confirmation.
                    let myAlert = UIAlertController(title: "Alert", message: "No Technology Checked Out", preferredStyle: UIAlertControllerStyle.Alert);
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                        self.dismissViewControllerAnimated(true, completion: nil);
                    }
                    myAlert.addAction(okAction);
                    
                    self.presentViewController(myAlert, animated: true, completion: nil)
                })
                
            }
            
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CheckItemOutTapped(sender: AnyObject) {
        
        //Get ID for Item
        print(ItemID)
        
        let myURL = NSURL(string : "http://40.122.160.224/CheckTechOut.php");
        let request = NSMutableURLRequest(URL: myURL!);
        request.HTTPMethod = "POST";
        let TID : NSString! = "\(ItemID)"
        let TuID = NSUserDefaults.standardUserDefaults().valueForKey("tutorID")
        let postString = "tech_id=\(TID!)&tutor_id=\(TuID!)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
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
                
                if(resultValue! == 1)// 1 if successful, 0 if not successful
                {
                    
                    let messageToDisplay:String = parseJSON["message"] as! String;
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        // Display alert with confirmation.
                        let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                            self.dismissViewControllerAnimated(true, completion: nil);
                        }
                        myAlert.addAction(okAction)
                        
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    })
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Display alert with confirmation.
                    let myAlert = UIAlertController(title: "Alert", message: "No Technology Checked Out", preferredStyle: UIAlertControllerStyle.Alert);
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

