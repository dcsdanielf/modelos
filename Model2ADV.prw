#Include "TOTVS.CH"
#include "protheus.ch"

User Function Model2()

    LOCAL cAlias := "SX5"
    PRIVATE cCadastro := "Cadastro de Tabela Temporária"
    PRIVATE aRotina     := { }

//AADD(aRotina, { “Pesquisar”, “AxPesqui”, 0, 1 })
    AADD(aRotina, { "Visualizar"   , "U_tela"   , 0, 2 })
    AADD(aRotina, { "Incluir"      , "U_tela"   , 0, 3 })
    AADD(aRotina, { "Alterar"      , "U_tela"   , 0, 4 })
//AADD(aRotina, { “Excluir”     , “AxDeleta” , 0, 5 })

    dbSelectArea(cAlias)
    dbSetOrder(1)

    mBrowse(, , , , cAlias)

RETURN

//============================================================

User Function tela(cAlias,nRecno,nOpc)

    Local nOpcx             := nOpc
    Local cFilter           := ""      // FILTRO PARA A TABELA SX3

    Private cCLiente        := ""
    Private cLoja           := ""
    Private cTable          := GetNextAlias() // APELIDO DO ARQUIVO DE TRABALHO
    Private aGetEdit        := {"cCliente","cLoja","dData"}

//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+
  
    // ABERTURA DO DICIONÁRIO SX3
    OpenSXs(,,,, SM0->M0_CODIGO, cTable, "SX3",, .F.)
	
	cFilter := cTable + "->X3_ARQUIVO == 'SX5' "

    (cTable)->(DbSetFilter({|| &(cFilter)}, cFilter))
    (cTable)->(DbGoTop())

    nUsado:=0
    aHeader:={}

    While (cTable)->(!Eof()) .And. ((cTable)->(x3_arquivo) == "SX5")

        IF X3USO((cTable)->(x3_usado)) .AND. cNivel >= (cTable)->(x3_nivel)
            nUsado:=nUsado+1
            AADD(aHeader,{ TRIM((cTable)->(x3_titulo)),;
                (cTable)->(x3_campo),;
                (cTable)->(x3_picture),;
                (cTable)->(x3_tamanho),;
                (cTable)->(x3_decimal),;
                "ExecBlock('Md2valid',.f.,.f.)",;
                (cTable)->(x3_usado),;
                (cTable)->(x3_tipo), ;
                (cTable)->(x3_arquivo), ;
                (cTable)->(x3_context) } )
        Endif
        
        (cTable)->(dbSkip())
    EndDo

