//
//  TemporizadorViewController.swift
//  tareaClase10Curso
//
//  Created by sebas  on 3/01/23.
//

import UIKit
import AVFoundation

class TemporizadorViewController: UIViewController {
    
    private struct Constantes {
        static let mensajeError = "ERROR"
        static let extensionDeSonidos = "mp3"
    }
    
    @IBOutlet weak var tiempoDeEsperaLabel: UILabel!
    @IBOutlet weak var tiempoDeEsperaBarraDeProgreso: UIProgressView!
    
    public var tiempoDeEspera: Int?
    private var momentoActual = 0
    private var temporizador: Timer?
    private var reproductor: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actualizacionDeLaVista()
        iniciarTemporizador()
    }
    
    private func actualizacionDeLaVista() {
        actualizacionTiempoDeEsperaLabel()
        actualizacionBarraDeProgreso()
    }
    
    private func actualizacionTiempoDeEsperaLabel() {
        tiempoDeEsperaLabel.text = obtenerTextoDeTiempoDeEspera()
    }
    
    private func obtenerTextoDeTiempoDeEspera() -> String {
        guard let tiempoDeEspera = tiempoDeEspera else {
            return Constantes.mensajeError
        }
        let segundosRestantes = Float(tiempoDeEspera - momentoActual)
        
        let minutos = Int(segundosRestantes / 60.0)
        let segundos = Int(segundosRestantes) - minutos * 60
        
        return convertirATexto(minutos: minutos, segundos: segundos)
    }
    
    private func convertirATexto(minutos: Int, segundos: Int) -> String {
        let minutosAString = "\(minutos)"
        let segundosAString = "\(segundos < 10 ? "0" : "") \(segundos)"
        return "\(minutosAString):\(segundosAString)"
    }
    
    private func actualizacionBarraDeProgreso() {
        tiempoDeEsperaBarraDeProgreso.progress = obtenerProgreso()
    }
    
    private func obtenerProgreso() -> Float {
        guard let tiempoDeEspera = tiempoDeEspera else {
            return 0.0
        }
        return Float(momentoActual) / Float(tiempoDeEspera)
    }
    
    private func iniciarTemporizador() {
        temporizador = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(procesoTick),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func procesoTick() {
        guard let tiempoDeEspera = tiempoDeEspera else {
            return
        }
        momentoActual += 1
        
        actualizacionDeLaVista()
        
        if momentoActual >= tiempoDeEspera {
            generarHaptic()
            reproducirSonido()
            temporizador?.invalidate()
            temporizador = nil
        }
    }
    
    private func generarHaptic() {
        let generador = UINotificationFeedbackGenerator()
        generador.notificationOccurred(.success)
    }
    
    private func reproducirSonido() {
        let url = Bundle.main.url(forResource: "sonidoSuperMario", withExtension: Constantes.extensionDeSonidos)
        reproductor = try? AVAudioPlayer(contentsOf: url!)
        reproductor?.play()
    }
}
