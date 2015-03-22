package ar.edu.telefonia.domain

import java.beans.Transient
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
abstract class Abonado implements Cloneable {
	private Long id
	private String nombre
	private String numero
	private List<Factura> facturas
	private List<Llamada> llamadas

	new() {
		facturas = new ArrayList<Factura>
		llamadas = new ArrayList<Llamada>
	}

	def copy() {
		super.clone as Abonado
	}

	abstract def float costo(Llamada llamada)

	def esMoroso() {
		deuda > 0
	}

	def deuda() {
		facturas.fold(0.0, [acum, factura|acum + factura.saldo.floatValue])
	}

	def agregarLlamada(Llamada llamada) {
		llamadas.add(llamada)
	}

	def agregarFactura(Factura factura) {
		facturas.add(factura)
	}
	
	@Transient
	abstract def String getDatosEspecificos()

	def void validar() {
		if (numero == null) {
			throw new UserException("Debe ingresar número")
		}
		if (nombre == null) {
			throw new UserException("Debe ingresar nombre")
		}	
	}
	
	/**
	 *************************************************************************
	 *  EXTENSION METHODS
	 *************************************************************************
	 */
	def max(Integer integer, Integer integer2) {
		if(integer > integer2) integer else integer2
	}

	def min(Integer integer, Integer integer2) {
		max(integer2, integer)
	}

}

class Residencial extends Abonado {

	override def costo(Llamada llamada) {
		2 * llamada.duracion
	}
	
	@Transient
	override getDatosEspecificos() {
		"Residencial"
	}

}

class Rural extends Abonado {

	private Integer cantidadHectareas

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */

	def getCantidadHectareas() {
		cantidadHectareas
	}

	def void setCantidadHectareas(Integer unaCantidadHectareas) {
		cantidadHectareas = unaCantidadHectareas
	}
	
	/** Constructor que necesita Hibernate */	
	new() {
		
	}

	/**
	 * ***********************************************************
	 *        FIN EXTRAS MANUALES QUE NECESITA HIBERNATE         *
	 *************************************************************
	 */
	new(Integer unaCantidadHectareas) {
		cantidadHectareas = unaCantidadHectareas
	}

	override def costo(Llamada llamada) {
		3 * llamada.duracion.max(new Integer(5))
	}

	@Transient
	override getDatosEspecificos() {
		"Rural (" + cantidadHectareas + " has)"
	}
}

class Empresa extends Abonado {

	String cuit

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */

	def getCuit() {
		cuit
	}

	def void setCuit(String unCuit) {
		cuit = unCuit
	}

	/** Constructor que necesita Hibernate */
	new() {
		
	}
	
	/**
	 * ***********************************************************
	 *        FIN EXTRAS MANUALES QUE NECESITA HIBERNATE         *
	 *************************************************************
	 */

	@Transient
	override getDatosEspecificos() {
		"Empresa (" + cuit + ")"
	}	
	new(String unCuit) {
		cuit = unCuit
	}

	override def costo(Llamada llamada) {
		1 * llamada.duracion.min(3)
	}

	override def esMoroso() {
		facturas.size > 3
	}

}
