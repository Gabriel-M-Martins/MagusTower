import GameplayKit
import UserNotifications

extension SKScene: ObservableObject {}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum ButtonAssociation {
        case movementAnalog
        case combosAnalog
    }
    
    enum CombosState {
        case element
        case magic(Directions4)
        case direction(Magics)
    }
    
    init(level: Levels) {
        let info = level.getInfo()
        
        self.currentLevel = level
        
        Constants.singleton.locker = false
        
        if level == .Level1 {
            Constants.singleton.currentLevel = 1
        } else if level == .Tutorial {
            Constants.singleton.currentLevel = 0
            tutorialFlag = true
        }
        
        Constants.singleton.currentLevel += 1
        
        self.background = SKSpriteNode(texture: SKTexture(imageNamed: info.background))
        self.numberEnemies = info.enemiesQtd
        
        self.mapInterpreter = MapInterpreter(map: Constants.singleton.frame, platformHeightDistance: Constants.singleton.playerSize.height + 60, platformHeight: Constants.singleton.platformsHeight, scale: 3, mapText: info.mapFile)!
        
        self.levelLabel = SKLabelNode(text: level.name())
        
        self.spawnRate = info.spawnRate
        
        super.init(size: Constants.singleton.frame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var currentLevel: Levels
    
    private var comboTimer: Timer?
    
    private let spawnRate: Double
    
    private var tutorialFlag = false
    
    private var platforms: [SKSpriteNode] = []
    private var walls: [SKSpriteNode] = []
    private var floors: [SKSpriteNode] = []
    private var player: Player = Player(sprite: "")
    private var spiders: [EnemySpider] = []
    private var magics: [MagicProjetile] = []
    
    private var comboElementNodes: [SKSpriteNode] = []
    
    private var comboFireNodes: [SKSpriteNode] = []
    private var comboThunderNodes: [SKSpriteNode] = []
    private var comboIceNodes: [SKSpriteNode] = []
    private var comboEarthNodes: [SKSpriteNode] = []
    
    private var comboDirectionsNodes: [SKSpriteNode] = []
    
//    private var currentCombo: [SKSpriteNode] = []
    private var currentComboState = CombosState.element
    
    var background = SKSpriteNode(texture: SKTexture(imageNamed: "MainScene"))
    var floorBackground = SKSpriteNode(texture: SKTexture(imageNamed: "Floor"))
    
    private var touches: [(UITouch, ButtonAssociation)] = []
    
    private var movementInput = SKShapeNode()
    private var movementAnalogic = SKShapeNode()
    
    private var combosInput = SKShapeNode()
    private var combosAnalogic = SKShapeNode()
    
    private var numberEnemies: Int
    
    private var directionToMove: Directions4?
//    private var firstDirectionCombo: Directions = .up
    
    private var door =  SKSpriteNode()
    
    private var levelLabel: SKLabelNode
    
    private var jumpCounter = 0
    private var jumpLocked = false
    
    private var enemiesKilled = 0
    
    private var mapInterpreter: MapInterpreter
    
    
    private func saveHighscore(){
        guard self.currentLevel != .Tutorial else { return }
        
        var points: Int = enemiesKilled * (Constants.singleton.currentLevel - 1)
        
        if let key = UserDefaults.standard.string(forKey: "currentHighscore") {
            if let value = Int(key) {
                points += value
            }
        }
        
        UserDefaults.standard.set(String( points ), forKey: "currentHighscore")
    }
    
    private func setupTutorial() {
        let text1 = SKLabelNode(text: "To move, use the joystick on the left corner of the screen.")
        
        let text3 = SKLabelNode(text: "To cast a")
        let text32 = SKLabelNode(text: "fireball")
        text32.fontColor = UIColor.red
        let text33 = SKLabelNode(text: ", drag and release left on the right joystick, then up ")
        let text34 = SKLabelNode(text: "and then aim where you feel like it. But hurry up, time is your enemy.")
        
        let text4 = SKLabelNode(text: "Beyond this wall is an evil spider.")
        let text5 = SKLabelNode(text: "Mages hate spiders. Kill it.")
        
        let text6 = SKLabelNode(text: "👈  👆  👉")
        
        let texts = [text1, text3, text32, text33, text34, text4, text5, text6]
        for i in texts {
            i.fontName = "NovaCut-Regular"
            i.fontSize = 23
        }
        
        text1.position = CGPoint(x: -850, y: 40)
        text3.position = CGPoint(x: -400, y: 140)
        text32.position = CGPoint(x: -315, y: 140)
        text33.position = CGPoint(x: -20, y: 140)
        text34.position = CGPoint(x: -100, y: 110)
        text4.position = CGPoint(x: 300, y: 35)
        text5.position = CGPoint(x: 770, y: 70)
        text6.position = CGPoint(x: 320, y: 110)
        
        addChild(text1)
        addChild(text3)
        addChild(text32)
        addChild(text33)
        addChild(text34)
        addChild(text4)
        addChild(text5)
        addChild(text6)
    }
    
    private func setupDoor() {
        let plat: SKSpriteNode
        
        if tutorialFlag {
            plat = platforms[1]
        } else {
            plat = platforms.randomElement()!
        }
        
        door = SKSpriteNode(imageNamed: "DoorLocked")
        
        door.name = "door"
        
        door.setScale(2)
        door.position = CGPoint(x: plat.frame.midX, y: plat.position.y + door.frame.height/2)
        door.zPosition = -7
        
        door.physicsBody = SKPhysicsBody(rectangleOf: door.size)
        door.physicsBody?.isDynamic = false
        door.physicsBody?.categoryBitMask = 0
        
        addChild(door)
    }
    
    private func openDoor() {
        door.physicsBody?.categoryBitMask = Constants.singleton.wallMask
        door.run(.animate(with: [.init(imageNamed: "DoorUnlocked")], timePerFrame: 1))
    }
    
    private func finishLevel(win: Bool) {
        if win {
            Constants.singleton.locker = true
            Constants.singleton.notificationCenter.post(name: Notification.Name("playerWin"), object: nil)
            
            AudioManager.shared.playSound(named: "door.wav")
        } else {
            Constants.singleton.notificationCenter.post(name: Notification.Name("playerDeath"), object: nil)
        }
        
        self.saveHighscore()
    }
    
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
                handleMovement(pos: pos)
                
                if movementInput.contains(pos) {
                    movementAnalogic.run(.move(to: pos, duration: 0.1))
                } else {
                    let limitedPos = (pos - movementInput.position).normalized() * 100
                    movementAnalogic.run(.move(to: movementInput.position + limitedPos, duration: 0.1))
                }
                
            case .combosAnalog:
                // --------------------------------------------------------------------------------------------- a bolinha do analogico
                if combosInput.contains(pos) {
                    combosAnalogic.run(.move(to: pos, duration: 0.1))
                } else {
                    let limitedPos = (pos - combosInput.position).normalized() * 100
                    combosAnalogic.run(.move(to: combosInput.position + limitedPos, duration: 0.1))
                }
                
                // --------------------------------------------------------------------------------------------- resto
                
                let vector = pos - combosInput.position
                
                switch currentComboState {
                case .element:
                    let direction = Directions4.calculateDirections(vector)

                    comboElementNodes.forEach { nd in
                        emphasizeComboSprite(nd, name: comboElementNodes[direction.rawValue].name!)
                    }
                    
                case .magic(let elementDirection):
                    let chosenDirection = Directions4.calculateDirections(vector)
                    
                    switch elementDirection {
                    case .up:
                        comboIceNodes.forEach { nd in
                            emphasizeComboSprite(nd, name: comboIceNodes[chosenDirection.rawValue].name!)
                        }

                    case .right:
                        comboEarthNodes.forEach { nd in
                            emphasizeComboSprite(nd, name: comboEarthNodes[chosenDirection.rawValue].name!)
                        }
                        
                    case .down:
                        comboThunderNodes.forEach { nd in
                            emphasizeComboSprite(nd, name: comboThunderNodes[chosenDirection.rawValue].name!)
                        }
                        
                    case .left:
                        comboFireNodes.forEach { nd in
                            emphasizeComboSprite(nd, name: comboFireNodes[chosenDirection.rawValue].name!)
                        }
                    }
                    
                case .direction:
                    let direction = Directions8.calculateDirections(vector)
                    
                    comboDirectionsNodes.forEach { nd in
                        emphasizeComboSprite(nd, name: comboDirectionsNodes[direction.rawValue].name!)
                    }
                }
            }
        }
    }
    
    private func emphasizeComboSprite(_ nd: SKNode, name: String) {
        guard let ndName = nd.name else { return }
        
        if ndName == name {
            nd.run(.group([
                .scale(to: Constants.singleton.combosSpritesScale + 0.2, duration: Constants.singleton.combosSpritesAnimationDuration),
                .fadeAlpha(to: 2, duration: Constants.singleton.combosSpritesAnimationDuration)
                
            ]))
        } else {
            nd.run(.group([
                .scale(to: Constants.singleton.combosSpritesScale, duration: Constants.singleton.combosSpritesAnimationDuration),
                .fadeAlpha(to: Constants.singleton.combosSpritesAlpha, duration: Constants.singleton.combosSpritesAnimationDuration)
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
                
                directionToMove = nil
                
            case .combosAnalog:
                let pos = t.location(in: camera)
                
                
                // --------------------------------------------------------------------------------------------- a bolinha do analogico
                combosAnalogic.run(SKAction.move(to: combosInput.position, duration: 0.1))
                
                // --------------------------------------------------------------------------------------------- volta todos os nodes pro tamanho original
                for i in combosInput.children {
                    i.run(.group([
                        .scale(to: Constants.singleton.combosSpritesScale, duration: Constants.singleton.combosSpritesAnimationDuration),
                        .fadeAlpha(to: Constants.singleton.combosSpritesAlpha, duration: Constants.singleton.combosSpritesAnimationDuration)
                    ]))
                }
                
                // --------------------------------------------------------------------------------------------- lida com o combo em si
                handleCombo(pos: pos)
            }
            return false
        })
    }
    
    private func handleMovement(pos: CGPoint) {
        let vector = pos - movementInput.position
        let dir = Directions4.calculateDirections(vector)
        
        if dir == .down {
            directionToMove = nil
        } else {
            directionToMove = dir
        }
    }
    
    private func hide(_ h: Bool, list: [SKSpriteNode]) {
        for i in list {
            i.isHidden = h
        }
    }
    
    private func handleCombo(pos: CGPoint) {
        let vector = pos - combosInput.position
        
        switch currentComboState {
        case .element:
            self.comboTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                if case .magic = self.currentComboState {
                    self.currentComboState = .element
                    
                    [self.comboIceNodes, self.comboEarthNodes, self.comboThunderNodes, self.comboFireNodes].forEach { list in
                        self.hide(true, list: list)
                    }
                    
                    self.hide(false, list: self.comboElementNodes)
                }
            }
            
            let direction = Directions4.calculateDirections(vector)
            
            hide(true, list: comboElementNodes)
            
            let show: [SKSpriteNode]
            
            switch direction {
            case .up:
                show = comboIceNodes
            case .right:
                show = comboEarthNodes
            case .down:
                show = comboThunderNodes
            case .left:
                show = comboFireNodes
            }
            
            [comboIceNodes, comboEarthNodes, comboThunderNodes, comboFireNodes].forEach { list in
                if list == show {
                    hide(false, list: list)
                } else {
                    hide(true, list: list)
                }
            }
            
            currentComboState = .magic(direction)
            
        case .magic(let previousDirection):
            self.comboTimer?.invalidate()
            
            let direction = Directions4.calculateDirections(vector)
            let magic = Magics.magic(primary: previousDirection, secondary: direction)
            
            switch previousDirection {
            case .up:
                hide(true, list: comboIceNodes)
            case .right:
                hide(true, list: comboEarthNodes)
            case .down:
                hide(true, list: comboThunderNodes)
            case .left:
                hide(true, list: comboFireNodes)
            }
            
            hide(false, list: comboDirectionsNodes)
            
            currentComboState = .direction(magic)
            
        case .direction(let magic):
            let normalizedVector = vector.normalized()
            let angle = atan2(normalizedVector.y, normalizedVector.x)
            
            hide(true, list: comboDirectionsNodes)
            
            switch magic {
            case .A(.fire):
                let fireball = Fireball(angle: angle, player: player)
                magics.append(fireball)
                addChild(fireball.node)
                
            case .A(.ice):
                let iceball = Iceball(angle: angle, player: player)
                magics.append(iceball)
                addChild(iceball.node)
                
            case .A(.thunder):
                let thunder = ThunderShot(angle: angle, player: player)
                addChild(thunder.node)
                magics.append(thunder)
                
            case .A(.earth):
                var floorHeight = player.position.y - player.sprite.frame.height/2
                var nd: SKNode?
                for i in floors + platforms {
                    if player.sprite.intersects(i) && (player.position.y > i.position.y) {
                        nd = i
                        floorHeight = i.position.y + i.size.height/2
                    }
                }
                
                if nd == nil {
                    floorHeight = floors[0].position.y
                    nd = floors[0]
                }
                
                let stoneWall = StoneWall(player: player, angle: angle, floorHeight: floorHeight, floor: nd!, move: false)
                addChild(stoneWall.sprite)
                
            case .B(.earth):
                var floorHeight = player.position.y - player.sprite.frame.height/2
                var nd: SKNode?
                for i in floors + platforms {
                    if player.sprite.intersects(i) && (player.position.y > i.position.y) {
                        nd = i
                        floorHeight = i.position.y + i.size.height/2
                    }
                }
                
                if nd == nil {
                    floorHeight = floors[0].position.y
                    nd = floors[0]
                }
                
                let stoneWall = StoneWall(player: player, angle: angle, floorHeight: floorHeight, floor: nd!, move: true)
                addChild(stoneWall.sprite)
                
            case .B(.ice):
                let iceball = Blizzard(angle: angle, player: player)
                magics.append(iceball)
                addChild(iceball.node)
                
            case .B(.fire):
                let fireArrow: FireArrow = FireArrow(angle: angle, player: player)
                addChild(fireArrow.node)
                magics.append(fireArrow)
            
            case .D(let element):
                let x = element.getBuff()
                x(player, 15.0)
                
            default:
                break
            }
            
            hide(false, list: comboElementNodes)
            
            currentComboState = .element
        }
        
        // to do
    }
    
    /// quando a view chamar a cena, esta funçao é a primeira a ser executada.
    ///  é a preparaçao da cena.
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        
        self.backgroundColor = .black
        physicsWorld.contactDelegate = self
        background.zPosition = -30
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.size = CGSize(width: Constants.singleton.frame.width * 3, height: Constants.singleton.frame.height * 3)
        background.position.y = -Constants.singleton.frame.height/2
        addChild(background)
        
        floorBackground.zPosition = -15
        floorBackground.anchorPoint = CGPoint(x: 0.5, y: 0)
        floorBackground.size = CGSize(width: frame.width * 3, height: frame.height * 6)
        floorBackground.position.y = frame.minY - (200*2)
        addChild(floorBackground)
        
        // ------------------------------------------------------------------------
        setupPlayer()
        
        // ------------------------------------------------------------------------
        setupCamera()
        // ------------------------------------------------------------------------
        setupGround()
        
        setupDoor()
        
        // ------------------------------------------------------------------------
        
        if tutorialFlag {
            setupTutorial()
            delayWithSeconds(spawnRate) { [self] in
                self.setupSpawn(position: CGPoint(x: 900, y: 2 * frame.maxY), spriteName: "Spider", idSpawn: 1)
            }
        } else {
            for i in 0...numberEnemies - 1 {
                delayWithSeconds(spawnRate * Double(i)) { [self] in
                    self.setupSpawn(position: CGPoint(x: CGFloat.random(in: -Constants.singleton.frame.width/3...Constants.singleton.frame.width/3), y: 2 * frame.maxY), spriteName: "Spider", idSpawn: i)
                }
            }
        }
        //------------------------------------------------------------------------
        setupButtons()
        
        view.isMultipleTouchEnabled = true
    }
    
    private func setupGround() {
        let rects = mapInterpreter.rects
        let wall = mapInterpreter.wall
        let floor = mapInterpreter.floor
        
        for i in rects {
            self.createPlatform(size: i.size, position: i.position, sprite: Constants.randomPlatformSprite())
        }
        
        for i in wall {
            self.createWall(size: i.size, position: i.position, sprite: Constants.randomPlatformSprite())
        }
        
        for i in floor {
            self.createFloor(size: i.size, position: i.position, sprite: Constants.randomPlatformSprite())
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func spiderToCharging(spider: EnemySpider){
        if spider.currentState == .walking || spider.currentState == .idle{
            var spiderCopy = spider
            spiderCopy.transition(to: .charging)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                spiderCopy.transition(to: .goingUp)
                //desiredHeight in x times the spider height
                let desiredHeight: CGFloat = 1.5
                //so pra caso a gravidade mude, muda isso aqui ou faz ser igual o valor nas constantes
                let gravity: CGFloat = -9.8
                
                spider.attributes.velocity.maxXSpeed *= 100
                spider.attributes.velocity.maxYSpeed *= 100
                let direction: CGFloat = spider.sprite.position.x > self.player.sprite.position.x ? -1 : 1
                if spider.currentState != .death{
                    spider.physicsBody.applyImpulse(CGVector(dx:(direction * (Constants.singleton.playerSize.width/2 + Constants.singleton.spiderSize.width/2)) + (self.player.sprite.position.x - spider.sprite.position.x), dy: abs(Constants.singleton.playerSize.height - Constants.singleton.spiderSize.height) + (spider.sprite.position.y - spider.sprite.position.y) + (desiredHeight * spider.sprite.size.height) - (45.0 * gravity)))
                }
            }
        }
    }
    
    func didBeginCompareNames(contact: SKPhysicsContact, name1: String, name2: String) -> Bool {
        return (contact.bodyA.node?.name == name1 && contact.bodyB.node?.name == name2) || (contact.bodyA.node?.name == name2 && contact.bodyB.node?.name == name1)
    }
    
    func didBeginPlatformFloorPlayer(contact: SKPhysicsContact){
        //Colocar aqui tudo que for adicionado a funcao:
        
        /*
         A funcao reseta o jumpCounter e muda o estado do player de acordo
         */
        if didBeginCompareNames(contact: contact, name1: "platform", name2: "Player") || didBeginCompareNames(contact: contact, name1: "floor", name2: "Player"){
            self.jumpCounter = 0
            player.transition(to: .landing)
            player.transition(to: .idle)
        }
    }
    
    func didBeginMagicFloorWall(contact: SKPhysicsContact){
        //Colocar aqui tudo que for adicionado a funcao:
        
        /*
         Procura a referencia a magia na lista de magias, entao torna seu birthRate em 0. Após 1.5 segundos, remove a magia de vez da cena.
         Retirar primeiro o birthrate e dps a magia torna o efeito visualmente melhor.
         */
        
        if didBeginCompareNames(contact: contact, name1: "Magic", name2: "wall") || didBeginCompareNames(contact: contact, name1: "floor", name2: "Magic"){
            for idx in 0..<magics.count {
                if magics[idx].physicsBody === contact.bodyA || magics[idx].physicsBody === contact.bodyB{
                    magics[idx].node.particleBirthRate = 0
                    let reference = magics[idx]
                    magics.remove(at: idx)
                    reference.node.run(SKAction.sequence(
                        [.wait(forDuration: 1.5),
                         .removeFromParent()
                        ]))
                    break
                }
            }
        }
        
        else if didBeginCompareNames(contact: contact, name1: "FireArrow", name2: "wall") || didBeginCompareNames(contact: contact, name1: "floor", name2: "FireArrow"){
            for idx in 0..<magics.count {
                if magics[idx].physicsBody === contact.bodyA || magics[idx].physicsBody === contact.bodyB{
                    FireArrowSmoke(father: magics[idx].node)
                }
            }
        }
    }
    
    func didBeginPlatformFloorSpider(contact: SKPhysicsContact){
        //Colocar aqui tudo que for adicionado a funcao:
        
        /*
         quando a aranha toca no chao ou em uma plataforma e ta em modo de ataque, quer dizer q a mask dela já estava solidificada, e por isso ela pode transicionar pro idle e voltar a velocidade padrão
         */
        
        if didBeginCompareNames(contact: contact, name1: "platform", name2: "Spider") || didBeginCompareNames(contact: contact, name1: "floor", name2: "Spider"){
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
    }
    
    func didBeginMagicSpider(contact: SKPhysicsContact){
        //Colocar aqui tudo que for adicionado a funcao:
        
        /*
         Essa funcao faz coisa p krl, ent ela ta quebrada em funcoes menores.
         */
        
        func colisaoMagiaAranha(spider: EnemySpider){
            //Aplica o onTouch na aranha, muda a velocidade dela pra aplicar o knockback adequado
            
            //Aplica o knockback e dps remove o feitico primeiro mudando o birth rate dele p 0 e dps fzendo sumir.
            
            for idx in 0..<magics.count{
                if magics[idx].physicsBody === contact.bodyA || magics[idx].physicsBody === contact.bodyB{
                    
                    magics[idx].onTouch(touched: spider)
                    
                    let className = String(describing: magics[idx])
                    if className != "HackSlash.Blizzard" {
                        spider.attributes.velocity.maxYSpeed *= 10
                        spider.attributes.velocity.maxXSpeed *= 10
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            spider.attributes.velocity.maxYSpeed /= 10
                            spider.attributes.velocity.maxXSpeed /= 10
                        }
                        
                        spider.physicsBody.applyImpulse(CGVector(dx: Constants.singleton.spiderSize.width * cos(magics[idx].angle) * 6, dy: Constants.singleton.spiderSize.height * sin(magics[idx].angle) * 6))
                        
                        let reference = magics[idx]
                        reference.node.run(SKAction.sequence([
                            .wait(forDuration: 0.1),
                            .run{
                                reference.node.particleBirthRate = 0
                            },
                            .wait(forDuration: 0.5),
                            .run{
                                for idx in 0..<self.magics.count{
                                    if self.magics[idx] === reference{
                                        self.magics.remove(at: idx)
                                    }
                                    break
                                }
                                reference.node.removeFromParent()
                            }
                        ]))
                    }
                }
            }
        }
        
        //Chama as funcoes nos momentos certos
        if didBeginCompareNames(contact: contact, name1: "Magic", name2: "Spider"){
            for idx in 0..<spiders.count{
                let spider = spiders[idx]
                if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                    colisaoMagiaAranha(spider: spider)
                }
            }
        }
    }
    
    func didBeginSpiderFireExplosion(contact: SKPhysicsContact){
        if didBeginCompareNames(contact: contact, name1: "Spider", name2: "FireExplosion"){
            for spider in spiders {
                if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                    spider.attributes.health -= Constants.singleton.fireExplosionDamage.damage
                }
                print(spider.attributes.health)
            }
        }
    }
    
    func didBeginWallSpider(contact: SKPhysicsContact){
        //Colocar aqui tudo que for adicionado a funcao:
        
        /*
         Se a aranha atingir uma parede, estiver tocando no chao e estiver em idle ou walking, entra em charging
         */
        
        if didBeginCompareNames(contact: contact, name1: "wall", name2: "Spider") {
            for idx in 0..<spiders.count{
               let spider = spiders[idx]
                if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                    spiderToCharging(spider: spider)
                }
            }
        }
    }
    
    func didBegin(_ contact:SKPhysicsContact){
        
        didBeginPlatformFloorPlayer(contact: contact)
        didBeginMagicFloorWall(contact: contact)
        didBeginPlatformFloorSpider(contact: contact)
        didBeginMagicSpider(contact: contact)
        didBeginWallSpider(contact: contact)
        didBeginSpiderFireExplosion(contact: contact)

        if (contact.bodyA.node?.name == "door") || (contact.bodyB.node?.name == "door") {
            self.finishLevel(win: true)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if player.attributes.health <= 0 {
            self.finishLevel(win: false)
        }
        
        camera?.position = player.position
        for spider in spiders{
            spider.moveAI(player: player.sprite)
        }
        updatePlayerState()
        updateSpidersState()

        if jumpLocked {
            if let directionToMove = self.directionToMove {
                if case .up = directionToMove {
                    self.directionToMove = nil
                }
            }
        }
        
//        if directionToMove == .up || directionToMove == .upLeft || directionToMove == .upRight {
        if directionToMove == .up {
            if jumpCounter >= 2 {
                self.directionToMove = nil
            }
            
            player.transition(to: .jump)
            
            jumpCounter += 1
            jumpLocked = true
        }
        
        if let directionToMove = self.directionToMove {
            player.move(direction: directionToMove)
        }
        
        if player.sprite.physicsBody!.velocity.dx < 0{
            player.sprite.xScale = -1
        }
        else{
            player.sprite.xScale = 1
        }
    }
    
    func updatePlayerState(){
        if player.currentState == .jump {
            player.physicsBody.collisionBitMask = player.physicsBody.collisionBitMask & (UInt32.max - Constants.singleton.groundMask)
            player.physicsBody.contactTestBitMask = player.physicsBody.contactTestBitMask & (UInt32.max - Constants.singleton.groundMask)
        }
        
        if player.physicsBody.velocity.dy < 0{
            player.transition(to: .airborne)
            jumpLocked = false
        }
        
        if player.currentState == .airborne{
            if player.sprite.physicsBody!.collisionBitMask & Constants.singleton.groundMask == 0 {
                var hasCollided = false
                for platform in platforms {
                    if platform.intersects(player.sprite){
                        hasCollided = true
                    }
                }
                if !hasCollided {
                    player.physicsBody.collisionBitMask = player.physicsBody.collisionBitMask + Constants.singleton.groundMask
                    player.physicsBody.contactTestBitMask = player.physicsBody.contactTestBitMask + Constants.singleton.groundMask
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
    
    func killSpider(spider: EnemySpider, idx: Int){
        //transition spider state and apply sound effects
        
        
        if spider.currentState != .death && spider.attributes.health <= 0{
            AudioManager.shared.playSound(named: "spiderDying.wav")
            var copy = spider
            copy.transition(to: .death)
            delayWithSeconds(spider.despawnTime, completion: {
                for idx in 0..<self.spiders.count{
                    if self.spiders[idx] === spider{
                        self.spiders.remove(at: idx)
                        break
                    }
                }
                //remover aranha da cena
                spider.sprite.removeFromParent()
            })
            enemiesKilled += 1
            
            //apply win sound
            if numberEnemies == enemiesKilled {
                AudioManager.shared.playSound(named: "notification.mp3")
                self.openDoor()
            }
        }
    }
    
    
    func updateSpidersState(){
        var deadSpiders: [(EnemySpider, Int)] = []
        for idx in 0..<spiders.count{
            let spider = spiders[idx]
            if spider.currentState != .death && spider.attributes.health <= 0{
                deadSpiders.append((spider, idx))
            }
            if spider.currentState == .attack{
                if spider.sprite.physicsBody!.collisionBitMask & Constants.singleton.groundMask == 0 {
                    if spider.position.y <= player.position.y{
                        var hasCollided = false
                        for platform in platforms {
                            if platform.intersects(spider.sprite){
                                hasCollided = true
                            }
                        }
                        if !hasCollided {
                            spider.physicsBody.collisionBitMask = spider.physicsBody.collisionBitMask | Constants.singleton.groundMask
                        }
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
        for tupla in deadSpiders {
            let spider = tupla.0
            let idx = tupla.1
            killSpider(spider: spider, idx: idx)
        }
    }
    
    func setupButtons() {
        let buttonRadius: CGFloat = 75
        
        let width = Constants.singleton.frame.width/3
        let height = -Constants.singleton.frame.height/4
        
        // ------------------------------------------------------------------------------------------ movement
        movementInput = SKShapeNode(circleOfRadius: buttonRadius)
        movementInput.position = CGPoint(x: -width, y: height)
        movementInput.zPosition = 10
        movementInput.strokeColor = Constants.singleton.buttonsColor
        movementInput.fillColor = Constants.singleton.buttonsColor.withAlphaComponent(0.2)
        
        // --------------------------------------------
        movementAnalogic = SKShapeNode(circleOfRadius: buttonRadius/4)
        movementAnalogic.zPosition = 11
        movementAnalogic.position = movementInput.position
        movementAnalogic.fillColor = Constants.singleton.buttonsColor
        
        // ------------------------------------------------------------------------------------------ combos
        combosInput = SKShapeNode(circleOfRadius: buttonRadius)
        combosInput.position = CGPoint(x: width, y: height)
        combosInput.strokeColor = .clear
        
        // --------------------------------------------
        let ice = SKSpriteNode(texture: Constants.singleton.icePowerTexture)
        ice.anchorPoint = CGPoint(x: 0.5, y: 0)
        ice.zPosition = 10
        ice.name = "ice"
        combosInput.addChild(ice)
        
        let earth = SKSpriteNode(texture: Constants.singleton.earthPowerTexture)
        earth.anchorPoint = CGPoint(x: 0, y: 0.5)
        earth.zPosition = 10
        earth.name = "earth"
        combosInput.addChild(earth)
        
        let eletric = SKSpriteNode(texture: Constants.singleton.eletricPowerTexture)
        eletric.anchorPoint = CGPoint(x: 0.5, y: 1)
        eletric.zPosition = 10
        eletric.name = "eletric"
        combosInput.addChild(eletric)
        
        let fire = SKSpriteNode(texture: Constants.singleton.firePowerTexture)
        fire.anchorPoint = CGPoint(x: 1, y: 0.5)
        fire.zPosition = 10
        fire.name = "fire"
        combosInput.addChild(fire)
        
        comboElementNodes = [ice, earth, eletric, fire]

        // -------------------------------------------- fire
        let fireA = SKSpriteNode(texture: Constants.singleton.fireATexture)
        fireA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        fireA.zPosition = 10
        fireA.name = "fireA"
        combosInput.addChild(fireA)
        
        let fireB = SKSpriteNode(texture: Constants.singleton.fireBTexture)
        fireB.anchorPoint = CGPoint(x: 1, y: 0.5)
        fireB.zPosition = 10
        fireB.name = "fireB"
        combosInput.addChild(fireB)
        
        let fireC = SKSpriteNode(texture: Constants.singleton.fireCTexture)
        fireC.anchorPoint = CGPoint(x: 0, y: 0.5)
        fireC.zPosition = 10
        fireC.name = "fireC"
        combosInput.addChild(fireC)

        let fireD = SKSpriteNode(texture: Constants.singleton.fireDTexture)
        fireD.anchorPoint = CGPoint(x: 0.5, y: 1)
        fireD.zPosition = 10
        fireD.name = "fireD"
        combosInput.addChild(fireD)

        comboFireNodes = [fireA, fireC, fireD, fireB]

        // -------------------------------------------- earth
        let earthC = SKSpriteNode(texture: Constants.singleton.earthCTexture)
        earthC.anchorPoint = CGPoint(x: 0, y: 0.5)
        earthC.zPosition = 10
        earthC.name = "earthC"
        combosInput.addChild(earthC)

        let earthD = SKSpriteNode(texture: Constants.singleton.earthDTexture)
        earthD.anchorPoint = CGPoint(x: 0.5, y: 1)
        earthD.zPosition = 10
        earthD.name = "earthD"
        combosInput.addChild(earthD)

        let earthB = SKSpriteNode(texture: Constants.singleton.earthBTexture)
        earthB.anchorPoint = CGPoint(x: 1, y: 0.5)
        earthB.zPosition = 10
        earthB.name = "earthB"
        combosInput.addChild(earthB)

        let earthA = SKSpriteNode(texture: Constants.singleton.earthATexture)
        earthA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        earthA.zPosition = 10
        earthA.name = "earthA"
        combosInput.addChild(earthA)

        comboEarthNodes = [earthA, earthC, earthD, earthB]

        // -------------------------------------------- ice
        let iceC = SKSpriteNode(texture: Constants.singleton.iceCTexture)
        iceC.anchorPoint = CGPoint(x: 0, y: 0.5)
        iceC.zPosition = 10
        iceC.name = "iceC"
        combosInput.addChild(iceC)

        let iceD = SKSpriteNode(texture: Constants.singleton.iceDTexture)
        iceD.anchorPoint = CGPoint(x: 0.5, y: 1)
        iceD.zPosition = 10
        iceD.name = "iceD"
        combosInput.addChild(iceD)

        let iceB = SKSpriteNode(texture: Constants.singleton.iceBTexture)
        iceB.anchorPoint = CGPoint(x: 1, y: 0.5)
        iceB.zPosition = 10
        iceB.name = "iceB"
        combosInput.addChild(iceB)

        let iceA = SKSpriteNode(texture: Constants.singleton.iceATexture)
        iceA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        iceA.zPosition = 10
        iceA.name = "iceA"
        combosInput.addChild(iceA)

        comboIceNodes = [iceA, iceC, iceD, iceB]

        // -------------------------------------------- thunder
        let thunderA = SKSpriteNode(texture: Constants.singleton.thunderATexture)
        thunderA.anchorPoint = CGPoint(x: 0.5, y: -0.03)
        thunderA.zPosition = 10
        thunderA.name = "thunderA"
        combosInput.addChild(thunderA)
        
        let thunderB = SKSpriteNode(texture: Constants.singleton.thunderBTexture)
        thunderB.anchorPoint = CGPoint(x: 1, y: 0.5)
        thunderB.zPosition = 10
        thunderB.name = "thunderB"
        combosInput.addChild(thunderB)
        
        let thunderC = SKSpriteNode(texture: Constants.singleton.thunderCTexture)
        thunderC.anchorPoint = CGPoint(x: 0, y: 0.5)
        thunderC.zPosition = 10
        thunderC.name = "thunderC"
        combosInput.addChild(thunderC)

        let thunderD = SKSpriteNode(texture: Constants.singleton.thunderDTexture)
        thunderD.anchorPoint = CGPoint(x: 0.5, y: 1)
        thunderD.zPosition = 10
        thunderD.name = "thunderD"
        combosInput.addChild(thunderD)

        comboThunderNodes = [thunderA, thunderC, thunderD, thunderB]

        // -------------------------------------------- directions
        let down = SKSpriteNode(texture: Constants.singleton.downMagicTexture)
        down.anchorPoint = CGPoint(x: 0.5, y: 6.5)
        down.zPosition = 10
        down.name = "down"
        combosInput.addChild(down)

        let up = SKSpriteNode(texture: Constants.singleton.upMagicTexture)
        up.anchorPoint = CGPoint(x: 0.5, y: -5.5)
        up.zPosition = 10
        up.name = "up"
        combosInput.addChild(up)

        let right = SKSpriteNode(texture: Constants.singleton.rightMagicTexture)
        right.anchorPoint = CGPoint(x: -5.5, y: 0.5)
        right.zPosition = 10
        right.name = "right"
        combosInput.addChild(right)

        let left = SKSpriteNode(texture: Constants.singleton.leftMagicTexture)
        left.anchorPoint = CGPoint(x: 6.5, y: 0.5)
        left.zPosition = 10
        left.name = "left"
        combosInput.addChild(left)

        let upR = SKSpriteNode(texture: Constants.singleton.upRMagicTexture)
        upR.anchorPoint = CGPoint(x: -1.45, y: -1.45)
        upR.zPosition = 10
        upR.name = "upR"
        combosInput.addChild(upR)

        let upL = SKSpriteNode(texture: Constants.singleton.upLMagicTexture)
        upL.anchorPoint = CGPoint(x: 2.45, y: -1.45)
        upL.zPosition = 10
        upL.name = "upL"
        combosInput.addChild(upL)

        let downR = SKSpriteNode(texture: Constants.singleton.downRMagicTexture)
        downR.anchorPoint = CGPoint(x: -1.45, y: 2.45)
        downR.zPosition = 10
        downR.name = "downR"
        combosInput.addChild(downR)

        let downL = SKSpriteNode(texture: Constants.singleton.downLMagicTexture)
        downL.anchorPoint = CGPoint(x: 2.45, y: 2.45)
        downL.zPosition = 10
        downL.name = "downL"
        combosInput.addChild(downL)

        let directions = SKSpriteNode(texture: Constants.singleton.directionsTexture)
        directions.name = "directions"
        combosInput.addChild(directions)

        comboDirectionsNodes = [up, right, down, left, upR, upL, downR, downL, directions]
        
        // ----------------------------------------------------------------------------------------
        for i in combosInput.children {
            i.setScale(Constants.singleton.combosSpritesScale)
            i.alpha = Constants.singleton.combosSpritesAlpha
        }
        
        for i in comboFireNodes{
            i.isHidden = true
        }
        for i in comboEarthNodes{
            i.isHidden = true
        }
        for i in comboIceNodes{
            i.isHidden = true
        }
        for i in comboThunderNodes{
            i.isHidden = true
        }
        
        for i in comboDirectionsNodes{
            i.isHidden = true
        }
        
        // --------------------------------------------
        combosAnalogic = SKShapeNode(circleOfRadius: buttonRadius/4)
        combosAnalogic.position = combosInput.position
        combosAnalogic.fillColor = Constants.singleton.buttonsColor
        combosAnalogic.zPosition = 11
        
        // ------------------------------------------------------------------------------------------ add to scene
        camera?.addChild(movementInput)
        camera?.addChild(movementAnalogic)
        
        camera?.addChild(combosInput)
        camera?.addChild(combosAnalogic)
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
        camera.setScale(2)
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
        platform.physicsBody?.categoryBitMask = Constants.singleton.groundMask
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
        wall.physicsBody?.categoryBitMask = Constants.singleton.wallMask
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
        floor.zPosition = -15
        floor.physicsBody?.categoryBitMask = Constants.singleton.wallMask
        floors.append(floor)
        floor.physicsBody?.friction = 0.7
        addChild(floor)
    }
    
    func setupPlayer(){
        //Creates player and adds it to the scene
        player = Player(sprite: "MagoFrente")
        player.sprite.position.y += Constants.singleton.frame.height/2 //frame.midY + frame.midY/2
        
        if tutorialFlag {
            player.sprite.position.x += -700
        } else {
            player.sprite.position.x += .random(in: -Constants.singleton.frame.width...Constants.singleton.frame.width)
        }
        
        addChild(player.sprite)
    }
    
    func setupSpider(spriteName: String, idSpider: Int) -> EnemySpider{
        AudioManager.shared.playSound(named: "spiderSpawn.wav")
        let spider = EnemySpider(sprite: spriteName, attributes: AttributesInfo(health: 20, defense: 20, weakness: [], resistence: [], velocity: VelocityInfo(xSpeed: 50, ySpeed: 10, maxXSpeed: 200, maxYSpeed: 5000), attackRange: frame.width * 0.3, maxHealth: 100), player: player, idSpider: idSpider)
        return spider
    }
    
}
