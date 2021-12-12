//
//  GameView.swift
//  TicTacToe
//
//  Created by Matheus Quirino on 11/12/21.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        //MAKES EVERYTHING RELATIVE TO SCREEN SIZE
        GeometryReader { geometry in
            //AUTOMATICALLY SETS VERTICAL ORIENTATION FOR OBJECTS
            VStack{
                //SPACER THAT USES WHATEVER SPACE IS LEFT AFTER OBJECTS
                HStack{
                    Text("TicTacToe")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding()
                    Spacer()
                    Button{
                        viewModel.restart()
                    } label: {
                        Image(systemName: "gobackward")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                    }
                    .contentShape(Circle())
                }
                Spacer()
                //
                HStack{
                    Text("Turn:\n" + viewModel.currentPlayerLabel)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
                LazyVGrid(columns: viewModel.columns, spacing: 5){
                    //REPEAT THIS 9  TIMES
                    ForEach(0..<viewModel.moves.count){i in
                        //A STACK WHICH CHANGES THE Z-INDEX ACCORDING
                        //TO THE POSITION IN WHICH ITEMS ARE PLACED
                        ZStack{
                            GameCircleView(geometry: geometry)
                            GameIconView(geometry: geometry,
                                         marker: viewModel.moves[i]?.indicator ?? "",
                                         markerColor: viewModel.moves[i]?.player == .human ? Color.blue : Color.red,
                                         i: i)
                        }.onTapGesture{
                            viewModel.makeMove(for: i)
                        }
                    }
                }
                HStack{
                    Text("Human:\n" + String(viewModel.scoreboard[.human]!))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("CPU:\n" + String(viewModel.scoreboard[.cpu]!))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                }.padding()
                Spacer()
                VStack{
                    Text("Built with SwiftUI\nby Matheus Quirino")
                        .foregroundColor(.white)
                        .underline()
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
            }
            .disabled(viewModel.isBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            })
        }
        .background(Color.black)
        .onAppear{
            viewModel.currentPlayerLabel = viewModel.writtenSymbols[Player.human] ?? ""
        }
    }
}

struct Move{
    let player: Player
    let boardIndex: Int
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameCircleView: View {
    var geometry: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.white).opacity(0.8)
            .frame(width: geometry.size.width/3.5 - 15,
                   height: geometry.size.width/3 - 15)
    }
}

struct GameIconView: View {
    var geometry: GeometryProxy
    var marker: String
    var markerColor: Color
    var i: Int
    var body: some View {
        Image(systemName: marker)
            .resizable()
            .frame(width: geometry.size.width/6,
                   height: geometry.size.width/6)
            .foregroundColor(markerColor)
    }
}
