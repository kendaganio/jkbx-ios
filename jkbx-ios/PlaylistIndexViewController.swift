//
//  PlaylistIndexViewController.swift
//  jkbx-ios
//
//  Created by Ken-Lauren Daganio on 7/13/15.
//  Copyright (c) 2015 Ken-Lauren Daganio. All rights reserved.
//

import UIKit

class PlaylistIndexViewController: UIViewController {

    var playlistName: String = ""
    var tracks = [Track]()
 
    func onDataReceive(snapshot: AnyObject) -> Void {
        println(snapshot)
        let data = snapshot as! Dictionary<String, AnyObject>
        if let tracks = data["tracks"] as? Dictionary<String, AnyObject> {
            let sortedTracks = sorted(tracks) { $0.0 < $1.0 }
            for (id, track) in sortedTracks {
                let t = Track(id: id, title: track["title"] as! String, addedBy: track["addedBy"] as! String, thumbnail: track["img"] as! String)
              
                println(t.props())
                self.tracks.append(t)
            }
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.playlistName
        
        let ref = Firebase(url: "https://jkbx.firebaseio.com/party/\(self.playlistName)")
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

}
