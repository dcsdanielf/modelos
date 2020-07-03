#include 'protheus.ch'

User Function BUSCCLI(CPF)

Local cRet := ""

    DEFAULT CPF := ""

    RpcSetEnv("99","01")

    If !Empty(CPF)

        dbSelectArea("SA1")
        SA1->(dbSetOrder(3))
        If SA1->(dbSeek(xFilial("SA1")+CPF))
            Conout("Nome do Cliente: " + SA1->A1_NOME)
            cRet := CPF + " = encontrado."
        else
            cRet := CPF + " não encontrado"
        EndIf
    
    else
            cRet := "não digitado!"

    EndIf
Return cRet