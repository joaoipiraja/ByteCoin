//
//  ProgressDialog.swift
//  ByteCoin
//
//  Created by João Victor Ipirajá de Alencar on 01/01/21.
//


import UIKit

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
