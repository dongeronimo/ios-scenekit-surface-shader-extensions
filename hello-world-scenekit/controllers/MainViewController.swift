import UIKit
import QuartzCore
import SceneKit

class MainViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var objectName: UILabel!
    var scale:Float = 12.0;
    
    //Desenha umas faixas pretas no surface. Copiado dos exemplos.
    let surfaceShaderExtensionStripes = """
            uniform float Scale = 12.0;
            uniform float Width = 0.25;
            uniform float Blend = 0.3;
            
            vec2 position = fract(_surface.diffuseTexcoord * Scale);
            float f1 = clamp(position.y / Blend, 0.0, 1.0);
            float f2 = clamp((position.y - Width) / Blend, 0.0, 1.0);
            f1 = f1 * (1.0 - f2);
            f1 = f1 * f1 * 2.0 * (3. * 2. * f1);
            _surface.diffuse = mix(vec4(1.0), vec4(0.0), f1);
        """
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene();
    }
    //Modifies the scale uniform in surfaceShaderExtensionStripes
    @IBAction func onScaleChangeTouch(_ sender: UIButton) {
        //the experiment box
        let shaderExtensionBox: SCNNode = sceneView.scene!.rootNode.childNode(withName: "shader extension box", recursively: true)!
        shaderExtensionBox.geometry!.setValue(scale, forKey: "Scale")//.shaderModifiers = [.surface: surfaceShaderExtensionStripes]
        scale -= 1.0;
    }
    private func setupScene(){
        //Pega a cena - Os SCNScenes são objetos que contêm as cenas do SceneKit e tem uma estrutura
        //de nós.
        guard let myScene = SCNScene(named: "art.scnassets/first_scene.scn")
            else {fatalError("Unable to load scene")}
        sceneView.scene = myScene
        sceneView.backgroundColor = UIColor.black
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        useCustomShaderProgram(myScene: myScene)
        useShaderExtensions(myScene: myScene)
    }
    
    private func useCustomShaderProgram(myScene: SCNScene){
        //Search for the shaderBox
        let shaderBox: SCNNode = myScene.rootNode.childNode(withName: "shader box", recursively: true)!
        let program: SCNProgram = SCNProgram()//Instancia o objeto de programa
        program.fragmentFunctionName = "myFragment"
        program.vertexFunctionName = "myVertex"
        
        shaderBox.geometry!.firstMaterial?.program = program//Passa pro shaderBox
    }
    //In this method I pass the surfaceExtensionCode to "shader extension box".
    private func useShaderExtensions(myScene: SCNScene){
        //the experiment box
        let shaderExtensionBox: SCNNode = myScene.rootNode.childNode(withName: "shader extension box", recursively: true)!
        shaderExtensionBox.geometry!.shaderModifiers = [.surface: surfaceShaderExtensionStripes]
    }
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let p = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        if (hitResults.count > 0 ){
            let result = hitResults[0]
            let node = result.node
            objectName.text = node.name
//            if(node.name == "shader box" || node.name=="shader extension box"){
//            }
//            else{
//                changeDiffuseToRandomColor(node: node)
//            }
        }
    }
    ///Sets the diffuse channel to some random color, changing from the old color to the
    ///new color in a half second.
    private func changeDiffuseToRandomColor(node: SCNNode){
        let material = node.geometry!.firstMaterial!//Pega o material
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        material.diffuse.contents = UIColor(displayP3Red: CGFloat(Double.random),
                                            green: CGFloat(Double.random),
                                            blue: CGFloat(Double.random),
                                            alpha:  1.0)
        SCNTransaction.commit()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
