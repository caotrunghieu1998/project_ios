//
//  CallAPI.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 02/05/2022.
//
import UIKit
class CallAPI{
    // Fields
    private let urlBackEnd:String = "https://backend-project-ios.000webhostapp.com"
    
    // User Login
    func CallApiUserLogin(email:String,password:String)->DataCallBackUserLogin {
        let Url = String(format: self.urlBackEnd + "/api/user/login")
        guard let serviceUrl = URL(string: Url) else {
            return DataCallBackUserLogin(isSuccess: false, token: nil, userName: nil, error: "Service Url not found", system_error: nil)
        }
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return DataCallBackUserLogin(isSuccess: false, token: nil, userName: nil, error: "Some thing wrong when login", system_error: nil)
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let semaphore = DispatchSemaphore(value: 0)
        var result:DataCallBackUserLogin = DataCallBackUserLogin(isSuccess: false, token: nil, userName: nil, error: "Result not use", system_error: nil)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print("response: ",response)
            //            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let value = json as! Dictionary<String, AnyObject>
                    if let isSuccess = value["isSuccess"],
                       let _data = value["data"],
                       let _error = value["error"],
                       let _system_error = value["system_error"]{
                        let _isSuccess = isSuccess as? Int == 1
                        if _isSuccess{
                            if var token = _data["token"], let user = _data["user"]{
                                if let userInfo1 = user{
                                    if let userInfo2 = userInfo1 as? [String:Any]{
                                        token = token!
                                        result = DataCallBackUserLogin(isSuccess: _isSuccess, token: token as! String, userName: userInfo2["name"]! as! String, error: _error as? String, system_error: _system_error as? String)
                                    }
                                }
                            }
                        }else{
                            result = DataCallBackUserLogin(isSuccess: _isSuccess, token: nil, userName: nil, error: _error as? String, system_error: _system_error as? String)
                        }
                    }
                } catch {
                    result = DataCallBackUserLogin(isSuccess: false, token: nil, userName: nil, error: "Something Wrong", system_error: nil)
                }
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()  //2. wait for finished counting
        return result
    }
    
    // Send Code reset pasword to email
    func CallApiUserSendCodeResetPass(email:String)->DataCallBackDataIsMessage {
        let Url = String(format: self.urlBackEnd + "/api/user/send-code-reset-password")
        guard let serviceUrl = URL(string: Url) else {
            return DataCallBackDataIsMessage(isSuccess: false, message: nil, error: "Service Url not found", system_error: nil)
        }
        let param: [String: Any] = [
            "email": email
        ]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return DataCallBackDataIsMessage(isSuccess: false, message: nil, error: "Some thing wrong when send code.", system_error: nil)
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let semaphore = DispatchSemaphore(value: 0)
        var result:DataCallBackDataIsMessage = DataCallBackDataIsMessage(isSuccess: false,message: nil, error: "Result not use", system_error: nil)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print("response: ",response)
            //            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let value = json as! Dictionary<String, AnyObject>
                    if let isSuccess = value["isSuccess"],
                       let _data = value["data"],
                       let _error = value["error"],
                       let _system_error = value["system_error"]{
                        let _isSuccess = isSuccess as? Int == 1
                        if _isSuccess{
                            result = DataCallBackDataIsMessage(isSuccess: _isSuccess,message: _data as? String, error: nil, system_error: nil)
                        }else{
                            result = DataCallBackDataIsMessage(isSuccess: _isSuccess,message: nil, error: _error as? String, system_error: _system_error as? String)
                        }
                    }
                } catch {
                    result = DataCallBackDataIsMessage(isSuccess: false, message: nil, error: "Some thing wrong when send code.", system_error: nil)
                }
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()  //2. wait for finished counting
        return result
    }
    
    // reset password
    func CallApiUserResetPassword(
        email:String,
        code:String, new_password:String,
        confirm_password:String
    )->DataCallBackDataIsMessage {
        let Url = String(format: self.urlBackEnd + "/api/user/reset-password")
        guard let serviceUrl = URL(string: Url) else {
            return DataCallBackDataIsMessage(isSuccess: false, message: nil, error: "Service Url not found", system_error: nil)
        }
        let param: [String: Any] = [
            "email": email,
            "code" : code,
            "new_password" : new_password,
            "confirm_password" : confirm_password
        ]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return DataCallBackDataIsMessage(isSuccess: false, message: nil, error: "Some thing wrong when reset password.", system_error: nil)
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let semaphore = DispatchSemaphore(value: 0)
        var result:DataCallBackDataIsMessage = DataCallBackDataIsMessage(isSuccess: false,message: nil, error: "Result not use", system_error: nil)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print("response: ",response)
            //            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let value = json as! Dictionary<String, AnyObject>
                    if let isSuccess = value["isSuccess"],
                       let _data = value["data"],
                       let _error = value["error"],
                       let _system_error = value["system_error"]{
                        let _isSuccess = isSuccess as? Int == 1
                        if _isSuccess{
                            result = DataCallBackDataIsMessage(isSuccess: _isSuccess,message: _data as? String, error: nil, system_error: nil)
                        }else{
                            result = DataCallBackDataIsMessage(isSuccess: _isSuccess,message: nil, error: _error as? String, system_error: _system_error as? String)
                        }
                    }
                } catch {
                    result = DataCallBackDataIsMessage(isSuccess: false, message: nil, error: "Some thing wrong when reset password.", system_error: nil)
                }
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()  //2. wait for finished counting
        return result
    }
    
    // Get profile
    func CallApiGetUserProfile(token:String)->UserModel {
        let Url = String(format: self.urlBackEnd + "/api/user/profile")
        guard let serviceUrl = URL(string: Url) else {
            print("Service not found")
            return UserModel(id: -1, name: "", email: "", phone: "", type: "", isConfirm: false, isActive: false)
        }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        let semaphore = DispatchSemaphore(value: 0)
        var result:UserModel = UserModel(id: -1, name: "", email: "", phone: "", type: "", isConfirm: false, isActive: false)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print("response: ",response)
            //            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let value = json as! Dictionary<String, AnyObject>
                    if let isSuccess = value["isSuccess"],
                       let _data = value["data"]{
                        let _isSuccess = isSuccess as? Int == 1
                        if _isSuccess,
                           let id = _data["id"],
                           let name = _data["name"],
                           let email = _data["email"],
                           let phone = _data["phone"],
                           let type_id = _data["type_id"],
                           let is_confirm = _data["is_confirm"],
                           let is_active = _data["is_active"]
                        {
                            // Processing User Type
                            let userTypeId = type_id as! Int
                            var type = ""
                            if userTypeId == 1 {
                                type = "Admin"
                            } else if userTypeId == 2 {
                                type = "Manager"
                            }else{
                                type = "Staff"
                            }
                            result = UserModel(id: id as! Int, name: (name as? String)!, email: email as! String, phone: phone as! String, type: type, isConfirm: is_confirm as? Int == 1, isActive: is_active as? Int == 1)
                        }
                    }
                } catch {
                    print("error")
                }
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()  //2. wait for finished counting
        return result
    }
    
    // Logout
    func CallApiUserLogout(token:String) {
        let Url = String(format: self.urlBackEnd + "/api/user/logout")
        guard let serviceUrl = URL(string: Url) else {
            print("Service logout not found")
            return
        }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print("response: ",response)
            //            }
            if let data = data {
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                } catch {
                    print("ERROR WHEN LOGOUT")
                }
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()  //2. wait for finished counting
    }
    
    // Change User Name
    func CallApiChangeUserName(token:String,newName:String)->Bool {
        let Url = String(format: self.urlBackEnd + "/api/user/change-name")
        guard let serviceUrl = URL(string: Url) else {
            print("Service change user name not found")
            return false
        }
        
        let parameters: [String: Any] = [
            "name": newName
        ]
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return false
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        var result = false
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print("response: ",response)
            //            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let value = json as! Dictionary<String, AnyObject>
                    if let isSuccess = value["isSuccess"]{
                        result = isSuccess as? Int == 1
                    }
                } catch {
                    print("error when change user name")
                }
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()  //2. wait for finished counting
        return result
    }
    
    // Change User Password
    func CallApiChangeUserPassword(
        token:String,
        oldPassword:String,
        newPassword:String,
        confirmPassword:String
    )->Bool {
        let Url = String(format: self.urlBackEnd + "/api/user/change-password")
        guard let serviceUrl = URL(string: Url) else {
            print("Service change user password not found")
            return false
        }
        
        let parameters: [String: Any] = [
            "old_password": oldPassword,
            "new_password": newPassword,
            "confirm_new_password": confirmPassword
        ]
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return false
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        var result = false
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print("response: ",response)
            //            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let value = json as! Dictionary<String, AnyObject>
                    print(value)
                    if let isSuccess = value["isSuccess"]{
                        result = isSuccess as? Int == 1
                    }
                } catch {
                    print("error when change user password")
                }
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()  //2. wait for finished counting
        return result
    }
}
