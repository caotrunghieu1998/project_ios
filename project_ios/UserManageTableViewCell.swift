//
//  UserManageTableViewCell.swift
//  Et O Et Coffee Manager
//
//  Created by Tran Quang Vinh on 26/05/2022.
//

import UIKit

class UserManageTableViewCell: UITableViewCell {
    
    // PROPERTIES
    var id = -1
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserPhone: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var swichConfirm: UISwitch!
    @IBOutlet weak var swichActive: UISwitch!
    var userToken = ""
    
    private let callApi:CallAPI = CallAPI()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func activeOrDeactiveUser(_ sender: Any) {
        let isSuccess = self.callApi.CallApiChangeUserStatus(token: self.userToken, id: self.id)
        if isSuccess == false{
            self.swichActive.isOn = !self.swichActive.isOn
        }
    }

}