//+-----------------------------------------------+
//¦ Montando aCols para a GetDados                ¦
//+-----------------------------------------------+

    aCols:=Array(1,nUsado+1)
    // dbSelectArea("Sx3")
    // dbSeek("SX5")

    nUsado:=0
    (cTable)->(dbgoTop())

    While (cTable)->(!Eof()) .And. ((cTable)->x3_arquivo == "SX5")
        IF X3USO((cTable)->x3_usado) .AND. cNivel >= (cTable)->x3_nivel
            nUsado:=nUsado+1
            IF nOpcx == 3
                IF (cTable)->x3_tipo == "C"
                    aCOLS[1][nUsado] := SPACE((cTable)->x3_tamanho)
                Elseif (cTable)->x3_tipo == "N"
                    aCOLS[1][nUsado] := 0
                Elseif (cTable)->x3_tipo == "D"
                    aCOLS[1][nUsado] := dDataBase
                Elseif (cTable)->x3_tipo == "M"
                    aCOLS[1][nUsado] := ""
                Else
                    aCOLS[1][nUsado] := .F.
                Endif
            Endif
        Endif
        (cTable)->(dbSkip())
    End
    aCOLS[1][nUsado+1] := .F.


    //+----------------------------------------------+
    //¦ Variaveis do Cabecalho do Modelo 2           ¦
    //+----------------------------------------------+
    cCliente:=Space(6)
    cLoja   :=Space(2)
    dData   :=Date()

    //+----------------------------------------------+
    //¦ Variaveis do Rodape do Modelo 2
    //+----------------------------------------------+

    nLinGetD:=0

    //+----------------------------------------------+
    //¦ Titulo da Janela                             ¦
    //+----------------------------------------------+

    cTitulo:="TESTE DE MODELO2"

    //+----------------------------------------------+
    //¦ Array com descricao dos campos do Cabecalho  ¦
    //+----------------------------------------------+

    aC:={}


    AADD(aC,{"cCliente" ,{15,10} ,"Cod. do Cliente","@!",'ExecBlock("MD2VLCLI",.F.,.F.)',"SA1",})
    AADD(aC,{"cLoja"    ,{15,200},"Loja","@!",,,})
    AADD(aC,{"dData"    ,{27,10} ,"Data de Emissao",,,,})


    //+-------------------------------------------------+
    //¦ Array com descricao dos campos do Rodape        ¦
    //+-------------------------------------------------+

    aR:={}

    AADD(aR,{"nLinGetD" ,{120,10},"Linha na GetDados", "@E 999",,,.F.})

    //+------------------------------------------------+
    //¦ Array com coordenadas da GetDados no modelo2   ¦
    //+------------------------------------------------+

    aCGD:={44,5,150,340}

    //+----------------------------------------------+
    //¦ Validacoes na GetDados da Modelo 2           ¦
    //+----------------------------------------------+

    cLinhaOk := "ExecBlock('Md2LinOk',.f.,.f.)"
    cTudoOk  := "ExecBlock('Md2TudOk',.f.,.f.)"
    //+----------------------------------------------+
    //¦ Chamada da Modelo2                           ¦
    //+----------------------------------------------+
    // lRet = .t. se confirmou
    // lRet = .f. se cancelou

    lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetEdit,,,,,,.t.)

    If lRet
        Grava()
    else
        Alert("Cancelado")
    EndIF

    (cTable)->(dbCloseArea())

RETURN

//==========================================================

User Function Md2valid()

    Local lRet := .T.

    Alert("Md2valid")

Return(lRet)

//=============================================================

User Function MD2VLCLI()

    Local lRet := .T.

// Verifica se o Código do Cliente existe no Cadastro de Clientes

    IF ExistCpo("SA1", cCliente + cLoja)
        MsgAlert("Cliente aprovado")
    ELSE
        MsgAlert("Cliente não existe")
        lRet := .F.
    ENDIF

Return(lRet)

//================================================================
User Function Md2LinOk()

    Local lRet := .T.

Return(lRet)

//================================================================

User Function Md2TudOk()

    Local lRet := .F.

    lRet :=  MsgYesNO("Deseja gravar")

Return(lRet)

//================================================================

Static Function Grava()

    Local x
    Local aPosTab   := aScan(aHeader, {|x| Alltrim(x[2]) = "X5_TABELA"})
    Local aPosCHV   := aScan(aHeader, {|x| Alltrim(x[2]) = "X5_CHAVE"})
    Local aPosDes   := aScan(aHeader, {|x| Alltrim(x[2]) = "X5_DESCRI"})
    Local aPosDSP   := aScan(aHeader, {|x| Alltrim(x[2]) = "X5_DESCSPA"})
    Local aPosDEN   := aScan(aHeader, {|x| Alltrim(x[2]) = "X5_DESCENG"})


    For x := 1 to Len(acols)

        If !(aCols[x,nUsado+1])

            If INCLUI
                RecLock("SX5",.T.)

                SX5->X5_FILIAL  :=  xFilial("SX5")
                SX5->X5_TABELA  :=  aCols[x,aPosTab]
                SX5->X5_CHAVE   :=  aCols[x,aPosCHV]
                SX5->X5_DESCRI  :=  aCols[x,aPosDes]
                SX5->X5_DESCSPA :=  aCols[x,aPosDSP]
                SX5->X5_DESCENG :=  aCols[x,aPosDEN]

                SX5->(MsUnclock())
            EndIf

        ENDIF
    Next x

Return
