//
//  ViewController.swift
//  face-tracking-test
//
//  Created by 山田尚吾 on 2019/08/25.
//  Copyright © 2019 山田尚吾. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    private var faceGeometory: ARSCNFaceGeometry!
    private var faceNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard ARFaceTrackingConfiguration.isSupported else { return }
        guard let device = sceneView.device else { return }
        
        faceGeometory = ARSCNFaceGeometry(device: device)
        
        if let material = faceGeometory.firstMaterial {
            material.diffuse.contents = UIColor.white
            material.lightingModel = .physicallyBased
        }
        faceNode = SCNNode(geometry: faceGeometory)
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return  }
        faceGeometory.update(from: faceAnchor.geometry)
        node.addChildNode(faceNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return  }
        faceGeometory.update(from: faceAnchor.geometry)
    }
    
}
