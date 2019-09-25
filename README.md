# LaunchVfp
 Permite correr el ejecutable con la fecha mas reciente donde el inicio especificado del archivo tengan el mismo nombre

# Uso
Para darle uso a este Launcher es necesario que se le coloque al usuario (en cualquier lugar que tenga acceso) los siguientes archivos:

*   config.fpw: Evita que se muestre la ventana de VFP

*   configlaunch.ini: Archivo donde se configuran todos los parametros que se utilizan en la aplicación como son:
	* Ruta: Se indica donde se encuentra el ejecutable de la aplicación que se estará ejecutando.
	* Ejecutable: Indica el nombre con el que debe de iniciar el ejecutable para que la aplicacion busque la mas reciente.
	* Acceso: Indica si se puede acceder (con un S) o no (con una N) al sistema.
	* MensajeMant: Indica el mensaje que se le mostrará al usuario cuando no se pueda acceder al sistema.
	* TiempoMant: Tiempo en segundos que durará la aplicación para verificar automaticamente si se puede o no acceder al sistema.
	* ImgMant: Imagen que se le mostrará al usuario en el formulario de espera.

*   launch.exe: Este es el ejecutable que se le debe de colocar al usuario, el mismo se le puede cambiar el nombre o el icono para que vaya mas acorde con el sistema en custión.
*	Mantenimiento.png: Esta es la imagen que vera el usuario en el parametro ImgMant

# Cambios y Mejoras
Te puedes sentir en total libertad de hacer cualquier mejoro y/o modificación a esta aplicacion para que vaya mas acorde a tus necesidades.
 