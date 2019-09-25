Public lcMensajeMant, lcImgMant, lcRutaSis, lnTiempoMant

lcRutaSis = Addbs(Justpath(Sys(16,1)))

lcRutaExe = LeeIni(lcRutaSis+"configlaunch.ini","Generico","Ruta")
lcExe = LeeIni(lcRutaSis+"configlaunch.ini","Generico","Ejecutable")

llAcceso = .f.&&LeeIni(lcRutaSis+"configlaunch.ini","Generico","Acceso") = "S"

lnTiempoMant = Val(LeeIni(lcRutaSis+"configlaunch.ini","Mantenimiento","TiempoMant"))

If llAcceso

	IngresoSistema()
Else

	lcMensajeMant = LeeIni(lcRutaSis+"configlaunch.ini","Mantenimiento","MensajeMant")
	lcImgMant = LeeIni(lcRutaSis+"configlaunch.ini","Mantenimiento","ImgMant")

	FormMantenimiento()

Endif

*--------------------------------------------------------------------------------
*Nombre		         : LeeIni()
*Valor devuelto      : lcValor (Valor de la variable, si es que existe, sino retorna .NULL.)
*Autor				 : Juan Cueli
*Ejemplo			 : =LeeIni("C:MiArchivo.ini","Default","Puerto")
*Creación            : 11/02/2017
*----------------------------------------------------------------------------------
*Lista modificaciones:
*  Fecha		Autor	Cambio
*----------------------------------------------------------------------------------
*** <summary>
*** Lee un valor de un archivo INI. Si no existe el archivo, la sección o la entrada, retorna .NULL.
*** </summary>
*** <param name="pcArchivo">Nombre y ruta completa del archivo .INI</param>
*** <param name="pcSeccion">Sección del archivo .INI</param>
*** <param name="pcVariable">Variable del archivo .INI donde se guardara el valor</param>
*** <remarks></remarks>
Function LeeIni(pcArchivo,pcSeccion,pcVariable)
Local lcValor, lnResultado, lnBufferSize, lcArchivo

lcArchivo = pcArchivo

Declare Integer GetPrivateProfileString ;
	IN WIN32API ;
	STRING cSeccion,;
	STRING cVariable,;
	STRING cDefecto,;
	STRING @aRetVal,;
	INTEGER nTam,;
	STRING cArchivo
lnBufferSize = 255
lcValor = Spac(lnBufferSize)
lnResultado=GetPrivateProfileString(pcSeccion,pcVariable,"*NULL*",;
	@lcValor,lnBufferSize,lcArchivo)
lcValor=Substr(lcValor,1,lnResultado)
If lcValor="*NULL*"
	lcValor=.Null.
Endif
Return lcValor
Endfunc

*--------------------------------------------------------------------------------
*Nombre		         : FormMantenimiento()
*Valor devuelto      :
*Autor				 : Juan Cueli
*Ejemplo			 : FormMantenimiento()
*Creación            : 23/09/2019
*----------------------------------------------------------------------------------
*Lista modificaciones:
*  Fecha		Autor	Cambio
*----------------------------------------------------------------------------------
*** <summary>
*** Crea un formulario que le indica al usuario que el sistema está en mantenimiento y no puede acceder al mismo.
*** </summary>
*** <remarks></remarks>
Procedure FormMantenimiento
Local loForm

loForm = Createobject("Mantenimiento")

loForm.Show()

Read Events

loForm = .Null.

Release loForm

Return

Define Class Mantenimiento As Form

*-Propiedades de la ventana de Mantenimiento
	BackColor 	= Rgb(255, 255, 224)
	Caption  	= "Mantenimiento"
	AutoCenter 	= .T.
	Width 		= 490
	Height 		= 490
	BorderStyle = 1
	ControlBox	= .F.
	ShowWindow 	= 2

*-Controles que tiene el formulario
*-Label con mensaje de mantenimiento
	Add Object lblMant As Label With ;
		BackStyle  	= 0,;
		Caption   	= "", ;
		ForeColor 	= Rgb(255,0, 0), ;
		Left      	= 10, ;
		Top       	= 10, ;
		Width     	= 480,;
		Height	  	= 35,;
		wordwrap  	= .T.,;
		FontBold  	= .T.,;
		Alignment	= 2,;
		caption	  	= lcMensajeMant

*-Imagen de la pantalla de mantenimiento
	Add Object imgMant As Image With ;
		picture 	= lcImgMant,;
		Left      	= 100, ;
		Top       	= 60, ;
		Width     	= 50,;
		Height	 	= 50

