#Include "Protheus.ch"
#Include "TopConn.ch"

User Function ModelSa1()

	AxCadastro("SA1")

Return
	//================================================================================

User Function ModelS2()

	Local cAlias := "SA1"
	Local aCores := {}
	Local cFiltra := "A1_FILIAL == '" + xFilial('SA1') + "' .And. A1_EST == 'SP' "
    Local aArea := GetArea()
    Local aAreaSb1 := SB1->(GetArea())

	Private cCadastro := "Cadastro de Clientes"
	Private aRotina := {}

// opções de filtro utilizando a FilBrowse
	Private aIndexSA1 := {}
	Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA1,@cFiltra) }

// quando a função FilBrowse for utilizada a função de pesquisa deverá ser a PesqBrw ao invés da AxPesqui

	AADD(aRotina,{"Pesquisar"   ,"PesqBrw"      ,0,1})
	AADD(aRotina,{"Visualizar"  ,"AxVisual"     ,0,2})
	AADD(aRotina,{"Incluir"     ,"AxInclui"     ,0,3})
	AADD(aRotina,{"Alterar"     ,"AxAltera"     ,0,4})
	AADD(aRotina,{"Excluir"     ,"U_Exclui"     ,0,5})
	AADD(aRotina,{"Legenda"     ,"U_BLegenda"   ,0,3})

// inclui as configurações da legenda

	AADD(aCores,{"A1_TIPO == 'F'" ,"BR_VERDE" })
	AADD(aCores,{"A1_TIPO == 'L'" ,"BR_AMARELO" })
	AADD(aCores,{"A1_TIPO == 'R'" ,"BR_LARANJA" })
	AADD(aCores,{"A1_TIPO == 'S'" ,"BR_MARRON" })
	AADD(aCores,{"A1_TIPO == 'X'" ,"BR_AZUL" })

	dbSelectArea(cAlias)
	dbSetOrder(1)

// Cria o filtro na MBrowse utilizando a função FilBrowse

	Eval(bFiltraBrw)
	dbSelectArea(cAlias)
	dbGoTop()

	mBrowse(,,,,cAlias,,,,,,aCores)
// Deleta o filtro utilizado na função FilBrowse

EndFilBrw(cAlias,aIndexSA1)

RestArea(aArea)
RestArea(aAreaSB1)

Return Nil

//========================================================================================

// Exemplo: Determinando a opção do aRotina pela informação recebida em nOpc
User Function Exclui(cAlias, nReg, nOpc)

	Local nOpcao := 0

	nOpcao := AxDeleta(cAlias,nReg,nOpc)

	If nOpcao == 2
//Se confirmou a exclusão	
		MsgInfo("Exclusão realizada com sucesso!")
	ElseIf nOpcao == 1
		MsgInfo("Exclusão cancelada!")
	Endif

Return Nil


//========================================================================================
//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function BLegenda()

	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE" ,"Cons.Final" })
	AADD(aLegenda,{"BR_AMARELO" ,"Produtor Rural" })
	AADD(aLegenda,{"BR_LARANJA" ,"Revendedor" })
	AADD(aLegenda,{"BR_MARRON" ,"Solidario" })
	AADD(aLegenda,{"BR_AZUL" ,"Exporta��o" })

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil
