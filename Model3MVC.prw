#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'


User Function MD3MVC()

	Local oBrowse
	Private aRotina := {}

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'ZZ1' )
	oBrowse:SetDescription( 'Pedido de Vendas ADVPL AVANÇADO' )

	aRotina := MenuDef()

	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

// ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.Model3MVc' OPERATION 2 ACCESS 0
// ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.Model3MVc' OPERATION 3 ACCESS 0
// ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.Model3MVc' OPERATION 4 ACCESS 0
// ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.Model3MVc' OPERATION 5 ACCESS 0
// ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.Model3MVc' OPERATION 8 ACCESS 0
// ADD OPTION aRotina Title 'Copiar'      Action 'VIEWDEF.Model3MVc' OPERATION 9 ACCESS 0
// ADD OPTION aRotina TITLE 'Cadastro de Cliente'       Action 'VIEWDEF.BRWMVC' OPERATION 3 ACCESS 0

	aAdd( aRotina, { 'Incluir'      				, 'VIEWDEF.Model3MVC', 0, 3, 0, NIL } )

Return aRotina

//===================================================================================================

//TESTE DA FUNCAO MPFORMMODEL NO BLOCO BPRE
// Static Function linePreGrid(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)
// Local lRet := .T.   

//   /* If cAction == "SETVALUE"
//       If oGridModel:GetValue("ZA2_TIPO") == "AUTOR"
//          lRet := .F.         
//          Help( ,, 'HELP',, 'Não é possível alterar linhas do tipo Autor', 1, 0)
//       EndIf
//    EndIf
//    */
// Return lRet
//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSC5 := FWFormStruct( 1, 'ZZ1', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oStruSC6 := FWFormStruct( 1, 'ZZ2', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oModel

	oModel := MPFormModel():New('MD3MVCADV')
	oModel:AddFields( 'SC5MASTER', /*cOwner*/, oStruSC5 )
	oModel:AddGrid( 'SC6DETAIL', 'SC5MASTER', oStruSC6 )

// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'SC6DETAIL', { { 'ZZ2_FILIAL', 'xFilial( "ZZ2" )' }, { 'ZZ2_COD', 'ZZ1_COD' } }, ZZ2->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey( {'ZZ1_COD'} )

// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'PV MVC ADVPL ++' )

// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SC5MASTER' ):SetDescription( 'CABEÇALHO PV' )
	oModel:GetModel( 'SC6DETAIL' ):SetDescription( 'ITEM PV'  )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oStrusc5 := FWFormStruct( 2, 'ZZ1' )
	Local oStrusc6 := FWFormStruct( 2, 'ZZ2' )
// Cria a estrutura a ser usada na View
	Local oModel   := Modeldef()
	Local oView

