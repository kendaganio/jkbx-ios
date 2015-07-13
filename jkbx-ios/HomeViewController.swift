//
//  HomeViewController.swift
//  
//
//  Created by Ken-Lauren Daganio on 7/13/15.
//
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var playlistTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onJoinButtonPressed(sender: AnyObject) {
        if playlistTextField.text == "" {
            var alert = UIAlertController(title: "Oops!", message: "Put in a playlist...", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("toNavigation", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! UINavigationController
        let tabs = dest.viewControllers[0] as! UITabBarController
        let playlist = tabs.viewControllers![0] as! PlaylistIndexViewController
        
        playlist.playlistName = self.playlistTextField.text
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
