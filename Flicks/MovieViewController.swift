//
//  MovieViewController.swift
//  Flicks
//
//  Created by Juliang Li on 1/14/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import AFNetworking
import BFRadialWaveHUD

class MovieViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var loadingView: BFRadialWaveHUD!
    var filteredMovies: [NSDictionary]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        //initialize refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //initialize loading view
        loadingView = BFRadialWaveHUD(view: tableView, fullScreen: true, circles: BFRadialWaveHUD_DefaultNumberOfCircles, circleColor: nil, mode: BFRadialWaveHUDMode.Default, strokeWidth: BFRadialWaveHUD_DefaultCircleStrokeWidth)
        // Do any additional setup after loading the view.
        loadingView.blurBackground = true
        loadData()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let _ = filteredMovies{
            return filteredMovies!.count
        }else{
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        //images may not be available
        if let posterPath = movie["poster_path"] as? String{
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURLRequest(NSURLRequest(URL: imageUrl!), placeholderImage: nil, success: {
                (request,response,image) in
                cell.posterView.image = image
                cell.posterView.alpha = 0.0
                UIView.animateWithDuration(1.0, animations: {cell.posterView.alpha = 1.0})
                }, failure: nil)
        }else{
            cell.posterView.setImageWithURL(NSURL(string:"https://browshot.com/static/images/not-found.png")!)
        }
        cell.titleLabel.text = title
        cell.overview.text = overview
        
        return cell
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMovies = searchText.isEmpty ? movies! : movies!.filter({ (dict) -> Bool in
                let title = dict["title"] as! String
                return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
        
        tableView.reloadData()
    }
    
    func loadData(){
        loadingView.showWithMessage("Loading...")
        let apiKey = "21b5cd324e05edc8b55883d7350ec7e3"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("loading Data")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.tableView.reloadData()
                            
                    }
                }else{
                    NSLog("Network Error")
                    let alert = UIAlertController(title: nil, message: "NetWork Error", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                    self.presentViewController(alert,animated: true,completion: nil)
                }
        });
        task.resume()
        loadingView.dismiss()
    }
    /**
     * end refresh either when finish loading or connect to network over 2 secs
     */
    func onRefresh(){
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
        loadData()
        refreshControl.endRefreshing()
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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