// Cria o objeto de View
	oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SC5', oStruSC5, 'SC5MASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid(  'VIEW_SC6', oStruSC6, 'SC6DETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 40 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )

// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SC5', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SC6', 'INFERIOR' )

// Define campos que terao Auto Incremento
	oView:AddIncrementField( 'VIEW_SC6', 'C6_ITEM' )

// Criar novo botao na barra de botoes
	oView:AddUserButton( 'CR', 'CLIPS', { |oView| FINA040() } )

// Liga a identificacao do componente
	oView:EnableTitleView('VIEW_SC5','CABEÇALHO')
	oView:EnableTitleView('VIEW_SC6','ITENS')

// Liga a Edição de Campos na FormGrid
//oView:SetViewProperty( 'VIEW_SC6', "ENABLEDGRIDDETAIL", { 50 } )
	oView:SetCloseOnOk( {|| .t.} )

Return oView


//-------------------------------------------------------------------
Static Function COMP021LPOS( oModelGrid )
	Local lRet       := .T.
	Local oModel     := oModelGrid:GetModel( 'ZA2DETAIL' )
	Local nOperation := oModel:GetOperation()

	If nOperation == 3 .OR. nOperation == 4

		If Mod( Val( FwFldGet( 'ZA2_AUTOR' )  ) , 2 )  <> 0
			Help( ,, 'Help',, 'So sao permitidos codigos pares', 1, 0 )
			lRet := .F.
		EndIf

	EndIf

Return lRet


//-------------------------------------------------------------------
Static Function COMP021POS( oModel )
	Local lRet       := .T.
	Local aArea      := GetArea()
	Local aAreaZA0   := ZA0->( GetArea() )
	Local nOperation := oModel:GetOperation()
	Local oModelZA2  := oModel:GetModel( 'ZA2DETAIL' )
	Local nI         := 0
	Local nCt        := 0
	Local lAchou     := .F.
	Local aSaveLines := FWSaveRows()

	ZA0->( dbSetOrder( 1 ) )

	If nOperation == 3 .OR. nOperation == 4

		For nI := 1 To  oModelZA2:Length()

			oModelZA2:GoLine( nI )

			If !oModelZA2:IsDeleted()
				If ZA0->( dbSeek( xFilial( 'ZA0' ) + oModelZA2:GetValue( 'ZA2_AUTOR' ) ) ) .AND. ZA0->ZA0_TIPO == '1'
					lAchou := .T.
					Exit
				EndIf
			EndIf

		Next nI

		If !lAchou
			Help( ,, 'Help',, 'Deve haver pelo menos 1 Autor', 1, 0 )
			lRet := .F.
		EndIf

		If lRet

			For nI := 1 To oModelZA2:Length()

				oModelZA2:GoLine( nI )

				If oModelZA2:IsInserted() .AND. !oModelZA2:IsDeleted() // Verifica se é uma linha nova
					nCt++
				EndIf

			Next nI

			If nCt > 2
				Help( ,, 'Help',, 'É permitida a inclusão de apenas 2 novos Autores/interpretes de cada vez', 1, 0 )
				lRet := .F.
			EndIf

		EndIf

	EndIf

	FWRestRows( aSaveLines )

	RestArea( aAreaZA0 )
	RestArea( aArea )

Return lRet


//-------------------------------------------------------------------
Static Function COMP021BUT()
	Local oModel     := FWModelActive()
	Local nOperation := oModel:GetOperation()
	Local aArea      := GetArea()
	Local aAreaZA0   := ZA0->( GetArea() )
	Local lOk        := .F.

//FWExecView( /*cTitulo*/, /*cFonteModel*/, /*nAcao*/, /*bOk*/ )

	If     nOperation == 3 // Inclusao
		lOk := ( FWExecView('Inclusao por FWExecView','COMP011_MVC', nOperation, , { || .T. } ) == 0 )

	ElseIf nOperation == 4

		ZA0->( dbSetOrder( 1 ) )
		If ZA0->( dbSeek( xFilial( 'ZA0' ) + FwFldGet( 'ZA2_AUTOR' ) ) )
			lOk := ( FWExecView('Alteracao por FWExecView','COMP011_MVC', nOperation, , { || .T. } ) == 0 )
		EndIf

	EndIf

	If lOk
		Help( ,, 'Help',, 'Foi confirmada a manutencao do Autor', 1, 0 )
	Else
		Help( ,, 'Help',, 'Foi cancelada a manutencao do Autor', 1, 0 )
	EndIf

	RestArea( aAreaZA0 )
	RestArea( aArea )

Return lOk

//-------------------------------------------------------------------
//Pontos de Entrada da Rotina 
//-------------------------------------------------------------------
User Function MD3MVCADV()

	Local _lRet         := .T.
	Local _aArea	    := GetArea()
	Local oModel        := ParamIXB[1]
	Local cIdPonto      := ParamIXB[2]
	Local cIdModel      := ParamIXB[3]

	If cIdPonto == 'MODELPRE' /* Chamada antes da alteração de qualquer campo do modelo. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'MODELPOS' /* Chamada na validação total do modelo. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'FORMPRE' /* Chamada na antes da alteração de qualquer campo do formulário. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'FORMPOS' /* Chamada na validação total do formulário. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'FORMLINEPOS' /* Chamada na validação da linha do formulário. */
		// Alert(cIdPonto)
	ElseIf cIdPonto == 'MODELVLDACTIVE' /* Chamada na validação da ativação do Modelo. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'MODELCOMMITTTS' /* Chamada apos a gravação total do modelo e dentro da transação. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'MODELCOMMITNTTS' /* Chamada apos a gravação total do modelo e fora da transação. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'FORMCOMMITTTSPRE' /* Chamada antes da gravação da tabela do formulário. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'FORMCOMMITTTSPOS' /* Chamada apos a gravação da tabela do formulário. */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'MODELCANCEL' /* Cancela */
		//Alert(cIdPonto)
	ElseIf cIdPonto == 'BUTTONBAR' /* Usado para Criação de Botoes Estrutura: { {'Nome', 'Imagem Botap', { || bBlock } } } */
		//Alert(cIdPonto)
		_lRet := {}
		aAdd(_lRet , {'Imprimir Boletos', 'BOLETO', { || FINA040()  }} )
	EndIf

	RestArea(_aArea)

Return _lRet

