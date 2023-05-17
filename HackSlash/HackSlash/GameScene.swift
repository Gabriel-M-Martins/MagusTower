import GameplayKit
import UserNotifications

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum ButtonAssociation {
        case movementAnalog
        case combosAnalog
    }
    
    /// struct constants vai ter todos os valores constantes ao longo do jogo, cores e etc
    private var constants: Constants {
        return Constants(frame: frame)
    }
    
    private var platforms: [SKSpriteNode] = []
    private var walls: [SKSpriteNode] = []
    private var floors: [SKSpriteNode] = []
    private var player: Player = Player(sprite: "")
    private var spiders: [EnemySpider] = []
    private var magics: [MagicProjetile] = []
    
    private var elementCombo: [SKSpriteNode] = []
    private var fireCombo: [SKSpriteNode] = []
    private var thunderCombo: [SKSpriteNode] = []
    private var iceCombo: [SKSpriteNode] = []
    private var earthCombo: [SKSpriteNode] = []
    private var directionCombo: [SKSpriteNode] = []
    
    private var currentCombo: [SKSpriteNode] = []
    
    var background = SKSpriteNode(texture: SKTexture(imageNamed: "MainScene"))
    
    private var touches: [(UITouch, ButtonAssociation)] = []
    
    private var movementInput = SKShapeNode()
    private var movementAnalogic = SKShapeNode()
    
    private var combosInput = SKShapeNode()
    private var combosAnalogic = SKShapeNode()
    
    private var numberEnemies = Int.random(in: 1..<5)
    
    private var directionsCombos: [Directions] = []
    private var directionsMovement: [Directions] = []
    private var firstDirectionCombo: Directions = .up
    
    private var jumpCounter = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let camera = camera else { return }
        
        for t in touches {
            let pos = t.location(in: camera)
            
            if movementInput.contains(pos) {
                movementAnalogic.run(SKAction.move(to: pos, duration: 0.1))
                self.touches.append((t, .movementAnalog))
            }
            
            if combosInput.contains(pos) {
                self.touches.append((t, .combosAnalog))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let camera = camera else { return }

        for t in self.touches {
            
            let pos = t.0.location(in: camera)
            
            switch t.1 {
            case .movementAnalog:
                handleMovement(start: movementInput.position, pos: pos)
                
                if movementInput.contains(pos) {
                    movementAnalogic.run(.move(to: pos, duration: 0.1))
                } else {
                    let limitedPos = (pos - movementInput.position).normalized() * 100
                    movementAnalogic.run(.move(to: movementInput.position + limitedPos, duration: 0.1))
                }
                
            case .combosAnalog:
                if combosInput.contains(pos) {
                    combosAnalogic.run(.move(to: pos, duration: 0.1))
                } else {
                    let limitedPos = (pos - combosInput.position).normalized() * 100
                    combosAnalogic.run(.move(to: combosInput.position + limitedPos, duration: 0.1))
                }
                
                let vector = pos - combosInput.position
                let directions = Directions.calculateDirections(vector)
                
                if currentCombo.count == 4{
                    switch directions[0] {
                    case .up:
                        combosInput.children.forEach { nd in
                            emphasizeComboSprite(nd, name: currentCombo[0].name ?? "")
                        }
                    case .left:
                        combosInput.children.forEach { nd in
                            emphasizeComboSprite(nd, name: currentCombo[1].name ?? "")
                        }
                    case .right:
                        combosInput.children.forEach { nd in
                            emphasizeComboSprite(nd, name: currentCombo[2].name ?? "")
                        }
                    case .down:
                        combosInput.children.forEach { nd in
                            emphasizeComboSprite(nd, name: currentCombo[3].name ?? "")
                        }
                    }
                }
                else {
                    switch directions[0] {
                    case .left:
                        if directions.count == 1{
                            combosInput.children.forEach { nd in
                                emphasizeComboSprite(nd, name: currentCombo[1].name ?? "")
                            }
                        }else{
                            switch directions[1]{
                            case .up:
                                combosInput.children.forEach { nd in
                                    emphasizeComboSprite(nd, name: currentCombo[5].name ?? "")
                                }
                            case .down:
                                combosInput.children.forEach { nd in
                                    emphasizeComboSprite(nd, name: currentCombo[7].name ?? "")
                                }
                            default:
                                return
                            }
                        }
                    case .right:
                        if directions.count == 1{
                            combosInput.children.forEach { nd in
                                emphasizeComboSprite(nd, name: currentCombo[2].name ?? "")
                            }
                        }else{
                            switch directions[1]{
                            case .up:
                                combosInput.children.forEach { nd in
                                    emphasizeComboSprite(nd, name: currentCombo[4].name ?? "")
                                }
                            case .down:
                                combosInput.children.forEach { nd in
                                    emphasizeComboSprite(nd, name: currentCombo[6].name ?? "")
                                }
                            default:
                                return
                            }
                        }
                    case .down:
                        combosInput.children.forEach { nd in
                            emphasizeComboSprite(nd, name: currentCombo[3].name ?? "")
                        }
                    case .up:
                        combosInput.children.forEach { nd in
                            emphasizeComboSprite(nd, name: currentCombo[0].name ?? "")
                        }
                    }
                }
            }
        }
    }
    
    private func emphasizeComboSprite(_ nd: SKNode, name: String) {
        guard let ndName = nd.name else { return }
        
        if ndName == name {
            nd.run(.group([
                .scale(to: Constants.combosSpritesScale + 0.5, duration: Constants.combosSpritesAnimationDuration),
                .fadeAlpha(to: 2, duration: Constants.combosSpritesAnimationDuration)
            ]))
        } else {
            nd.run(.group([
                .scale(to: Constants.combosSpritesScale, duration: Constants.combosSpritesAnimationDuration),
                .fadeAlpha(to: Constants.combosSpritesAlpha, duration: Constants.combosSpritesAnimationDuration)
            ]))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let camera = camera else { return }
    
        self.touches = self.touches.filter({ (t, i) in
            guard touches.contains(t) else { return true }
            
            switch i {
                
            case .movementAnalog:
                movementAnalogic.run(SKAction.move(to: movementInput.position, duration: 0.1))
                
                directionsMovement = []
                
            case .combosAnalog:
                let pos = t.location(in: camera)
                
                handleCombo(start: combosInput.position, pos: pos)
                combosAnalogic.run(SKAction.move(to: combosInput.position, duration: 0.1))
                
                for i in combosInput.children {
                    i.run(.group([
                        .scale(to: Constants.combosSpritesScale, duration: Constants.combosSpritesAnimationDuration),
                        .fadeAlpha(to: Constants.combosSpritesAlpha, duration: Constants.combosSpritesAnimationDuration)
                    ]))
                }
            }
            return false
        })
    }
    
    private func handleMovement(start: CGPoint, pos: CGPoint) {
        let vector = pos - start
        
        directionsMovement = Directions.calculateDirections(vector).filter { dir in
            dir != .down
        }
    }
    
    private func hidde(_ h: Bool, list: [SKSpriteNode]) {
        if !h {
            currentCombo = list
        }
        for i in list{
            i.isHidden = h
        }
    }

    //Spell count declarado aqui só p ficar mais entendível
    var spellCount: Int = 0
    
    private func handleCombo(start: CGPoint, pos: CGPoint) {
        spellCount += 1
        let vector = pos - start
        let directions = Directions.calculateDirections(vector)
        if directionsCombos.count == 0{
            //elements
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.directionsCombos.count == 1 && self.spellCount < 3{
                    print("Miss timing!")
                    self.directionsCombos.removeAll()
                    
                    self.hidde(true, list: self.directionCombo)
                    
                    switch directions[0]{
                    case .up:
                        self.hidde(true, list: self.iceCombo)
                        
                    case .down:
                        self.hidde(true, list: self.thunderCombo)
                        
                    case .left:
                        self.hidde(true, list: self.fireCombo)
                        
                    case .right:
                        self.hidde(true, list: self.earthCombo)
                    }
                    
                    self.hidde(false, list: self.elementCombo)
                    
                    return
                }
                self.spellCount = 0
            }
            
            hidde(true, list: elementCombo)
            
            firstDirectionCombo = directions[0]
            
            switch firstDirectionCombo{
            case .up:
                hidde(false, list: iceCombo)
                
            case .down:
                hidde(false, list: thunderCombo)
                
            case .left:
                hidde(false, list: fireCombo)
                
            case .right:
                hidde(false, list: earthCombo)
            }
        }
        else if directionsCombos.count == 1{
            //attack
            if directions[0] == .down{
                let magic = Magics.magic(primary: directionsCombos[0], secondary: directions[0])
                let x = magic.getElement().getBuff()
                x(player, 15.0)
                
                switch firstDirectionCombo{
                case .up:
                    hidde(true, list: iceCombo)
                    
                case .down:
                    hidde(true, list: thunderCombo)
                    
                case .left:
                    hidde(true, list: fireCombo)
                    
                case .right:
                    hidde(true, list: earthCombo)
                }
                
                hidde(false, list: elementCombo)
                
                directionsCombos = []
                return
            }
            
            switch firstDirectionCombo{
            case .up:
                hidde(true, list: iceCombo)
                
            case .down:
                hidde(true, list: iceCombo)
                
            case .left:
                hidde(true, list: fireCombo)
                
            case .right:
                hidde(true, list: earthCombo)
            }
            
            hidde(false, list: directionCombo)
        }
        
        if directionsCombos.count == 2 {
            //direction
            let normalizedVector = vector.normalized()
            let magic = Magics.magic(primary: directionsCombos[0], secondary: directionsCombos[1])
            let angle = atan2(normalizedVector.y, normalizedVector.x)
            // MARK: call combo with vector and magic
            switch magic{
            case .A(.fire):
                let fireball = Fireball(angle: angle, player: player)
                magics.append(fireball)
                addChild(fireball.node)
                directionsCombos.removeAll()
            case .A(.ice):
                let iceball = Iceball(angle: angle, player: player)
                magics.append(iceball)
                addChild(iceball.node)
                directionsCombos.removeAll()
            case .A(.earth):
                let stoneWall = StoneWall(player: player, angle: angle)
                addChild(stoneWall.sprite)
                directionsCombos.removeAll()
            case .A(.thunder):
                let thunder = ThunderShot(angle: angle, player: player)
                addChild(thunder.node)
                magics.append(thunder)
                directionsCombos.removeAll()
                
            case .D(let element):
                let x = element.getBuff()
                x(player, 15.0)
                
            case .C(.fire):
                directionsCombos.removeAll()
            case .C(.ice):
                directionsCombos.removeAll()
            case .C(.earth):
                directionsCombos.removeAll()
            case .C(.thunder):
                directionsCombos.removeAll()
                
            case .B(.fire):
                directionsCombos.removeAll()
            case .B(.ice):
                directionsCombos.removeAll()
            case .B(.earth):
                directionsCombos.removeAll()
            case .B(.thunder):
                directionsCombos.removeAll()
                
            default:
                break
            }
            directionsCombos = []
            
            hidde(false, list: elementCombo)
            
            hidde(true, list: directionCombo)
            
        } else {
            directionsCombos.append(directions[0])
        }
    }
    
    /// quando a view chamar a cena, esta funçao é a primeira a ser executada.
    ///  é a preparaçao da cena.
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        myFrame.myVariables.frame = self.size
        myFrame.myVariables.scene = self
        physicsWorld.contactDelegate = self
        background.zPosition = -30
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.size = CGSize(width: frame.width * 3, height: frame.height * 3)
        background.position.y = frame.minY - 185
        addChild(background)
        
        // ------------------------------------------------------------------------
        setupPlayer()

        // ------------------------------------------------------------------------
        setupCamera()
        
        // ------------------------------------------------------------------------
        setupGround()
        
        // ------------------------------------------------------------------------
        for i in 1...20{
            delayWithSeconds(5.0 * Double(i)) { [self] in
                self.setupSpawn(position: CGPoint(x: CGFloat(Double.random(in: Double(-size.width/3)...Double(size.width/3))), y: frame.midY - 20), spriteName: "Spider", idSpawn: i)
            }
        }
        //------------------------------------------------------------------------
        setupButtons()
        
        view.isMultipleTouchEnabled = true
    }
    
    private func setupGround() {
        let rects = MapInterpreter(map: frame, platformHeightDistance: Constants.playerSize.height + 60, platformHeight: constants.platformsHeight, scale: 3)?.rects
        
        guard let rects = rects else { return }
        for i in rects {
            self.createPlatform(size: i.size, position: i.position, sprite: Constants.randomPlatformSprite())
        }
        
        let wall = MapInterpreter(map: frame, platformHeightDistance: Constants.playerSize.height + 60, platformHeight: constants.platformsHeight, scale: 3)?.wall
        
        guard let wall = wall else { return }
        for i in wall {
            self.createWall(size: i.size, position: i.position, sprite: Constants.randomPlatformSprite())
        }
        
        let floor = MapInterpreter(map: frame, platformHeightDistance: Constants.playerSize.height + 60, platformHeight: constants.platformsHeight, scale: 3)?.floor
        
        guard let floor = floor else { return }
        for i in floor {
            self.createFloor(size: i.size, position: i.position, sprite: Constants.randomPlatformSprite())
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func didBegin(_ contact:SKPhysicsContact){
        
        if (contact.bodyA.node?.name == "platform" && contact.bodyB.node?.name == "Player") || (contact.bodyA.node?.name == "Player" && contact.bodyB.node?.name == "platform") || (contact.bodyA.node?.name == "floor" && contact.bodyB.node?.name == "Player") || (contact.bodyA.node?.name == "Player" && contact.bodyB.node?.name == "floor"){
            self.jumpCounter = 0
            player.transition(to: .landing)
            player.transition(to: .idle)
        }
        else if (contact.bodyA.node?.name == "platform" && contact.bodyB.node?.name == "Spider") || (contact.bodyA.node?.name == "Spider" && contact.bodyB.node?.name == "platform") || (contact.bodyA.node?.name == "floor" && contact.bodyB.node?.name == "Spider") || (contact.bodyA.node?.name == "Spider" && contact.bodyB.node?.name == "floor"){
            for spider in spiders{
                if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                    if spider.currentState == .attack{
                        var copy = spider
                        copy.transition(to: .walking)
                        copy.attributes.velocity.maxYSpeed /= 100
                        copy.attributes.velocity.maxXSpeed /= 100
                    }
                }
            }
        }
        else if (contact.bodyA.node?.name == "Magic" && contact.bodyB.node?.name == "Spider") || (contact.bodyA.node?.name == "Spider" && contact.bodyB.node?.name == "Magic"){
            for idx in 0..<spiders.count{
                let spider = spiders[idx]
                if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                    for magic in magics{
                        if magic.physicsBody === contact.bodyA || magic.physicsBody === contact.bodyB{
                            magic.onTouch(touched: &spider.attributes)
                            spider.attributes.velocity.maxYSpeed *= 10
                            spider.attributes.velocity.maxXSpeed *= 10
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                spider.attributes.velocity.maxYSpeed /= 10
                                spider.attributes.velocity.maxXSpeed /= 10
                            }
                            spider.physicsBody.applyImpulse(CGVector(dx: Constants.spiderSize.width * cos(magic.angle) * 6, dy: Constants.spiderSize.height * sin(magic.angle) * 6))
                            magic.node.removeFromParent()
                        }
                    }
                }
                if spider.attributes.health<=0 {
                    if spider.currentState != .death{
                        var copy = spider
                        copy.transition(to: .death)
                        spiders.remove(at: idx)
                        delayWithSeconds(spider.despawnTime, completion: {
                            for s in self.spiders{
                                if s.idSpider > spider.idSpider{
                                    s.idSpider -= 1
                                }
                            }
                            //remover aranha da cena
                            spider.sprite.removeFromParent()
                        })
                        //points += 1
                        break
                    }
                }
            }
        }
        else if (contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "Spider") || (contact.bodyA.node?.name == "Spider" && contact.bodyB.node?.name == "wall") {
            
            for idx in 0..<spiders.count{
                var spider = spiders[idx]
                if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                    if spider.currentState == .walking || spider.currentState == .idle{
                        spider.transition(to: .charging)
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if player.attributes.health <= 0 {
            Constants.notificationCenter.post(name: Notification.Name("playerDeath"), object: nil)
        }
        
        camera?.position = player.position
        for spider in spiders{
            spider.moveAI(player: player.sprite)
        }
        updatePlayerState()
        updateSpidersState()
        
        guard !directionsMovement.isEmpty else { return }
        if player.currentState == .jump || (player.currentState == .airborne && jumpCounter >= 3) {
            directionsMovement.removeAll { dir in
                dir == .up
            }
        }
        
        if directionsMovement.contains(.up) {
            player.transition(to: .jump)
            jumpCounter += 1
        }
        
        player.move(direction: directionsMovement)
        
        if player.sprite.physicsBody!.velocity.dx < 0{
            player.sprite.xScale = -1
        }
        else{
            player.sprite.xScale = 1
        }
    }
    
    func updatePlayerState(){
        if player.currentState == .jump {
            player.physicsBody.collisionBitMask = player.physicsBody.collisionBitMask & (UInt32.max - Constants.groundMask)
            player.physicsBody.contactTestBitMask = player.physicsBody.contactTestBitMask & (UInt32.max - Constants.groundMask)
        }
        
        if player.physicsBody.velocity.dy < 0{
            player.transition(to: .airborne)
        }
        
        if player.currentState == .airborne{
            if player.sprite.physicsBody!.collisionBitMask & Constants.groundMask == 0 {
                var hasCollided = false
                for platform in platforms {
                    if platform.intersects(player.sprite){
                        hasCollided = true
                    }
                }
                if !hasCollided {
                    player.physicsBody.collisionBitMask = player.physicsBody.collisionBitMask + Constants.groundMask
                    player.physicsBody.contactTestBitMask = player.physicsBody.contactTestBitMask + Constants.groundMask
                }
            }
        }
        if player.currentState == .idle {
            if player.physicsBody.velocity.dx != 0 {
                player.transition(to: .walking)
            }
        }
        else if player.currentState == .walking {
            if player.physicsBody.velocity.dx == 0 {
                player.transition(to: .idle)
            }
        }
    }
    
    
    func updateSpidersState(){
        for spider in spiders{
            if spider.currentState == .attack{
                if spider.sprite.physicsBody!.collisionBitMask & Constants.groundMask == 0{
                    var hasCollided = false
                    for platform in platforms {
                        if platform.intersects(spider.sprite){
                            hasCollided = true
                        }
                    }
                    if !hasCollided {
                        spider.physicsBody.collisionBitMask = spider.physicsBody.collisionBitMask | Constants.groundMask
                    }
                }
//                else if spider.sprite.physicsBody!.collisionBitMask & Constants.wallMask == 0 {
//                    var hasCollided = false
//                    for floor in floors {
//                        if floor.intersects(spider.sprite){
//                            hasCollided = true
//                        }
//                    }
//                    if !hasCollided {
//                        spider.physicsBody.collisionBitMask = spider.physicsBody.collisionBitMask | Constants.wallMask
//                    }
//                }
            }
        }
    }
    
    func setupButtons() {
        let buttonRadius: CGFloat = 120
        let positionOffset: CGFloat = 250
        
        // ------------------------------------------------------------------------------------------ movement
        movementInput = SKShapeNode(circleOfRadius: buttonRadius)
        movementInput.position = CGPoint(x: frame.minX + positionOffset, y: frame.minY + positionOffset)
        movementInput.strokeColor = Constants.buttonsColor
        movementInput.fillColor = Constants.buttonsColor.withAlphaComponent(0.2)
        
        // --------------------------------------------
        movementAnalogic = SKShapeNode(circleOfRadius: 25)
        movementAnalogic.position = CGPoint(x: frame.minX + positionOffset, y: frame.minY + positionOffset)
        movementAnalogic.fillColor = Constants.buttonsColor
    
        // ------------------------------------------------------------------------------------------ combos
        combosInput = SKShapeNode(circleOfRadius: buttonRadius)
        combosInput.position = CGPoint(x: frame.maxX - positionOffset, y: frame.minY + positionOffset)
        combosInput.strokeColor = .clear
        
        let earth = SKSpriteNode(texture: Constants.earthPowerTexture)
        earth.anchorPoint = CGPoint(x: 0, y: 0.5)
        earth.zPosition = 10
        earth.name = "earth"
        combosInput.addChild(earth)
        
        let eletric = SKSpriteNode(texture: Constants.eletricPowerTexture)
        eletric.anchorPoint = CGPoint(x: 0.5, y: 1)
        eletric.zPosition = 10
        eletric.name = "eletric"
        combosInput.addChild(eletric)
        
        let fire = SKSpriteNode(texture: Constants.firePowerTexture)
        fire.anchorPoint = CGPoint(x: 1, y: 0.5)
        fire.zPosition = 10
        fire.name = "fire"
        combosInput.addChild(fire)
        
        let ice = SKSpriteNode(texture: Constants.icePowerTexture)
        ice.anchorPoint = CGPoint(x: 0.5, y: 0)
        ice.zPosition = 10
        ice.name = "ice"
        combosInput.addChild(ice)
        
        elementCombo = [ice, fire, earth, eletric]
        
        //fire
        let fireC = SKSpriteNode(texture: Constants.fireCTexture)
        fireC.anchorPoint = CGPoint(x: 0, y: 0.5)
        fireC.zPosition = 10
        fireC.name = "fireC"
        combosInput.addChild(fireC)
        
        let fireD = SKSpriteNode(texture: Constants.fireDTexture)
        fireD.anchorPoint = CGPoint(x: 0.5, y: 1)
        fireD.zPosition = 10
        fireD.name = "fireD"
        combosInput.addChild(fireD)
        
        let fireB = SKSpriteNode(texture: Constants.fireBTexture)
        fireB.anchorPoint = CGPoint(x: 1, y: 0.5)
        fireB.zPosition = 10
        fireB.name = "fireB"
        combosInput.addChild(fireB)
        
        let fireA = SKSpriteNode(texture: Constants.fireATexture)
        fireA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        fireA.zPosition = 10
        fireA.name = "fireA"
        combosInput.addChild(fireA)
        
        fireCombo = [fireA, fireB, fireC, fireD]
        
        //earth
        let earthC = SKSpriteNode(texture: Constants.earthCTexture)
        earthC.anchorPoint = CGPoint(x: 0, y: 0.5)
        earthC.zPosition = 10
        earthC.name = "earthC"
        combosInput.addChild(earthC)
        
        let earthD = SKSpriteNode(texture: Constants.earthDTexture)
        earthD.anchorPoint = CGPoint(x: 0.5, y: 1)
        earthD.zPosition = 10
        earthD.name = "earthD"
        combosInput.addChild(earthD)
        
        let earthB = SKSpriteNode(texture: Constants.earthBTexture)
        earthB.anchorPoint = CGPoint(x: 1, y: 0.5)
        earthB.zPosition = 10
        earthB.name = "earthB"
        combosInput.addChild(earthB)
        
        let earthA = SKSpriteNode(texture: Constants.earthATexture)
        earthA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        earthA.zPosition = 10
        earthA.name = "earthA"
        combosInput.addChild(earthA)
        
        earthCombo = [earthA, earthB, earthC, earthD]
        
        //ice
        let iceC = SKSpriteNode(texture: Constants.iceCTexture)
        iceC.anchorPoint = CGPoint(x: 0, y: 0.5)
        iceC.zPosition = 10
        iceC.name = "iceC"
        combosInput.addChild(iceC)
        
        let iceD = SKSpriteNode(texture: Constants.iceDTexture)
        iceD.anchorPoint = CGPoint(x: 0.5, y: 1)
        iceD.zPosition = 10
        iceD.name = "iceD"
        combosInput.addChild(iceD)
        
        let iceB = SKSpriteNode(texture: Constants.iceBTexture)
        iceB.anchorPoint = CGPoint(x: 1, y: 0.5)
        iceB.zPosition = 10
        iceB.name = "iceB"
        combosInput.addChild(iceB)
        
        let iceA = SKSpriteNode(texture: Constants.iceATexture)
        iceA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        iceA.zPosition = 10
        iceA.name = "iceA"
        combosInput.addChild(iceA)
        
        iceCombo = [iceA, iceB, iceC, iceD]
        
        //thunder
        let thunderC = SKSpriteNode(texture: Constants.thunderCTexture)
        thunderC.anchorPoint = CGPoint(x: 0, y: 0.5)
        thunderC.zPosition = 10
        thunderC.name = "thunderC"
        combosInput.addChild(thunderC)
        
        let thunderD = SKSpriteNode(texture: Constants.thunderDTexture)
        thunderD.anchorPoint = CGPoint(x: 0.5, y: 1)
        thunderD.zPosition = 10
        thunderD.name = "thunderD"
        combosInput.addChild(thunderD)
        
        let thunderB = SKSpriteNode(texture: Constants.thunderBTexture)
        thunderB.anchorPoint = CGPoint(x: 1, y: 0.5)
        thunderB.zPosition = 10
        thunderB.name = "thunderB"
        combosInput.addChild(thunderB)
        
        let thunderA = SKSpriteNode(texture: Constants.thunderATexture)
        thunderA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        thunderA.zPosition = 10
        thunderA.name = "thunderA"
        combosInput.addChild(thunderA)
        
        thunderCombo = [thunderA, thunderB, thunderC, thunderD]
        
        //direction Combo
        let down = SKSpriteNode(texture: Constants.downMagicTexture)
        down.anchorPoint = CGPoint(x: 0.5, y: 6.5)
        down.zPosition = 10
        down.name = "down"
        combosInput.addChild(down)
        
        let up = SKSpriteNode(texture: Constants.upMagicTexture)
        up.anchorPoint = CGPoint(x: 0.5, y: -5.5)
        up.zPosition = 10
        up.name = "up"
        combosInput.addChild(up)
        
        let right = SKSpriteNode(texture: Constants.rightMagicTexture)
        right.anchorPoint = CGPoint(x: -5.5, y: 0.5)
        right.zPosition = 10
        right.name = "right"
        combosInput.addChild(right)
        
        let left = SKSpriteNode(texture: Constants.leftMagicTexture)
        left.anchorPoint = CGPoint(x: 6.5, y: 0.5)
        left.zPosition = 10
        left.name = "left"
        combosInput.addChild(left)
        
        let upR = SKSpriteNode(texture: Constants.upRMagicTexture)
        upR.anchorPoint = CGPoint(x: -1.45, y: -1.45)
        upR.zPosition = 10
        upR.name = "upR"
        combosInput.addChild(upR)
        
        let upL = SKSpriteNode(texture: Constants.upLMagicTexture)
        upL.anchorPoint = CGPoint(x: 2.45, y: -1.45)
        upL.zPosition = 10
        upL.name = "upL"
        combosInput.addChild(upL)
        
        let downR = SKSpriteNode(texture: Constants.downRMagicTexture)
        downR.anchorPoint = CGPoint(x: -1.45, y: 2.45)
        downR.zPosition = 10
        downR.name = "downR"
        combosInput.addChild(downR)
        
        let downL = SKSpriteNode(texture: Constants.downLMagicTexture)
        downL.anchorPoint = CGPoint(x: 2.45, y: 2.45)
        downL.zPosition = 10
        downL.name = "downL"
        combosInput.addChild(downL)
        
        let directions = SKSpriteNode(texture: Constants.directionsTexture)
        directions.name = "directions"
        combosInput.addChild(directions)
        
        directionCombo = [up, left, right, down, upR, upL, downR, downL, directions]
        
        for i in combosInput.children {
            i.setScale(Constants.combosSpritesScale)
            i.alpha = Constants.combosSpritesAlpha
        }
        
        for i in fireCombo{
            i.isHidden = true
        }
        for i in earthCombo{
            i.isHidden = true
        }
        for i in iceCombo{
            i.isHidden = true
        }
        for i in thunderCombo{
            i.isHidden = true
        }
        
        for i in directionCombo{
            i.isHidden = true
        }
        
        // --------------------------------------------
        combosAnalogic = SKShapeNode(circleOfRadius: 25)
        combosAnalogic.position = CGPoint(x: frame.maxX - positionOffset, y: frame.minY + positionOffset)
        combosAnalogic.fillColor = Constants.buttonsColor
        combosAnalogic.zPosition = 11
        
        // ------------------------------------------------------------------------------------------ add to scene
        camera?.addChild(movementInput)
        camera?.addChild(movementAnalogic)
        
        camera?.addChild(combosInput)
        camera?.addChild(combosAnalogic)
        
        currentCombo = elementCombo
    }
    //Constants.spiderIdleTexture
    func setupSpawn(position: CGPoint, spriteName: String, idSpawn: Int){
        if(spriteName == "Spider"){
            let enemy = setupSpider(spriteName: "Spider", idSpider: (idSpawn-1))
            enemy.sprite.position = position
            spiders.append(enemy)
            addChild(enemy.sprite)
        }
    }

    func setupCamera() {
        let camera = SKCameraNode()
//        camera.setScale(0.7)
        camera.setScale(1)
        self.camera = camera
        addChild(camera)
    }
    
    func createPlatform(size: CGSize, position: CGPoint, sprite: String){
        let platform = SKSpriteNode(imageNamed: sprite)
        platform.size = size
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        platform.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // posicao do platform é zero no x e o mais baixo no y
        platform.position = position
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height * 0.9))
        platform.physicsBody?.isDynamic = false
        platform.name = "platform"
        platform.zPosition = -25
        platform.physicsBody?.categoryBitMask = Constants.groundMask
        platforms.append(platform)
        platform.physicsBody?.friction = 2
        addChild(platform)
    }
    
    func createWall(size: CGSize, position: CGPoint, sprite: String){
        let wall = SKSpriteNode(imageNamed: sprite)
        wall.size = size
        wall.zRotation = .pi / 2
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        wall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // posicao do wall é zero no x e o mais baixo no y
        wall.position = position
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        wall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height * 0.9))
        wall.physicsBody?.isDynamic = false
        wall.name = "wall"
        wall.zPosition = -25
        wall.physicsBody?.categoryBitMask = Constants.wallMask
        walls.append(wall)
        wall.physicsBody?.friction = 0.7
        addChild(wall)
    }
    
    func createFloor(size: CGSize, position: CGPoint, sprite: String){
        let floor = SKSpriteNode(imageNamed: sprite)
        floor.size = size
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        floor.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // posicao do floor é zero no x e o mais baixo no y
        floor.position = position
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height * 0.9))
        floor.physicsBody?.isDynamic = false
        floor.name = "floor"
        floor.zPosition = -25
        floor.physicsBody?.categoryBitMask = Constants.wallMask
        floors.append(floor)
        floor.physicsBody?.friction = 0.7
        addChild(floor)
    }
    
    func setupPlayer(){
        //Creates player and adds it to the scene
        player = Player(sprite: "MagoFrente")
        player.sprite.position.y += frame.midY + frame.midY/2
        addChild(player.sprite)
    }
    
    func setupSpider(spriteName: String, idSpider: Int) -> EnemySpider{
        let spider = EnemySpider(sprite: spriteName, attributes: AttributesInfo(health: 10, defense: 20, weakness: [], velocity: VelocityInfo(xSpeed: 50, ySpeed: 10, maxXSpeed: 200, maxYSpeed: 5000), attackRange: frame.width * 0.3, maxHealth: 100), player: player, idSpider: idSpider)
        return spider
    }

}
