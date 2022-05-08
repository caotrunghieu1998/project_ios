//
//  MainController.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 06/05/2022.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet weak var lblToken: UILabel!
    public var token:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = self.token{
            lblToken.text = token
        }
    }
}
