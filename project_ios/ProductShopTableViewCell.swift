//
//  ProductShopTableViewCell.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 24/05/2022.
//

import UIKit

class ProductShopTableViewCell: UITableViewCell {
    
    // Properties
    var productId:Int = -1
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
