#include "rwmake.ch"

User Function RDMOD3()

	LOCAL cAlias := "SC5"
	PRIVATE cCadastro := "Cadastro de Tabela ZZ1"
	PRIVATE aRotina     := { }

	AADD(aRotina, { "Pesquisar",     "U_MOD3T"      , 0, 1 })
	AADD(aRotina, { "Visualizar"   , "U_MOD3T"      , 0, 2 })
	AADD(aRotina, { "Incluir"      , "U_MOD3T"      , 0, 3 })
	AADD(aRotina, { "Alterar"      , "U_MOD3T"      , 0, 4 })
	AADD(aRotina, { "Excluir"     ,  "U_MOD3T"      , 0, 5 })

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(, , , , cAlias)
Return

//=======================================================================================

User Function MOD3T(cAlias,Recno,nOpc)

	Local _ni               := 0
	Local cFilter := ""      // FILTRO PARA A TABELA SX3

	Private cTable          := GetNextAlias()


//+--------------------------------------------------------------+
//| Opcoes de acesso para a Modelo 3                             |
//+--------------------------------------------------------------+

	Do Case
	Case nOpc == 3
		nOpcE:=3
		nOpcG:=3
	Case nOpc == 4
		nOpcE:=4
		nOpcG:=4
	Case nOpc == 5
		nOpcE:=5
		nOpcG:=5
	Case nOpc == 2
		nOpcE:=2
		nOpcG:=2
	EndCase

//+--------------------------------------------------------------+
//| Cria variaveis M->????? da Enchoice                          |
//+--------------------------------------------------------------+

	RegToMemory("SC5",(nOpc == 3))
//+--------------------------------------------------------------+
//| Cria aHeader e aCols da GetDados                             |
//+--------------------------------------------------------------+
	nUsado:=0
	aHeader:={}


	// ABERTURA DO DICIONÁRIO SX3
	OpenSXs(,,,, SM0->M0_CODIGO, cTable, "SX3",, .F.)
	cFilter := cTable + "->X3_ARQUIVO == 'SC6' "
	(cTable)->(DbSetFilter({|| &(cFilter)}, cFilter))
	(cTable)->(DbGoTop())

	While (cTable)->(!Eof()) .And. (cTable)->(x3_arquivo)=="SC6"

		If Alltrim((cTable)->(x3_campo)) $ "C6_FILIAL"
			(cTable)->(dbSkip())
			Loop
		Endif

		If X3USO((cTable)->x3_usado).And.cNivel>=(cTable)->x3_nivel
			nUsado:= nUsado+1
			Aadd(aHeader,{ TRIM((cTable)->(x3_titulo)), ;
				(cTable)->(x3_campo), ;
				(cTable)->(x3_picture),;
				(cTable)->(x3_tamanho), ;
				(cTable)->(x3_decimal),;
				"AllwaysTrue()",;
				(cTable)->(x3_usado), ;
				(cTable)->(x3_tipo), ;
				(cTable)->(x3_arquivo), ;
				(cTable)->(x3_context) } )
		Endif

		(cTable)->(dbSkip())

	End

	If nOpc == 3
		aCols:={Array(nUsado+1)}
		aCols[1,nUsado+1]:= .F.

		For _ni:=1 to nUsado
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Next

	Else
		aCols:={}
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))

		While SC6->(!eof()) .and. SC6->C6_NUM == SC5->C5_NUM  .AND. SC6->C6_FILIAL == SC5->C5_FILIAL

			AADD(aCols,Array(nUsado+1))

			For _ni:=1 to nUsado
				aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
			Next

			aCols[Len(aCols),nUsado+1]:=.F.

			SC6->(dbSkip())
		End
	Endif

	If Len(aCols) > 0
//+--------------------------------------------------------------+	
//| Executa a Modelo 3                                           |	
//+--------------------------------------------------------------+	

		cTitulo:="Teste de Modelo3()"
		cAliasEnchoice:="SC5"
		cAliasGetD:="SC6"
		cLinOk:="AllwaysTrue()"
		cTudOk:="AllwaysTrue()"
		cFieldOk:="AllwaysTrue()"

//	aCpoEnchoice:={} 
//{"C5_CLIENTE"}	

		_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)

//+--------------------------------------------------------------+	
//| Executar processamento                                       |	
//+--------------------------------------------------------------+	

		If _lRet
			If nOpc == 3 //INCLUSAO
				Inclui()
			ElseIF nOpc == 4 //ALTERACAO
				Altera()
			ElseIF nOpc == 5 //EXCLUSAO
				Exclui()
			EndIf
		else
			Aviso("Modelo3()","Cancelada Operação", {"Ok"})
		Endif
	Endif

	(cTable)->(dbCloseArea())

