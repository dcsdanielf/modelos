#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function REST003()
	local oReport

	Private aRet :={}

	Pergunta()

	oReport := reportDef()
	oReport:printDialog()
Return

//============================================================================================================

static function reportDef()

	local oReport
	Local oSection1
	local oBreak
	local oBreak2
	local cTitulo := '[REST003] - Impressão de Produtos'

	oReport := TReport():New('REST003', cTitulo, , {|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao de produtos.")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Cadastro de Produto",{"QRY","SB1"})
	oSection1:SetTotalInLine(.F.)

	TRCell():New(oSection1, "B1_FILIAL"	, "QRY", 'FILIAL'	,PesqPict('SB1',"B1_FILIAL"),TamSX3("B1_FILIAL")[1]+1 )
	TRCell():new(oSection1, "B1_COD"	, "QRY", 'CODIGO'	,PesqPict('SB1',"B1_COD")	,TamSX3("B1_COD")[1]+1 )
	TRCell():new(oSection1, "B1_DESC"	, "QRY", 'DESCRIÇÃO',PesqPict('SB1',"B1_DESC")	,TamSX3("B1_DESC")[1]+1 )
	TRCell():new(oSection1, "B1_GRUPO"	, ""   , 'GRUPO'    ,PesqPict('SBM',"BM_DESC")	,TamSX3("BM_DESC")[1]+1 )
	TRCell():new(oSection1, "B1_CUSTD"	, "QRY", 'PREÇO'    ,PesqPict('SB1',"B1_CUSTD")	,TamSX3("B1_CUSTD")[1]+1 )
	TRCell():new(oSection1, "B1_TIPO"	, "QRY", 'TIPO'     ,PesqPict('SB1',"B1_TIPO")	,TamSX3("B1_TIPO")[1]+1 )

	oBreak := TRBreak():New(oSection1,oSection1:Cell("B1_FILIAL"),,.F.)
	oBreak2 := TRBreak():New(oSection1,oSection1:Cell("B1_TIPO"),,.F.)

	TRFunction():New(oSection1:Cell("B1_FILIAL"),"TOTAL FILIAL","COUNT",oBreak,,"@E 999999",,.F.,.F.)
	TRFunction():New(oSection1:Cell("B1_CUSTD"),"TOTAL CUSTO" ,"SUM",oBreak,,PesqPict('SB1',"B1_CUSTD"),,.F.,.T.)

	TRFunction():New(oSection1:Cell("B1_FILIAL"),"TOTAL GERAL" ,"COUNT",,,"@E 999999",,.F.,.T.)


return (oReport)

//======================================================================================================================================

Static Function PrintReport(oReport)


	Local oSection1 := oReport:Section(1)
	Local cQuery := ""

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)

	cQuery := " SELECT * FROM " + RetSqlTab("SB1")
	cQUery += " WHERE SB1.D_E_L_E_T_ = '' "
	cQuery += " AND B1_COD BETWEEN '" + aRet[1] + "' AND '" + aRet[2] + "' "
	cQuery += " ORDER BY B1_FILIAL, B1_TIPO "

	cQUery := changeQuery(cQUery)

	IF Select("QRY") <> 0
		QRY->(dbCloseArea())
	EndIf

	MPSysOpenQuery( cQuery, 'QRY' )

	DbSelectArea('QRY')
	QRY->(dbGoTop())

	oReport:SetMeter(QRY->(RecCount()))
	QRY->(dbGoTop())

	While QRY->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf

		oReport:IncMeter()

		oSection1:Cell("B1_FILIAL"):SetValue(QRY->B1_FILIAL)
		// oSection1:Cell("B1_FILIAL"):SetAlign("CENTER")

		oSection1:Cell("B1_COD"):SetValue(QRY->B1_COD)
		// oSection1:Cell("B1_COD"):SetAlign("CENTER")

		oSection1:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
		// oSection1:Cell("B1_DESC"):SetAlign("LEFT")

		oSection1:Cell("B1_GRUPO"):SetValue(Posicione("SBM",1,xFilial("SBM")+QRY->B1_GRUPO,"BM_DESC"))
		// oSection1:Cell("B1_GRUPO"):SetAlign("LEFT")

		oSection1:Cell("B1_CUSTD"):SetValue(QRY->B1_CUSTD)
		// oSection1:Cell("B1_CUSTD"):SetAlign("LEFT")

		oSection1:Cell("B1_TIPO"):SetValue(QRY->B1_TIPO)
		// oSection1:Cell("B1_TIPO"):SetAlign("LEFT")

		oSection1:PrintLine()

		QRY->(dbSkip())
	EndDo
	oSection1:Finish()
Return

//=========================================================================================
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
