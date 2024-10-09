//
//  OfflinePlayView.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 21/12/23.
//

import SwiftUI

struct OfflinePlayView: View {
    @Environment(PuntosModel.self) var puntosModel
    
    @Environment(QuizzesModel.self) var quizzesModel
    
    //@Environment(TokenModel.self) var tokenModel
    
    @Environment(\.verticalSizeClass) var vSizeClass
    
    @State var origenError = ""//Para saber qué Modelo ha sacado el error
    @State var sacaAlertaError = false
    @State var msjError = ""{
        didSet{
            sacaAlertaError = true
        }
    }
    
    @State private var respuesta: String = ""
    @State private var sacaAlerta = false
    @State private var respuestaCorrecta = false
    
    
    
    var quiz: OfflineQuizItem
    
    var body: some View {
        if vSizeClass == .regular {
            VStack{
                author.padding()
                Spacer()
                preguntaYestrella
                formulario
                Spacer()
                VStack(alignment: .trailing){
                    imagenQuiz
                }
                puntos
            }
        }else{
            HStack{
                VStack{
                    author.padding()
                    Spacer()
                    preguntaYestrella
                    formulario
                    Spacer()
                    puntos
                }
                VStack(alignment: .trailing){
                    imagenQuiz
                }
            }
        }
    }
    
    private var formulario: some View{
        VStack{
            TextField("Respuesta:", text: $respuesta)
                .onSubmit {
                    respuestaCorrecta = puntosModel.checkOffline(answer: respuesta, quiz: quiz)     //Verificar respuesta
                    sacaAlerta = true
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            HStack{
                Button("Verificar") {
                    respuestaCorrecta = puntosModel.checkOffline(answer: respuesta, quiz: quiz)     //Verificar respuesta
                    sacaAlerta = true
                }
                .alert("Respuesta:", isPresented: $sacaAlerta) {
                } message: {
                    Text(respuestaCorrecta ? "Bien" : "Errónea")
                }
                .buttonStyle(.bordered)
            }
        }
        .alert("Error en \(origenError)", isPresented: $sacaAlertaError){
        } message: {Text(msjError)}
    }
    
    private var puntos: some View{                                                              //Contador de respuestas correctas
        Text("\(puntosModel.puntos.count)")
            .font(.title.bold())
            .foregroundStyle(puntosModel.puntos.count == 0 ? .red : .black)
    }
    
    private var author: some View {                                                             //foto y nombre del autor
        HStack{
            Spacer()
            Text(quiz.author?.profileName ?? quiz.author?.username ?? "Anónimo").font(.body)    //nombre
            AsyncImage(url: quiz.author?.photo?.url ?? URL(string: "https://icon-library.com/images/unknown-person-icon/unknown-person-icon-4.jpg")){image in
                image.resizable()
            } placeholder: {
                Image("blank-user")
                    .resizable()
            }
            .frame(width: 30, height: 30)
            .scaledToFit()
            .clipShape(Circle())
            .overlay{
                Circle().stroke(Color.black, lineWidth: 1)
            }
            .contextMenu(ContextMenu(menuItems: {                                               //menu contextual en la foto del autor
                Button(action: {
                    respuesta = ""
                }, label: {
                    Label("Limpiar", systemImage: "x.circle")
                })
                Button(action: {
                    cheater(quiz)                                   //Hacer trampas
                }, label: {
                    Text("Mostrar respuesta")
                })
            }))
        }
    }
    private var preguntaYestrella: some View {                                                  //Pregunta y estrellita
        HStack{
            Text(quiz.question)                                                         //pregunta
                .font(.title)
            Image(quiz.favourite ? "yellowStar" : "greyStar").resizable()               //estrellita
                .frame(width: 20, height: 20)
                .scaledToFit()
        }
    }
    
    private var imagenQuiz: some View{                                                          //imagen del Quiz
        GeometryReader{ g in
            AsyncImage(url: quiz.attachment?.url){image in
                image.resizable()
            } placeholder: {
                Image("default_quiz_image")
                    .resizable()
            }
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay{                                            //animación (cambio de color del borde) al verificar la respuesta
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .stroke(sacaAlerta && !respuestaCorrecta ? Color.red : puntosModel.puntos.contains(quiz.id) ? Color.green : Color.blue, lineWidth: 5.0)
            }
            .shadow(color: sacaAlerta && !respuestaCorrecta ? Color.red : puntosModel.puntos.contains(quiz.id) ? Color.green : Color.blue, radius: 4)
            .onTapGesture(count: 2, perform: {
                cheater(quiz)                                   //Hacer trampas
            })
        }
        .padding()
    }
    
    
    func cheater(_ quizItem: OfflineQuizItem){
        respuesta = quizzesModel.offlineCheater(quiz)           //Hacer trampas
    }
}

/*#Preview {
    let puntosModel = PuntosModel()
    
    return NavigationStack{
        OfflinePlayView(quiz: OfflineQuizItem.offlineQuizPreview())
            .environment(puntosModel)
    }
}*/
