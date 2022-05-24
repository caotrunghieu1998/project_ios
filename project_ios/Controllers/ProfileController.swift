//
//  ProfileController.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 24/05/2022.
//

import UIKit

class ProfileController: UIViewController, UITextFieldDelegate {
    // Ánh xạ
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var formUpdatePassword: UIStackView!
    @IBOutlet var profileScreen: UIView!
    
    // Các biến cần dùng
    var token: String = ""
    private let validation = Validation()
    private let callApi = CallAPI()
    private var isShowPassword:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide Message
        self.lblMessage.isHidden = true
        // Hide form update password
        self.formUpdatePassword.isHidden = true
        self.btnShowHidePassword.isHidden = true
        // Get User
        let userInfo = callApi.CallApiGetUserProfile(token: token)
        if userInfo.id > 0{
            self.txtUserName.text = userInfo.name
            self.lblPhone.text = userInfo.phone
            self.lblEmail.text = userInfo.email
            self.lblUserType.text = userInfo.type
        }else{
            self.logOut()
        }
        // Uỷ quyền cho txt
        self.txtUserName.delegate = self
        self.txtOldPassword.delegate = self
        self.txtNewPassword.delegate = self
        self.txtConfirmPassword.delegate = self
    }
    
    // Back to menu option screen
    @IBAction func backToMenuOptionScreen(_ sender: Any) {
        self.token = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnUpdateName(_ sender: Any) {
        if !self.txtUserName.isUserInteractionEnabled{
            self.txtUserName.isUserInteractionEnabled = true
            self.txtUserName.backgroundColor = .white
            self.showMessage(message: "Enter new name.", isError: false, timeDisplay: 5.0)
            
        }else{
            if let userName = self.txtUserName.text{
                if self.validation.checkUserName(userName: userName){
                    let isUpdateSuccess = self.callApi.CallApiChangeUserName(token: self.token, newName: userName)
                    if isUpdateSuccess{
                        self.txtUserName.isUserInteractionEnabled = false
                        self.txtUserName.backgroundColor = .lightGray
                        self.formUpdatePassword.isHidden = true
                        self.btnShowHidePassword.isHidden = true
                        self.showMessage(message: "Update name success", isError: false, timeDisplay: 5.0)
                    }else{
                        self.showMessage(message: "Error when change user name", isError: true, timeDisplay: 5.0)
                    }
                }else{
                    self.showMessage(message: "Wrong at the new name", isError: true, timeDisplay: 5.0)
                }
                
            }else{
                showMessage(message: "The input name empty.", isError: true, timeDisplay: 5.0)
            }
        }
    }
    
    
    @IBAction func updatePassword(_ sender: Any) {
        if self.formUpdatePassword.isHidden{
            self.formUpdatePassword.isHidden = false
            self.btnShowHidePassword.isHidden = false
        }else{
            // Update password here
            if let oldPassword = self.txtOldPassword.text,
               let newPassword = self.txtNewPassword.text,
               let confirmPassword = self.txtConfirmPassword.text{
                if validation.checkPassword(password: oldPassword),
                   validation.checkPassword(password: newPassword),
                   validation.checkPassword(password: confirmPassword){
                    // Call api
                    let resuft = self.callApi.CallApiChangeUserPassword(token: self.token, oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword)
                    if resuft{
                        self.profileScreen.isUserInteractionEnabled = false
                        showMessage(message: "Success, auto logout in 5s", isError: false, timeDisplay: 5.0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            self.logOut()
                        }
                    }else{
                        showMessage(message: "Some field is not true !", isError: true, timeDisplay: 5.0)
                    }
                }else{
                    showMessage(message: "Wrong at password type", isError: true, timeDisplay: 5.0)
                }
            }else{
                showMessage(message: "Wrong at password type", isError: true, timeDisplay: 5.0)
            }
        }
    }
    
    // Touch Up in button show Password
    @IBAction func showOrHiddenPassword(_ sender: Any) {
        self.isShowPassword = !self.isShowPassword
        self.txtNewPassword.isSecureTextEntry = self.isShowPassword
        self.txtOldPassword.isSecureTextEntry = self.isShowPassword
        self.txtConfirmPassword.isSecureTextEntry = self.isShowPassword
        let icon = self.isShowPassword ? "◎" : "◉"
        self.btnShowHidePassword.setTitle(icon, for: .normal)
    }
    
    // Logout
    func logOut(){
        self.callApi.CallApiUserLogout(token: token)
        self.token = ""
        self.navigationController?.popToRootViewController(animated: true)
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
    
    // Tắt bàn phím khi nhấn vài nút Done 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        self.turnOffKetboard()
        return true
    }
    
    // Tắt bàn phím
    func turnOffKetboard() {
        txtUserName.resignFirstResponder()
        txtOldPassword.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
