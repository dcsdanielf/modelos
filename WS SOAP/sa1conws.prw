#include 'Protheus.ch'

User Function SA1CLI()

    Local oWS := WSCONCLI():new()
    Local aRet := {}
    Local aPergs := {}
    Local oWSRet    := {}
    Local cNome     := ""
    Local cIdade    := ""
    Local cEnd      := ""
    Local oDialog   


    If !Empty(oWs)

        aAdd( aPergs ,{1,"CNPJ : "	,Space(9),PesqPict("SA1", "A1_CGC"),'.T.',,'.T.',40,.T.})
        ParamBox(aPergs ,"Parametros ",aRet)


        oWs:GETCLI(aRet[1])
        oWSRet := oWs:oWSGETCLIRESULT:OWSINFCLI[1]
        cNome   := oWSRet:cCNome
        cIdade  := oWSRet:cCIdade
        cEnd    := oWSRet:cCEnd


        Define MsDialog oDialog TITLE "Titulo" STYLE DS_MODALFRAME From 0,0 To 800,600 OF oMainWnd PIXEL
        @ 010,050 MSGET cNome SIZE 100,11 OF oDialog PIXEL PICTURE "@!" 
        @ 040,050 MSGET cIdade SIZE 100,11 OF oDialog PIXEL PICTURE "@!" 
        @ 090,050 MSGET cEnd SIZE 100,11 OF oDialog PIXEL PICTURE "@!" 
        ACTIVATE MSDIALOG oDialog  CENTERED

    else
        MsgAlert("Erro: " + GetWScError() + " ,Codigo: " + GetWScError(2) + " ,Descrição: " + GetWScError(3) )
        Conout("Erro: " + GetWScError() + " ,Codigo: " + GetWScError(2) + " ,Descrição: " + GetWScError(3) )
    EndIf

Return








Return