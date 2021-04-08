#include 'protheus.ch'
#include 'fwmvcdef.ch'

User Function MD3MVC()

    Private aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias( 'SC5' )
    oBrowse:SetDescription('Grupo de Aprovação de Docente')
    oBrowse:DisableDetails()

    oBrowse:Activate()

Return Nil

//=======================================================================================================
Static Function MenuDef()

    Local aRotina := {}

    aAdd( aRotina, { 'Visualizar'   				, 'VIEWDEF.SF69A04T', 0, 2, 0, NIL } )
    aAdd( aRotina, { 'Incluir'      				, 'VIEWDEF.SF69A04T', 0, 3, 0, NIL } )
    aAdd( aRotina, { 'Alterar'    					, 'VIEWDEF.SF69A04T', 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Excluir'    					, 'VIEWDEF.SF69A04T', 0, 5, 0, NIL } )

Return aRotina
//=======================================================================================================

Static Function ModelDef()

    Local oModel 	:= MPFormModel():New( 'SF69X04T' )
    Local oStruZBD 	:= FWFormStruct( 1, 'SC5' )
    Local oStruZBE 	:= FWFormStruct( 1, 'SC6' )

    oModel:AddFields( 'ZBDMASTER', , oStruZBD )
    oModel:AddGrid('ZBEDETAIL','ZBDMASTER',oStruZBE)
    oModel:SetRelation('ZBEDETAIL',{ {'C6_FILIAL', 'xFilial("SC6")'}, {'C5_NUM','C6_NUM'}},SC6->(IndexKey(1)))
    oModel:SetPrimaryKey( {'C5_NUM'} )

Return oModel
//=======================================================================================================

Static Function ViewDef()

    Local oModel	:= ModelDef()
    Local oStruZBD	:= FWFormStruct( 2, 'SC5')
    Local oStruZBE 	:= FWFormStruct( 2, 'SC6')
    Local oView		:= FWFormView():New()

oView:SetModel( oModel )
oView:AddField( 'VIEW_ZBD', oStruZBD, 'ZBDMASTER' )
oView:AddGrid ( 'VIEW_ZBE', oStruZBE, 'ZBEDETAIL' )
oView:AddIncrementField( 'VIEW_ZBE',  'ZBE_ITEM'  )
oView:AddIncrementField( 'VIEW_ZBE',  'ZBE_COD'  )
oView:CreateHorizontalBox( 'SUPERIOR', 30 )
oView:CreateHorizontalBox( 'INFERIOR', 70 )
oView:SetOwnerView( 'VIEW_ZBD', 'SUPERIOR' )
oView:SetOwnerView ('VIEW_ZBE', 'INFERIOR' )
oView:EnableTitleView( 'VIEW_ZBD' )
oView:EnableTitleView( 'VIEW_ZBE' , 'Aprovadores')
oView:SetCloseOnOk( {|| .t.} )
	
Return oView

//-------------------------------------------------------------------
//Pontos de Entrada da Rotina 
//-------------------------------------------------------------------
User Function SF69X04T()

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
    EndIf
	
RestArea(_aArea)
	
Return _lRet
