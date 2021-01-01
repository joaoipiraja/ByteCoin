//
//  ViewController.swift
//  ByteCoin
//
//  Created by João Victor Ipirajá de Alencar on 30/12/20.
//

import UIKit

class ViewController: UIViewController {
    var bcm:ByteCoinManager = ByteCoinManager()
    var exchangerateData: exchangerateData?
    var assetDataArray: [AssetsData]?
    @IBOutlet weak var pickerAsset: UIPickerView!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.pickerAsset.delegate = self
        self.pickerAsset.dataSource = self
        self.bcm.delegate = self
        
        DispatchQueue.main.async {
            self.LoadingStart(message: "Please Wait...")
        }
        
        bcm.fetchAssetData()
        
        //bcm.fetchExchangerateData(of: "BTC")
        // Do any additional setup after loading the view.
    }
    
}

//MARK: - UIPickerViewDelegate and UIPickerViewDataSource
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let ada = self.assetDataArray{
            bcm.fetchExchangerateData(of: ada[row].asset_id)
            DispatchQueue.main.async {
                self.LoadingStart(message: "Search...")
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let ada = assetDataArray{
            return ada.count
        }else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let ada = assetDataArray{
            return ada[row].asset_id
        }else{
            return ""
        }
    }
    
    
}


//MARK: - ByteCoinManagerDelegate

extension ViewController: ByteCoinManagerDelegate{
    

    
    func didUpdateExchangerateData(_ byteCoinManager: ByteCoinManager, exchangerateData: exchangerateData?) {
        self.exchangerateData = exchangerateData
        DispatchQueue.main.async {
            
            if let ed = exchangerateData{
                self.lblValue.text = ed.rateString
                self.lblCoin.text = ed.asset_id_quote
            }else{
                
            }
            self.LoadingStop()
        }
        
    }
    
    func didUpdateAssetsData(_ byteCoinManager: ByteCoinManager, assetDataArray: [AssetsData]?) {
        
        self.assetDataArray = assetDataArray
        
        //Modifications to the layout engine must not be performed from a background thread after it has been accessed from the main thread
        
        DispatchQueue.main.async {
            self.pickerAsset.reloadAllComponents()
            self.LoadingStop()
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.LoadingStop()
            self.alert(message: "Something happened! Please Try Later...")
            
        }
    }
    
}

//MARK: - ProgressDialog

extension UIViewController{
    func LoadingStart(message:String){
        
        ProgressDialog.alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        ProgressDialog.alert.view.addSubview(loadingIndicator)
        
        present(ProgressDialog.alert, animated: true, completion: nil)
    }
    
    func LoadingStop(){
        ProgressDialog.alert.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - AlertDialog
extension UIViewController{
    func alert(message:String){
        let alert = UIAlertController(title: "⚠️ Ops!", message: message.capitalized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // Avoids conflicting with progressDialog
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.present(alert, animated: true, completion: nil)
        }
    }
}

