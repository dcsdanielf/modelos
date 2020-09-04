#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://localhost:8090/ws/CONCLIENTE.apw?WSDL
Gerado em        09/04/20 11:32:35
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _TRRPMKC ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCONCLIENTE
------------------------------------------------------------------------------- */

WSCLIENT WSCONCLIENTE

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETCLI
	WSMETHOD PUTCLI

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCCPF                     AS string
	WSDATA   oWSGETCLIRESULT           AS CONCLIENTE_ARRAYOFINFCLI
	WSDATA   cCNOME                    AS string
	WSDATA   cCEND                     AS string
	WSDATA   cPUTCLIRESULT             AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCONCLIENTE
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20200102] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCONCLIENTE
	::oWSGETCLIRESULT    := CONCLIENTE_ARRAYOFINFCLI():New()
Return

WSMETHOD RESET WSCLIENT WSCONCLIENTE
	::cCCPF              := NIL 
	::oWSGETCLIRESULT    := NIL 
	::cCNOME             := NIL 
	::cCEND              := NIL 
	::cPUTCLIRESULT      := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCONCLIENTE
Local oClone := WSCONCLIENTE():New()
	oClone:_URL          := ::_URL 
	oClone:cCCPF         := ::cCCPF
	oClone:oWSGETCLIRESULT :=  IIF(::oWSGETCLIRESULT = NIL , NIL ,::oWSGETCLIRESULT:Clone() )
	oClone:cCNOME        := ::cCNOME
	oClone:cCEND         := ::cCEND
	oClone:cPUTCLIRESULT := ::cPUTCLIRESULT
Return oClone

// WSDL Method GETCLI of Service WSCONCLIENTE

WSMETHOD GETCLI WSSEND cCCPF WSRECEIVE oWSGETCLIRESULT WSCLIENT WSCONCLIENTE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETCLI xmlns="http://localhost:8090/">'
cSoap += WSSoapValue("CCPF", ::cCCPF, cCCPF , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETCLI>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://localhost:8090/GETCLI",; 
	"DOCUMENT","http://localhost:8090/",,"1.031217",; 
	"http://localhost:8090/ws/CONCLIENTE.apw")

::Init()
::oWSGETCLIRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETCLIRESPONSE:_GETCLIRESULT","ARRAYOFINFCLI",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PUTCLI of Service WSCONCLIENTE

WSMETHOD PUTCLI WSSEND cCNOME,cCEND WSRECEIVE cPUTCLIRESULT WSCLIENT WSCONCLIENTE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PUTCLI xmlns="http://localhost:8090/">'
cSoap += WSSoapValue("CNOME", ::cCNOME, cCNOME , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CEND", ::cCEND, cCEND , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PUTCLI>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://localhost:8090/PUTCLI",; 
	"DOCUMENT","http://localhost:8090/",,"1.031217",; 
	"http://localhost:8090/ws/CONCLIENTE.apw")

::Init()
::cPUTCLIRESULT      :=  WSAdvValue( oXmlRet,"_PUTCLIRESPONSE:_PUTCLIRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ARRAYOFINFCLI

WSSTRUCT CONCLIENTE_ARRAYOFINFCLI
	WSDATA   oWSINFCLI                 AS CONCLIENTE_INFCLI OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CONCLIENTE_ARRAYOFINFCLI
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CONCLIENTE_ARRAYOFINFCLI
	::oWSINFCLI            := {} // Array Of  CONCLIENTE_INFCLI():New()
Return

WSMETHOD CLONE WSCLIENT CONCLIENTE_ARRAYOFINFCLI
	Local oClone := CONCLIENTE_ARRAYOFINFCLI():NEW()
	oClone:oWSINFCLI := NIL
	If ::oWSINFCLI <> NIL 
		oClone:oWSINFCLI := {}
		aEval( ::oWSINFCLI , { |x| aadd( oClone:oWSINFCLI , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CONCLIENTE_ARRAYOFINFCLI
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_INFCLI","INFCLI",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSINFCLI , CONCLIENTE_INFCLI():New() )
			::oWSINFCLI[len(::oWSINFCLI)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure INFCLI

WSSTRUCT CONCLIENTE_INFCLI
	WSDATA   cCEND                     AS string
	WSDATA   cCIDADE                   AS string
	WSDATA   cCNOME                    AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CONCLIENTE_INFCLI
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CONCLIENTE_INFCLI
Return

WSMETHOD CLONE WSCLIENT CONCLIENTE_INFCLI
	Local oClone := CONCLIENTE_INFCLI():NEW()
	oClone:cCEND                := ::cCEND
	oClone:cCIDADE              := ::cCIDADE
	oClone:cCNOME               := ::cCNOME
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CONCLIENTE_INFCLI
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCEND              :=  WSAdvValue( oResponse,"_CEND","string",NIL,"Property cCEND as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCIDADE            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,"Property cCIDADE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNOME             :=  WSAdvValue( oResponse,"_CNOME","string",NIL,"Property cCNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


