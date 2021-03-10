#Include "PROTHEUS.CH"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"

User Function QRCode()

	Local oPrinter

	Private aRet := {}

	Pergunta()

	BeginSQL alias "TMPCNA"
				SELECT B1_COD+B1_TIPO+B1_LOCPAD AS QRCODE FROM %table:SB1% SB1
				// WHERE B1_FILIAL = %xfilial:SB1%
				WHERE B1_COD BETWEEN %exp:aRet[1]% AND %exp:aRet[2]%
				AND SB1.%notDel%
	EndSQl

	oPrinter := FWMSPrinter():New('teste',6,.F.,,.T.,,,,,.F.)
	oPrinter:Setup()
	oPrinter:setDevice(IMP_PDF)
	oPrinter:cPathPDF :="C:\TOTVS\"

	While TMPCNA->(!EOF())

		oPrinter:QRCode(150,150,TMPCNA->QRCODE, 100)

		TMPCNA->(dbSkip())
	EndDo

	oPrinter:EndPage()
	oPrinter:Preview()
	FreeObj(oPrinter)
	oPrinter := Nil

    TMPCNA->(dbCloseArea())
Return

//==============================================================

Static Function Pergunta()

	Local aArea := GetArea()
	Local aPerg 	:= {}

	aAdd( aPerg ,{1,"Produto de"		,Space(TAMSX3("B1_COD")[1]),PesqPict('SB1',"B1_COD"),'.T.',"SB1",'.T.',70,.F.})
	aAdd( aPerg ,{1,"Produto ate"		,Space(TAMSX3("B1_COD")[1]),PesqPict('SB1',"B1_COD"),'.T.',"SB1",'.T.',70,.T.})

	ParamBox(aPerg ,"Parametros ",aRet)

	If Empty(aRet)
		MsgAlert("Informações invalidas!","Atenção")
		Return
	EndIf

	RestArea(aArea)

Return(aRet)
