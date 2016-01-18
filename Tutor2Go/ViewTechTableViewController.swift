//
//  ViewTechTableViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 12/29/15.
//  Copyright © 2015 Kevin Wayne. All rights reserved.
//

import UIKit

class ViewTechViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var TableData : Array <String> = Array <String> ()
    var TableDataSubtitle : Array <String> = Array <String> ()
    
    
    @IBOutlet var myTableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell : UITableViewCell = myTableView.dequeueReusableCellWithIdentifier("prototype1", forIndexPath: indexPath)
        
        myCell.textLabel?.text = TableData[indexPath.row]
        myCell.detailTextLabel?.text = TableDataSubtitle[indexPath.row]
        
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowViewSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get_data_from_URL();
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        TableData.removeAll()
        get_data_from_URL()
        myTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_data_from_URL()
    {
        let myURL = NSURL(string : "http://40.122.160.224/viewTechCheckedOut.php");
        let request = NSMutableURLRequest(URL: myURL!);
        request.HTTPMethod = "POST";
        let TID = NSUserDefaults.standardUserDefaults().valueForKey("tutorID")
        let postString = "tutor_id=\(TID!)";
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

                if(resultValue! == 1)// 1 if successful, 0 if not successful
                {
                    let dataArray : NSArray = parseJSON.valueForKey("Checkout_Info") as! NSArray
                    for(var i = 0; i < dataArray.count; i++)
                    {
                        let techItem: String? = dataArray[i].valueForKey("tech_name") as? String
                        let techKind: String? = dataArray[i].valueForKey("tech_kind") as? String
                        self.TableData.append(techItem!)
                        self.TableDataSubtitle.append(techKind!)
                        print("techItem: \(techItem!)");
                        print("techKind: \(techKind!)");
                    }

                    //Reload the table with the updated information
                    dispatch_async(dispatch_get_main_queue(), {
                        self.myTableView.reloadData()
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
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let upcoming : IndividualTechItemViewController = segue.destinationViewController as! IndividualTechItemViewController
        let indexPath = self.myTableView.indexPathForSelectedRow
        
        self.myTableView.deselectRowAtIndexPath(indexPath!, animated: true)
        upcoming.ItemString = TableData[indexPath!.row]
        
        
    }
    

}
