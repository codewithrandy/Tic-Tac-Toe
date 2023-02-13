//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Randy McKown on 2/12/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win"),
                                    message: Text("😀 You Won !"),
                                    buttonTitle: Text("Play Again?"))
    static let computerWin = AlertItem(title: Text("You Lost"),
                                    message: Text("☹️ You Lost !!!"),
                                    buttonTitle: Text("Play Again?"))
    static let draw = AlertItem(title: Text("Draw"),
                                    message: Text("No Winner"),
                                    buttonTitle: Text("Play Again?"))
}
