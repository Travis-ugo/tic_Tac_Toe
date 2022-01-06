//
//  ContentView.swift
//  Tic_Tac_toe
//
//  Created by Travis Okonicha on 04/01/2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
  
    var body: some View {
        
        GeometryReader {
            geometry in
            VStack {
                Spacer()
                LazyVGrid( columns: viewModel.columns, spacing: 10) {
                    ForEach(0..<9){ i in
                        ZStack {
                           GameCircleBox(geometryProxy: geometry)
                            
                            ImagePlayerIndicator(systemName: viewModel.moves[i]?.indicator ?? "")
                            
                        }.onTapGesture {
                            viewModel.processMovePlayer(for: i)
                        }
                        
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            . padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in Alert(title: alertItem.titles, message: alertItem.messages, dismissButton: .default(alertItem.buttonTitle, action: {viewModel.resetGame()})) })
        }
        
        
    }
    
}


enum Player{
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct GameCircleBox: View{
    
    var geometryProxy: GeometryProxy
    var body: some View{
        Circle()
            .foregroundColor(.pink).opacity(0.7)
            .frame(width: geometryProxy.size.width / 3 - 25,
                   height: geometryProxy.size.width / 3 - 25)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct ImagePlayerIndicator: View {
    
    var systemName: String
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
