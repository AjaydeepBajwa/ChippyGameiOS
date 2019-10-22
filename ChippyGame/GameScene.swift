//
//  GameScene.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-05.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    // Sprite/Shape Nodes Declaration
    var playerHealthNode:SKShapeNode!
    var enemyHealthNode:SKShapeNode!
    var enemy:SKSpriteNode!
    var enemyCore:SKSpriteNode!
    var upArrow:SKSpriteNode!
    var downArrow:SKSpriteNode!
    var leftArrow:SKSpriteNode!
    var rightArrow:SKSpriteNode!
    var upLeftArrow:SKSpriteNode!
    var downLeftArrow:SKSpriteNode!
    var upRightArrow:SKSpriteNode!
    var downRightArrow:SKSpriteNode!
    var reloadBtn:SKSpriteNode!
    var healthUp:SKSpriteNode!
    var shield:SKSpriteNode!
    var shieldBubble:SKSpriteNode!
    var obstacle:SKSpriteNode!
    var timeElapsedSprite:SKLabelNode!
    
    // Player/Bullet Object Variables
    var player:Player = Player(imageNamed: "player")
    var playerBullet:Bullet = Bullet(imageNamed: "player_bullet")
    var enemyBullet:Bullet = Bullet(imageNamed: "enemyBullet")
    
    // Other required variables
    let player_speed:CGFloat = 30
    var enemyPartsCount = 0
    var enemyPartPercentage:Double = 0
    var bulletsArray:[SKSpriteNode] = []
    var enemyBulletsArray:[SKSpriteNode] = []
    var arrowTouched:String = ""
    var touch:UITouch!
    var mouseX:CGFloat! = 100
    var mouseY:CGFloat! = 100
    var arrowButtonTouched = false
    var shootBullet = false
    var arrowButtonsRect:CGRect!
    var burstType = 1
    var healthMilliCount = 0
    var shieldMilliCount = 60
    var shieldTimer = 0
    var timeElapsedSeconds = 00
    var timeElapsedMinutes = 00
    var timeElapsedHours = 00
    
    override func didMove(to view: SKView) {
        // Setting the physics contact delegate
        self.physicsWorld.contactDelegate = self
        
        //Setting up the Game Background
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        print("screen: \(self.size.width), \(self.size.height)")
        
        //Adding the player Sprite
        self.player = Player(imageNamed: "player")
        self.player.size.width = self.size.width/15
        self.player.size.height = self.size.height/12
        self.player.position = CGPoint(x: self.size.width*0.2, y: self.size.height*0.3)
        self.player.zPosition = 5
        addChild(self.player)
        
        // Player Health Indicator
        self.playerHealthNode = self.scene?.childNode(withName: "playerHealth") as! SKShapeNode
        
        // Circular Path for Enemy Movement
        let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 30, height: 50), cornerRadius: 30)
        let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, duration: 5.0)
        let circleAnimation = followCircle.reversed()
        
        // EnemyCore Initialization
        self.enemyCore = self.scene?.childNode(withName: "core") as! SKSpriteNode
        
        // Enemy Core Animation Textures
        let image1 = SKTexture(imageNamed: "core1")
        let image2 = SKTexture(imageNamed: "core2")
        let image3 = SKTexture(imageNamed: "core3")
        let coreTextures = [image1, image2, image3, image1]
        let coreAnimation = SKAction.animate(
            with: coreTextures,
            timePerFrame: 0.4)
        
        //Animating Enemy Core in circular path and different textures
        let coreAnimationGroup = SKAction.group([circleAnimation.reversed(),coreAnimation])
        self.enemyCore.run(SKAction.repeatForever(coreAnimationGroup))
        
        // Getting the enemy parts
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            self.enemy = node as? SKSpriteNode
            self.enemy.run(SKAction.repeatForever(circleAnimation.reversed()))
            self.enemyPartsCount = self.enemyPartsCount + 1
        }
        // Percentage of single enemy part among total enemy parts
        self.enemyPartPercentage = Double(100/self.enemyPartsCount)
        print("Total Enemy Parts: \(self.enemyPartsCount)")
        
        // Enemy Health Indicator
        self.enemyHealthNode = self.scene?.childNode(withName: "enemyHealth") as! SKShapeNode
        
        // Adding and positioning movement buttons/sprites
        self.leftArrow = SKSpriteNode(imageNamed: "left")
        self.leftArrow.size = CGSize(width: self.size.width/25, height: self.size.height/20)
        self.leftArrow.position = CGPoint(x: 100, y: 250)
        addChild(self.leftArrow)
        
        self.downArrow = SKSpriteNode(imageNamed: "down")
        self.downArrow.size = CGSize(width: self.size.height/20 , height: self.size.width/30)
        self.downArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y - self.leftArrow.size.height*1.5)
        addChild(self.downArrow)
        
        self.rightArrow = SKSpriteNode(imageNamed: "right")
        self.rightArrow.size = CGSize(width: self.size.width/25, height: self.size.height/20)
        self.rightArrow.position = CGPoint(x: self.downArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y)
        addChild(self.rightArrow)
        
        self.upArrow = SKSpriteNode(imageNamed: "up")
        self.upArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upArrow.position = CGPoint(x: self.downArrow.position.x, y: self.leftArrow.position.y + self.leftArrow.size.height*1.5)
        addChild(self.upArrow)
        
        self.upLeftArrow = SKSpriteNode(imageNamed: "upLeft")
        self.upLeftArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upLeftArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*0.7, y: self.upArrow.position.y - self.upArrow.size.height*0.7)
        addChild(self.upLeftArrow)
        
        self.downLeftArrow = SKSpriteNode(imageNamed: "downLeft")
        self.downLeftArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.downLeftArrow.position = CGPoint(x: self.upLeftArrow.position.x, y: self.downArrow.position.y + self.downArrow.size.height*0.7)
        addChild(self.downLeftArrow)
        
        self.downRightArrow = SKSpriteNode(imageNamed: "downRight")
        self.downRightArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.downRightArrow.position = CGPoint(x: self.rightArrow.position.x - self.rightArrow.size.width*0.7, y: self.downLeftArrow.position.y)
        addChild(self.downRightArrow)
        
        self.upRightArrow = SKSpriteNode(imageNamed: "upRight")
        self.upRightArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upRightArrow.position = CGPoint(x: self.downRightArrow.position.x, y: self.upLeftArrow.position.y)
        addChild(self.upRightArrow)
        
        // Game Restart Button
        self.reloadBtn = self.scene?.childNode(withName: "reload") as! SKSpriteNode
        
        //Area covered by movement buttons
        self.arrowButtonsRect = CGRect(x: 0, y: 0, width: self.rightArrow.position.x + self.rightArrow.size.width/2, height: self.upArrow.position.y + self.upArrow.size.height/2)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //check if any arrow button is touhed
        if self.arrowButtonTouched == true {
            self.movePlayer()
        }
        
        //Check whether player should shoot new bullets or not
        if self.shootBullet == true{
            self.spawnPlayerBullet()
            self.moveBulletToTarget()
        }
        
        //remove bullets after they hit edges or player/enemy
        self.removeBullet()
        self.bulletHitsEnemy()
        self.removeEnemyBullets()
        
        self.healthMilliCount = self.healthMilliCount + 1
        self.shieldMilliCount = self.shieldMilliCount + 1
        
        // Show shield/health powerup and obstacles after particular time intervals.
        if (self.shieldMilliCount % 240 == 0){
            self.spawnShield()
        }
        if (self.healthMilliCount % 240 == 0){
            self.spawnHealthUp()
        }
        if (self.shieldMilliCount % 100 == 0){
            self.spawnObstacle()
        }
        if (healthMilliCount%50 == 0){
            self.spawnEnemyBullet()
        }
        //remove powerups after they hit edges
        self.removePowerUp()
        //Start shield countdown timer after player gets shield
        self.playerGetsShield()
        if (self.shieldTimer > 0){
            self.shieldTimer = self.shieldTimer - 1
            let shieldActiveSound = SKAction.playSoundFileNamed("shieldActive", waitForCompletion: true)
            self.run(shieldActiveSound)
            print("Shield Timer: \(self.shieldTimer)")
        }
        if (self.shieldTimer) == 1 {
            self.removePlayerShield()
        }
        self.endGame()
        
        // Show Time Elapsed during the Gameplay
        if (self.healthMilliCount % 10 == 0){
            self.timeElapsed()
    
        }
    }
    
    func timeElapsed(){
        // Calculate total time elapsed in hrs:min:sec format
        self.timeElapsedSeconds = self.timeElapsedSeconds + 1
        self.timeElapsedSprite = self.scene?.childNode(withName: "timeElapsed") as! SKLabelNode
        self.timeElapsedSprite.text =  String(format: "%02d", self.timeElapsedSeconds)
        self.timeElapsedSprite.text = "Time Elapsed: \(String(format: "%02d", self.timeElapsedHours)):\(String(format: "%02d", self.timeElapsedMinutes)):\(String(format: "%02d", self.timeElapsedSeconds))"
        if (self.timeElapsedSeconds % 60 == 0){
            self.timeElapsedMinutes = self.timeElapsedMinutes + 1
            self.timeElapsedSeconds = 0
            if (self.timeElapsedMinutes % 60 == 0){
                self.timeElapsedHours = self.timeElapsedHours + 1
                self.timeElapsedMinutes = 0
            }
        }
    }
    
    
    func spawnPlayerBullet() {
        // Make a bullet
        if(self.bulletsArray.count <= 1){
            self.playerBullet = Bullet(imageNamed: "player_bullet")
            self.playerBullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "player_bullet"), size: self.playerBullet.size)
            self.playerBullet.physicsBody?.affectedByGravity = false
            self.playerBullet.physicsBody?.categoryBitMask = 16
            self.playerBullet.physicsBody?.collisionBitMask = 0
            self.playerBullet.size.width = self.player.size.width/2
            self.playerBullet.size.height = self.player.size.height/2
            self.playerBullet.position = CGPoint(x: self.player.position.x - 30, y: self.player.position.y)
            addChild(self.playerBullet)
            self.playerBullet.zPosition = 7
            self.bulletsArray.append(self.playerBullet)

            //Add sound when player spawns bullet
            let bulletSound = SKAction.playSoundFileNamed("shootBullet", waitForCompletion: true)
            self.run(bulletSound)
        }
        print("No. of bullets: \(self.bulletsArray.count)")
    }
    
    func spawnEnemyBullet(){
        // Spawn Enemy Bullets if no.of bullets is zero
        if (self.enemyBulletsArray.count <= 0){
            if (self.burstType == 1){
                // Shoot enemy Bullets in a cicular burst
                for i in stride(from: 0.1, to: 2*CFloat.pi, by: 0.3){
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    let x = 50*cos(i) + 1480
                    let y = 50*sin(i) + 767
                    let enemyBulletAction = SKAction.applyImpulse(
                        CGVector(dx: CDouble(x - 1480), dy: CDouble(y - 767)),duration: 10)
                    self.enemyBullet.run(enemyBulletAction)
                }
            }
            if(self.burstType == 2){
                // Shoot Bullets that target the player.
                var duration = 50
                for i in stride(from: 1, to: 4, by: 1){
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet2")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    
                    let x =  Float(self.player.position.x)
                    let y =  Float(self.player.position.y)
                    //moving bullet towards player
                    let enemyBulletAction = SKAction.applyImpulse(
                        CGVector(dx: CDouble(x - 1480), dy: CDouble(y - 767)),duration: TimeInterval(duration))
                    self.enemyBullet.run(enemyBulletAction)
                    duration = duration + 20
                    
                }
            }

            if(self.burstType == 3){
                // Shoot bullets in Four Different Directions follwing a semi circular path
                var duration = 20
                for _ in 0...3{
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)

                    //move in up left direction
                    let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2000, height: 2000), cornerRadius: 1000)
                    let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: true, duration: TimeInterval(duration))
                    let circleAnimation = followCircle
                    self.enemyBullet.run((circleAnimation.reversed()))
                    
                    
                    //move in down left direction
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet3")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    
                    let circle2 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: -2000, height: -2000), cornerRadius: 1000)
                    let followCircle2 = SKAction.follow(circle2.cgPath, asOffset: true, orientToPath: true, duration:  TimeInterval(duration))
                    let circleAnimation2 = followCircle2.reversed()
                    
                    self.enemyBullet.run((circleAnimation2.reversed()))
                    
                    //move in down Right direction
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet3")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    self.enemyBullet.run((circleAnimation2))
                    
                    //move in up right direction
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    
                    let circle3 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2000, height: 2000), cornerRadius: 1000)
                    let followCircle3 = SKAction.follow(circle3.cgPath, asOffset: true, orientToPath: true, duration:  TimeInterval(duration))
                    let circleAnimation3 = followCircle3.reversed()
                    self.enemyBullet.run((circleAnimation3.reversed()))
                    
                    duration = duration + 5
                }
            }
            // Set zPosition of enemyBullets
            self.enumerateChildNodes(withName: "enemyBullet") {
                node, stop in
                node.zPosition = 6
            }
            
            // play a sound when enemy shoots bullets in any pattern
            let bulletSound = SKAction.playSoundFileNamed("enemyBullet", waitForCompletion: true)
            run(bulletSound)
        }
    }
    
    func removeEnemyBullets(){
        // Getting all enemyBullet objects using enumeration.
        self.enemyBullet.name = "enemyBullet"
        self.enumerateChildNodes(withName: "enemyBullet") {
            node, stop in
            if(self.enemyBulletsArray.count != 0){
                if (node is SKSpriteNode) {
                    let sprite = node as! SKSpriteNode
                    //Remove enemy bullets after they hit the borders
                    if (sprite.position.x < 10 || sprite.position.x > self.size.width - 10 || sprite.position.y < 10 || sprite.position.y > self.size.height - 10) {
                        sprite.removeFromParent()
                        self.enemyBulletsArray.removeFirst()
                        print("no.of enemy bullets: \(self.enemyBulletsArray.count)")
                    }
                    
                    //remove enemy bullets and decrease player health after they hit player
                    if(sprite.intersects(self.player)){
                        if (self.shieldTimer < 1)&&(self.playerHealthNode.xScale >= 0){
                        sprite.removeFromParent()
                        self.enemyBulletsArray.removeFirst()
                        self.playerHealthNode.xScale = self.playerHealthNode.xScale - (10*5)/100
                        print("no.of enemy bullets: \(self.enemyBulletsArray.count)")
                        }
                    }
                    
                    //Changing Burst type one after another.
                    if(self.enemyBulletsArray.count == 0){
                        
                        if (self.burstType == 1){
                            self.burstType = 2
                        }
                            
                        else if (self.burstType == 2){
                            self.burstType = 3
                        }
                        else if (self.burstType == 3){
                            self.burstType = 1
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func spawnHealthUp(){
        // Show up Health Powerup and move in random directions. One Health powerup at a time.
        if(children.contains(where: { $0.name?.contains("healthUp") ?? false }) == false){
            self.healthUp = SKSpriteNode(imageNamed: "healthUp")
            self.healthUp.name = "healthUp"
            self.healthUp.position.x = self.size.width/2
            self.healthUp.position.y = 50
            self.healthUp.zPosition = 4
            self.healthUp.physicsBody = SKPhysicsBody(rectangleOf: self.healthUp.size)
            self.healthUp.physicsBody?.categoryBitMask = 1
            self.healthUp.physicsBody?.collisionBitMask = 0
            addChild(self.healthUp)
            
            let healthMove = SKAction.applyImpulse(CGVector(dx: CGFloat.random(in: -(self.size.width)...self.size.width), dy: CGFloat.random(in: self.size.height/2...self.size.height)), duration: 50)
            self.healthUp.run(SKAction.repeatForever(healthMove))
        }
    }
    
    func spawnShield(){
        // Show up Shield powerup if there is no other shield on scene and move it in random directions.
        if(children.contains(where: { $0.name?.contains("shield") ?? false }) == false){
            self.shield = SKSpriteNode(imageNamed: "shield")
            self.shield.name = "shield"
            self.shield.position.x = self.size.width/2
            self.shield.position.y = 50
            self.shield.zPosition = 4
            self.shield.physicsBody = SKPhysicsBody(rectangleOf: self.shield.size)
            self.shield.physicsBody?.categoryBitMask = 2
            self.shield.physicsBody?.collisionBitMask = 0
            addChild(self.shield)
            
            let shieldMove = SKAction.applyImpulse(CGVector(dx: CGFloat.random(in: -(self.size.width)...self.size.width), dy: CGFloat.random(in: self.size.height/2...self.size.height)), duration: 50)
            self.shield.run(shieldMove)
        }
    }
    
    func spawnObstacle(){
        // Show up Obstacle generated by world and move it in random direction.
        if(children.contains(where: { $0.name?.contains("obstacle") ?? false }) == false){
            self.obstacle = SKSpriteNode(imageNamed: "obstacle")
            self.obstacle.name = "obstacle"
            self.obstacle.position.x = CGFloat.random(in: self.size.width/2...self.size.width)
            self.obstacle.position.y = 50
            self.obstacle.zPosition = 4
            self.obstacle.physicsBody = SKPhysicsBody(circleOfRadius: self.obstacle.size.width/2)
            self.obstacle.physicsBody?.categoryBitMask = 32
            self.obstacle.physicsBody?.collisionBitMask = 0
            addChild(self.obstacle)
            
            let obstacleMove = SKAction.applyImpulse(CGVector(dx: CGFloat.random(in: -(self.size.width*0.4)...self.size.width), dy: CGFloat.random(in: (self.size.height/3)...self.size.height)), duration: 50)
            self.obstacle.run(obstacleMove)
            
            // Animating Obstacle with differnt textures
            let image1 = SKTexture(imageNamed: "obstacle1")
            let image2 = SKTexture(imageNamed: "obstacle2")
            let image3 = SKTexture(imageNamed: "obstacle3")
            let image4 = SKTexture(imageNamed: "obstacle4")
            
            let obstacleTextures = [image1, image2, image3, image4, image1]
            
            let obstacleAnimation = SKAction.animate(
                with: obstacleTextures,
                timePerFrame: 0.1)
            self.obstacle.run(SKAction.repeatForever(obstacleAnimation))
        }
    }
    
    func removePowerUp(){
        // Remove Power Ups after they hit the screen edges
        self.enumerateChildNodes(withName: "shield") {
            node, stop in
            if (node is SKSpriteNode) {
                let shieldSprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (shieldSprite.position.x < 40 || shieldSprite.position.x > self.size.width - 40 || shieldSprite.position.y < 40 || shieldSprite.position.y > self.size.height - 40) {
                    shieldSprite.removeFromParent()
                    }
                }
            }
        
        self.enumerateChildNodes(withName: "healthUp") {
            node, stop in
            if (node is SKSpriteNode) {
                let healthUpSprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (healthUpSprite.position.x < 40 || healthUpSprite.position.x > self.size.width - 40 || healthUpSprite.position.y < 40 || healthUpSprite.position.y > self.size.height - 40) {
                    healthUpSprite.removeFromParent()
                }
                // Remove health powerup after it hits player
                // Increase player health
                if (healthUpSprite.intersects(self.player)){
                    healthUpSprite.removeFromParent()
                    if self.playerHealthNode.xScale > 0{
                    if (self.playerHealthNode.xScale < (70*5)/100){
                    self.playerHealthNode.xScale = self.playerHealthNode.xScale + (30*5)/100
                    }
                    else {
                       self.playerHealthNode.xScale = 5
                    }
                }
                    // Play sound when player gets health powerup
                    let healthUpSound = SKAction.playSoundFileNamed("healthUp", waitForCompletion: true)
                    self.run(healthUpSound)
                }
            }
        }
        
        // Remove Obstacle after it hits screen edges
        self.enumerateChildNodes(withName: "obstacle") {
            node, stop in
            if (node is SKSpriteNode) {
                let obstacleSprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (obstacleSprite.position.x < 40 || obstacleSprite.position.x > self.size.width - 40 || obstacleSprite.position.y < 40 || obstacleSprite.position.y > self.size.height - 40) {
                    obstacleSprite.removeFromParent()
                }
                // remove obstacle after it hits player
                if (obstacleSprite.intersects(self.player)){
                   if (self.playerHealthNode.xScale >= 0){
                        obstacleSprite.removeFromParent()
                    //decrease player health by 20% if obstacle hits player
                        self.playerHealthNode.xScale = self.playerHealthNode.xScale - (20*5)/100
                    }
                }
            }
            
        }
    }
        
    func playerGetsShield(){
            // start shield timer and change player texture/add bubble around player if player hits shield
            self.enumerateChildNodes(withName: "shield") {
                node, stop in
                if (node is SKSpriteNode) {
                    let shieldSprite = node as! SKSpriteNode
                    // Check if the shield node hits player
                    if(shieldSprite.intersects(self.player))
                    {
                        self.shieldTimer = 120
                        shieldSprite.removeFromParent()
                        self.player.texture = SKTexture(imageNamed: "bubblePlayer")

                    }
                }
            }

    }
    
    func removePlayerShield(){
        // Remove the player shield
        self.player.texture = SKTexture(imageNamed: "player")
    }
    
    func endGame(){
        // Stop the Game if enemy dies or player dies
        if (self.enemyHealthNode.xScale <= 0.5){
            // show congrats message
            let congratsMessage = SKLabelNode(text: "Congratulations, You Won!")
            congratsMessage.fontSize = 150
            congratsMessage.fontName = "Avenir"
            congratsMessage.fontColor = UIColor.red
            congratsMessage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            addChild(congratsMessage)
            
            self.enemyHealthNode.removeFromParent()
            
            //Change reload/ restart button positiona nd texture
            self.reloadBtn.texture = SKTexture(imageNamed: "playAgain")
            self.reloadBtn.size = CGSize(width: (self.reloadBtn.texture?.size().width)!, height: (self.reloadBtn.texture?.size().height)!)
            self.reloadBtn.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
            
            //change time elapsed node position
            self.timeElapsedSprite.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            self.timeElapsedSprite.fontColor = UIColor.green
            // pause the game after finishing blast animation
            if(self.healthMilliCount%25 == 0 ){
                scene!.view?.isPaused = true
            }
            // remove all the enemy bullets
            self.enumerateChildNodes(withName: "enemyBullet") {
                node, stop in
                    node.removeFromParent()
            }

        }
        if (self.playerHealthNode.xScale <= 0.5){
            //Showing the Game Lost message
            let lostMessage = SKLabelNode(text: "You lose!")
            lostMessage.fontSize = 150
            lostMessage.fontName = "Avenir"
            lostMessage.fontColor = UIColor.red
            lostMessage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            addChild(lostMessage)
            
            scene!.view?.isPaused = true
            self.playerHealthNode.removeFromParent()
            
            self.reloadBtn.texture = SKTexture(imageNamed: "playAgain")
            self.reloadBtn.size = CGSize(width: (self.reloadBtn.texture?.size().width)!, height: (self.reloadBtn.texture?.size().height)!)
            self.reloadBtn.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
            self.timeElapsedSprite.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
        }
    }
    
    func movePlayer(){
        
        //Moving the player in different directions
        //Up
        if (self.arrowTouched == "up"){
            self.player.zRotation = .pi / 2
            if(self.player.position.y < self.size.height - self.player.size.height){
            let playerMove = SKAction.moveBy(x: 0, y: player_speed, duration: 0.01)
            self.player.run(playerMove)
            }
        }
            //down
        else if (self.arrowTouched == "down"){
            self.player.zRotation = .pi / -2
            if(self.player.position.y > 0 + self.player.size.height){
            let playerMove = SKAction.moveBy(x: 0, y: -(player_speed), duration: 0.01)
            self.player.run(playerMove)
            }
        }
            //left
        else if (self.arrowTouched == "left"){
            self.player.zRotation = .pi
            if(self.player.position.x > 0 + self.player.size.width){
            let playerMove = SKAction.moveBy(x: -(player_speed), y: 0, duration: 0.01)
            self.player.run(playerMove)
            }
        }
            //right
        else if (self.arrowTouched == "right"){
            self.player.zRotation = 0
            if(self.player.position.x < self.size.width - self.player.size.width){
            let playerMove = SKAction.moveBy(x: player_speed, y: 0, duration: 0.01)
            self.player.run(playerMove)
            }
        }
            //upRight
        else if (self.arrowTouched == "upRight"){
            self.player.zRotation = .pi / 4
            if(self.player.position.x < self.size.width - self.player.size.width)&&(self.player.position.y < self.size.height - self.player.size.height){
            let playerMove = SKAction.moveBy(x: player_speed, y: player_speed, duration: 0.01)
            self.player.run(playerMove)
            }
        }
            //downright
        else if (self.arrowTouched == "downRight"){
              self.player.zRotation = .pi / -4
            if(self.player.position.x < self.size.width - self.player.size.width)&&(self.player.position.y > self.player.size.height){
            let playerMove = SKAction.moveBy(x: player_speed, y: -(player_speed), duration: 0.01)
            self.player.run(playerMove)
            }
        }
            //downRight
        else if (self.arrowTouched == "downLeft"){
             self.player.zRotation = .pi / -1.5
            if(self.player.position.x > 0 + self.player.size.width)&&(self.player.position.y > 0 + self.player.size.height){
            let playerMove = SKAction.moveBy(x: -(player_speed), y: -(player_speed), duration: 0.01)
            self.player.run(playerMove)
            }
        }
            //upLeft
        else if (self.arrowTouched == "upLeft"){
            self.player.zRotation = .pi / 1.5
            if(self.player.position.x > 0 + self.player.size.width)&&(self.player.position.y < self.size.height - self.player.size.height){
            let playerMove = SKAction.moveBy(x: -(player_speed), y: player_speed, duration: 0.01)
            self.player.run(playerMove)
            }
        }
        
        
    }
    func removeBullet(){
        //Remove Player bullet after it hits screen edges or enemy
        self.playerBullet.name = "playerBullet"
        self.enumerateChildNodes(withName: "playerBullet") {
            node, stop in
            if(self.bulletsArray.count != 0){
                if (node is SKSpriteNode) {
                    let sprite = node as! SKSpriteNode
                    // Check if the node is not in the scene
                    if (sprite.position.x < 100 || sprite.position.x > self.size.width - 100 || sprite.position.y < 100 || sprite.position.y > self.size.height - 100) {
                        // Remove the Sprite first from Parent then, from Array. else it does not completely removes the sprite and creates memory problems.
                        sprite.removeFromParent()
                        self.bulletsArray.removeFirst()
                    }
                    if sprite.intersects(self.enemy) {
                        sprite.removeFromParent()
                        self.bulletsArray.removeFirst()
                        print("no. of bullets after hitting: \(self.bulletsArray.count)")
                    }
                    
                }
            }
        }
    }
    
    
    func moveBulletToTarget() {
        // Move Player Bullet towards the mouse position
        let a = (self.mouseX - self.player.position.x);
        let b = (self.mouseY - self.player.position.y);
        //Caculating angle between a and b
        let angle = atan2(b, a)
        //turning the bullet in mouse click direction
        self.playerBullet.zRotation = angle
        
        var destination1 = CGPoint.zero
        if b > 0 {
            // move bullet to the top of screen
            destination1.y = self.size.height + self.enemy.size.height*2
        } else {
            // move bullet to the bottom of screen
            destination1.y = -self.enemy.size.height*2
        }
        // X position of destination in proportion to the Y Position
        destination1.x = self.player.position.x +
            ((destination1.y - self.player.position.y) / b * a)
        
        var destination2 = CGPoint.zero
        if a > 0 {
            // move the bullet to the right of screen
            destination2.x = self.size.width + self.enemy.size.width*2
        } else {
            //move the bullet to the left of screen
            destination2.x = -self.enemy.size.width*2
        }
        // Y position of destination in proportion to the X Position
        destination2.y = self.player.position.y +
            ((destination2.x - self.player.position.x) / a * b)
        
        var destination:CGPoint!
        //comparing the absolute Coordinate values of destination
        if abs(destination1.x) < abs(destination2.x) || abs(destination1.y) < abs(destination2.y) {
            destination = destination1
        }
        else {
            destination = destination2
        }
        
        if (((self.player.position.y - 30)...(self.player.position.y)).contains(self.mouseY)){
            let bulletAction = SKAction.applyImpulse(CGVector(dx: mouseX - self.player.position.x , dy: mouseY - self.player.position.y), duration: 0.5)
            self.playerBullet.run(bulletAction)
        }
        else {
            let bulletVector = CGVector(dx: destination.x - self.player.position.x, dy: destination.y - self.player.position.y)
            // Shoot the bullet to destination
            let bulletAction = SKAction.move(by: bulletVector, duration: 1.5)
            self.playerBullet.run(bulletAction)
//            self.playerBullet.physicsBody?.velocity = bulletVector
        }
    }
    
    
    func bulletHitsEnemy(){
        // If player Bullet hits any enemy part, remove enemy part, reduce enemy health
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            self.enemy = node as? SKSpriteNode
            if self.playerBullet.intersects(self.enemy){
                self.enemy.removeFromParent()
                self.removeBullet()
                print("enemy removed")
                self.enemyPartsCount = self.enemyPartsCount - 1
                self.enemyHealthNode.xScale = self.enemyHealthNode.xScale - CGFloat((self.enemyPartPercentage * 5)/100)
            }
            
            // If player Bullet hits enemy Core, remove all the enemy parts, show a blast animation using different textures
            if self.playerBullet.intersects(self.enemyCore){
                var blastNode: SKSpriteNode!
                blastNode = SKSpriteNode(imageNamed: "blast1")
                blastNode.size = (blastNode.texture?.size())!
                blastNode.position = self.enemyCore.position
                self.addChild(blastNode)
                
                let image1 = SKTexture(imageNamed: "blast1")
                let image2 = SKTexture(imageNamed: "blast2")
                let image3 = SKTexture(imageNamed: "blast3")
                let image4 = SKTexture(imageNamed: "blast4")
                let image5 = SKTexture(imageNamed: "blast5")
                let image6 = SKTexture(imageNamed: "blast6")
                let image7 = SKTexture(imageNamed: "blast7")
                
                let blastTextures = [image1, image2, image3, image4, image5, image6, image7]
                let blastAnimation = SKAction.animate(
                    with: blastTextures,
                    timePerFrame: 0.2)
                blastNode.run(SKAction.repeat(blastAnimation, count: 1))
                
                // Play sound when bullet hits core.
                let coreDeadSound = SKAction.playSoundFileNamed("coreDead", waitForCompletion: true)
                self.run(coreDeadSound)
                
                //remove enemy parts
                self.enemy.removeFromParent()
                //remove enemy Core
                self.enemyCore.removeFromParent()
                //remove palyer bullet
                self.removeBullet()
                print("core removed")
                self.enemyPartsCount = 0
                // reducing enemy health node to zero
                self.enemyHealthNode.xScale = 0
            }
        }
    }
    
    func checkArrowTouched(){
        
        // Checking which movement arrow is touched by user and store value in a string
        if self.upArrow.contains(touch.location(in: self)) {
            print("up touched")
            self.arrowTouched = "up"
        }
        else if self.downArrow.contains(touch.location(in: self)) {
            print("down touched")
            self.arrowTouched = "down"
        }
        else if self.leftArrow.contains(touch.location(in: self)) {
            print("left touched")
            self.arrowTouched = "left"
        }
        else if self.rightArrow.contains(touch.location(in: self)) {
            print("right touched")
            self.arrowTouched = "right"
        }
        else if self.upRightArrow.contains(touch.location(in: self)) {
            print("UpRight touched")
            self.arrowTouched = "upRight"
        }
        else if self.downRightArrow.contains(touch.location(in: self)) {
            print("downRight touched")
            self.arrowTouched = "downRight"
        }
        else if self.upLeftArrow.contains(touch.location(in: self)) {
            print("upLeft touched")
            self.arrowTouched = "upLeft"
        }
        else if self.downLeftArrow.contains(touch.location(in: self)) {
            print("downLeft touched")
            self.arrowTouched = "downLeft"
        }
    }
    
    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        
        //Reduce player/chippy height if an arrow is touched or bullet is shooted
        self.player.size.height = self.player.size.height - self.player.size.height/3
        
        // Do not shoot bullet if arrow Buttons Area is touched
        if (self.arrowButtonsRect.contains(touch.location(in: self))){
            self.arrowButtonTouched = true
            self.checkArrowTouched()
        }
        else {
            self.shootBullet = true
        }
        
        // Checking ig Restart/Reload Button is touched
        if (self.reloadBtn.contains(touch.location(in: self))){
            //Remove all the Scene Children
            self.removeAllChildren()
            self.removeAllActions()
            print("Restarted")
            //Present the scene again
            let scene = SKScene(fileNamed: "GameScene")
            scene!.scaleMode = .aspectFill
            view!.presentScene(scene)
        }
 
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        print(mousePosition)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        
        if (self.arrowButtonsRect.contains(touch.location(in: self))){
            self.arrowButtonTouched = true
            self.checkArrowTouched()
        }
        else{
            self.shootBullet = false
            self.spawnPlayerBullet()
            self.moveBulletToTarget()
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Restting the variables to their initial values after the touch is ended
        self.arrowTouched = ""
        self.shootBullet = false
        self.arrowButtonTouched = false
        self.shootBullet = false
        //Restting the player height
        self.player.size.height = self.size.height/12
    }
    
}

