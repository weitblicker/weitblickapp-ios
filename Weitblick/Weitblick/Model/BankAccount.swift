//
//  BankAccount.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 02.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class BankAccount{
    
    private var holder : String
    private var iban : String
    private var bic : String
    
    init(holder : String, iban : String, bic : String) {
        self.holder = holder
        self.iban = iban
        self.bic = bic
    }
    
    init(){
        self.holder = ""
        self.iban = ""
        self.bic = ""
    }
    
    public var getHolder : String{
        return self.holder
    }
    
    public var getIban : String{
        return self.iban
    }
    
    public var getBic : String{
        return self.bic
    }
    
}