Return

//=====================================================================

Static Function Inclui()

	Local x := 0
	Local y := 0
	Local cTableSc5 := GetNextAlias()
	Local cCampo := ""

	Begin Transaction

		// ABERTURA DO DICIONÁRIO SX3
		OpenSXs(,,,, SM0->M0_CODIGO, cTableSc5, "SX3",, .F.)
		cFilter := cTableSc5 + "->X3_ARQUIVO == 'SC5' "
		(cTableSc5)->(DbSetFilter({|| &(cFilter)}, cFilter))
		(cTableSc5)->(DbGoTop())

		RecLock("SC5",.T.)

		SC5->C5_FILIAL := xFilial("SC5")

		While (cTableSc5)->(!Eof()) .And. (cTableSc5)->X3_ARQUIVO == "SC5"
			If Alltrim((cTableSc5)->X3_CAMPO) <> "C5_FILIAL"
				cCampo  := (cTableSc5)->X3_CAMPO
				SC5->&(cCampo) := M->&(cCampo)
				(cTableSc5)->(dbSkip())
			EndIf
		EndDo

		SC5->(MsUnlock())
		(cTableSc5)->(dbCLoseArea())


//Gravação dos Itens

		For x := 1 to Len(aCols)

			RecLock("SC6", .T.)

			SC6->C6_FILIAL := xFilial("SC6")
			SC6->C6_NUM     := SC5->C5_NUM

			For y :=1 to nUsado
				FieldPut( FieldPos( aHeader[ y, 2 ] ), aCOLS[ x, y ] )
			Next y

			SC6->(MsUnlock())

		Next x

	End Transaction

Return

//=====================================================================

Static Function Exclui()

	Local cQuery := ""
	Local nRet  := 0

// Marca como deletado a Tabela ZZ1
	cQuery := " UPDATE " + RetSqlName("SC5")
	cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery += " WHERE C5_NUM = '" + SC5->C5_NUM + "' "
	cQuery += " AND C5_FILIAL = '" + SC5->C5_FILIAL + "' "

// Comando que executa o script direto no Banco de Dados
	nRet := TCSqlExec( cQuery )

	If nRet < 0
		Alert("Não foi possível deletar o registro. A operação será abortada!")
		RETURN
	EndIf

// Marca como deletado a Tabela ZZ2
	cQuery := " UPDATE " + RetSqlName("SC6")
	cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery += " WHERE C6_NUM = '" + SC5->C5_NUM + "' "
	cQuery += " AND C6_FILIAL = '"  + SC5->C5_FILIAL + "' "

// Comando que executa o script direto no Banco de Dados
	nRet :=  TCSqlExec( cQuery )

	If nRet < 0
		Alert("Não foi possível deletar o registro. A operação será abortada!")
		RETURN
	EndIf

Return

//=====================================================================

Static Function Altera()

	// Local cPed  := ZZ1->ZZ1_COD

	// Begin Transaction

	// 	DbSelectArea("ZZ1")
	// 	ZZ1->(dbSetOrder(1))
	// 	ZZ1->(dbSeek(xFilial("ZZ1") + cPed ))

	// 	RecLock("ZZ1", .F.)

	// 	ZZ1->ZZ1_FILIAL := M->ZZ1_FILIAL
	// 	ZZ1->ZZ1_COD    := M->ZZ1_COD
	// 	ZZ1->ZZ1_CLIENT := M->ZZ1_CLIENT
	// 	ZZ1->ZZ1_LOJA   := M->ZZ1_LOJA
	// 	ZZ1->ZZ1_DATAPV := M->ZZ1_DATAPV

	// 	ZZ1->(MsUnlock())

	// 	DbSelectArea("ZZ2")
	// 	ZZ2->(dbSetOrder(1))
	// 	ZZ2->(dbSeek(xFilial("ZZ2") + cPed ))


	// 	For x := 1 to Len(aCols)

	// 		RecLock("ZZ2", .F.)

	// 		//Deleta Linha
	// 		If aCols[x,nUsado+1]
	// 			ZZ2->(dbDelete())
	// 			Loop
	// 		else
	// 			For y :=1 to nUsado
	// 				FieldPut( FieldPos( aHeader[ y, 2 ] ), aCOLS[ x, y ] )
	// 			Next y
	// 		EndIf

	// 		ZZ2->(MsUnlock())

	// 	Next x

	// End Transaction


RETURN
