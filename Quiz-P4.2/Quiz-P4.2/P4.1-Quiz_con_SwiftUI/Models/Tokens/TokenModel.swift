//
//  TokenModel.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 15/12/23.
//

import Foundation

@Observable class TokenModel{
    var token: String = ""
    var user : TokenAuthorData?
    
    init(){
        token = UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func getToken() -> String{
        return token
    }
    
    func logout(){
        token = ""
        UserDefaults.standard.set(token, forKey:"token")
        UserDefaults.standard.synchronize()
    }
    
    func login(_ logInfo: String, userName: String) async throws -> Bool{
        
        user = try? await getAuthorData(logInfo)
        if userName != "" && logInfo != ""{//Verifica que no se deja vacía la casilla de userName
            print("Userlogin:\(userName), UserToken:\(user?.username ?? "empty"), ProfileToken:\(user?.profileName ?? "empty")")
            if  user?.profileName == userName || user?.username == userName{//Verifica que userName proporcionado sea el del autor del token
                self.token = logInfo
                UserDefaults.standard.set(token, forKey:"token")
                UserDefaults.standard.synchronize()
                print("Token saved to defaults")
                return true
            } else{
                print("Error login: unknown user token")
                return false
            }
        }else{
            print("Error login: no user input found")
            return false
        }
        
    }
    
    func getAuthorData(_ token: String) async throws -> TokenAuthorData{
        guard let url = URL(string: "https://quiz.dit.upm.es/api/users/tokenOwner?token=\(token)") else {
            throw "getAuthor-Fallo interno: No se pudo crear la URL para llamar al servidor"
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw "getAuthor-Fallo en la conexión con el servidor"
        }
        
        print("Response ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
        guard let datos = try? JSONDecoder().decode(TokenAuthorData.self, from: data)  else {
            print("getAuthor-Error: recibidos datos corruptos.")
            throw "getAuthor-Error: recibidos datos corruptos."
        }
        print("getAuthor-Author cargado")
        return datos
    }
}
