//
//  ContentView.swift
//  OddEven
//
//  Created by Rahul Gupta on 15/07/23.
//

import SwiftUI

struct ContentView: View {
    @State var todos = [Todo]()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text("Hello, world!")
                      .padding()
                      .onAppear() {
                          TodoApi().loadData { (todos) in
                              self.todos = todos
                              print(todos)
                          }
                      }.navigationTitle("Todos")
            List(todos) {
                todo in
                Text(todo.title)
                //
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
