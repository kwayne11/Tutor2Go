//
//  ViewAvailableViewController.swift
//  Tutor2Go
//
//  Created by Kevin Wayne on 1/5/16.
//  Copyright © 2016 Kevin Wayne. All rights reserved.
//

import UIKit

class ViewAvailableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var TableData : Array <String> = Array <String> ()
    var TableDataSubtitle : Array <String> = Array <String> ()
    
    @IBOutlet var myTable: UITableView!

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell : UITableViewCell = myTable.dequeueReusableCellWithIdentifier("CellAvailable", forIndexPath: indexPath)
        
        myCell.textLabel?.text = TableData[indexPath.row]
        myCell.detailTextLabel?.text = TableDataSubtitle[indexPath.row]
        
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowItemSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        myTable.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        TableData.removeAll()
        get_data_from_URL()
        myTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_data_from_URL()
    {
        let myURL = NSURL(string : "http://40.122.160.224/viewTechAvailable.php");
        let request = NSMutableURLRequest(URL: myURL!);
        request.HTTPMethod = "POST";
        
        let postString = "";
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
                    let dataArray : NSArray = parseJSON.valueForKey("Available_Info") as! NSArray
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
                        self.myTable.reloadData()
                    })
                    
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Display alert with confirmation.
                    let myAlert = UIAlertController(title: "Alert", message: "No Technology Available", preferredStyle: UIAlertControllerStyle.Alert);
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
        let upcoming : IndividualAvailableViewController = segue.destinationViewController as! IndividualAvailableViewController
        let indexPath = self.myTable.indexPathForSelectedRow
        
        self.myTable.deselectRowAtIndexPath(indexPath!, animated: true)
        upcoming.ItemString = TableData[indexPath!.row]
        
        
    }
    
    
}