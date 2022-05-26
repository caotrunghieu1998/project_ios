//
//  CreateOrUpdateProductController.swift
//  Et O Et Coffee Manager
//
//  Created by Vo Thanh Dat on 25/05/2022.
//

import UIKit

class CreateOrUpdateProductController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Ánh xạ
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet var screen: UIView!
    
    
    
    // Properties
    var token = "";
    var product = ProductModel(id: -1, image: UIImage(), name: "", price: 0, quantity: 0, type: "", unit: "", isActice: false)
    private let callApi = CallAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check user login
        let userInfo = callApi.CallApiGetUserProfile(token: token)
        if userInfo.id < 0{
            self.logOut()
        }
        
        self.lblMessage.isHidden = true
        self.imageProduct.contentMode = .scaleAspectFit
        if self.product.id < 0{
            // Create Mode
            self.navigationItem.title = "Create Product"
            self.lblTitle.text = "Create New Product"
            self.imageProduct.image = UIImage(named: "DefaultProduct")
            self.btnAction.setTitle("Create Product", for: .normal)
        }else{
            // Update Model
            self.navigationItem.title = "Update Product"
            self.lblTitle.text = "Update Product"
            
            self.imageProduct.image = product.image
            self.txtName.text = product.name
            self.txtPrice.text = "\(product.price)"
            self.txtQuantity.text = "\(product.quantity)"
            self.txtType.text = product.type
            self.txtUnit.text = product.unit
            
            
            self.btnAction.setTitle("Update Product", for: .normal)
        }
        
        // Uỷ quyền cho text field
        self.txtName.delegate = self
        self.txtPrice.delegate = self
        self.txtQuantity.delegate = self
        self.txtType.delegate = self
        self.txtUnit.delegate = self
    }
    
    // chọn image
    @IBAction func chooseImage(_ sender: Any) {
        self.turnOffKeyboard()
        // Tạo màn hình Image Piker
        let imagePickerController = UIImagePickerController()
        // Setup properties cho màn hình Image picker
        imagePickerController.sourceType = .photoLibrary
        // Uỷ quyền cho màn hình mới
        imagePickerController.delegate = self
        // hiện màn hình mới lên
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Chọn cancel cho màn hình thư viện
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Chọn hình thành công
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            self.imageProduct.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func action(_ sender: Any) {
        self.turnOffKeyboard()
        var price = 0
        var quantity = 0
        // Check Price and Quantity input is int
        if let _price = txtPrice.text,
           let _quantity = txtQuantity.text{
            if let intPrice = Int(_price),
               let intQuantity = Int(_quantity){
                price = intPrice
                quantity = intQuantity
            }else{
                self.showMessage(message: "Price and quantity must be int", isError: true, timeDisplay: 5.0)
                return
            }
        }else{
            self.showMessage(message: "Some field is not true", isError: true, timeDisplay: 5.0)
            return
        }
        if product.id < 0{
            // Create
            if let name = txtName.text,
               let type = txtType.text,
               let unit = txtUnit.text,
               let image = imageProduct.image{
                let isSuccess = self.callApi.CallApiCreateProduct(
                    token: self.token,
                    name: name,
                    price: price,
                    quantity: quantity,
                    type: type,
                    unit: unit,
                    image: image)
                if isSuccess{
                    self.showMessage(message: "Create product success.", isError: false, timeDisplay: 5.0)
                    self.screen.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.lblMessage.isHidden = true
                        self.token = ""
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.showMessage(message: "Something wrong when create product.", isError: true, timeDisplay: 5.0)
                }
            }
        }else{
            // Update
            if let name = txtName.text,
               let type = txtType.text,
               let unit = txtUnit.text,
               let image = imageProduct.image{
                let isSuccess = self.callApi.CallApiUpdateProduct(
                    token: self.token,
                    id: self.product.id,
                    name: name,
                    price: price,
                    quantity: quantity,
                    type: type,
                    unit: unit,
                    image: image)
                if isSuccess{
                    self.showMessage(message: "Update product success.", isError: false, timeDisplay: 5.0)
                }else{
                    self.showMessage(message: "Something wrong when update product.", isError: true, timeDisplay: 5.0)
                }
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
    
    @IBAction func backToProductManageScreen(_ sender: Any) {
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
        self.txtPrice.resignFirstResponder()
        self.txtQuantity.resignFirstResponder()
        self.txtType.resignFirstResponder()
        self.txtUnit.resignFirstResponder()
    }
    
    
    // Logout
    func logOut(){
        self.callApi.CallApiUserLogout(token: token)
        self.token = ""
        self.navigationController?.popToRootViewController(animated: true)
    }
}
