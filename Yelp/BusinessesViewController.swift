//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {

    @IBOutlet weak var searchResultsTableView: UITableView!
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        self.searchResultsTableView.estimatedRowHeight = 120
        callYelpApi()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if businesses != nil {
            return businesses!.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = searchResultsTableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }
    
    func callYelpApi(){
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.searchResultsTableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        //        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        //            self.businesses = businesses
        //
        //            for business in businesses {
        //                print(business.name!)
        //                print(business.address!)
        //            }
        //        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) { (businesses, error) -> Void in
            self.businesses = businesses
            self.searchResultsTableView.reloadData()
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
