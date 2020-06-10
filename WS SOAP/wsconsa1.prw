#include 'Protheus.ch'
#include 'ApWebSrv.ch'
#include 'TbiConn.ch'

/*/{Protheus.doc} Função de WS em SOAP
    @type  WSSERVICE
    @author Daniel
    @since 21/05/2020
    @version version
    @param cCPF
    @return aDados ( dados do retorno do cliente)
    /*/


WSSERVICE concli DESCRIPTION "Consulta de Cliente"

WSDATA cCpf as String
WSDATA aDados as Array of InfCLi
WSDATA cRet as String

WSMETHOD GetCli Description "Consulda de Dados do cliente tabela SA1"
ENDWSSERVICE

WsStruct InfCli
WSDATA cNome as String
WSDATA cEnd as String
WSDATA cIdade as String
EndWsStruct

WSMETHOD GetCli WSRECEIVE cCpf WSSEND aDados WSSERVICE concli

Conout("[INFO] - Iniciando consulta cliente de WS")

dbSelectArea("SA1")
SA1->(dbSetOrder(3))
If SA1->(dbSeek(xFilial("SA1") + ::cCpf))

    aadd(aDados, WSClassNew( "InfCLi" ))

    aDados[1]:cNome     := SA1->A1_NOME
    aDados[1]:cEnd      := SA1->A1_END
    aDados[1]:cIdade    := cValtochar(Year(dDatabase) - Year(SA1->A1_DTNASC))
   
else
    Conout("[INFO] Não foi possivel encontrar cliente")
    ::cRet:= "Cliente não encontrado"
    
    aadd(aDados, WSClassNew( "InfCLi" ))

    aDados[1]:cNome     := ""
    aDados[1]:cEnd      := ""
    aDados[1]:cIdade    := ""
ENDIF

Conout("[INFO] - Finalizando consulta cliente de WS")

Return(.T.)