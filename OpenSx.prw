#include "protheus.ch"

User Function OpenDic(cAlias, cEmp)

    Local lOpen   := .F.     // VALIDAÇÃO DE ABERTURA DE TABELA
    Local cFilter := ""      // FILTRO PARA A TABELA SX3

    cFilter := cTable + "->X3_ARQUIVO == " + cAlias

    // ABERTURA DO DICIONÁRIO SX3
    OpenSXs(NIL, NIL, NIL, NIL, cEmp, cTable, "SX3", NIL, .F.)
    lOpen := Select(cTable) > 0

    // CASO ABERTO FILTRA O ARQUIVO PELO X3_ARQUIVO "DIC",
    // DEFINE COMO TABELA CORRENTE E POSICIONA NO TOPO
 /*   If (lOpen)
        DbSelectArea(cTable)
        (cTable)->(DbSetFilter({|| &(cFilter)}, cFilter))
        (cTable)->(DbGoTop())
    EndIf
 */   
Return (lOpen)
