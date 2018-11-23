# Space Invaders

"Homage" programado con [Love2D](https://love2d.org/) del clásico shooter diseñado originalmente por Toshihiro Nishikado y distribuido por Taito y Midway.

## El juego en sus distintas fases de desarrollo

Durante el desarrollo se han ido creando distintas ramas / branches para poder examinar el estado del proyecto en distintos momentos:

* `ventana-vacia`: Proyecto Love2D con una ventana vacía escalable
* `pantallas-del-juego`: Añadidas las pantallas del juego (menu y game)
* `movimiento-canon`: Movimiento básico del cañon
* `ufo`: Añadido gameobject ufo para crear los tres tipos de ovnis
* `ufo-squad`: Añadido gameobject squad para manejar todo el escuadrón de enemigos
* `movimiento-squad`: Movimiento del escuadrón de enemigos y cambio de frame
* `disparo-canon`: Posibilidad de disparar con el cañón (¡todavía de fogueo!)
* `colisiones-disparo-canon`: Detección y resolución de colisiones entre el disparo del cañón y el escuadrón de enemigos
* `disparo-ufo`: Disparos desde los ovnis
* `colisiones-disparo-ufo`: Colisiones entre los disparos de los ovnis y el cañón
* `vidas`: Si perdemos tres vidas volveremos al menú principal del juego
* `puntos`: Puntos y máxima puntuación
* `invasion-y-niveles`: Fin de partida si los invasores alcanzan la tierra y cambio de nivel al destruir un escuadrón completo

## Cómo descargar el código

Para descargar una rama particular:

`$ git clone -b nombre-de-la-rama https://github.com/codemonsters/space-invaders`
