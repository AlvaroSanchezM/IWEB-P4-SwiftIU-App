//
//  PuntosModel.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 21/11/23.
//

import Foundation

@Observable class PuntosModel {
    
    // Los datos
    var puntos: Set<Int> = []
    var record : Set<Int> = []
    
    init(){
        let a = UserDefaults.standard.object(forKey: "record") as? [Int] ?? []
        record = Set(a)
    }
    
    func checkOffline(answer: String, quiz: OfflineQuizItem) -> Bool {//para playOffline
        if answer.trimmingCharacters(in: .whitespaces).lowercased() == quiz.answer.lowercased(){
            if !puntos.contains(quiz.id){//Si ya se ha acertado, no se dan más puntos
                puntos.insert(quiz.id)//en modo offline, no se suman puntos para el record
            }
            return true
        }else{
            return false
        }
    }
    
    func checkAnswer(_ token: String, id: Int, answer: String) async throws -> Bool{
        
        guard let jsonURL = Endpoints.checkAnswer(token, id: id, respuesta: answer) else {
            throw "CheckAns-Fallo interno: No se pudo crear la URL para llamar al servidor"
        }
        
        let (data, response) = try await URLSession.shared.data(from: jsonURL)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw "CheckAns-Fallo en la conexión con el servidor"
        }
        
        // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
        guard let respondido = try? JSONDecoder().decode(QuizItemAnswer.self, from: data)  else {
            throw "CheckAns-Error: recibidos datos corruptos."
        }
        
        if respondido.result && !puntos.contains(id){
            self.add(id)
        }
        
        print("CheckAns-Verificado quiz\(id)")
        
        return respondido.result
    }
    
    func add(_ id: Int) {
        puntos.insert(id)
        if !record.contains(id){
            record.insert(id)
            UserDefaults.standard.set(Array(record), forKey:"record")
            UserDefaults.standard.synchronize()
        }
    }
    func resetPuntos(){
        puntos = []
    }
    func resetRecord(){
        record = []
        UserDefaults.standard.set(Array(record), forKey:"record")
        UserDefaults.standard.synchronize()
    }
}
