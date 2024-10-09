//
//  OfflineQuizItem.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 21/12/23.
//

import Foundation

struct OfflineQuizItem: Codable, Identifiable {
    let id: Int
    let question: String
    let answer: String
    let author: Author?
    let attachment: Attachment?
    let favourite: Bool
    
    struct Author: Codable {
        let isAdmin: Bool?
        let username: String?
        let profileName: String?
        let photo: Attachment?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: URL?
    }
}

/*extension OfflineQuizItem {
    static let offlineQuizPreview = {
        let adj = QuizItem.Attachment(
            filename: nil,
            mime: "image/jpeg",
            url: URL(string: "https://quiz.dit.upm.es/quizzes/75/attachment"))
        
        let author = QuizItem.Author(
            isAdmin: false,
            username: "Ana",
            profileName: nil,
            photo: nil)
        return QuizItem(
            id: 1,
            question: "Pregunta",
            answer: "Respuesta",
            author: author,
            attachment: adj,
            favourite: true)
    }
}*/
