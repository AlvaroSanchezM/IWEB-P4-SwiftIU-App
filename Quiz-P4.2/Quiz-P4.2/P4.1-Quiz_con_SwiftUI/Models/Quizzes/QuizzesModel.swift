//
//  QuizzesModel.swift
//  P4.1 Quiz
//
//  Created by Santiago Pavón Gómez on 11/9/23.
//

import Foundation

@Observable class QuizzesModel {
    
    // Los datos
    private(set) var quizzes = [QuizItem]()
    private(set) var offlineQuizzes = [OfflineQuizItem]()
    
    func download(_ token: String) async throws{
        guard let url = Endpoints.random10(token) else {
            throw "Downl-Fallo interno: No se pudo crear la URL para llamar al servidor"
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw "Downl-Fallo en la conexión con el servidor"
        }
        
        //print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
        guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else {
            throw "Downl-Error: recibidos datos corruptos."
        }
        //self.quizzes es el quizzes de la clase, NO el de la función
        self.quizzes = quizzes
        
        print("Downl-Quizzes cargados")
    }
    
    func toggleFavouriteQuiz(_ token: String, quiz: QuizItem) async throws {
        
        guard let url = Endpoints.fav(token, id: quiz.id) else { //Generación de URL
            throw "Fav-Fallo interno: No se pudo crear la URL para llamar al servidor"
        }
        //print("Fav-URL creada")
        
        var request = URLRequest(url: url)
        request.httpMethod = quiz.favourite ? "DELETE" : "PUT"//Peticiones put o delete
        //print("Fav-Cambiado método HTTP (a put o a delete)")
        
        let (data, response) = try await URLSession.shared.data(for: request)//Envío de la petición HTTPS
        //print("Fav-Iniciado intercambio HTTPS")
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{//manejo de la respuesta
            throw "Fav-Fallo en la conexión con el servidor"
        }
        //print("Fav-Finalizado intercambio HTTPS")
        
        // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
        guard let respondido = try? JSONDecoder().decode(QuizFavourite.self, from: data)  else {
            throw "Fav-Error: recibidos datos corruptos."
        }
        //print("Fav-Datos de la respuesta parseados")
        
        //print("Fav-quiz.id = \(quiz.id)")
        
        //modificar array quizzes
        guard let i = quizzes.firstIndex(where: {qitem in qitem.id == quiz.id}) else{
            print("Fav-Index NO encontrado")
            throw "Fav-No encontrado el quiz para poner favorito en quizzes"
        }
        print("Fav-Index Encontrado")
        quizzes[i].favourite = respondido.favourite
    }
    
    func cheatAnswer(_ token: String, quiz: QuizItem) async throws -> String{
        guard let url = Endpoints.cheatAnswer(token, quizItem: quiz) else {
            throw "CheatAns-Fallo interno: No se pudo crear la URL para llamar al servidor"
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw "CheatAns-Fallo en la conexión con el servidor"
        }
        
        // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
        guard let cheater = try? JSONDecoder().decode(QuizCheatAnswer.self, from: data)  else {
            throw "CheatAns-Error: recibidos datos corruptos."
        }
        //self.quizzes es el quizzes de la clase, NO el de la función
        
        
        print("CheatAns-answer de quiz \(quiz.id) cargada")
        return cheater.answer
    }
    
    func eraseQuizzes(){//para borrar los quizzes cuando se hace logout
        quizzes = [QuizItem]()
    }
    
    func defaultLoad() async throws {//para enseñar algunos quizzes cuando no se está logueado, usamos la carga offline de la P4.1
        guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json") else {
            throw "defLoad-Internal error: No encuentro quizzes.json"
        }
        
        let data = try Data(contentsOf: jsonURL)
        
        // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
        guard let quizzes = try? JSONDecoder().decode([OfflineQuizItem].self, from: data)  else {
            throw "defLoad-Error: recibidos datos corruptos."
        }
        
        self.offlineQuizzes = quizzes
        
        print("Load-offlineQuizzes cargados")
    }
    
    func offlineCheater(_ quiz: OfflineQuizItem) -> String{
        return quiz.answer
    }
}
