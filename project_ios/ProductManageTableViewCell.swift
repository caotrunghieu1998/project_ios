//
//  ProductManageTableViewCell.swift
//  Et O Et Coffee Manager
//
//  Created by Vo Thanh Dat on 25/05/2022.
//

import UIKit

class ProductManageTableViewCell: UITableViewCell {

    // Properties
    var userToken = ""
    var id:Int = -1
    var type:String = ""
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var switchActive: UISwitch!
    
    private let callApi:CallAPI = CallAPI()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func activeOrDeactiveProduct(_ sender: Any) {
        let isSuccess = self.callApi.CallApiChangeProductStatus(token: self.userToken, id: self.id)
        if isSuccess == false{
            self.switchActive.isOn = !self.switchActive.isOn
        }
    }
}
