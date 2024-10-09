//
//  P4_1_Quiz_con_SwiftUIApp.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 10/11/23.
//

import SwiftUI

@main
struct P4_1_Quiz_con_SwiftUIApp: App {
    @State var puntosModel = PuntosModel()
    @State var quizzesModel = QuizzesModel()
    @State var tokenModel = TokenModel()
    var body: some Scene {
        WindowGroup {
            QuizHomeView()
                .environment(puntosModel)
                .environment(quizzesModel)
                .environment(tokenModel)
        }
    }
}
