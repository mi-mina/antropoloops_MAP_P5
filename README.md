# antropoloops_MAP
<img src="https://github.com/mi-mina/antropoloops_P5/blob/master/antropoloops-MAP-peq.jpg" alt="antropoloops_MAP" title="antropoloops_MAP"  align="center"/>

antropoloops_MAP is an application made with [processing](https://processing.org/) for [antropoloops] (http://antropoloops.tumblr.com/), a musical project that creates sound collages with fragments of other songs, mixing melodies and rhythms from different times and territories. The aim of the application is to make the mix more transparent and give visibility to the sources that compose it.

antropoloops_MAP 1.0 is structured to receive data from the session in [ableton live](https://www.ableton.com/en/live/new-in-9/) via [OSC](http://opensoundcontrol.org/) and display it live on screen. The application shows the location and year of each loop recording, and the album covers of the original songs. It also shows the main fields of the mp3 ID3 tag (title, album and artist).

Here's a couple of videos to see the application running:

[![Sacromontes Gettin' Fyzzy](https://github.com/mi-mina/antropoloops_P5/blob/master/sacromontes%20getting%20fuzzy.jpg)](https://vimeo.com/118357778) [![Detente Judas Dance](https://github.com/mi-mina/antropoloops_P5/blob/master/detente%20judas%20dance.jpg)](https://vimeo.com/92180493)

### Concerning the code
This is my first code and my first application ever, so, the code can be very likely improved…
Suggestions are welcome and appreciated.

### Before you run the app
We store images of the albums in the folder 0_covers. The name of the images must match the name of the song. 
The app uses two JSON files stored in the folder 1_BDatos. In the first JSON file, called *BDloops*, we store the mp3 files metadata. For example:
```
{"nombreArchivo":"01 Chant de louanges Sonrai",
"artista":"Charles Duvelle",
"album":"Rythmes Et Chants Du Niger",
"titulo":"Chant de louanges Sonrai",
"fecha":"1960",
"lugar":"Nigeria",
"antropoloop":"Antioch Okwagala Express"}
```
You have to create this database ad hoc for your songs. It can be done easily using Jaikoz, to manage the mp3 ID3Tags.
In the second JSON file, *BDlugares*, we store the coordinates of the places where the songs come from.
The coordinates are calculated based on the world map used as background image. If you change the background, you´ll have to recalculate the coordinates.

### How to run antropoloops_MAP
* Open your song in Ableton Live
* Open antropoloops_MAP
* Press 1 and wait until the grey point in the bottom left corner disappears.
* Press 2 and wait until the white point in the bottom left corner disappears.
* Press 3 and play your song!

This first version was developed before we began to use Max for live. We are now exploring more possibilities for interaction with ableton live, improving graphics and trying to evolve towards clojure...

## antropoloops_MAP
antropoloops_MAP 1.0 es la primera versión de una aplicación interactiva creada con [processing](https://processing.org/) para [antropoloops] (http://antropoloops.tumblr.com/), un proyecto musical que crea canciones nuevas uniendo fragmentos de otras canciones, mezclando melodías y ritmos de distintas épocas y territorios. El objetivo de la aplicación es hacer la remezcla más transparente y darle visibilidad a las fuentes que la componen.  
antropoloops_MAP 1.0 se ha programado para recibir los datos de la sesión en [ableton live](https://www.ableton.com/en/live/new-in-9/) via [OSC](http://opensoundcontrol.org/) y visualizarlos en la pantalla en directo. La aplicación muestra la procedencia y el año de grabación de cada loop, así como las portadas de los discos a los que pertenecen las canciones originales. También muestra los campos principales de el ID3tag del mp3 (título, álbum y artista).

Aquí tenéis un par de vídeos para ver la aplicación en funcionamiento: 
[![Sacromontes Gettin' Fyzzy](https://github.com/mi-mina/antropoloops_P5/blob/master/sacromontes%20getting%20fuzzy.jpg)](https://vimeo.com/118357778) [![Detente Judas Dance](https://github.com/mi-mina/antropoloops_P5/blob/master/detente%20judas%20dance.jpg)](https://vimeo.com/92180493)

### En relación al código.
Este es mi primer código y mi primera aplicación chispas, por lo que el código es muy mejorable :)
Se agradecen sugerencias y mejoras si os apetece jugar con él.

### Antes de poner en marcha la aplicación.
En la carpeta 0_covers guardamos las portadas de los álbumes a los que pertenecen las canciones. El nombre de las imágenes debe coincidir con el nombre de la canción. 

La aplicación usa dos archivos JSON ubicados en la carpeta 1_BDatos. En el primero, llamado *BDloops*, almacenamos los metadatos de los archivos mp3 usados. Ejemplo:
```
{"nombreArchivo":"01 Chant de louanges Sonrai",
"artista":"Charles Duvelle",
"album":"Rythmes Et Chants Du Niger",
"titulo":"Chant de louanges Sonrai",
"fecha":"1960",
"lugar":"Nigeria",
"antropoloop":"Antioch Okwagala Express"}
```
Esta base de datos tenéis que crearla ad hoc para vuestras canciones. Se puede hacer de forma sencilla usando Jaikoz para gestionar las ID3Tags de los mp3, y [Mr. Data Converter](http://shancarter.github.io/mr-data-converter/) para convertir a JSON.
En el segundo JSON, *BDlugares*, almacenamos las coordenadas de los lugares de donde proceden las canciones. Las coordenadas están calculadas en base al mapamundi usado como imagen de fondo de la aplicación. Si cambias la imagen de fondo, tendrás que recalcular las coordenadas.

### Para poner en marcha la aplicación:
* Abre en Ableton Live la canción que quieras pinchar
* Abre antropoloops_MAP
* Pulsa 1 y espera a que se apague el punto gris que aparece en la esquina inferior izquierda de la pantalla.
* Pulsa 2 y espera a que se apague el punto blanco que aparece en la esquina inferior izquierda de la pantalla.
* Pulsa 3 y ¡ya puedes empezar a pinchar!

Esta primera versión se ha desarrollado antes de que empezáramos a usar Max for live. Ahora andamos explorando más posibilidades de interacción con el ableton live, estamos tratando de mejorar los gráficos, así como intentando evolucionar hacia clojure...
