//
//  ViewController.swift
//  MLApp
//
//  Created by Cesar Vargas on 07/09/21.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var dataImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var takePickBtn: UIButton!
    @IBOutlet weak var galleryBtn: UIButton!
    
    //Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detectarImagenes()
    }
    
    //IBActions
    @IBAction func takePicBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func galleryBtnTapped(_ sender: Any) {
        
    }
    
    //Functions
    func detectarImagenes() {
        
        dataLabel.text = "Cargando..."
        
        
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else {
            print("Ocurrio un error al cargar el modelo")
            return
        }
        
        let peticion = VNCoreMLRequest(model: model) { request, error in
            
            guard let resultados = request.results as? [VNClassificationObservation],
                  let primerResultado = resultados.first else {
                
                print("No se encontraron resultados")
                return
            }
            
            DispatchQueue.main.async {
                self.dataLabel.text = "\(primerResultado.identifier)"
            }
        }
        
        
        guard let ciimage = CIImage(image: self.dataImageView.image!) else {
            print("No se ha podido crear la imagen CIImage a partir del UIImage")
            return
        }
        
        //Correr Petición
        let handler = VNImageRequestHandler(ciImage: ciimage)
        
        DispatchQueue.global().async {
            
            do {
                try handler.perform([peticion])
            }catch {
                
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    //System Functions


}

