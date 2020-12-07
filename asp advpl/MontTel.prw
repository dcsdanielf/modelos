#INCLUDE "PROTHEUS.CH"

User Function MontTel(nPedido)

Private cNome   := "Daniel Tavares Codigo zzzz"
Private cPed    := nPedido
Private cDtEnt  := "10/02/2021"
Private aPed    := {}

RpcSetEnv("99","01")

dbSelectArea("SC6")
SC6->(dbSetorder(1))
SC6->(dbSeek(xFilial("SC6") + "000001"))

While !EOF() .AND. SC6->C6_NUM = "000001"

    aAdd(aPed,{SC6->C6_PRODUTO, cValtoChar(SC6->C6_QTDVEN), cValtoChar(SC6->C6_PRCVEN),cValtoChar(SC6->C6_VALOR)})

SC6->(dbSkip())
EndDo

HttpSession->cNome := cNome
HttpSession->cPed := cPed
HttpSession->cDtEnt := cDtEnt
HttpSession->aPed := aPed

Return
