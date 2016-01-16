//
//  DetailViewController.swift
//  Flicks
//
//  Created by Juliang Li on 1/15/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var detailView: UIView!
    var movie: NSDictionary!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide tab bar
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: detailView.frame.origin.y + scrollView.frame.height)
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let rate = String(movie["vote_average"]!)
        //images may not be available
        if let posterPath = movie["poster_path"] as? String{
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterView.setImageWithURL(imageUrl!)
        }else{
            posterView.setImageWithURL(NSURL(string:"https://browshot.com/static/images/not-found.png")!)
        }
        titleLabel.text = title
        rateLabel.text = "Rate: \(rate)"
        self.overview.text = overview
        self.overview.sizeToFit()
        self.title = title
        // Do any additional setup after loading the view.
        networkRequestForReleaseDate()
        networkRequestForReview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //get release date and review
    func networkRequestForReleaseDate(){
        let apiKey = "21b5cd324e05edc8b55883d7350ec7e3"
        let movieId = movie["id"]!
        let url = "http://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)"
        let request = NSURLRequest(URL: NSURL(string: url)!)
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
                            
                        self.releaseLabel.text = "Release Date: \(responseDictionary["release_date"] as! String)"
                    }
                }else{
                    NSLog("Network Error")
                    let alert = UIAlertController(title: nil, message: "NetWork Error", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                    self.presentViewController(alert,animated: true,completion: nil)
                }
        });
        task.resume()
    }
    
    func networkRequestForReview(){
        let apiKey = "21b5cd324e05edc8b55883d7350ec7e3"
        let movieId = movie["id"]!
        let url = "http://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=\(apiKey)"
        let request = NSURLRequest(URL: NSURL(string: url)!)
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
                            if let reviews = responseDictionary["results"] as? [NSDictionary]{
                                if reviews.count != 0{
                                    self.reviewLabel.text = "Review:\n \(reviews[0]["content"] as! String)"
                                    print(reviews[0]["content"])
                                }
                            }
                    }
                }else{
                    NSLog("Network Error")
                    let alert = UIAlertController(title: nil, message: "NetWork Error", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                    self.presentViewController(alert,animated: true,completion: nil)
                }
        });
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController!.tabBar.hidden = true
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

}
