//
//  QuizItem.swift
//  P4.1 Quiz
//
//  Created by Santiago Pavón Gómez on 11/9/23.
//

import Foundation

struct QuizItem: Codable, Identifiable {
    static func == (lhs: QuizItem, rhs: QuizItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let question: String
    //let answer: String
    let author: Author?
    let attachment: Attachment?
    var favourite: Bool
    
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

extension QuizItem {
    static let quizPreview = {
        let adj = QuizItem.Attachment(filename: nil,
                                      mime: "image/jpeg",
                                      url: URL(string: "https://quiz.dit.upm.es/quizzes/75/attachment"))
        
        let author = QuizItem.Author(isAdmin: false,
                                     username: "Ana",
                                     profileName: nil,
                                     photo: nil)
        return QuizItem(id: 1,
                        question: "Pregunta",
                        author: author,
                        attachment: adj,
                        favourite: true)
    }
}
