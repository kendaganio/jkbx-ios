//
//  SearchViewController.swift
//  jkbx-ios
//
//  Created by Ken-Lauren Daganio on 7/20/15.
//  Copyright (c) 2015 Ken-Lauren Daganio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchedTracks = [Track]()
    var ref: Firebase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let playlist = appDelegate.playlist
        self.ref = Firebase(url: "https://jkbx.firebaseio.com/party/\(playlist!)/tracks")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func debounce(delay:NSTimeInterval, queue:dispatch_queue_t, action: (()->()) ) -> ()->() {
        var lastFireTime:dispatch_time_t = 0
        let dispatchDelay = Int64(delay * Double(NSEC_PER_SEC))
        
        return {
            lastFireTime = dispatch_time(DISPATCH_TIME_NOW,0)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, dispatchDelay), queue) {
                let now = dispatch_time(DISPATCH_TIME_NOW,0)
                let when = dispatch_time(lastFireTime, dispatchDelay)
                if now >= when {
                    action()
                }
            }
        }
    }
    
    func youtubeSearch(searchText: String) {
//        let searchText = searchBarView.text
        let escapedString = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let searchUrl = "https://content.googleapis.com/youtube/v3/search?part=snippet&q=\(escapedString!)&type=video&key=AIzaSyD0kYfb-et-hNuLKF0x55eMHxPq_ksbWr0"
        Alamofire.request(.GET, searchUrl).responseJSON { _, _, response, _ in
            self.searchedTracks = [Track]()
            let data = JSON(response!)
           
            if let items = data["items"].array {
                for item in items {
                    let id = item["id"]["videoId"].string!
                    let snippet = item["snippet"]
                    
                    let t = Track(id: id, title: snippet["title"].string!, addedBy: "iOS", thumbnail: "https://i.ytimg.com/vi/\(id)/default.jpg")
                    
                    println(t.props())
                    self.searchedTracks.append(t)
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.searchTableView.reloadData()
            }
        }
    }

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 3 {
            youtubeSearch(searchText)
        }
    }
   
    
    // table stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedTracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResults") as! TrackTableViewCell
        let track = self.searchedTracks[indexPath.row]
        
        cell.thumbnail?.image = track.getImage()
        cell.trackTitle?.text = track.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = self.searchedTracks[indexPath.row]
        let newTrack = self.ref?.childByAutoId()
        newTrack?.setValue(track.toDict())
        
        var alert = UIAlertController(title: "Yay!", message: "\(track.title) added to queue.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        self.resignFirstResponder()
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
