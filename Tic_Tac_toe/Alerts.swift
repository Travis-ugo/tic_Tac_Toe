//
//  Alerts.swift
//  Tic_Tac_toe
//
//  Created by Travis Okonicha on 05/01/2022.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let titles: Text
    let messages: Text
    let buttonTitle: Text
}

struct AlertContent {
    static let humanWin = AlertItem(titles: Text("You Win"),
                                    messages: Text("Congartulations"),
                                    buttonTitle:Text("Normally"))
    static let computerWin = AlertItem(titles: Text("Computer Win"),
                                       messages: Text("so sad, you lost"),
                                       buttonTitle:Text("Rematch"))
    static let draw = AlertItem(titles: Text("Its a Draw"),
                                messages: Text("Well Played"),
                                buttonTitle:Text("Play again"))
}
