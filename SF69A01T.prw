#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} SF69A01W
@description MVC do Cadastro da Necessidade de Docentes

@author  Walmir Junior
@since   21/06/2020
@version 1.0 
/*/
User Function SF69A01T()

	Local oBrowse
	Private aRotina    := MenuDef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias( 'SC5' )
	oBrowse:SetDescription('Cadastro de Necessidade de Docentes')

	oBrowse:Activate()

Return Nil

/*/{Protheus.doc} MenuDef   
@description Montagem do Menu

@author  Walmir Junior
@since   21/06/2020
@version 1.0 
/*/
Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'   				, 'VIEWDEF.SF69A01T', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'      				, 'VIEWDEF.SF69A01T', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'    					, 'VIEWDEF.SF69A01T', 0, 4, 0, NIL } )

Return aRotina

/*/{Protheus.doc} ModelDef
@description Monta Model de apresentação

@author  Walmir Junior
@since   21/06/2020
@version 1.0 
/*/
Static Function ModelDef()

	Local oModel 	:= MPFormModel():New( 'SF69X01W' )
	Local oStruZBB 	:= FWFormStruct( 1, 'SC5' )

	oModel:AddFields( 'ZBBMASTER', , oStruZBB )


Return oModel

/*/{Protheus.doc} ViewDef
@description Apresentação do model e View junto

@author  Walmir Junior
@since   21/06/2020
@version 1.0 
/*/
Static Function ViewDef()

	Local oModel	:= ModelDef()
	Local oStruZBB	:= FWFormStruct( 2, 'SC5')
	Local oView		:= FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZBB', oStruZBB, 'ZBBMASTER' )
	oView:CreateHorizontalBox( 'SUPERIOR', 100 )
	oView:SetOwnerView( 'VIEW_ZBB', 'SUPERIOR' )
	oView:EnableTitleView( 'VIEW_ZBB' )
	oView:SetCloseOnOk( {|| .t.} )

Return oView
