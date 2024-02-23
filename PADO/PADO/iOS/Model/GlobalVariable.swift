//
//  GlobalVariable.swift
//  PADO
//
//  Created by 최동호 on 2/23/24.
//

import Foundation

var userNameID: String {
    get {
        UserDefaults.standard.string(forKey: "userNameID") ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "userNameID")
    }
}

var userToken: String {
    get {
        UserDefaults.standard.string(forKey: "userToken") ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "userToken")
    }
}

var savePhoto: Bool {
    get {
        UserDefaults.standard.bool(forKey: "savePhoto")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "savePhoto")
    }
}

var userFollowingIDs: [String] = []
var acceptAlert = "no"
var blockingUser: [BlockUser] = []
var blockedUser: [BlockUser] = []
var needsDataFetch: Bool = false
var resetNavigation: Bool = false
