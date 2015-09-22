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
    var searchBar: UISearchBar!
    var searchItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializing the search bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        //adding search bar to the navigation bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
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
        let searchTerm = self.searchItem ?? "Restaurants"
        Business.searchWithTerm(searchTerm, completion: { (businesses: [Business]!, error: NSError!) -> Void in
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
        let deals = filters["deals"] as? Bool
        
        let sort = filters["sort"] as? Int
        var sortYelp:YelpSortMode?
        if sort != nil {
            sortYelp = YelpSortMode(rawValue: sort! + 1)
        }
        let searchTerm = self.searchItem ?? "Restaurants"
        Business.searchWithTerm(searchTerm, sort: sortYelp, categories: categories, deals: deals) { (businesses, error) -> Void in
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

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchItem = searchBar.text as String?
        searchBar.resignFirstResponder()
        callYelpApi()
    }
}
