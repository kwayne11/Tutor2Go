//
//  IndividualTechItemViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 12/30/15.
//  Copyright © 2015 Kevin Wayne. All rights reserved.
//

import UIKit
import SCLAlertView
import ANLongTapButton

class IndividualTechItemViewController: UIViewController {

    @IBOutlet var ItemName: UILabel!
    @IBOutlet var TimeCheckedOut: UILabel!
    @IBOutlet var CheckItemInButton: ANLongTapButton!
    //@IBOutlet var CheckItemInButton: UIButton!
    
    var ItemString : String!
    var ItemID : String!
    var DateCheckedOut : String!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //self.CheckItemInButton.enabled = false
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Purple.png")!)
        self.ItemName.text = ItemString
        
        let myURL = NSURL(string : "http://40.122.160.224/getTechID.php");
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
                print("result: \(resultValue!)");
                
                if(resultValue! == 1)// 1 if successful, 0 if not successful
                {
                    let dataArray : NSArray = parseJSON.valueForKey("User_Info") as! NSArray
                    for(var i = 0; i < dataArray.count; i++)
                    {
                        let techItem: String? = dataArray[i].valueForKey("tech_id") as? String

                        let techDate: String? = dataArray[i].valueForKey("time_checked_out") as? String

                        print("techItemID: \(techItem!)");
                        print("techDate: \(techDate!)");
                        self.ItemID = techItem
                        self.DateCheckedOut = techDate
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.TimeCheckedOut.text = "Time Checked Out: \(self.DateCheckedOut) "
                            //self.CheckItemInButton.enabled = true
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
        //self.CheckItemInButton.enabled = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnCheckItemInButtonPressed(longTapButton: ANLongTapButton) {
        
        longTapButton.didTimePeriodElapseBlock = { () -> Void in
            let myURL = NSURL(string : "http://40.122.160.224/CheckTechIn.php");
            let request = NSMutableURLRequest(URL: myURL!);
            request.HTTPMethod = "POST";
            let TID : NSString! = "\(self.ItemID)"
            let postString = "tech_id=\(TID!)";
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
                        
                        //let messageToDisplay:String = parseJSON["message"] as! String;
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            SCLAlertView().showNotice("Success!", subTitle: "You have checked back in '\(self.ItemString)'") // Notice
                            self.dismissViewControllerAnimated(true, completion: nil)
                            /*
                            // Display alert with confirmation.
                            let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                            self.dismissViewControllerAnimated(true, completion: nil);
                            }
                            myAlert.addAction(okAction)
                            
                            self.presentViewController(myAlert, animated: true, completion: nil)
                            */
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
