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
   
    func onDataReceive(snapshot: AnyObject) -> Void {
        let data = snapshot as! Dictionary<String, AnyObject>
        let tracks = data["tracks"] as! Dictionary<String, AnyObject>
       
        for track in tracks {
            println(track)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.playlistName
        
        let ref = Firebase(url: "https://jkbx.firebaseio.com/party/\(self.playlistName)")
        ref.observeEventType(.Value) { (snapshot) in
//            println(snapshot.value)
            self.onDataReceive(snapshot.value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
