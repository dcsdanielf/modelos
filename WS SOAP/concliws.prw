#include 'Protheus.ch'

User Function Concli()

Local oWS := WSSERVICETIME():new()

If !Empty(oWs)
    oWs:GETSERVERTIME(" ")
    MsgAlert(oWs:cGETSERVERTIMERESULT)
else
    MsgAlert("Erro: " + GetWScError() + " ,Codigo: " + GetWScError(2) + " ,Descrição: " + GetWScError(3) )
    Conout("Erro: " + GetWScError() + " ,Codigo: " + GetWScError(2) + " ,Descrição: " + GetWScError(3) )
EndIf

Return