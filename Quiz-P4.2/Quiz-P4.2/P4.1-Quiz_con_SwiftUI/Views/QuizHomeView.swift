//
//  ContentView.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 10/11/23.
//

import SwiftUI

struct QuizHomeView: View {
    @Environment(PuntosModel.self) var puntosModel
    
    @Environment(QuizzesModel.self) var quizzesModel
    
    @Environment(TokenModel.self) var tokenModel
    
    @State var initialMaximum = 0 //para colorear las puntuaciones
    
    @State var verTodos = true
    
    @State var showAlertErrorMessage = false
    @State var errorMsg = ""{
        didSet{
            showAlertErrorMessage = true
        }
    }
    
    
    
    var body: some View {
        NavigationStack{
            HStack{
                Toggle("Mostrar quizzes acertados", isOn: $verTodos)
                    .padding(.horizontal)
                NavigationLink{
                    LoginProfileView()
                }label:{
                    Text("\(tokenModel.getToken() == "" ? "Login" : "Perfil")")
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            
            List{
                if tokenModel.getToken() != ""{
                    ForEach(quizzesModel.quizzes){quizItem in
                        if verTodos || !puntosModel.puntos.contains(quizItem.id){
                            NavigationLink{
                                ViewPlayQuiz(quiz: quizItem)
                            } label: {
                                ViewQuizListItem(quiz: quizItem)
                            }
                        }
                    }
                }else{//en modo offline
                    Text("En modo offline no se dan puntos para el record. Inicia sesión en \"Login\"")
                    ForEach(quizzesModel.offlineQuizzes){offlQI in
                        if verTodos || !puntosModel.puntos.contains(offlQI.id){
                            NavigationLink{
                                OfflinePlayView(quiz: offlQI)
                            } label: {
                                OfflineRowQIView(quiz: offlQI)
                            }
                        }
                    }
                }
            }
            
            .alert("Error",
                   isPresented: $showAlertErrorMessage){
            } message: {Text(errorMsg)}
            
            .task{
                if tokenModel.getToken() != "" {
                    do{
                        guard quizzesModel.quizzes.count == 0 else{return}
                        initialMaximum = puntosModel.record.count//Carga el record al inicio de la sesión, para colorear las puntuaciones
                        try await quizzesModel.download(tokenModel.getToken())
                    }catch{
                        errorMsg = error.localizedDescription
                    }
                }else{
                    do{
                        guard quizzesModel.offlineQuizzes.count == 0 else{return}
                        try await quizzesModel.defaultLoad()
                    }catch{
                        errorMsg = error.localizedDescription
                    }
                }
            }
        
            .navigationTitle("Quizzes")
        
            .navigationBarItems(
                leading:
                    HStack{//PUNTUACIONES AQUÍ
                        Text("Record:\(puntosModel.record.count)")//MÁXIMA
                            .font(.title.bold())
                            .foregroundStyle(puntosModel.record.count <= 0 ? .red : .black)
                        Text(" Actual:\(puntosModel.puntos.count)")//ACTUAL
                            .font(.title.bold())
                            .foregroundStyle(puntosModel.puntos.count <= 0 ? .red : puntosModel.puntos.count > initialMaximum ? .green : .black)
                    },
                trailing: Button(action: {
                    Task{
                        if tokenModel.getToken() != "" {//cuando la sesión sí está iniciada
                            do{
                                try await quizzesModel.download(tokenModel.getToken())
                                puntosModel.resetPuntos()
                            }catch{
                                errorMsg = error.localizedDescription
                            }
                        }else{//cuando la sesión no está iniciada(token no introducido)
                            do{
                                try await quizzesModel.defaultLoad()
                                puntosModel.resetPuntos()
                            }catch{
                                errorMsg = error.localizedDescription
                            }
                        }
                    }
                }, label: {
                    Label("Reload", systemImage: "arrow.counterclockwise")
                })
            )
        }
    }
}

#Preview {
    @State var puntosModel = PuntosModel()
    return QuizHomeView()
        .environment(puntosModel)
}

