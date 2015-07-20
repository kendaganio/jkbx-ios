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
    var tracks = [Track]()
 
    @IBOutlet var addButton: MKButton!
    
    func onDataReceive(snapshot: AnyObject) -> Void {
        self.tracks = [Track]() // reset all tracks!
        //let data = snapshot as! Dictionary<String, AnyObject>
        if let tracks = snapshot as? Dictionary<String, AnyObject> {
            let sortedTracks = sorted(tracks) { $0.0 < $1.0 }
            
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
        
        let ref = Firebase(url: "https://jkbx.firebaseio.com/party/\(self.playlistName)/tracks")
        ref.observeEventType(.Value) { (snapshot) in
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
