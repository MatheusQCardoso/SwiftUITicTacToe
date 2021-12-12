//
//  Alerts.swift
//  TicTacToe
//
//  Created by Matheus Quirino on 11/12/21.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext{
    static let winHuman = AlertItem(title: Text("Good job!"), message: Text("Player Wins."), buttonTitle: Text("Great"))
    static let winCPU = AlertItem(title: Text("Better luck next time."), message: Text("CPU Wins."), buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Better luck next time."), message: Text("DRAW."), buttonTitle: Text("Play again"))
}

