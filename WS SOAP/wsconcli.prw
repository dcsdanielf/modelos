#include 'Protheus.ch'
#include 'ApWebSrv.ch'
#include 'TbiConn.ch'

WSSERVICE servicetime DESCRIPTION "Veja o Hor�rio"

WSDATA horario as String
WSDATA parametro as String

WSMETHOD GetServerTime Description "Metodo de visualiza��o de Hor�rio"
ENDWSSERVICE

WSMETHOD GetServerTime WSRECEIVE parametro WSSEND horario WSSERVICE servicetime

::horario := TIME()

Return(.T.)

