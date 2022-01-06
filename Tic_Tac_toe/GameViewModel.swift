//
//  GameViewModel.swift
//  Tic_Tac_toe
//
//  Created by Travis Okonicha on 06/01/2022.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isHumansTurn = true
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    
    func processMovePlayer(for position: Int) {
        if isCircleOccuped(in: moves, forIndex:  position) {return}
        // Human Moves processing
        moves[position] = Move(player: .human, boardIndex:  position)
        
        if checkWinConditions (for: .human, in: moves) {
            
            alertItem = AlertContent.humanWin

            return
        }
        if checkForDraw(in: moves) {
            
            alertItem = AlertContent.draw
            
            return
        }
        
        isGameBoardDisabled = true
        
        
        // AI moves Processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
            
            let computerPosition = determineComputerMove(in: moves)
            
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            isGameBoardDisabled = false
            
            if checkWinConditions (for: .computer, in: moves) {
                
                alertItem = AlertContent.computerWin
                
                return
            }
            if checkForDraw(in: moves) {
                
                alertItem = AlertContent.draw
                
                return
            }
            
        }
    }
    
    func isCircleOccuped(in moves: [Move?], forIndex index: Int) -> Bool {
        
        return moves.contains(where: { $0?.boardIndex == index })
        
    }
    
    func determineComputerMove(in Move: [Move?]) -> Int {
        
        let winPatterns: Set<Set<Int>> = [ [1,2,3], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [2,4,6], [0,4,8],]
        
        // if AI try to win.
        
        let computerMove = moves.compactMap { $0 }.filter { $0.player == .computer }
        
        let computerPosition = Set(computerMove.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            
            if winPositions.count == 1 {
                
                let isAvalable = !isCircleOccuped(in: moves, forIndex: winPositions.first!)
                
                if isAvalable { return winPositions.first! }
            }
        }
        
        // if AI cant win, then block
        
        let humanMove = moves.compactMap { $0 }.filter { $0.player == .human }
        
        let humanPosition = Set(humanMove.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            if winPositions.count == 1 {
                
                let isAvalable = !isCircleOccuped(in: moves, forIndex: winPositions.first!)
                
                if isAvalable { return winPositions.first! }
            }
        }
        
        // if Ai cant block, take the middle space
        let centerCircle: Int = 4
        
        if !isCircleOccuped(in: moves, forIndex: centerCircle) { return centerCircle }
        
        // if AI cant take the middle space, pick a random spot
        
        
        
        var movePostion = Int.random(in: 0..<9)
        
        while isCircleOccuped(in: moves, forIndex: movePostion) {
            
            movePostion = Int.random(in: 0..<9)
            
        }
        return movePostion
    }
    func checkWinConditions(for player: Player, in moves: [Move?]) ->Bool {
        
        let winPatterns: Set<Set<Int>> = [ [1,2,3], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [2,4,6], [0,4,8],]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    func checkForDraw(in moves: [Move?]) ->Bool {
        return moves.compactMap { $0 }.count == 9
    }
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
