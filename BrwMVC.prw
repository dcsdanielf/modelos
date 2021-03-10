#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MBRMVC()
	Local oBrowse
	Private aRotina    := MenuDef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SA1')
	oBrowse:SetDescription('Cadastro de Cliente Daniel MVC')
	oBrowse:DisableDetails()

	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

    Local aRotina := {}

    aAdd( aRotina, { 'Visualizar'   				, 'VIEWDEF.BrwMVC', 0, 2, 0, NIL } )
    aAdd( aRotina, { 'Incluir'      				, 'VIEWDEF.BrwMVC', 0, 3, 0, NIL } )
    aAdd( aRotina, { 'Alterar'    					, 'VIEWDEF.BrwMVC', 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Excluir'    					, 'VIEWDEF.BrwMVC', 0, 5, 0, NIL } )

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()

    Local oModel 	:= MPFormModel():New( 'SF69X04X' )
    Local oStruZBD 	:= FWFormStruct( 1, 'SA1' )

    oModel:AddFields( 'ZBDMASTER', , oStruZBD )
    oModel:SetDescription( 'Modelo de Dados de Autor/Interprete' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()

    Local oModel	:= FWloadModel("BRWMVC")
    Local oStruZBD	:= FWFormStruct( 2, 'SA1')
    Local oView		:= FWFormView():New()

oView:SetModel( oModel )
oView:AddField( 'VIEW_ZBD', oStruZBD, 'ZBDMASTER' )
oView:CreateHorizontalBox( 'SUPERIOR', 100 )
oView:SetOwnerView( 'VIEW_ZBD', 'SUPERIOR' )
oView:EnableTitleView( 'VIEW_ZBD' )
oView:SetCloseOnOk( {|| .t.} )
	
Return oView
