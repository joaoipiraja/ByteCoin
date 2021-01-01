//
//  ByteCoinManager.swift
//  ByteCoin
//
//  Created by João Victor Ipirajá de Alencar on 31/12/20.
//

import Foundation

protocol ByteCoinManagerDelegate {
    func didUpdateExchangerateData(_ byteCoinManager:ByteCoinManager, exchangerateData:exchangerateData? )
    func didUpdateAssetsData(_ byteCoinManager:ByteCoinManager, assetDataArray:[AssetsData]? )
    func didFailWithError(error: Error)
}

class ByteCoinManager{
    
    private let API_KEY = "488C4737-DC38-4F68-A5F3-236BFDB5CE21"
    var delegate:ByteCoinManagerDelegate?
    
    func fetchExchangerateData(of coinName:String)  {
        
        let string = "https://rest.coinapi.io/v1/exchangerate/BTC/\(coinName.uppercased())"
        print(string)
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(self.API_KEY, forHTTPHeaderField: "X-CoinAPI-Key") //**
        request.httpMethod = "GET"
        //request.addValue("accept", forHTTPHeaderField: "application/json")
        //request.addValue("content-type", forHTTPHeaderField: "application/json")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            
            
            if let safeData = data{
                //print(String(data: safeData, encoding: .utf8))
                if let bitcoin = self.parseJSON_ED(d: safeData){
                    print(bitcoin.rateString)
                    self.delegate?.didUpdateExchangerateData(self, exchangerateData: bitcoin)
                }
            }
        }
        task.resume()
    }
    
    func fetchAssetData()  {
        let string = "https://rest.coinapi.io/v1/assets"
        print(string)

        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(self.API_KEY, forHTTPHeaderField: "X-CoinAPI-Key") //**
        request.httpMethod = "GET"
        //request.addValue("accept", forHTTPHeaderField: "application/json")
        //request.addValue("content-type", forHTTPHeaderField: "application/json")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            
            if let safeData = data{
                
                if let assets = self.parseJSON_AD(d: safeData){
                    print(assets[0].asset_id)
                    self.delegate?.didUpdateAssetsData(self, assetDataArray: assets)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    private func parseJSON_ED(d: Data) -> exchangerateData?{
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do{
            let jsonData = try decoder.decode(exchangerateData.self, from: d)
            return jsonData
        } catch let error as Error {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func parseJSON_AD(d: Data) -> [AssetsData]?{
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
    
        do{
            let jsonData = try decoder.decode([AssetsData].self, from: d)
            return jsonData
            
        } catch let error as Error {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
