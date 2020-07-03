#include 'protheus.ch'

User Function BuscaPed()

    Local cHtml     := ""
    Local cPedido   := HTTPPOST->PEDIDO
    Local cEmpresa  := HTTPPOST->EMPRESA
    Local cFili     := HTTPPOST->FILIAL
    Local nTot      := 0

    RpcSetEnv(cEmpresa,cFili)

    dbSelectArea("SC5")
    SC5->(dbSetOrder(1))
    If SC5->(dbSeek(xfilial("SC5") + cPedido))

        cHtml := '<html>'
        cHtml += '<head>'
        cHtml += '<meta content="text/html; charset=ISO-8859-1"'
        cHtml += 'http-equiv="content-type">'
        cHtml += '<title></title>'
        cHtml += '</head>'
        cHtml += '<body>'
        cHtml += 'Pedido : ' + SC5->C5_NUM + '<br>'
        cHtml += 'Cliente: ' + Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE, "A1_NOME" ) + ' <br>'
        cHtml += 'Condição de Pagamento: ' + Posicione("SE4", 1, xFilial("SE4") + SC5->C5_CONDPAG, "E4_DESCRI") + '<br>'
        cHtml += '<br>'

        cHtml += '<table style="text-align: left; width: 100%;" border="1" cellpadding="2"'
        cHtml += 'cellspacing="2">'
        cHtml += '<tbody>'
        cHtml += '<tr>'
        cHtml += '<td style="vertical-align: top;">Produto<br>'
        cHtml += '</td>'
        cHtml += '<td style="vertical-align: top;">Quantidade<br>'
        cHtml += '</td>'
        cHtml += '<td style="vertical-align: top;">Preço Total<br>'
        cHtml += '</td>'
        cHtml += '</tr>'

        dbselectArea("SC6")
        SC6->(DbsetOrder(1))
        SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))

        While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM

            cHtml += '<tr>'
            cHtml += '<td style="vertical-align: top;">' + SC6->C6_PRODUTO + '<br>'
            cHtml += '</td>'
            cHtml += '<td style="vertical-align: top;">' + cValtoChar(SC6->C6_QTDVEN) + '<br>'
            cHtml += '</td>'
            cHtml += '<td style="vertical-align: top;">' + Transform(SC6->C6_VALOR, PesqPict("SC6","C6_VALOR")) + ' <br>'
            cHtml += '</td>'
            cHtml += '</tr>'

            nTot += SC6->C6_VALOR
            SC6->(dbSkip())
        EndDo
        
        cHtml += '</tbody>'
        cHtml += '</table>
        cHtml += '<br>'


        cHtml += '<br><br>'
        cHtml += 'Total do Pedido: R$' + Transform(nTot, PesqPict("SC6","C6_VALOR")) + '<br>'

        cHtml += '</body>'      
        cHtml += '</html>'

    EndIf

    Conout(HTTPPOST->PEDIDO)

Return(cHtml)