//
//  ViewPlayQuiz.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 15/11/23.
//

import SwiftUI

struct ViewPlayQuiz: View {
    
    @Environment(PuntosModel.self) var puntosModel
    
    @Environment(QuizzesModel.self) var quizzesModel
    
    @Environment(TokenModel.self) var tokenModel
    
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
    
    
    
    var quiz: QuizItem
    
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
            TextField("Respuesta:", text: $respuesta).onSubmit {
                Task{
                    do{
                        try await respuestaCorrecta = puntosModel.checkAnswer(tokenModel.getToken(), id: quiz.id, answer: respuesta)
                        sacaAlerta = true
                    }catch{
                        msjError = error.localizedDescription
                        origenError = "corrección"
                    }
                }
            }.textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            HStack{
                Button("Verificar") {
                    Task{
                        do{
                            try await respuestaCorrecta = puntosModel.checkAnswer(tokenModel.getToken(), id: quiz.id, answer: respuesta)
                            sacaAlerta = true
                        }catch{
                            msjError = error.localizedDescription
                            origenError = "corrección"
                        }
                    }
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
    
    private var puntos: some View{
        //Contador de respuestas correctas
        Text("\(puntosModel.puntos.count)")
            .font(.title.bold())
            .foregroundStyle(puntosModel.puntos.count == 0 ? .red : .black)
    }
    
    private var author: some View {
        HStack{
            Spacer()
            //Datos del autor
            Text(quiz.author?.profileName ?? quiz.author?.username ?? "Anónimo").font(.body)
            //Foto
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
            .contextMenu(ContextMenu(menuItems: {
                Button(action: {
                    respuesta = ""
                }, label: {
                    Label("Limpiar", systemImage: "x.circle")
                })
                Button(action: {
                    cheater(quiz)
                }, label: {
                    Text("Mostrar respuesta")
                })
            }))
        }
    }
    private var preguntaYestrella: some View {
        HStack{
            //pregunta
            Text(quiz.question)
                .font(.title)
            Estrellita(quiz: quiz)
            
        }
    }
    private var imagenQuiz: some View{
        GeometryReader{ g in
            AsyncImage(url: quiz.attachment?.url){image in
                image.resizable()
            } placeholder: {
                Image("default_quiz_image")
                    .resizable()
            }
            //.frame(width: g.size.width, height: g.size.height)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(sacaAlerta && !respuestaCorrecta ? Color.red : puntosModel.puntos.contains(quiz.id) ? Color.green : Color.blue, lineWidth: 5.0)
            }
            .shadow(color: sacaAlerta && !respuestaCorrecta ? Color.red : puntosModel.puntos.contains(quiz.id) ? Color.green : Color.blue, radius: 4)
            .onTapGesture(count: 2, perform: {
                cheater(quiz)
            })
        }
        .padding()
    }
    func cheater(_ quizItem: QuizItem){
        Task{
            do{
                respuesta = try await quizzesModel.cheatAnswer(tokenModel.getToken(), quiz: quiz)
            }catch{
                msjError = error.localizedDescription
                origenError = "cheater-getAnswer"
            }
        }
    }
}

#Preview {
    let puntosModel = PuntosModel()
    
    return NavigationStack{
        ViewPlayQuiz(quiz: QuizItem.quizPreview())
            .environment(puntosModel)
    }
}
