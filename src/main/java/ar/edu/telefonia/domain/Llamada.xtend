package ar.edu.telefonia.domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
class Llamada {
	Long id
	Abonado origen
	Abonado destino
	Integer duracion

	new() {
		origen = null
		destino = null
		duracion = new Integer(0)
	}
	
	new(Abonado unOrigen, Abonado unDestino, Integer unaDuracion) {
		origen = unOrigen
		destino = unDestino
		duracion = unaDuracion
	}
	
}
