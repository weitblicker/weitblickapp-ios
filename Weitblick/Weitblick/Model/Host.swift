//
//  Host.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 02.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Host{
    
    private var id : String
    private var name : String
    private var partners : [Int]
    private var bankAccount : BankAccount
    
    init(id : String, name : String, partners : [Int], bankAccount : BankAccount){
        self.id = id
        self.name = name
        self.partners = partners
        self.bankAccount = bankAccount
    }
    
    init(){
        self.id = ""
        self.name = ""
        self.partners = []
        self.bankAccount = BankAccount()
    }
    
    public var getID : String{
        return self.id
    }
    
    public var getName : String{
        return self.name
    }
    
    public var getPartners : [Int]{
        return self.partners
    }
    
    public var getBankAccount : BankAccount{
        return self.bankAccount
    }
    
}
