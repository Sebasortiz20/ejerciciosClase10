//
//  ViewController.swift
//  tareaClase10Curso
//
//  Created by sebas  on 3/01/23.
//

import UIKit

class ConfiguracionViewController: UIViewController {
    
    private struct Constantes {
        static let identificadorDelSegue = "haciaTemporizador"
        static let tituloDelBotonDeLaAlerta = "Aceptar"
        static let tituloDeLaAlerta = "Ingrese"
        static let cuerpoDeLaAlerta = "Numero En el Campo De Texto"
    }
    
    private var alerta: UIAlertController?
    private var aceptarAccion: UIAlertAction?
    private var tiempo: String?
    
    @IBOutlet weak var tiempoDeEsperaCampoDeTexto: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let temporizadorViewController = segue.destination as? TemporizadorViewController else {
            return
        }
        guard let tiempoDeEsperaText = tiempoDeEsperaCampoDeTexto.text, let tiempoDeEspera = Int(tiempoDeEsperaText) else {
            return
        }
        
        temporizadorViewController.tiempoDeEspera = tiempoDeEspera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crearAlerta()
        configuracionAccionEnLaAlerta()
    }
    
    private func crearAlerta() {
        alerta = UIAlertController(title: Constantes.tituloDeLaAlerta, message: Constantes.cuerpoDeLaAlerta , preferredStyle: .alert)
    }
    
    private func configuracionAccionEnLaAlerta() {
        aceptarAccion = UIAlertAction(title: Constantes.tituloDelBotonDeLaAlerta, style: .default)
        if let alertaSegura = alerta, let okAccionSegura = aceptarAccion  {
            alertaSegura.addAction(okAccionSegura)
        }
    }
    
    @IBAction func alPulsarElBotonDeContinuar() {
        extraerTiempoDeEsperaCampoDeTexto()
        validarValorIngresadoEnElCampoDeTexto()
    }
    
    private func extraerTiempoDeEsperaCampoDeTexto() {
        tiempo = tiempoDeEsperaCampoDeTexto.text ?? ""
    }
    
    private func validarValorIngresadoEnElCampoDeTexto() {
        if let tiempoSeguro = tiempo {
            if tiempoSeguro.isEmpty {
                presentarAlerta()
            }else{
                navegarHaciaTimerViewController()
            }
        }
    }
    
    private func presentarAlerta() {
        if let alertaSegura = alerta {
            present(alertaSegura, animated: true)
        }
    }
    
    private func navegarHaciaTimerViewController() {
        performSegue(withIdentifier: Constantes.identificadorDelSegue, sender: self)
    }
}

