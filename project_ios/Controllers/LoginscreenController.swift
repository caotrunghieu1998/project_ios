//
//  ViewController.swift
//  project_ios
//
//  Created by Cao Trung Hieu on 22/04/2022.
//

import UIKit

class LoginscreenController: UIViewController,UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    
    private let validation = Validation()
    private let callApi = CallAPI()
    private var isShowPassword:Bool = true
    public var token:String?
    private var isLoginSuccess:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblError.isHidden = true
        self.isShowPassword = txtPassword.isSecureTextEntry
        self.isLoginSuccess = false
        // Uỷ quyền cho txt
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
    
    //MARK: Custome function
    // Touch Up Inside button login
    @IBAction func btnLoginTouchUpInside(_ sender: UIButton) {
        self.turnOffKetboard()
        if let email = txtEmail.text, let password = txtPassword.text{
            if validation.checkEmai(email: email) && validation.checkPassword(password: password){
                // Login Here
                let resultLogin = self.callApi.CallApiUserLogin(email: email, password: password)
                if resultLogin.isSuccess, let userName = resultLogin.userName, let token = resultLogin.token{
                    // Login success here
                    //self.isLoginSuccess = true
                    self.token = token
                    self.showMessage(message: "Login Success, Hi \"\(userName)\"", textColor: .green, timeDisplay: 5)
                    
                }else if !resultLogin.isSuccess, let error = resultLogin.error{
                    // Login False here
                    self.showMessage(message: error, textColor: .red, timeDisplay: 5.0)
                    if let system_error = resultLogin.error{
                        print(system_error)
                    }
                }
            }else{
                self.showMessage(message: "Wrong at Email or password", textColor: .red, timeDisplay: 5.0)
            }
        }
    }
    
    // Kiểm tra màn hình chuẩn bị chuyển
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainController = segue.destination as? MainController {
            mainController.token = self.token
        }
    }
    
    // Kiểm tra xem màn hình chuyển được chưa
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let btnSender = sender as? UIButton{
            if btnSender === btnLogin {
                return self.isLoginSuccess
            }
        }
        return true
    }
    
    // Touch Up in button show Password
    @IBAction func showOrHiddenPassword(_ sender: Any) {
        self.isShowPassword = !self.isShowPassword
        txtPassword.isSecureTextEntry = self.isShowPassword
        let icon = self.isShowPassword ? "◎" : "◉"
        self.btnShowPassword.setTitle(icon, for: .normal)
    }
    
    // Show Message String and auto hidden
    func showMessage(message:String,textColor:UIColor,timeDisplay:Double) {
        self.lblError.text = message
        self.lblError.isHidden = false
        self.lblError.textColor = textColor
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDisplay) {
            self.lblError.isHidden = true
        }
    }
    
    // Tắt bàn phím khi nhấn vài nút Done của txtEmail hoặc txtPassword
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        self.turnOffKetboard()
        return true
    }
    
    // Tắt bàn phím
    func turnOffKetboard() {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
}

