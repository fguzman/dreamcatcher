//
//  JournalViewController.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/12/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController{
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    var paragraph: String!
    var titleText: String!
    var dateText: String!
    var image: UIImage!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = paragraph
        titleLabel.text = titleText
        dateLabel.text = dateText
        backgroundImageView.image = image
        // Do any additional setup after loading the view.
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPressBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
