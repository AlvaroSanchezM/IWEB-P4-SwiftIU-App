//
//  Endpoints.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 24/11/23.
//

import Foundation

let urlBase = "https://quiz.dit.upm.es"

//let token = "6b592181640318397d76"

struct Endpoints{
    static func random10(_ token: String) -> URL?{
        let path = "/api/quizzes/random10"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
    }
    static func checkAnswer(_ token: String, id: Int, respuesta: String) -> URL?{
        let respuestaEscapada = respuesta.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let path = "/api/quizzes/\(id)/check"
        let str = "\(urlBase)\(path)?answer=\(respuestaEscapada ?? respuesta)&token=\(token)"
        return URL(string: str)
    }
    static func fav(_ token: String, id: Int) -> URL?{
        let path = "/api/users/tokenOwner/favourites/\(id)"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
    }
    static func cheatAnswer(_ token: String, quizItem: QuizItem) -> URL?{
        let path = "/api/quizzes/\(quizItem.id)/answer"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
    }
}
