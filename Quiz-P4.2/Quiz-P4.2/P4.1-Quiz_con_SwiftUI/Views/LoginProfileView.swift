//
//  LoginProfileView.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 15/12/23.
//

import SwiftUI

struct LoginProfileView: View {
    
    @Environment(TokenModel.self) var tokenModel
    @Environment(QuizzesModel.self) var quizzesModel
    @Environment(PuntosModel.self) var puntosModel
    
    @State var sacaAlertaBorrarPts = false
    @State var sacaAlertaLogout = false
    @State var sacaAlertaLogin = false
    
    @State var origenError = ""//Para saber qué Modelo ha sacado el error
    @State var sacaAlertaError = false
    @State var msjError = ""{
        didSet{
            sacaAlertaError = true
        }
    }
    
    @State private var tokenInput: String = "" //6b592181640318397d76"
    @State private var userInput: String = "" //AlvaroSanchezMartinez"
    @State private var justLogged = false
    
    var body: some View {
        if tokenModel.getToken() == "" {//si el token está vacío, hay que hacer login
            VStack{
                Spacer()
                ayuda
                Spacer()
                login
                Spacer()
            }
        }else{//Si el token ya está lleno, se puede hacer logout
            VStack{
                Spacer()
                resetyourrecord
                Spacer()
                logout
                Spacer()
            }
        }
    }
    
    private var login: some View{
        VStack{
            TextField("User:", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            TextField("Token:", text: $tokenInput).onSubmit() {
                Task{
                    do{
                        if try await tokenModel.login(tokenInput, userName: userInput) {
                            justLogged = true
                            sacaAlertaLogin = true
                        }else{
                            justLogged = false
                            sacaAlertaLogin = true
                        }
                    }catch{
                        msjError = error.localizedDescription
                        origenError = "login"
                    }
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            Button(action: {
                Task{
                    do{
                        if try await tokenModel.login(tokenInput, userName: userInput) {
                            justLogged = true
                            sacaAlertaLogin = true
                        }else{
                            justLogged = false
                            sacaAlertaLogin = true
                        }
                    }catch{
                        msjError = error.localizedDescription
                        origenError = "login"
                    }
                }
            }, label: {
                Text("Login")
            })
            .alert("", isPresented: $sacaAlertaLogin) {
            } message: {
                Text(justLogged ? "Sesión iniciada" : "Token o usuario incorrectos")
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var logout: some View{
        Button(action: {
            tokenModel.logout()
            quizzesModel.eraseQuizzes()
            puntosModel.resetPuntos()
            puntosModel.resetRecord()
            justLogged = false
            sacaAlertaLogout = true
        }, label: {
            Text("Logout")
        })
        .alert("", isPresented: $sacaAlertaLogout) {
        } message: {
            Text("Sesión cerrada")
        }
        .buttonStyle(.bordered)
    }
    
    private var ayuda: some View{
        NavigationLink{
            LoginHelpView()
        }label:{
            Text("Ayuda para crear cuenta o token")
        }
        .buttonStyle(.bordered)
    }
    
    private var resetyourrecord: some View{
        Button(action: {
            puntosModel.resetPuntos()
            puntosModel.resetRecord()
            sacaAlertaBorrarPts = true
        }, label: {
            Text("Borrar puntos y record")
        })
        .alert("", isPresented: $sacaAlertaBorrarPts) {
        } message: {
            Text("Puntos y record borrados")
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    LoginProfileView()
}
