//
//  OfflineRowQI.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 21/12/23.
//

import SwiftUI

struct OfflineRowQIView: View {
    var quiz: OfflineQuizItem
    //var contador: PuntosModel//[Int]
    @Environment(PuntosModel.self) var contador
    
    var body: some View {
        HStack{
            imagenQuiz
            VStack{
                HStack{
                    //Estrellita(quiz: quiz) //No funciona como botón
                    Spacer()
                    author
                }
                //Pregunta
                Text(quiz.question).font(.title3).lineLimit(4)
            }
        }
    }
    private var imagenQuiz: some View{
        AsyncImage(url: quiz.attachment?.url){image in
            image.resizable()
        } placeholder: {
            Image("default_quiz_image")
                .resizable()
        }
        .frame(width: 50, height: 50)
        .scaledToFit()
        .clipShape(Circle())
        .overlay{
            Circle().stroke(contador.puntos.contains(quiz.id) ? Color.green : Color.blue, lineWidth: 2.0)
        }.shadow(color: contador.puntos.contains(quiz.id) ? Color.green : Color.blue, radius: 2)
    }
    
    private var author: some View {
        HStack{
            //Datos del autor
            Text(quiz.author?.profileName ?? quiz.author?.username ?? "Anónimo").font(.body)
            //imagen
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
        }
    }
}

/*#Preview {
    let puntosModel = PuntosModel()
    //puntosModel.add(id: 48)
    return OfflineRowQIView(quiz: OfflineQuizItem.offlineQuizPreview())
        .environment(puntosModel)
}*/
