#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RESTFUL.CH"


User function WSCONCLI()

	WSRESTFUL oConCli DESCRIPTION "Consulta Cliente/Advogado OAB"

		WSMETHOD POST DESCRIPTION "Consulta Cliente/Advogado OAB" WSSYNTAX "/oConCli || /oConCli/{id}"

	END WSRESTFUL

WSMETHOD POST WSRECEIVE RECEIVE WSSERVICE oConCli

	Local cCNPJ 	:= ""
	Local oObj
	Local cJsonRet	:= ""

	Private cJSON	:= ""

	Conout("[INICIO] - WEBSERVICE DE INTEGRACAO DE CLIENTE ")
	Conout("[DATA] " + DtoC(dDataBase) + "[HORA] " + Time() )

	cJSON := Self:GetContent() // Pega a string do JSON

	If FWJsonDeserialize(cJSON,@oObj)

		nRegs := Len(oObj:CLI)
		If nRegs >0
			cCNPJ := oObj:CLI[1]:A1_CGC
		Else
			cJsonRet := '{"MSG": "Sem informação"}'
		EndIf

		If !Empty(cCNPJ)
			Conout("[INFO] CONSULTANDO CLIENTE" )

			dbSelectArea("SA1")
			SA1->(dbSetOrder(3))
			If SA1->(dbSeek(xFilial("SA1") + cCNPJ ))
				cJsonRet :=  '{"STATUS":"OK" ,'
				cJsonRet +=  '"NOME":"' +  Alltrim(SA1->A1_NOME) + '"}'
			Else
				cJsonRet :=  '{"MSG": "Cliente não cadastrado"}'
			EndIf
		EndIf

		::SetResponse( cJsonRet )

	EndIf

	Conout("[INFO] Resposta: " + cJsonRet)
	Conout("[FIM] - WEBSERVICE DE INTEGRACAO CLIENTE ")
	Conout("[DATA] " + DtoC(dDataBase) + "[HORA] " + Time() )

	RpcClearEnv()

Return(.T.)

//==============================================================================================

User Function ENVCLI(ccgc)

	Local cJson := '{"CLI":[{"A1_CGC":"' + Alltrim(ccgc) +'"}]}'
	private oRest:= FWRest():New("http://localhost:9090/rest/")
	private aHeader := {}
	private resultado
	Private cError
	Private cUser := "user1"
	Private cPass	:= "user1"

	// inclui o campo Authorization no formato : na base64 somente quando estiver habilitado a segurança no INI.
	Aadd(aHeader, "Authorization: Basic " + Encode64(cUser+":"+cPass))

	oRest:setPath('oConCli')

	oRest:SetPostParams( cJson )

	If oRest:Post(aHeader) //oRest:Get(aHeader)
		Conout("POST", oRest:GetResult())
	Else
		Conout("POST", oRest:GetLastError())
	EndIf

//usar o camando pra deserializar os retornos

	resultado := oRest:GetResult()
	cError:= oRest:GetLastError()

	Alert(resultado)
	alert(cError)

	Conout("FIM")

Return
