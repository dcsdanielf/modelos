#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function SE1MVC()
	Local oBrowse
	Private aRotina    := MenuDef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SE1')
	oBrowse:SetDescription('Cadastro Títulos a Receber em Atraso')
	oBrowse:SetFilterDefault( "E1_VENCREA < dDatabase " )
	oBrowse:DisableDetails()

	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar Título'   				, 'VIEWDEF.SE1MVC', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'INCLUIR Título'   				, 'VIEWDEF.SE1MVC', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'ALtera Título'   				, 'VIEWDEF.SE1MVC', 0, 4, 0, NIL } )

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel 	:= MPFormModel():New( 'SE1MVCA' )
	Local oStruZBD 	:= FWFormStruct( 1, 'SE1' )

	oModel:AddFields( 'SE1MASTER', , oStruZBD )
	oModel:SetDescription( 'Títulos a Receber em Atraso' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()

	Local oModel	:= FWLOADMODEL("SE1MVC")
	Local oStruZBD	:= FWFormStruct( 2, 'SE1')
	Local oView		:= FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_SE1', oStruZBD, 'SE1MASTER' )
	oView:CreateHorizontalBox( 'SUPERIOR', 80 )
    oView:CreateHorizontalBox( 'RODAPE', 20 )
	oView:SetOwnerView( 'VIEW_SE1', 'SUPERIOR' )
	oView:EnableTitleView( 'VIEW_SE1' )
    oView:AddOtherObject("OTHER_PANEL", {|oPanel| Aprova(oPanel,oModel)})
	oView:SetOwnerView("OTHER_PANEL",'RODAPE')
	oView:SetCloseOnOk( {|| .t.} )


Return oView

Static Function Aprova( oPanel,oModel )

	@ 30, 60 Button 'Aprovar'   Size 36, 13 Message 'Docente Aprovado' Pixel Action Alert("Função para outras coisas") of oPanel

Return NIL


//=============================================================

User Function SE1MVCA()


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
		_lRet := {}
        aAdd(_lRet , {'Imprimir Boletos', 'BOLETO', { || IMPRIMI(oModel)  }} )
	EndIf

	RestArea(_aArea)

Return _lRet

//===================================================================

Static Function IMPRIMI()

    Alert("Imprimindo Boleto.")

Return
