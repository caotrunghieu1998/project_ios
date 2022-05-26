//
//  Validation.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 02/05/2022.
//

import Foundation

class Validation{
    //MARK: Properties
    private let emailLength:Int = 6
    private let passwordLength:Int = 6
    
    //MARK: Method
    // Check email
    public func checkEmai(email: String) -> Bool {
        if email.count < self.emailLength {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Check email
    public func checkPassword(password: String) -> Bool {
        return password.count >= self.passwordLength
    }
    
    // Check User Name
    public func checkUserName(userName: String)->Bool{
        return (userName.count >= 2 && userName.count <= 100)
    }
    
    // Check User phone
    public func checkUserPhone(phone: String)->Bool{
        if phone.count != 10{
            return false
        }
        if phone.first != "0"{
            return false
        }
        return true
    }
    // check user type
    public func checkUserType(type:String)->Int{
        let typeCheck = type.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        switch typeCheck {
        case "ADMIN":
            return 1
        case "MANAGER":
            return 2
        case "STAFF":
            return 3
        default:
            return -1
        }
    }
}
