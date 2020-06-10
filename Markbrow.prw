#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSOLE.CH"


user function Markbrow()

	Local aArea		:= GetArea()
	Local aFields 	:= {}
	Local oTempTable
	Local cQuery

	Private CALIAS	:= "S66"
	//-------------------
	//Criaï¿½ï¿½o do objeto
	//-------------------
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	EndIf

	oTempTable := FWTemporaryTable():New( cAlias )

	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	aadd(aFields,{"OK","C",2,0})
	aadd(aFields,{"C6_PRODUTO",TAMSX3("C6_PRODUTO")[3],TAMSX3("C6_PRODUTO")[1],TAMSX3("C6_PRODUTO")[2]})
	aadd(aFields,{"C6_VALOR",TAMSX3("C6_VALOR")[3],TAMSX3("C6_VALOR")[1],TAMSX3("C6_VALOR")[2]})
	aadd(aFields,{"C6_QTDVEN",TAMSX3("C6_QTDVEN")[3],TAMSX3("C6_QTDVEN")[1],TAMSX3("C6_QTDVEN")[2]})


	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("indice1", {"C6_PRODUTO"} )
	//------------------
	//Criaï¿½ï¿½o da tabela
	//------------------
	oTempTable:Create()

	//------------------------------------
	//Executa query para leitura da tabela
	//--------------------'----------------
	cQuery := " SELECT C6_PRODUTO, C6_QTDVEN, C6_VALOR "
	cQuery += " FROM " + RetSqlTab("SC6")
	cQuery += " WHERE SC6.D_E_L_E_T_ = '' "

	//cQuery := ChangeQuery(cQuery)

	MPSysOpenQuery( cQuery, 'TMP' )

	DbSelectArea('TMP')
	TMP->(dbGoTop())

	While TMP->(!EOF())

		//Grava Tabela temporaria
		RecLock(cAlias, .T.)

		(cALias)->C6_PRODUTO := TMP->C6_PRODUTO
		(cALias)->C6_VALOR 	 := TMP->C6_VALOR
		(cALias)->C6_QTDVEN	 := TMP->C6_QTDVEN
 		(cALias)->(msUnLock())

		TMP->(dbSkip())
	EndDo

	(cALias)->(dbGotop())


	//---------------------------------
	//Tela de Markbrowe
	//---------------------------------
	Processa( {|| MARK() }, "Aguarde...", "Carregando defini��es...",.F.)

	//---------------------------------
	//Exclui a tabela
	//---------------------------------
	TMP->(dbCloseArea())
	oTempTable:Delete()
	RestArea(aArea)


Return()

//==========================================================================================

Static Function Mark()



	Local aArea			:= GetArea()

	Private cAliasMark  := cALias
	Private oMarK
	Private lMarcar		:= .F.

	cAliasMark->(dbGoTop())

	oMark := FWMarkBrowse():New()
	oMark:SetMenuDef("")
	oMark:SetAlias(cAliasMark)
	oMark:SetOnlyFields( { C6_PRODUTO, C6_VALOR, C6_QTDVEN } )
	oMark:SetDescription("MarkBrowse Teste")
	oMark:SetFieldMark( 'OK')
	oMark:SetTemporary()

	oMark:SetColumns(MontaColunas("C6_PRODUTO"	,"Produto"    ,15,PesqPict("SC6","C6_PRODUTO")	,0,005,0))
	oMark:SetColumns(MontaColunas("C6_VALOR"	,"Valor R$"   ,18,PesqPict("SC6","C6_VALOR")	,0,003,0))
	oMark:SetColumns(MontaColunas("C6_QTDVEN"	,"Qauntidad"  ,18,PesqPict("SC6","C6_QTDVEN")	,0,005,0))


	oMark:AddButton("Boleto",{|| Grava() },,3,2)
	oMark:SetIgnoreArotina(.T.)
	oMark:bAllMark := { || SetMarkAll(oMark:Mark(),lMarcar := !lMarcar ), oMark:Refresh(.T.)  }

	oMark:Activate()

	RestArea(aArea)


return

//==========================================================================================================

Static Function SetMarkAll(cMarca,lMarcar )

	Local aAreaMark  := (cAliasMark)->( GetArea() )

	dbSelectArea(cAliasMark)
	(cAliasMark)->( dbGoTop() )

	While !(cAliasMark)->( Eof() )
		RecLock( (cAliasMark), .F. )
		(cAliasMark)->OK := IIf( lMarcar, cMarca, '  ' )
		MsUnLock()
		(cAliasMark)->( dbSkip() )
	EndDo

	RestArea( aAreaMark )

Return .T.

//===========================================================================================================


/*
*Funï¿½ï¿½o para montagem das colunas da Markbrowse
*/
Static Function MontaColunas(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	Local aColumn
	Local bData 	:= {||}
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0

	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf

	/* Array da coluna
	[n][01] Tï¿½tulo da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Mï¿½scara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a ediï¿½ï¿½o
	[n][09] Code-Block de validaï¿½ï¿½o da coluna apï¿½s a ediï¿½ï¿½o
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execuï¿½ï¿½o do duplo clique
	[n][12] Variï¿½vel a ser utilizada na ediï¿½ï¿½o (ReadVar)
	[n][13] Code-Block de execuï¿½ï¿½o do clique no header
	[n][14] Indica se a coluna estï¿½ deletada
	[n][15] Indica se a coluna serï¿½ exibida nos detalhes do Browse
	[n][16] Opï¿½ï¿½es de carga dos dados (Ex: 1=Sim, 2=Nï¿½o)
	*/
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}

Return {aColumn}

//===========================================================================================================

Static Function Grava()

(cAliasMark)->(dbGoTop())
	While (cAliasMark)->(!EOF())

		If !Empty((cAliasMark)->OK)
			Alert("Item Marcado")
		else
			Alert("Item Desmarcado")
		END

		(cAliasMark)->(dbSkip())
	ENDDO

Return
	