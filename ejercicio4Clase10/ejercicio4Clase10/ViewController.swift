//
//  ViewController.swift
//  ejercicio4Clase10
//
//  Created by sebas  on 11/01/23.
//

/* REQUISITOS
 - APLICACION EN BLANCO
 - BOTON OCULTO MITAD DE LA PANTALLA
 - VARIABLE N ME INDICA EN QUE MOMENTO CARGA LA APP (NUMERO ALEATORIO 3-10
 - LUEGO DE APARECER SE ESCONDE A LOS 0.2 SEG
 - SI ALCANZA A PRECIONAR BOTON GENERE ALERTA (FELICITACIONES)
 - SI NO ALERTA PERDIO
 - AMBOS CASOS JUEGO VUELVE A EMPEZAR
 - PARTE SUPERIOR DE LA PANTALLA ( JUEGOS TOTALES, JUEGOS GANADOS, JUEGOS PERDIDOS )
 */

import UIKit

class ViewController: UIViewController {
    
    struct Constantes {
        static let tituloDeLaAlertaFelicitaciones = "Felicitaciones"
        static let cuerpoDeLaAlertaFelicitaciones = "Presionaste el boton a tiempo!"
        static let tituloDeLaAlertaFallaste = "Fallaste"
        static let cuerpoDeLaAlertaFallaste = "No lograste presionar el boton a tiempo"
        static let tituloDelBotonDeLaAlertaFelicitaciones = "Ok"
        static let tituloDelBotonDeLaAlertaFallaste = "Reintentar"
    }
    
    private var alertaFelicitaciones: UIAlertController?
    private var alertaFallaste: UIAlertController?
    private var accionok: UIAlertAction?
    private var accionReintentar: UIAlertAction?
    private var temporizador: Timer?
    private var juegosTotales = 0
    private var juegosGanados = 0
    private var juegosPerdidos = 0
    
    @IBOutlet weak var juegosGanadosLabel: UILabel!
    @IBOutlet weak var presionameBotonOutlet: UIButton!
    @IBOutlet weak var juegosTotalesLabel: UILabel!
    @IBOutlet weak var juegosPerdidosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crearAlertaFelicitaciones()
        crearAlertaFallaste()
        jugar()
    }
    
    private func crearAlertaFelicitaciones() {
        alertaFelicitaciones = UIAlertController(title: Constantes.tituloDeLaAlertaFelicitaciones, message: Constantes.cuerpoDeLaAlertaFelicitaciones , preferredStyle: .alert)
        accionok = UIAlertAction(title: Constantes.tituloDelBotonDeLaAlertaFelicitaciones, style: .default, handler: { _ in
            self.self.jugar()
        })
        if let alertaSegura = alertaFelicitaciones, let okAccionSegura = accionok  {
            alertaSegura.addAction(okAccionSegura)
        }
    }
    
    private func crearAlertaFallaste() {
        alertaFallaste = UIAlertController(title: Constantes.tituloDeLaAlertaFallaste, message: Constantes.cuerpoDeLaAlertaFallaste , preferredStyle: .alert)
        accionReintentar = UIAlertAction(title: Constantes.tituloDelBotonDeLaAlertaFallaste, style: .default, handler: { _ in
            self.jugar()
        })
        if let alertaSegura = alertaFallaste, let reintentarAccionSegura = accionReintentar  {
            alertaSegura.addAction(reintentarAccionSegura)
        }
    }
    
    private func jugar () {
        ocultarBotonPresioname()
        iniciarTemporizadorParaMostrarBoton()
    }
    
    private func ocultarBotonPresioname() {
        presionameBotonOutlet.isHidden = true
    }
    
    private func iniciarTemporizadorParaMostrarBoton() {
        temporizador = Timer.scheduledTimer(withTimeInterval: TimeInterval(generarNumeroAleatorio()), repeats: false, block: { _ in
            self.mostrarBotonPresioname()
            self.sumarUnoAJuegosJugados()
            self.anularTimer()
            self.pararTemporizadorParaEsconderBoton()
        })
    }
    
    private func generarNumeroAleatorio() -> Int{
        return Int.random(in: 0 ... 7)
    }
    
    private func mostrarBotonPresioname() {
        presionameBotonOutlet.isHidden = false
    }
    
    private func sumarUnoAJuegosJugados() {
        juegosTotales += 1
    }
    
    private func anularTimer() {
        guard let temporizador = temporizador else {
            return
        }
        temporizador.invalidate()
    }
    
    private func pararTemporizadorParaEsconderBoton() {
        temporizador = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            self.ocultarBotonPresioname()
            self.sumarUnoAJuegosPerdidos()
            self.presentarAlertaFallaste()
            self.actualizarContadoresLabel()
        })
    }
    
    private func sumarUnoAJuegosPerdidos() {
        juegosPerdidos += 1
    }
    
    private func presentarAlertaFallaste() {
        if let alertaSegura = alertaFallaste {
            present(alertaSegura, animated: true)
        }
    }
    
    private func actualizarContadoresLabel() {
        presentarJuegosTotalesEnElLabel()
        presentarJuegosGanadosEnElLabel()
        presentarJuegosPerdidosEnElLabel()
    }
    
    private func presentarJuegosTotalesEnElLabel() {
        let juegosTotales = obtenerTextoJuegosTotales()
        juegosTotalesLabel.text = juegosTotales
    }
    
    private func obtenerTextoJuegosTotales() -> String {
        let textoDeJuegosTotales = "\(juegosTotales)"
        return textoDeJuegosTotales
    }
    
    private func presentarJuegosGanadosEnElLabel() {
        let juegosGanados = obtenerTextoJuegosGanados()
        juegosGanadosLabel.text = juegosGanados
    }
    
    private func obtenerTextoJuegosGanados() -> String {
        let textoDeJuegosGanados = "\(juegosGanados)"
        return textoDeJuegosGanados
    }
    
    private func presentarJuegosPerdidosEnElLabel() {
        let juegosPerdidos = obtenerTextoJuegosPerdidos()
        juegosPerdidosLabel.text = juegosPerdidos
    }
    
    private func obtenerTextoJuegosPerdidos() -> String {
        let textoJuegosPerdidos = "\(juegosPerdidos)"
        return textoJuegosPerdidos
    }
    
    @IBAction func accionAlTocarBotonPresioname(_ sender: UIButton) {
        sumarUnoAJuegosGanados()
        actualizarContadoresLabel()
        presentarAlertaFelicitaciones()
        anularTimer()
    }
    
    private func sumarUnoAJuegosGanados() {
        juegosGanados += 1
    }
    
    private func presentarAlertaFelicitaciones() {
        if let alertaSegura = alertaFelicitaciones {
            present(alertaSegura, animated: true)
        }
    }
}
