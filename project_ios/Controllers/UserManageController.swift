//
//  UserManageController.swift
//  Et O Et Coffee Manager
//
//  Created by Tran Quang Vinh on 26/05/2022.
//

import UIKit

class UserManageController: UIViewController,UITableViewDataSource,UITextFieldDelegate {
    
    // Ánh xạ
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableViewUser: UITableView!
    
    // Properties
    var token = ""
    private var userData:[UserModel] = []
    private var callApi:CallAPI = CallAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        // check user info
        let userInfo = callApi.CallApiGetUserProfile(token: token)
        if userInfo.id > 0{
            self.userData = self.callApi.CallApiGetUserList(token: self.token, keyword: "")
            self.tableViewUser.reloadData()
        }else{
            self.logOut()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewUser.dataSource = self
        self.txtSearch.clipsToBounds = true
        self.txtSearch.layer.cornerRadius = 10
        self.txtSearch.layer.borderWidth = 2
     
        // Uỷ quyền cho text field
        self.txtSearch.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "userManageCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserManageTableViewCell{
            let user = self.userData[indexPath.row]
            cell.id = user.id
            
            cell.lblUserName.text = user.name
            cell.lblUserEmail.text = user.email
            cell.lblUserPhone.text = user.phone
            cell.lblUserType.text = user.type
            cell.swichConfirm.isOn = user.isConfirm
            cell.swichActive.isOn = user.isActive
            
            cell.userToken = self.token
            // Tạo viền cho cell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 2
            cell.layer.shadowOffset = CGSize(width: -1, height: -1)
            let colorBack: UIColor = .black
            cell.layer.borderColor = colorBack.cgColor
            return cell
        }else{
            fatalError("Cannot create the cell")
        }
        
    }
    
    // Kiểm tra màn hình chuẩn bị chuyển
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create user screen
        if let createUserController = segue.destination as? CreateUserController {
            createUserController.token = self.token
        }
    }
    
    // Search
    @IBAction func search(_ sender: Any) {
        // Hide the keyboard
        self.txtSearch.resignFirstResponder()
        if let keyword = txtSearch.text{
            self.userData = self.callApi.CallApiGetUserList(token: self.token, keyword: keyword)
            self.tableViewUser.reloadData()
        }
    }
    
    // Logout
    func logOut(){
        self.callApi.CallApiUserLogout(token: token)
        self.token = ""
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Trở về Manage
    @IBAction func backToOptionScreen(_ sender: Any) {
        self.token = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    // Tắt bàn phím khi nhấn vài nút Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        self.txtSearch.resignFirstResponder()
        return true
    }
    
}
