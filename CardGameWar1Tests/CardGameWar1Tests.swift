//
//  CardGameWar1Tests.swift
//  CardGameWar1Tests
//
//  Created by Jimmy Jameson on 11/7/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import XCTest
@testable import CardGameWar1

class CardGameWar1Tests: XCTestCase {
    
    let testGame = TestGame()
    
    func testInitialSetup() {
        //ensure both decks of cards have 26 cards to start game
        XCTAssertEqual(testGame.p1Cards.count, 26)
        XCTAssertEqual(testGame.p2Cards.count, 26)
    }
    
    func testConvertCardValue() {
        //convert cards from string to integer
        XCTAssertEqual(testGame.convertCardValue(rawCard: "KING"), 13)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "QUEEN"), 12)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "ACE"), 1)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "6"), 6)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "0"), 0)
    }
    func testDidLoseRounds() {
        testGame.roundCount += 1 // roundCount = 1
        //lost game after round 1: false
        testGame.didLoseRounds()
        XCTAssertFalse(testGame.draw)
        //lost game after round 49: false
        testGame.roundCount += 48 //roundCount = 49
        testGame.didLoseRounds()
        XCTAssertFalse(testGame.draw)
        //game draw after 50 rounds and no cards played: draw
        testGame.roundCount += 1 //roundCount = 50
        testGame.didLoseRounds()
        XCTAssertTrue(testGame.draw) //score: 26 - 26
    }
    func testDidLoseP1() {
        //game is not lost at start of game
        testGame.didLose()
        //neither team has won
        XCTAssertFalse(testGame.p1Win)
        XCTAssertFalse(testGame.p2Win)
        //player 1 no longer has any cards
        testGame.p1Cards.removeAll()
        testGame.didLose()
        //if player 1 runs out of cards, player 2 should win
        XCTAssertTrue(testGame.p2Win)
    }
    func testDidLoseP2() {
        //player 2 no longer has any cards
        testGame.p2Cards.removeAll()
        testGame.didLose()
        //if player 2 runs out of cards, player 1 should win
        XCTAssertTrue(testGame.p1Win)
    }
    func testDetermineTitle() {
        //at the start of the game, title should read "draw"
        XCTAssertEqual(testGame.determineTitle(), "Draw")
        //if player 1 wins, title should read "Player 1 Wins!"
        testGame.p1Win = true
        XCTAssertEqual(testGame.determineTitle(), "Player 1 Wins!")
        testGame.p1Win = false
        //if player 2 wins, title should read "Player 2 Wins!"
        testGame.p2Win = true
        XCTAssertEqual(testGame.determineTitle(), "Player 2 Wins!")
    }
    func testGenerateMessage() {
        //at the start of the game, the message should read "Draw: 26-26"
        XCTAssertEqual(testGame.generateMessage(), "Draw: 26 - 26")
        //if player 1 wins, message should read "Player 1 wins: 26 - 26"
        testGame.p1Win = true
        XCTAssertEqual(testGame.generateMessage(), "Player 1 wins: 26 - 26")
        testGame.p1Win = false
        //if player 2 wins, message should read "Player 2 wins: 26-26")
        testGame.p2Win = true
        XCTAssertEqual(testGame.generateMessage(), "Player 2 wins: 26 - 26")
    }
    func testBattle() {
        testGame.battle()
        //after a battle, the two players should not have the original number of cards
        if testGame.isWar == false {
            XCTAssertNotEqual(testGame.p1Cards.count, 26)
            XCTAssertNotEqual(testGame.p2Cards.count, 26)
        }
        //after a battle, the roundCount should be incremented by 1
        XCTAssertEqual(testGame.roundCount, 1)
        //after a battle, the top card should be drawn next
        XCTAssertEqual(testGame.p1CardDraw, 0)
        XCTAssertEqual(testGame.p2CardDraw, 0)
        //after a battle, both players should have more than 0 cards
        XCTAssertGreaterThan(testGame.p1Cards.count, 0)
        XCTAssertGreaterThan(testGame.p2Cards.count, 0)
        //after a battle, card images should be generated for each player
        XCTAssertNotNil(testGame.p1CardImage)
        XCTAssertNotNil(testGame.p2CardImage)
        //players should not have 26 cards after a battle
        if testGame.isWar == false {
        XCTAssertTrue(testGame.p1Cards.count >= 25 && testGame.p1Cards.count <= 27)
        XCTAssertTrue(testGame.p2Cards.count >= 25 && testGame.p2Cards.count <= 27)
        }
        //neither player should win, lose, or draw after a battle
        XCTAssertFalse(testGame.p1Win)
        XCTAssertFalse(testGame.p2Win)
        XCTAssertFalse(testGame.draw)
        //the local player move should be incremented by 1
        XCTAssertEqual(testGame.localPlayerMove, 1)
    }
    
}
