//
//  PlayedTracksViewController.swift
//  jkbx-ios
//
//  Created by Ken-Lauren Daganio on 7/18/15.
//  Copyright (c) 2015 Ken-Lauren Daganio. All rights reserved.
//

import UIKit

class PlayedTracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var playedTracksTableView: UITableView!
    var playedTracks = [Track]()
   
    func onDataReceive(snapshot: AnyObject) {
        self.playedTracks = [Track]() // reset all tracks!
        let data = snapshot as! Dictionary<String, AnyObject>
        if let tracks = data["playedTracks"] as? Dictionary<String, AnyObject> {
            let sortedTracks = sorted(tracks) { $0.0 < $1.0 }
            
            for (id, track) in sortedTracks {
                let t = Track(id: id, title: track["title"] as! String, addedBy: track["addedBy"] as! String, thumbnail: track["img"] as! String)
                self.playedTracks.append(t)
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.playedTracksTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let playlist = appDelegate.playlist
        // Do any additional setup after loading the view.
        let ref = Firebase(url: "https://jkbx.firebaseio.com/party/\(playlist!)/")
        ref.observeEventType(.Value) { (snapshot) in
            self.onDataReceive(snapshot.value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playedTracks.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = self.playedTracks[indexPath.row]
        var confirmation = UIAlertController(title: "Requeue?", message: "\(track.title)", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmation.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Ok logic here")
        }))
        
        confirmation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Nothing to do here!")
        }))
        
        presentViewController(confirmation, animated: true, completion: nil)
        
        println(track.props())
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("playedTrack") as! TrackTableViewCell
        let track = self.playedTracks[indexPath.row]
        
        cell.thumbnail?.image = track.getImage()
        cell.trackTitle?.text = track.title
        
        return cell
    }

}
