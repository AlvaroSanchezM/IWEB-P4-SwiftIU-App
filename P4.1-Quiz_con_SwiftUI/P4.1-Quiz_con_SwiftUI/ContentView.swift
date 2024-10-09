//
//  ContentView.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 10/11/23.
//

import SwiftUI

struct ContentView: View {

    struct Ocean: Identifiable {
        let name: String
        let id = UUID()
    }


    private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic")
    ]

    var body: some View {
        List(oceans) {
            Text($0.name)
        }
    }
    /*
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        List(content: QuizzesModel().quizzes){
            Text("Question")//Text(quizz.question)
            Text("Image")//Image(quizz.attachment)
            Text("Estrellita iluminada/noIluminada")//quizz.favourite? Image(estrellitaIluminada):Image(estrellitaApagada)
            Text("Nombre del Autor")//Text(quizz.author?.username?)
            Text("foto del autor")//Image(quizz.author?.photo?)
        }.padding()
    }
    */
}

#Preview {
    ContentView()
}
