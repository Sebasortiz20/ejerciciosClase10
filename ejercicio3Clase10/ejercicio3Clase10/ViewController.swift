//
//  ViewController.swift
//  ejercicio3Clase10
//
//  Created by sebas  on 4/01/23.
//

/* que voy a necesitar:
 - pantalla de preguntas
 - alerta fin del juego y resultado
 - objeto de respuesta
 - objeto de pregunta
 - sonido y vibracion de correcto
 - sonido y vibracion de incorrecto
 - barra de progreso
 - indicador de progreso 1/10
 - acumula (contador)
 - validar siempre y cuando el usario diga si o no
 - */

import UIKit
import AVFoundation

private struct Pregunta {
    let texto: String
    let respuesta: Bool
}

class ViewController: UIViewController {
    
    private struct Constantes {
        static let tituloDelBotonDeLaAlerta = "Reintetar"
        static let tituloDeLaAlerta = "Su Puntaje Obtenido Fue: "
        static let mensajeDeLaAlerta = "0"
        static let sobreElTotalDePreguntas = "/ 10"
        static let extensionDeSonido = "caf"
    }
    
    private let listaDePreguntas = [
        Pregunta(texto: "China es el país más grande del mundo", respuesta: false),
        Pregunta(texto: "La caja negra de un avión es negra", respuesta: false),
        Pregunta(texto: "Venus es el planeta más cercano al sol", respuesta: false),
        Pregunta(texto: "Mónaco es el país más pequeño del mundo", respuesta: false),
        Pregunta(texto: "Alemania es la selección que más veces ha ganado un Mundial", respuesta: false),
        Pregunta(texto: "La pizza se inventó en Napoles", respuesta: true),
        Pregunta(texto: "El primer hombre en viajar al espacio era Ruso", respuesta: true),
        Pregunta(texto: "El rascacielos más alto del mundo está en Nueva York", respuesta: false),
        Pregunta(texto: "El río más largo del mundo es el Amazonas", respuesta: true),
        Pregunta(texto: "El café se descubrió en Colombia", respuesta: false),
    ]
    
    @IBOutlet weak var noBotonOutlet: UIButton!
    @IBOutlet weak var siBotonOutlet: UIButton!
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var progresoLabel: UILabel!
    @IBOutlet weak var preguntasPorResponderProgressVIew: UIProgressView!
    
    private var indiceDeLaPreguntaActual = 0
    private var puntaje = 0
    private var alertaFinal: UIAlertController?
    private var accionReintentar: UIAlertAction?
    private var reproductorDeSonido: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentarPregunta()
        presentarBarraDeProgreso()
        presentarNumeroDePreguntaEnElLabel()
        crearAlerta()
    }
    
    private func presentarPregunta() {
        let textoDeLaPregunta = obtenerTextoDeLaPregunta()
        preguntaLabel.text = textoDeLaPregunta
    }
    
    private func obtenerTextoDeLaPregunta() -> String {
        let textoDeLaPregunta = listaDePreguntas[indiceDeLaPreguntaActual].texto
        return textoDeLaPregunta
    }
    
    private func presentarBarraDeProgreso() {
        let progreso = obtenerBarraDeProgreso()
        preguntasPorResponderProgressVIew.progress = progreso
    }
    
    private func obtenerBarraDeProgreso() -> Float {
        let progreso = Float(indiceDeLaPreguntaActual + 1) / Float(listaDePreguntas.count)
        return progreso
    }
    
    private func presentarNumeroDePreguntaEnElLabel() {
        let numero = obtenerNumeroDePregunta()
        progresoLabel.text = "\(numero - indiceDeLaPreguntaActual) \(Constantes.sobreElTotalDePreguntas)"
    }
    
    private func obtenerNumeroDePregunta() -> Int{
        let pregunta = listaDePreguntas.count
        return pregunta
    }
    
    private func crearAlerta() {
        alertaFinal = UIAlertController(title: Constantes.tituloDeLaAlerta, message: Constantes.mensajeDeLaAlerta, preferredStyle: .alert)
        accionReintentar = UIAlertAction(title: Constantes.tituloDelBotonDeLaAlerta, style: .default, handler: { _ in
            self.indiceDeLaPreguntaActual = 0
            self.puntaje = 0
        })
        if let alertaSegura = alertaFinal, let okAccionSegura = accionReintentar  {
            alertaSegura.addAction(okAccionSegura)
        }
    }
    
    @IBAction func accionAlPresionarElBotonSi(_ sender: UIButton) {
        revisarRespuesta(respuestaDelUsuario: true)
        pasarALaSiguientePregunta()
        tratarDeMostrarAlertaUltimaPregunta()
    }
    
    @IBAction func accionAlPresionarElBotonNo(_ sender: UIButton) {
        revisarRespuesta(respuestaDelUsuario: false)
        pasarALaSiguientePregunta()
        tratarDeMostrarAlertaUltimaPregunta()
    }
    
    private func revisarRespuesta(respuestaDelUsuario: Bool) {
        let respuestaCorrecta = listaDePreguntas[indiceDeLaPreguntaActual].respuesta
        if respuestaDelUsuario == respuestaCorrecta {
            puntaje += 1
            ejercutarAccionCorrecto()
        } else {
            ejecutarAccionIncorrecto()
        }
    }
    
    private func ejercutarAccionCorrecto() {
        crearVibracionCorrecto()
        crearSonidoDeCorrecto()
    }
    
    private func crearVibracionCorrecto() {
        let generador = UINotificationFeedbackGenerator()
        generador.notificationOccurred(.success)
    }
    
    private func crearSonidoDeCorrecto() {
        let url = Bundle.main.url(forResource: "correcto", withExtension: Constantes.extensionDeSonido)
        reproductorDeSonido = try? AVAudioPlayer(contentsOf: url!)
        reproductorDeSonido?.play()
    }
    
    private func ejecutarAccionIncorrecto() {
        crearVibracionIncorrecto()
        crearSonidoDeIncorrecto()
    }
    
    private func crearVibracionIncorrecto() {
        let generador = UINotificationFeedbackGenerator()
        generador.notificationOccurred(.error)
    }
    
    private func crearSonidoDeIncorrecto() {
        let url = Bundle.main.url(forResource: "incorrecto", withExtension: Constantes.extensionDeSonido)
        reproductorDeSonido = try? AVAudioPlayer(contentsOf: url!)
        reproductorDeSonido?.play()
    }
    
    private func pasarALaSiguientePregunta() {
        indiceDeLaPreguntaActual += 1
    }
    
    private func tratarDeMostrarAlertaUltimaPregunta(){
        let seObtuvoUltimaPregunta = revisarUbicacionDeLaPregunta()
        if seObtuvoUltimaPregunta {
            actualizarAlerta()
            presentarAlerta()
        } else {
            presentarPregunta()
            presentarBarraDeProgreso()
            presentarNumeroDePreguntaEnElLabel()
        }
    }
    
    private func revisarUbicacionDeLaPregunta() -> Bool {
        let numeroTotalDePreguntas = obtenerNumeroDePregunta()
        if indiceDeLaPreguntaActual < numeroTotalDePreguntas {
            return false
        } else {
            return true
        }
    }
    
    private func actualizarAlerta() {
        guard let alertaFinalSegura = alertaFinal else {
            return
        }
        alertaFinalSegura.message = String(obtenerPuntaje())
    }
    
    private func obtenerPuntaje() -> Int {
        return puntaje
    }
    
    private func presentarAlerta() {
        if let alertaFinalSegura = alertaFinal {
            present(alertaFinalSegura, animated: true)
        }
    }
}
