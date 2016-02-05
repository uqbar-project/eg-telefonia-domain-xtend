package ar.edu.telefonia.repo

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import ar.edu.telefonia.domain.Empresa
import ar.edu.telefonia.domain.Residencial
import ar.edu.telefonia.domain.Rural
import java.util.List

class RepoTelefonia {

	List<Abonado> abonados
	
	private static RepoTelefonia instance = null
	
	private new() {
		abonados = newArrayList
		createIfNotExists(createResidencial("RE10204", "Claudio Masferrer"))
		createIfNotExists(createResidencial("RE01558", "Sonia Guzman"))
		createIfNotExists(createRural("RU219BA", "Joaquin Bartomeo", 300).facturar(540))
		createIfNotExists(createEmpresa("EM7762NA", "Rivara SA", "30-60119164-0").facturar(1200)) 
	}
	
	static def getInstance() {
		if (instance == null) {
			instance = new RepoTelefonia
		}
		instance
	}
	
	def doGetAbonado(Abonado abonado) {
		abonados.findFirst [ it.nombre.equalsIgnoreCase(abonado.nombre)]
	}

	/** Genero una copia del objeto para no actualizar el que referencia el repo **/
	def getAbonado(Abonado abonado) {
		val result = doGetAbonado(abonado)
		if (result == null) {
			null
		} else {
			result.copy
		} 
	}

	/** Genero una copia de los objetos para no actualizar el que referencia el repo **/
	def List<Abonado> getAbonados(BusquedaAbonados busquedaAbonados) {
		val copiaDeAbonados = abonados.map [ it.copy ]
		val abonadosFiltrados = copiaDeAbonados.filter [ busquedaAbonados.cumple(it) ].toList
		abonadosFiltrados.toList
	}

	def actualizarAbonado(Abonado abonado) {
		abonado.validar
		if (abonado.id == null) {
			// es un alta
			val maxId = abonados.fold(0l, [ max, unAbonado | Math.max(max, unAbonado.id) ])
			abonado.id = maxId + 1
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

	/** ***********************************************
	 *  METODOS CREACIONALES
	 *  ***********************************************
	 */
	def createResidencial(String unNumero, String unNombre) {
		new Residencial => [
			numero = unNumero
			nombre = unNombre 
		]
	}

	def createRural(String unNumero, String unNombre, int cuantasHectareas) {
		new Rural => [
			numero = unNumero
			nombre = unNombre
			cantidadHectareas = cuantasHectareas 
		]
	}

	def createEmpresa(String unNumero, String unNombre, String unCuit) {
		new Empresa => [
			numero = unNumero
			nombre = unNombre
			cuit = unCuit 
		]
	}

	def createIfNotExists(Abonado abonado) {
		val existe = this.getAbonado(abonado) != null
		if (!existe) {
			this.actualizarAbonado(abonado)
		}
		existe
	}

}