*-Boton que cierra el formulario
	Add Object btncerrar As CommandButton With ;
		left 		= 335,;
		top 		= 400,;
		height 		= 27,;
		width 		= 135,;
		caption		= "Cerrar"

*-Boton que le da acceso al sistema
	Add Object btnAcceder As CommandButton With ;
		left 		= 50,;
		top 		= 420,;
		height 		= 27,;
		width 		= 135,;
		caption		= "Accesar el sistema"

*-Timer que indica el intervalo de tiempo en en que se va a verificar si se tiene o no acceso al sistema
	Add Object tmReintentar As Timer With ;
		interval = lnTiempoMant * 1000

*-Boton para reintentar validar el acceso al sistema
	Add Object btnReintentar As CommandButton With ;
		left 		= 50,;
		top 		= 380,;
		height 		= 27,;
		width 		= 135,;
		caption		= "Volver a Intentar en "+Alltrim(Str(lnTiempoMant)),;
		nReintentar = (Thisform.tmReintentar.Interval)/1000

*-Timer que reduce el tiempo para reintentar cada segundo
	Add Object tmCaptionBtnReintentar As Timer With ;
		interval = 1000

*-Metodos y Procedimiento del formulario y los objetos
*-Procedimiento que se corre cuando se cierra el formulario
	Procedure Destroy
	Clear Events
	Release lcMensajeMant, lcImgMant, lcRutaSis, lnTiempoMant
	Endproc

*-Inicio del formulario
	Procedure Init
	Thisform.btnAcceder.Refresh
	Endproc

*-Clic al boton cerrar
	Procedure btncerrar.Click
	Thisform.Release
	Endproc

*-Refresh al boton acceder
	Procedure btnAcceder.Refresh
	llAcceso = LeeIni(lcRutaSis+"configlaunch.ini","Generico","Acceso") = "S"
	This.Enabled = llAcceso
	Endproc

*-Clic al boton acceder
	Procedure btnAcceder.Click
	IngresoSistema()
	Endproc

*-Timer que validar el tiempo restante para reintentar acceder al sistema
	Procedure tmCaptionBtnReintentar.Timer
	If Thisform.btnReintentar.nReintentar > 0
		Thisform.btnReintentar.nReintentar = Thisform.btnReintentar.nReintentar - 1
	Else
		Thisform.btnReintentar.Click
	Endif

	Thisform.btnReintentar.Caption	= "Volver a Intentar en "+Alltrim(Str(Thisform.btnReintentar.nReintentar))
	Endproc

*-Clic al boton reintentar
	Procedure btnReintentar.Click
	Thisform.btnReintentar.nReintentar = lnTiempoMant
	Thisform.btnAcceder.Refresh
	Endproc

Enddefine


Endproc


*--------------------------------------------------------------------------------
*Nombre		         : IngresoSistema()
*Valor devuelto      :
*Autor				 : Juan Cueli
*Ejemplo			 : =IngresoSistema()
*Creación            : 25/09/2019
*----------------------------------------------------------------------------------
*Lista modificaciones:
*  Fecha		Autor	Cambio
*----------------------------------------------------------------------------------
*** <summary>
*** Lee un valor de un archivo INI. Si no existe el archivo, la sección o la entrada, retorna .NULL.
*** </summary>
*** <param name="pcArchivo">Nombre y ruta completa del archivo .INI</param>
*** <param name="pcSeccion">Sección del archivo .INI</param>
*** <param name="pcVariable">Variable del archivo .INI donde se guardara el valor</param>
*** <remarks></remarks>
Function IngresoSistema()
Cd &lcRutaExe

Adir(laExe,lcRutaExe+"\"+lcExe+"*.EXE")

lcUltExe = ""
ldtUltFecha = Ctot("")

For i = 1 To Alen(laExe,1)

	ldtExe = Datetime(Year(laExe(i,3)),Month(laExe(i,3)),Day(laExe(i,3)),Hour(Ctot(laExe(i,4))),Minute(Ctot(laExe(i,4))),Sec(Ctot(laExe(i,4))))

	If ldtUltFecha < ldtExe
		ldtUltFecha = ldtExe
		lcUltExe = laExe(i,1)
	Endif

Endfor

obj = Createobject("Shell.Application")
obj.ShellExecute(lcRutaExe +lcUltExe)
obj = Null

Release lcMensajeMant, lcImgMant, lcRutaSis, lnTiempoMant

Quit
Endfunc