package ar.edu.telefonia.domain

import java.math.BigDecimal
import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
class Factura {
  	private Long id
	private Date fecha
	private BigDecimal totalPagado
	private BigDecimal total

	/** Constructor que necesita Hibernate */	
	new() {
		
	}
	
	new(Date unaFecha, int elTotalPagado, int elTotal) {
	  fecha = unaFecha
	  totalPagado = new BigDecimal(elTotalPagado)
	  total = new BigDecimal(elTotal)
	}

	def saldo() { 
		total.subtract(totalPagado).abs
	}
	
}