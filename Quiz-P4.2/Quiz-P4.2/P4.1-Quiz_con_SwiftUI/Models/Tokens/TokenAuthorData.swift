//
//  TokenAuthorData.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 15/12/23.
//

import Foundation

struct TokenAuthorData: Codable{
    let id: Int
    let isAdmin: Bool
    let username: String?
    let accountTypeId: Int
    let profileId: Decimal
    let profileName: String?
    let photo: Attachment?
    
    struct Attachment: Codable {
        //let filename: String?
        let mime: String?
        let url: URL?
    }
}

/*
 {
    "id":226,
    "isAdmin":false,
    "username":null,
    "accountTypeId":3,
    "profileId":107526477183414370000,
    "profileName":"AlvaroSanchezMartinez",
    "photo":{
       "mime":null,
       "url":"https://quiz.dit.upm.es/users/226/photo"
    }
 }
 */
