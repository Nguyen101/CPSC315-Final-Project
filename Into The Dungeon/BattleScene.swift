//
//  BattleScene.swift
//  Into The Dungeon
//
//  Created by Latham, Nicholas De Artola on 11/29/20.
//  Copyright © 2020 Vy Nguyen. All rights reserved.
//

import SpriteKit
import GameplayKit

class BattleScene: SKScene {
    

    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var players: [Player] = []
        
    var playerNames: [String] = []
    var turn: Int = 0
    
//    var entityManager: EntityManager! // user to remove or add an entity
    
    
    override func didMove(to view: SKView) {
        observeGameData()
    }
    
    override func sceneDidLoad() {

    }
    
    func observeGameData(){
        FirebaseUtils.observeGameData(gameID: FirstScreenViewController.gameID) { (data) in
            guard let players = data["users"] as? [String] else {
                print("couldn't get players")
                return
            }
            self.playerNames = players
            
            guard let turn = data["turn"] as? Int else {
                print("couldnt get turn")
                return
            }
            self.turn = turn
            
            self.deleteAllPlayerNodes()
            
            for x in players {
                if let player = data[x] as? NSDictionary {
                    
                    
                    var tempPlayer: Player? = nil
                    
                    if let className = player["class"] as? String {
                        if className == "Cleric" {
                            tempPlayer = Player(playerType: .cleric)
                        }else if className == "Mage" {
                            tempPlayer = Player(playerType: .mage)
                        }else if className == "Archer" {
                            tempPlayer = Player(playerType: .archer)
                        }else {
                            tempPlayer = Player(playerType: .warrior)
                        }
                        
                        
                        
                        
                    }
                    
                    if let cards = player["cards"] as? [String] {
                        for x in cards {
                            let type = Card.getCardType(cardName: x)
                            tempPlayer?.currentDeck.append(Card(cardType: type))
                        }
                    }
                    
                    self.players.append(tempPlayer!)
                    
                }
            }
            
            self.addPlayerNodes()
            
            
            
        }
    }
    
    func addPlayerNodes(){
        print("ADDING NODES")
        var i = 0
        for x in players {
            x.name = playerNames[i]
            x.size = CGSize(width: x.size.width/8, height: x.size.height/8)
            x.position = CGPoint(x: 0, y: i*10)
            i += 1
            addChild(x)
        }
    }
    
    /*
     deletes all the nodes
     */
    func deleteAllPlayerNodes(){
        for x in self.players {
            x.removeFromParent()
        }
        self.players = []
    }
    
    /*
     sets the turn to be the next players
     */
    func nextPlayersTurn(){
        updatePlayerInDatabase()
        turn = (turn + 1) % playerNames.count
        FirebaseUtils.setPlayerTurn(gameID: FirstScreenViewController.gameID, turn: turn)
    }
    
    /*
     updates the player in the database
     */
    func updatePlayerInDatabase(){
        
    }
    
    /*
     checks to see if it is the current players turn
     */
    func isCurrentPlayersTurn() -> Bool{
        if turn < playerNames.count {
            if playerNames[turn] == FirstScreenViewController.userName {
                return true
            }
        }
        return false
    }

}

