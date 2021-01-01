//
//  CoinAPI_Data.swift
//  ByteCoin
//
//  Created by João Victor Ipirajá de Alencar on 31/12/20.
//

import Foundation

struct exchangerateData: Codable{
    
    let asset_id_base:String
    let asset_id_quote:String
    let rate:Float
    var rateString:String{
        return String(format: "%.2f", rate)
    }
}


struct AssetsData: Codable{
    
    //let name:String
    let asset_id:String
}
