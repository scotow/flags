//
//  DetailViewController.swift
//  Flags
//
//  Created by Benjamin Lopez on 19/01/2017.
//  Copyright © 2017 Scotow. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var flagView: UIImageView!
    
    var flag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let flagName = flag {
            flagView.image = UIImage(named: flagName)
            
            flagView.layer.borderWidth = 1
            flagView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
