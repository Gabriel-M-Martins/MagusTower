import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    /// struct constants vai ter todos os valores constantes ao longo do jogo, cores e etc
    var constants: Constants {
        return Constants(frame: frame)
    }

    // lista de plataformas existentes na cena. todas sao desenhadas no começo do jogo
    var platforms: [SKSpriteNode] = []
    var player: Player = Player(sprite: "")
    
    
    private var movementInput = SKShapeNode()
    private var combosInput = SKShapeNode()
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        let tappedNode = atPoint(convertPoint(fromView: recognizer.location(in: view)))
        
        guard let nodeName = tappedNode.name else { return }
        
        if nodeName == "movementInput" {
            player.move(direction: [.up])
            player.transition(to: .jump)
            return
        }
        
        if nodeName == "combosInput" {
            // implement attack stuff
            return
        }
    }
    
    /// quando a view chamar a cena, esta funçao é a primeira a ser executada.
    ///  é a preparaçao da cena.
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        // ------------------------------------------------------------------------
        setupGround()
        // ------------------------------------------------------------------------
        setupPlayer()
        // ------------------------------------------------------------------------
        setupCamera()
        // ------------------------------------------------------------------------
        setupButtons()
        // ------------------------------------------------------------------------
        setupGestures()
    }
    
    
    func didBegin(_ contact:SKPhysicsContact){
        if contact.bodyA.node?.name == "Player" || contact.bodyB.node?.name == "Player" {
            player.transition(to: .idle)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
//        player.move(direction: [.right, .up])
        camera?.position = player.position
    }
    
    func setupButtons() {
        movementInput = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
        movementInput.name = "movementInput"
        movementInput.position = CGPoint(x: frame.minX + 250, y: frame.minY + 250)
        movementInput.strokeColor = .red

        combosInput = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
        combosInput.name = "combosInput"
        combosInput.position = CGPoint(x: frame.maxX - 250, y: frame.minY + 250)
        combosInput.strokeColor = .blue
        
        camera?.addChild(movementInput)
        camera?.addChild(combosInput)
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        view?.addGestureRecognizer(tap)
    }
    
    func setupCamera() {
        let camera = SKCameraNode()
        camera.setScale(0.7)
        self.camera = camera
        addChild(camera)
    }
    
    func createPlatform(size: CGSize, position: CGPoint, sprite: String){
        let platform = SKSpriteNode(imageNamed: sprite)
        platform.size = size
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        platform.anchorPoint = CGPoint(x: 0.5, y: 0)
        // posicao do platform é zero no x e o mais baixo no y
        platform.position = position
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height * 2))
        platform.physicsBody?.isDynamic = false
        platform.name = "platform"
        platform.physicsBody?.contactTestBitMask = Constants.groundMask
        addChild(platform)
    }
    
    func setupGround(){
        //cria o chao
        createPlatform(size: CGSize(width: frame.width, height: frame.height/4), position: CGPoint(x: 0, y: frame.minY), sprite: "YellowBall")
        // ------------------------------------------------------------------------
        //cria plataforma esquerda
        createPlatform(size: CGSize(width: frame.width/3, height: constants.platformsHeight), position: CGPoint(x: frame.minX + frame.width/6, y: frame.midY), sprite: "YellowBall")
        // ------------------------------------------------------------------------
        //cria plataforma direita
        createPlatform(size: CGSize(width: frame.width/3, height: constants.platformsHeight), position: CGPoint(x: frame.maxX - frame.width/6, y: frame.midY), sprite: "YellowBall")
        // ------------------------------------------------------------------------
        
        // adicionando todas as plataformas como childs da cena
        for i in platforms {
            addChild(i)
        }
    }
    
    func setupPlayer(){
        //Creates player and adds it to the scene
        player = Player(sprite: "MagoFrente")
        addChild(player.sprite)
    }
}
