//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Randy McKown on 2/12/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func getDeviceWidth()->CGFloat {
        // 60 is total horizontal spacing + padding from lazygrid
        let width = UIScreen.main.bounds.width - (60)
        return width / 3
    }
    
    func processMove(for position: Int) {
        // process human moves
        if isSquareOccupied(in: moves, forIndex: position) {return}
        moves[position] = Move(player: .human, boardIndex: position)
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        // process computer moves
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [self] in
            let AIPosition = determineAIMovePosition(in: moves)
            moves[AIPosition] = Move(player: .AI, boardIndex: AIPosition)
            isGameBoardDisabled = false
            if checkWinCondition(for: .AI, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int)-> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineAIMovePosition(in moves: [Move?])-> Int{
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8],
                                          [0,3,6], [1,4,7], [2,5,8],
                                          [0,4,8], [2,4,6]]
        // AI Can Win -- Take Win
        let AIMoves = moves.compactMap {$0}.filter {$0.player == .AI}
        let AIPositions = Set(AIMoves.map {$0.boardIndex})
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(AIPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first!}
            }
        }
        
        // AI Cant Win -- Block Human Win
        let humanMoves = moves.compactMap {$0}.filter {$0.player == .human}
        let humanPositions = Set(humanMoves.map {$0.boardIndex})
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first!}
            }
        }
        
        // AI Cant Block -- Take Middle Square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
            
        }
        
        // AI Middle Already Taken -- Take Random
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?])-> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8],
                                          [0,3,6], [1,4,7], [2,5,8],
                                          [0,4,8], [2,4,6]]
        let playerMoves = moves.compactMap {$0}.filter {$0.player == player}
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true}
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{$0}.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
