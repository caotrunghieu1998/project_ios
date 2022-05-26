//
//  ShopController.swift
//  Et O Et Coffee Manager
//
//  Created by Tran Huu Phuc on 24/05/2022.
//

import UIKit

class ShopController: UIViewController, UITableViewDataSource,UITextFieldDelegate {
    
    // Ánh xạ
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableViewProductShop: UITableView!
    
    // Properties
    var token = ""
    private var productData:[ProductModel] = []
    private var callApi:CallAPI = CallAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewProductShop.dataSource = self
        self.txtSearch.clipsToBounds = true
        self.txtSearch.layer.cornerRadius = 10
        self.txtSearch.layer.borderWidth = 2
     
        // check user info
        let userInfo = callApi.CallApiGetUserProfile(token: token)
        if userInfo.id > 0{
            self.productData = self.callApi.CallApiGetProductList(token: self.token, screen: "SHOP", keyword: "")
        }else{
            self.logOut()
        }
        
        // Uỷ quyền cho text field
        self.txtSearch.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "productShopCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ProductShopTableViewCell{
            let product = self.productData[indexPath.row]
            cell.productId = product.id
            cell.imgProduct.image = product.image
            cell.lblProductName.text = product.name
            cell.lblProductPrice.text = "\(product.price)"
            cell.lblProductQuantity.text =
                "\(product.quantity)"
            cell.lblUnit.text = "\(product.unit)"
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
    
    // Search
    @IBAction func search(_ sender: Any) {
        // Hide the keyboard
        self.txtSearch.resignFirstResponder()
        if let keyword = txtSearch.text{
            self.productData = self.callApi.CallApiGetProductList(token: self.token, screen: "SHOP", keyword: keyword)
            self.tableViewProductShop.reloadData()
        }
    }
    
    
    // Logout
    func logOut(){
        self.callApi.CallApiUserLogout(token: token)
        self.token = ""
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Trở về Menu Option
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
