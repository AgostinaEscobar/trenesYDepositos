class Deposito {
  var formaciones= []
  const locomotoras= []

  // 10 Conjunto formado por el vagón más pesado de cada formación
  method saberVagonesMasPesados()= formaciones.filter{ formacion => formacion.vagonMasPesado()}
  // 11 Argumentar si un depósito necesita un conductor experimentado
  method necesitaConductorExperimentado(){
    if (formaciones.all{formacion => formacion.esCompleja()})
    return 'necesita conductor experimentado'
    else
    return 'no necesita conductor experimentado'
  }
  // 12 Agregar, dentro de un depósito, una locomotora a una formación determinada, de forma tal que la formación pueda moverse.
  method agregarLocomotora(formacion){
    if (formacion.puedeMoverse())
    return 'no necesita locomotora adicional'
    else
    {
      if (self.hayLocomotoraAdecuada(formacion)){
        formacion.add{self.locomotoraAdecuada(formacion)}
        locomotoras.remove{self.locomotoraAdecuada(formacion)}
        return 'se le agrego una locomotora adecuada'
        }
      else
        return 'no hay locomotora adecuada en deposito'
    }   
    }
    method hayLocomotoraAdecuada(formacion) = 
      locomotoras.any{locomotora =>  locomotora.arraseUtil() - formacion.pesoRestante() > 0}
    method locomotoraAdecuada(formacion) = 
      locomotoras.find{locomotora =>  locomotora.arraseUtil() - formacion.pesoRestante() > 0}
  }
class Formacion {
  var locomotoras= []
  const vagones= []
  // 1 Añadir un vagón a una formación.
  method aniadirVagon(vagon){
    vagones.add(vagon)
  }
  
  // 2 Agregar una locomotora a una formación.
  method aniadirLocomotora(locomotora){
    locomotoras.add(locomotora)
  }
  // 3 Saber la cantidad de vagones que tiene una formación.
  method saberCantidadVagones()= vagones.size()
  // 4 Conocer el total de pasajeros que puede transportar una formación.
  method saberCupo()= vagones.sum{vagon => vagon.puedeSostener(vagon)}
  // 5 Determinar cuántos vagones livianos tiene una formación.
  method cantidadDeVagonesLivianos()= vagones.filter{vagon => vagon.serLiviano()}.size()
  // 6 Calcular la velocidad máxima de una formación, min entre las velocidades max de las locomotoras.
  method velocidadMaxima()= locomotoras.min{locomotora => locomotora.velocidadMaxima()}
  // 7 Responder si una formación es eficiente.
  method esEficiente(){
    if (locomotoras.all{locomotora => locomotora.arrastraCincoVecesSuPeso()})
    return 'es eficiente'
    else 
    return 'no es eficiente'
  } 
  // 8 Contestar si una formación puede moverse.
  method puedeMoverse(){
    if(self.pesoRestante()<0)
    return 'no se mueve'
    else 
    return 'se mueve'
  } 
  method pesoRestante()= self.pesoMaximoACargar() - self.pesoMaximoVagones()
  method pesoMaximoACargar()= locomotoras.sum{locomotora => locomotora.arraseUtil()}
  method pesoMaximoVagones()= vagones.sum{vagon => vagon.pesoMaximo()}
  // 9 cuántos kilos de empuje le faltan a una formación para poder moverse
  method empujeFaltante()= self.pesoRestante().abs()
  // 10
  method vagonMasPesado()= vagones.max{vagon=> vagon.pesoMaximo()}
  // 11
  method esCompleja()= self.unidades()>20 || self.pesoTotal()>10000
  method unidades()= locomotoras.size() + vagones.size()
  method pesoTotal()= self.pesoMaximoACargar() + self.pesoMaximoVagones()

}
class Locomotora {
  const capacidadPesoMaximo
  const velocidadMaxima
  const peso

  method arraseUtil()= peso - capacidadPesoMaximo
  method velocidadMaxima()= velocidadMaxima
  method peso()= peso
  method arrastraCincoVecesSuPeso()= self.arraseUtil() > 5*peso
}
class Vagon {
  const pesoMaximo
  method serLiviano()= pesoMaximo < 2500
}
class VagonDePasajeros inherits Vagon {
    const largo
    const ancho
    method puedeSostener() =  largo*self.anchoUtil()
    method pesoMaximo()= puedeSostener() * 80
    method anchoUtil() {
      if (ancho > 2.5)
      return 10
      else
      return 8
    }
  }
class VagonDeCarga inherits Vagon {
    method pesoMaximo()= pesoMaximo
  }
