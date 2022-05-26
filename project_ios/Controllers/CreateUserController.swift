//
//  CreateUserController.swift
//  Et O Et Coffee Manager
//
//  Created by Tran Quang Vinh on 26/05/2022.
//

import UIKit

class CreateUserController: UIViewController, UITextFieldDelegate {
    
    // Ánh xạ
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet var screen: UIView!
    
    // Properties
    var token = "";
    private let callApi = CallAPI()
    private let validation = Validation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check user login
        let userInfo = callApi.CallApiGetUserProfile(token: token)
        if userInfo.id < 0{
            self.logOut()
        }
        
        self.lblMessage.isHidden = true
        
        // Uỷ quyền cho text field
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtPhone.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        self.txtType.delegate = self
    }
    
    
    @IBAction func createUser(_ sender: Any) {
        self.turnOffKeyboard()
        if let name = self.txtName.text,
           let email = self.txtEmail.text,
           let phone = self.txtPhone.text,
           let password = self.txtPassword.text,
           let confirmPassword = self.txtConfirmPassword.text,
           let type = self.txtType.text{
            // check input
            // Name
            if !validation.checkUserName(userName: name){
                self.showMessage(message: "Wrong at user name format", isError: true, timeDisplay: 5.0)
                return
            }
            // Email
            if !validation.checkEmai(email: email){
                self.showMessage(message: "Wrong at user emal format", isError: true, timeDisplay: 5.0)
                return
            }
            // Phone
            if !validation.checkUserPhone(phone: phone){
                self.showMessage(message: "Wrong at user phone format", isError: true, timeDisplay: 5.0)
                return
            }
            // Password
            if !validation.checkPassword(password: password){
                self.showMessage(message: "Wrong at user password format", isError: true, timeDisplay: 5.0)
                return
            }
            // Confirm Password
            if !validation.checkPassword(password: confirmPassword){
                self.showMessage(message: "Wrong at user confirm password format", isError: true, timeDisplay: 5.0)
                return
            }
            // password and confirm password is same
            if password != confirmPassword{
                self.showMessage(message: "Confirm password not same", isError: true, timeDisplay: 5.0)
                return
            }
            // type
            let type_id = validation.checkUserType(type: type)
            print(type_id)
            if type_id < 0 {
                self.showMessage(message: "Wrong at type user", isError: true, timeDisplay: 5.0)
                return
            }
            let isCreateSuccess = callApi.CallApiCreateUser(
                token: self.token,
                name: name,
                phone: phone,
                email: email,
                password: password,
                confirm_password: confirmPassword,
                type_id: type_id)
            if isCreateSuccess == true{
                self.screen.isUserInteractionEnabled = false
                self.showMessage(message: "Create User success", isError: false, timeDisplay: 5.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.token = ""
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.showMessage(message: "System error", isError: true, timeDisplay: 5.0)
            }
        }
    }
    
    // show message và error
    func showMessage(message:String,isError:Bool,timeDisplay:Double) {
        self.lblMessage.text = message
        self.lblMessage.isHidden = false
        self.lblMessage.textColor = isError ? .red : .green
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDisplay) {
            self.lblMessage.isHidden = true
        }
    }
    
    @IBAction func backToUserManageScreen(_ sender: Any) {
        self.token = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    // Tắt bàn phím khi nhấn vài nút Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        self.turnOffKeyboard()
        return true
    }
    
    // turn off keyboard
    func turnOffKeyboard(){
        self.txtName.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtPhone.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtConfirmPassword.resignFirstResponder()
        self.txtType.resignFirstResponder()
    }
    
    
    // Logout
    func logOut(){
        self.callApi.CallApiUserLogout(token: token)
        self.token = ""
        self.navigationController?.popToRootViewController(animated: true)
    }
}
