package ar.edu.telefonia.home

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import java.util.ArrayList
import java.util.List

class HomeTelefonia {

	List<Abonado> abonados
	
	private static HomeTelefonia instance = null
	
	private new() {
		abonados = new ArrayList<Abonado>
	}
	
	static def getInstance() {
		if (instance == null) {
			instance = new HomeTelefonia
		}
		instance
	}
	
	def doGetAbonado(Abonado abonado) {
		abonados.findFirst [ it.nombre.equalsIgnoreCase(abonado.nombre)]
	}

	/** Genero una copia del objeto para no actualizar el que referencia el home **/
	def getAbonado(Abonado abonado) {
		val result = doGetAbonado(abonado)
		if (result == null) {
			null
		} else {
			result.copy
		} 
	}

	/** Genero una copia de los objetos para no actualizar el que referencia el home **/
	def List<Abonado> getAbonados(BusquedaAbonados busquedaAbonados) {
		val copiaDeAbonados = abonados.map [ it.copy ]
		val abonadosFiltrados = copiaDeAbonados.filter [ busquedaAbonados.cumple(it) ].toList
		abonadosFiltrados.toList
	}

	def actualizarAbonado(Abonado abonado) {
		abonado.validar
		if (abonado.id == null) {
			// es un alta
			abonado.id = abonados.fold(0l, [ max, unAbonado | Math.max(max, unAbonado.id) ]) + 1
			abonados.add(abonado)
		} else {
			// es una modificación
			var abonadoPosta = doGetAbonado(abonado)
			abonadoPosta = abonado
		}
	}
	
	def eliminarAbonado(Abonado abonado) {
		abonados.remove(doGetAbonado(abonado))
	}

}
