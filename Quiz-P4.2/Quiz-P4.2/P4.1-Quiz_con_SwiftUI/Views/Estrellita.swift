//
//  Estrellita.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 24/11/23.
//

import SwiftUI

struct Estrellita: View {
    @Environment(QuizzesModel.self) var quizzesModel
    
    @Environment(TokenModel.self) var tokenModel
    
    @State var sacaAlertaError = false
    @State var msjError = ""{
        didSet{
            sacaAlertaError = true
        }
    }
    
    var quiz: QuizItem
    
    var body: some View {
        Button(action: {
            Task{
                do{//esta es la parte asíncrona
                    try await quizzesModel.toggleFavouriteQuiz(tokenModel.getToken(), quiz: quiz)
                }catch{
                    msjError = error.localizedDescription
                }
            }
        }, label: {
            Image(quiz.favourite ? "yellowStar" : "greyStar").resizable().frame(width: 20, height: 20).scaledToFit()
        })
        
    }
}

/*#Preview {
    return Estrellita(quiz: QuizItem.quizPreview())
}*/

