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
    
    let testGame = Game()
    
    func testInitialSetup() {
        XCTAssertEqual(testGame.p1Cards.count, 26)
        XCTAssertEqual(testGame.p2Cards.count, 26)
    }
    
    func testConvertCardValue() {
        XCTAssertEqual(testGame.convertCardValue(rawCard: "KING"), 13)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "QUEEN"), 12)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "ACE"), 1)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "6"), 6)
        XCTAssertEqual(testGame.convertCardValue(rawCard: "0"), 0)
    }
    func testDidLoseRounds() {
        testGame.roundCount += 1 // roundCount = 1
        testGame.didLoseRounds()
        XCTAssertFalse(testGame.draw)
        testGame.roundCount += 48 //roundCount = 49
        testGame.didLoseRounds()
        XCTAssertFalse(testGame.draw)
        testGame.roundCount += 1 //roundCount = 50
        testGame.didLoseRounds()
        XCTAssertTrue(testGame.draw)
    }
    func testDidLoseP1() {
        testGame.didLose()
        XCTAssertFalse(testGame.p1Win)
        XCTAssertFalse(testGame.p2Win)
        testGame.p1Cards.removeAll()
        testGame.didLose()
        XCTAssertTrue(testGame.p2Win)
    }
    func testDidLoseP2() {
        testGame.p2Cards.removeAll()
        testGame.didLose()
        XCTAssertTrue(testGame.p1Win)
    }
    func testDetermineTitle() {
        XCTAssertEqual(testGame.determineTitle(), "Draw")
        testGame.p1Win = true
        XCTAssertEqual(testGame.determineTitle(), "Player 1 Wins!")
        testGame.p1Win = false
        testGame.p2Win = true
        XCTAssertEqual(testGame.determineTitle(), "Player 2 Wins!")
    }
    func testGenerateMessage() {
        XCTAssertEqual(testGame.generateMessage(), "Draw: 26 - 26")
        testGame.p1Win = true
        XCTAssertEqual(testGame.generateMessage(), "Player 1 wins: 26 - 26")
        testGame.p1Win = false
        testGame.p2Win = true
        XCTAssertEqual(testGame.generateMessage(), "Player 2 wins: 26 - 26")
    }
    func testBattle() {
        testGame.battle()
        XCTAssertNotEqual(testGame.p1Cards.count, 26)
        XCTAssertNotEqual(testGame.p2Cards.count, 26)
        XCTAssertEqual(testGame.roundCount, 1)
        XCTAssertEqual(testGame.p1CardDraw, 0)
        XCTAssertEqual(testGame.p2CardDraw, 0)
        XCTAssertGreaterThan(testGame.p1Cards.count, 0)
        XCTAssertGreaterThan(testGame.p2Cards.count, 0)
        XCTAssertNotNil(testGame.p1CardImage)
        XCTAssertNotNil(testGame.p2CardImage)
        XCTAssertTrue(testGame.p1Cards.count >= 25 && testGame.p1Cards.count <= 27)
        XCTAssertTrue(testGame.p2Cards.count >= 25 && testGame.p2Cards.count <= 27)
        XCTAssertFalse(testGame.p1Win)
        XCTAssertFalse(testGame.p2Win)
        XCTAssertFalse(testGame.draw)
        XCTAssertEqual(testGame.localPlayerMove, 1)
    }
    
}
