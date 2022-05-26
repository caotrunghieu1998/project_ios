//
//  ProductManageController.swift
//  Et O Et Coffee Manager
//
//  Created by Vo Thanh Dat on 25/05/2022.
//

import UIKit

class ProductManageController: UIViewController,UITableViewDataSource,UITextFieldDelegate {
    
    // Ánh xạ
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableViewProductShop: UITableView!
    
    // Properties
    var token = ""
    private var productData:[ProductModel] = []
    private var callApi:CallAPI = CallAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        // check user info
        let userInfo = callApi.CallApiGetUserProfile(token: token)
        if userInfo.id > 0{
            self.productData = self.callApi.CallApiGetProductList(token: self.token, screen: "MANAGE", keyword: "")
            self.tableViewProductShop.reloadData()
        }else{
            self.logOut()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewProductShop.dataSource = self
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
        return self.productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "productManageCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ProductManageTableViewCell{
            let product = self.productData[indexPath.row]
            cell.id = product.id
            cell.type = product.type
            cell.imgProduct.image = product.image
            cell.lblName.text = product.name
            cell.lblPrice.text = "\(product.price)"
            cell.lblQuantity.text =
                "\(product.quantity)"
            cell.lblUnit.text = "\(product.unit)"
            cell.switchActive.isOn = product.isActive
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
    
    // Search
    @IBAction func search(_ sender: Any) {
        // Hide the keyboard
        self.txtSearch.resignFirstResponder()
        if let keyword = txtSearch.text{
            self.productData = self.callApi.CallApiGetProductList(token: self.token, screen: "MANAGE", keyword: keyword)
            self.tableViewProductShop.reloadData()
        }
    }
    
    // Kiểm tra màn hình chuẩn bị chuyển
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // screen create or update product
        if let createOrUpdateProductController = segue.destination as? CreateOrUpdateProductController {
            createOrUpdateProductController.token = self.token
            if let selectedIndexPathRow = self.tableViewProductShop.indexPathForSelectedRow{
                let product = self.productData[selectedIndexPathRow.row]
                createOrUpdateProductController.product = product
            }
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
