//
//  PlaylistIndexViewController.swift
//  jkbx-ios
//
//  Created by Ken-Lauren Daganio on 7/13/15.
//  Copyright (c) 2015 Ken-Lauren Daganio. All rights reserved.
//

import UIKit
import MaterialKit

class PlaylistIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var trackTableView: UITableView!
    var playlistName: String = ""
    
    // all tracks collection
    var ref: Firebase?
    var tracks = [Track]()
   
    // now playing stuff
    var nowPlaying: Track?
    @IBOutlet weak var nowPlayingImage: UIImageView!
    @IBOutlet weak var nowPlayingTitle: UILabel!
 
    @IBOutlet var addButton: MKButton!
    
    @IBAction func onControlsPressed(sender: UIButton) {
        let PAUSE_BUTTON = 1
        let PLAY_BUTTON = 2
        let NEXT_BUTTON = 3
        
        var action = ""
        var controlsRef = self.ref?.childByAppendingPath("controls")
        
        switch(sender.tag) {
        case PAUSE_BUTTON:
            action = "pause"
            break;
        case PLAY_BUTTON:
            action = "play"
            break;
        case NEXT_BUTTON:
            action = "skip"
            break;
        default: break;
        }
        
        var command = ["action": action, "time": Int(NSDate().timeIntervalSince1970)]
        controlsRef?.setValue(command)
    }
    
    func onDataReceive(snapshot: AnyObject) -> Void {
        self.tracks = [Track]() // reset all tracks!
        let data = snapshot as! Dictionary<String, AnyObject>
        if let tracks = data["tracks"] as? Dictionary<String, AnyObject> {
            var sortedTracks = sorted(tracks) { $0.0 < $1.0 }
       
            // if first track is playing
            if sortedTracks[0].1["playing"] as! Int == 1 {
                let id = sortedTracks[0].0
                let first: AnyObject = sortedTracks[0].1
                sortedTracks.removeAtIndex(0)
                
                self.nowPlaying = Track(id: id, title: first["title"] as! String, addedBy: first["addedBy"] as! String, thumbnail: first["img"] as! String)
                
                nowPlayingImage.image = self.nowPlaying?.getImage()
                nowPlayingTitle.text = self.nowPlaying?.title
            } else {
                nowPlayingTitle.text = "No track playing."
            }
            
            for (id, track) in sortedTracks {
                let t = Track(id: id, title: track["title"] as! String, addedBy: track["addedBy"] as! String, thumbnail: track["img"] as! String)
                self.tracks.append(t)
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.trackTableView.reloadData()
        }
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.playlistName
       
        addButton.maskEnabled = false
        addButton.backgroundLayerCornerRadius = 35
        
        addButton.layer.shadowOpacity = 0.75
        addButton.layer.shadowRadius = 1.5
        addButton.layer.shadowColor = UIColor.blackColor().CGColor
        addButton.layer.shadowOffset = CGSize(width: 1.0, height: 3.5)
        
        self.ref = Firebase(url: "https://jkbx.firebaseio.com/party/\(self.playlistName)")
        self.ref?.observeEventType(.Value) { (snapshot) in
            self.onDataReceive(snapshot.value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.tracks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("track") as! TrackTableViewCell
        let track = self.tracks[indexPath.row]
        
        cell.thumbnail?.image = track.getImage()!
        cell.trackTitle?.text = "\(track.title) - \(track.addedBy)"
        
        return cell
    }
}
