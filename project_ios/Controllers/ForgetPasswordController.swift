//
//  ForgetPasswordController.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 21/05/2022.
//

import UIKit

class ForgetPasswordController: UIViewController,UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var formResetPassword: UIStackView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnGetCode: UIButton!
    
    
    // Form Reset Password
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnShowOrHidePassword: UIButton!
    
    
    
    // Khai báo những đối tượng và biến cần dùng
    private let validation = Validation()
    private let callApi = CallAPI()
    private var isHidePassword:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formResetPassword.isHidden = true
        self.lblMessage.isHidden = true
        
        // Uỷ quyền cho text fields
        self.txtEmail.delegate = self
        self.txtCode.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
    }
    
    // Nhấn vào nút quay về Login
    @IBAction func backToLoginScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // nhấn vào nút Get Code
    @IBAction func tapOnBtnGetCode(_ sender: Any) {
        self.turnOffKetboard()
        if let email = self.txtEmail.text {
            if validation.checkEmai(email: email){
                // Send Code here
                let resultSendCode = self.callApi.CallApiUserSendCodeResetPass(email: email)
                if resultSendCode.isSuccess,
                   let message = resultSendCode.message{
                    self.showMessage(message: message, isError: false, timeDisplay: 3.0)
                    self.formResetPassword.isHidden = false
                    self.txtEmail.isUserInteractionEnabled = false
                    self.btnGetCode.isUserInteractionEnabled = false
                }else if let error = resultSendCode.error{
                    self.showMessage(message: error, isError: true, timeDisplay: 5.0)
                    if let system_error = resultSendCode.error{
                        print(system_error)
                    }
                }
            }else{
                let message = "The email input not true."
                self.showMessage(message: message, isError: true, timeDisplay: 5.0)
            }
        }else{
            let message = "The email's input cannot empty."
            self.showMessage(message: message, isError: true, timeDisplay: 5.0)
        }
    }
    
    // Nhấn vào nút show/hide password
    @IBAction func tapOnBtnShowHidePassword(_ sender: Any) {
        self.isHidePassword = !self.isHidePassword
        self.txtPassword.isSecureTextEntry = self.isHidePassword
        self.txtConfirmPassword.isSecureTextEntry = self.isHidePassword
        let icon = self.isHidePassword ? "◎" : "◉"
        self.btnShowOrHidePassword.setTitle(icon, for: .normal)
    }
    
    
    @IBAction func tapOnBtnResetPassword(_ sender: Any) {
        self.turnOffKetboard()
        if  let email = self.txtEmail.text,
            let code = self.txtCode.text,
            let password = self.txtPassword.text,
            let confirmPassword = self.txtConfirmPassword.text {
            if self.validation.checkPassword(password: password), self.validation.checkPassword(password: confirmPassword){
                // Reset Password here
                let resultResetPassword = self.callApi.CallApiUserResetPassword(
                    email: email,
                    code: code,
                    new_password: password,
                    confirm_password: confirmPassword
                )
                if resultResetPassword.isSuccess,
                   let message = resultResetPassword.message{
                    // Reset Password success
                    self.showMessage(message: message, isError: false, timeDisplay: 5.0)
                    self.formResetPassword.isUserInteractionEnabled = false
                    //Auto go back login screen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }else if let error = resultResetPassword.error{
                    self.showMessage(message: error, isError: true, timeDisplay: 5.0)
                    if let system_error = resultResetPassword.system_error{
                        print(system_error)
                    }
                }
            }else{
                let message = "Wrong at password type."
                self.showMessage(message: message, isError: true, timeDisplay: 5.0)
            }
        }else{
            let message = "Some input is empty."
            self.showMessage(message: message, isError: true, timeDisplay: 5.0)
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
    
    // Hàm uỷ quyền tắt bàn phím
    // Tắt bàn phím khi nhấn vài nút Done của txtEmail hoặc txtPassword
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        self.turnOffKetboard()
        return true
    }
    
    // Tắt bàn phím
    func turnOffKetboard() {
        self.txtEmail.resignFirstResponder()
        self.txtCode.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtConfirmPassword.resignFirstResponder()
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
