package ar.edu.telefonia.repo

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import ar.edu.telefonia.domain.Empresa
import ar.edu.telefonia.domain.Factura
import ar.edu.telefonia.domain.Llamada
import ar.edu.telefonia.domain.Residencial
import ar.edu.telefonia.domain.Rural
import java.util.Date
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestRepoTelefonia {

	Abonado walterWhite
	Abonado jessePinkman
	RepoTelefonia repoTelefonia 
	Llamada llamada1 = new Llamada(walterWhite, jessePinkman, 10)

	@Before
	def void init() {
		repoTelefonia = RepoTelefonia.instance
		
		walterWhite = new Residencial => [
			nombre = "Walter White"
			numero = "46710080"
			agregarFactura(new Factura(new Date(10, 1, 109), 500, 740))
			agregarFactura(new Factura(new Date(10, 1, 111), 1200, 1800))
		]

		jessePinkman = new Rural(100) => [
			nombre = "Jesse Pinkman"
			numero = "45673887"
			agregarFactura(new Factura(new Date(5, 5, 113), 1200, 1200))
		]

		var Abonado ibm = new Empresa("30-50396126-8") => [
			nombre = "IBM"
			numero = "47609272"
		]

		repoTelefonia.createIfNotExists(jessePinkman)
		val existeIBM = repoTelefonia.createIfNotExists(ibm)
		val existeWalterWhite = repoTelefonia.createIfNotExists(walterWhite)

		jessePinkman = repoTelefonia.getAbonado(jessePinkman)
		ibm = repoTelefonia.getAbonado(ibm)
		walterWhite = repoTelefonia.getAbonado(walterWhite)

		// El update lo tenemos que hacer por separado por las referencias circulares
		if (!existeWalterWhite) {
			var Llamada llamada2 = new Llamada(walterWhite, ibm, 2)
			walterWhite.agregarLlamada(llamada1)
			walterWhite.agregarLlamada(llamada2)
			repoTelefonia.actualizarAbonado(walterWhite)
		}

		if (!existeIBM) {
			ibm.agregarLlamada(new Llamada(ibm, jessePinkman, 5))
			repoTelefonia.actualizarAbonado(ibm)
		}
	}

	@Test
	def void walterWhiteTiene2Llamadas() {
		var walterWhiteBD = repoTelefonia.getAbonado(walterWhite)
		var llamadasDeWalterWhite = walterWhiteBD.llamadas
		Assert.assertEquals(2, llamadasDeWalterWhite.size)
	}

	@Test
	def void deudaDeWalterWhite() {
		val walterWhiteBD = repoTelefonia.getAbonado(walterWhite)
		Assert.assertEquals(840, walterWhiteBD.deuda, 0.1)
	}

	@Test
	def void walterWhiteCostoDeLlamada1() {
		val walterWhiteBD = repoTelefonia.getAbonado(walterWhite)
		Assert.assertEquals(20, walterWhiteBD.costo(llamada1), 0.1)
	}

	@Test
	def void walterWhiteSaleEnLaListaDeMorosos() {
		val result = repoTelefonia.getAbonados(buildBusquedaSoloMorosos).map [ it.id ]
		val idWalterWhite = repoTelefonia.getAbonado(walterWhite).id
		Assert.assertTrue(result.contains(idWalterWhite))
	}

	@Test
	def void jessePinkmanNoSaleEnLaListaDeMorosos() {
		val busquedaAbonados = buildBusquedaSoloMorosos()
		val result = repoTelefonia.getAbonados(busquedaAbonados)
		val jessePinkmanBD = repoTelefonia.getAbonado(jessePinkman)
		Assert.assertFalse(result.contains(jessePinkmanBD))
	}
	
	def buildBusquedaSoloMorosos() {
		val busquedaAbonados = new BusquedaAbonados => [
			soloMorosos = true
		]
		busquedaAbonados
	}

}
