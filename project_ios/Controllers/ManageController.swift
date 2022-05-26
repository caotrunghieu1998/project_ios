//
//  ManageController.swift
//  Et O Et Coffee Manager
//
//  Created by Tran Huu Phuc on 25/05/2022.
//

import UIKit

class ManageController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnUsers: UIButton!
    @IBOutlet weak var lblUserType: UILabel!
    
    
    // Các biến cần dùng
    private let callApi = CallAPI()
    private var isFirst = true
    
    // Properties tự định nghĩa
    public var token:String = ""
    public var userInfo:UserModel = UserModel(
        id: -1,
        name: "",
        email: "",
        phone: "",
        type: "",
        isConfirm: false,
        isActive: false)
    
    
    // MARK: Method
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirst{
            isFirst = false
            self.userInfo = callApi.CallApiGetUserProfile(token: token)
            if userInfo.id > 0{
                self.lblUserName.text = userInfo.name
                self.lblUserType.text = userInfo.type
                if userInfo.type == "Staff" || userInfo.type == "Manager"{
                    self.btnUsers.isHidden = true
                }
            }else{
                self.logOut()
            }
        }
    }
    
    @IBAction func backToMenuOption(_ sender: Any) {
        self.token = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Kiểm tra màn hình chuẩn bị chuyển
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // user manage screen
        if let userManageController = segue.destination as? UserManageController {
            userManageController.token = self.token
        }
        
        // product manage screen
        if let productManageController = segue.destination as? ProductManageController {
            productManageController.token = self.token
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFirst == false{
            self.userInfo = callApi.CallApiGetUserProfile(token: token)
            if userInfo.id > 0{
                self.lblUserName.text = userInfo.name
                self.lblUserType.text = userInfo.type
                if userInfo.type == "Staff" || userInfo.type == "Manager"{
                    self.btnUsers.isHidden = true
                }
            }else{
                self.logOut()
            }
        }
    }
    
    // Logout
    func logOut(){
        self.callApi.CallApiUserLogout(token: token)
        self.token = ""
        self.navigationController?.popToRootViewController(animated: true)
    }
}
