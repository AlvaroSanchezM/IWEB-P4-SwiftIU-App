//
//  QuizzesModel.swift
//  P4.1 Quiz
//
//  Created by Santiago Pavón Gómez on 11/9/23.
//

import Foundation

extension String: LocalizedError{
    public var errorDescription: String?{
        return self
    }
}

@Observable class QuizzesModel {
    
    // Los datos
    private(set) var quizzes = [QuizItem]()
    
    func load() {
        do {
            guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json") else {
                throw "Internal error: No encuentro quizzes.json"
            }
            
            let data = try Data(contentsOf: jsonURL)
            
            // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else {
                throw "Error: recibidos datos corruptos."
            }
            
            self.quizzes = quizzes
            
            print("Quizzes cargados")
        } catch {
            print(error.localizedDescription)
        }
    }
}
