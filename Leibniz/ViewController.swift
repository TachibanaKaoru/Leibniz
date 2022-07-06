//
//  ViewController.swift
//  Leibniz
//
//  Created by Kaoru Tachibana on 2022/07/06.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // デバッグ用の軸表示
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        //あまり多いと表示できません。
        addCoordinatePoints(from: -10, to: 10, stride: 0.2)

        //さわると音がしたり、色が変わったりしてもいいなー。あにめーしょんとか。
        //でもそーいう処理はあっちのほうがやりやすそう。
        //とりあえず、ノードの大きさとstride（間隔）はかえられたほうがいいよね。
        //ノードを押して直線を引きたい。
        //あと、数字をカメラに合わせて回転させたい
        //カメラのまわり、というかみえるほうこうだけ表示したい
        //(ARなので)見えない部分は空間点が見えなくていいと思う。

        addVector()

        addSampleText()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    private func addCoordinatePoints(from: Int = -10, to: Int = 10, stride: Double = 0.1) {

        for xValue in from...to{

            for yValue in from...to{

                for zValue in from...to{

                    let x = Double(xValue) * stride
                    let y = Double(yValue) * stride
                    let z = Double(zValue) * stride
                    addCoordinatePoint(x: x, y: y, z: z)

                }
            }
        }
    }

    private func addCoordinatePoint(x: CGFloat, y: CGFloat, z: CGFloat){

        let sphere1: SCNSphere = SCNSphere.init(radius: 0.01)
        let sphereNode = SCNNode(geometry: sphere1)
        sphereNode.position = SCNVector3(x, y, z)

        let material1 = SCNMaterial()
        material1.diffuse.contents = UIColor.blue
        material1.isDoubleSided = true
        material1.lightingModel = .physicallyBased //よい！
        sphereNode.geometry?.firstMaterial = material1

        let strX = String(format: "%.1f",x)
        let strY = String(format: "%.1f",x)
        let strZ = String(format: "%.1f",x)

        let posText = SCNText(string: "x:\(strX) y:\(strY) z:\(strZ)", extrusionDepth: 0.01)
        posText.font = UIFont.systemFont(ofSize: 1.0)


        posText.containerFrame = CGRect(x: -5.0, y: 0.0, width: 20.0, height: 1.5)//このくらい……
//        posText.containerFrame = CGRect(x: -0.0, y: 0.0, width: 20.0, height: 1.5)//これだとみぎによりすぎ
//        posText.containerFrame = CGRect(x: -10.0, y: 0.0, width: 20.0, height: 1.5)//これだとひだりによりすぎ
        //alignmentModeはまったく効いてない。

//        posText.isWrapped = false
        posText.truncationMode = CATextLayerTruncationMode.middle.rawValue
        posText.alignmentMode = CATextLayerAlignmentMode.center.rawValue

        let textNode = SCNNode(geometry: posText)

        textNode.position = SCNVector3(x: 0.0, y: 0.005, z: 0.0)
        textNode.scale = SCNVector3(0.01,0.01,0.01)

        let material3 = SCNMaterial()
        material3.diffuse.contents = UIColor.darkGray
        material3.lightingModel = .physicallyBased

        textNode.geometry?.firstMaterial = material3
        sphereNode.addChildNode(textNode)

        sceneView.scene.rootNode.addChildNode(sphereNode)

    }

    private func addVector() {

        let jiku = SCNCapsule(capRadius: 0.01, height: 0.2)
        let jikuNode = SCNNode(geometry: jiku)
        jikuNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)

        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.red
        material2.isDoubleSided = true
        material2.lightingModel = .physicallyBased
        jikuNode.geometry?.firstMaterial = material2

        let vectorTop = SCNCone(topRadius: 0.0, bottomRadius: 0.02, height: 0.05)
        let vectorTopNode = SCNNode(geometry: vectorTop)
        vectorTopNode.geometry?.firstMaterial = material2
        vectorTopNode.position = SCNVector3(x: 0, y: 0.10, z: 0)
        jikuNode.addChildNode(vectorTopNode)

        sceneView.scene.rootNode.addChildNode(jikuNode)

    }

    private func addSampleText() {

        let posText = SCNText(string: "Hello", extrusionDepth: 0.01)
        posText.font = UIFont.systemFont(ofSize: 1.0)

        let textNode = SCNNode(geometry: posText)
        textNode.position = SCNVector3(x: 0.1, y: 0.2, z: -0.3)
        textNode.scale = SCNVector3(0.03,0.03,0.03)

        let material3 = SCNMaterial()
        material3.diffuse.contents = UIColor.black
        material3.isDoubleSided = true
        material3.lightingModel = .physicallyBased

        textNode.geometry?.firstMaterial = material3
        sceneView.scene.rootNode.addChildNode(textNode)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
