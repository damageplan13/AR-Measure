//
//  ViewController.swift
//  AR Measure
//
//  Created by Shwait Kumar on 13/06/18.
//  Copyright © 2018 Shwait Kumar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView){
            
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first{
                
                addDot(at : hitResult)
                
            }
            
        }
        
    }
    
    func addDot(at hitResult : ARHitTestResult){
        
        let dotGeometry = SCNSphere()
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.white
        
        dotGeometry.materials = [material]
        
        dotGeometry.radius = 0.005
        
        let dotNode = SCNNode()
        
        dotNode.geometry = dotGeometry
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2{
            
            calculate()
            
        }
        
    }
    
    func calculate(){
        
        let startPoint = dotNodes[0]
        let endPoint = dotNodes[1]
        
        print(startPoint.position)
        print(endPoint.position)
        
        let a = endPoint.position.x - startPoint.position.x
        let b = endPoint.position.y - startPoint.position.y
        let c = endPoint.position.z - startPoint.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2)) * 100
        
        
        updateText(text: "\(distance)", atPosition : endPoint.position)
        
    }
    
    func updateText (text : String, atPosition position : SCNVector3){
        
        let textGeometry = SCNText(string: text, extrusionDepth: 0.5)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01) //scale down to 1% if text is too big
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    

}
