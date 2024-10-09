//
//  LoginHelpView.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 21/12/23.
//

import SwiftUI

struct LoginHelpView: View {
    var body: some View {
        Text("¿Cómo hacer una cuenta y sacar el token?")
            .font(.title)
        List{
            VStack{
                Text("Primero hay que hacerse una cuenta en la web")
                Link(destination: URL(string: "https://quiz.dit.upm.es/login")!, label: {
                    Text("Página web de quizzes")
                })
                .buttonStyle(.bordered)
                Image("TutImg1")//foto1 sitio login general
                    .scaledToFit()
                Image("TutImg2")//foto2 Login con cuenta
                    .scaledToFit()
            }
            VStack{
                Text("___________________________________")
            }
            VStack{
                Text("Entramos con Google, por ejemplo")
                Image("TutImg3")//foto3
                    .scaledToFit()
                Image("TutImg4")//foto4
                    .scaledToFit()
            }
            VStack{
                Text("___________________________________")
            }
            VStack{
                Text("Entramos en la vista de perfil")
                Image("TutImg5")//foto5
                    .scaledToFit()
                Image("TutImg6")//foto6
                    .scaledToFit()
                Text("Hacemos click en Edit")
            }
            VStack{
                Text("___________________________________")
            }
            VStack{
                Text("Click en \"Generate new token\"")
                Text(" y luego en \"Save\"")
                Image("TutImg7")//Imagen 7
                    .scaledToFit()
            }
            VStack{
                Text("___________________________________")
            }
            VStack{
                Text("Tomamos el UserName y el Token y los introducimos en los correspondientes lugares del login de la aplicación y apretamos el botón \"Login\"")
            }
            VStack{
                Text("___________________________________")
            }
        }
    }
}

#Preview {
    LoginHelpView()
}
