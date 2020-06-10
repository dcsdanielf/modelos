#include 'protheus.ch'
#include 'parmtype.ch'

user function AulaI6WF()

Local oProcess
Local oHtml
Local cDestino	:= "dcs.danielf@gmail.com"
Local cHtml1	:= "\workflow\html\wfenv.htm"
Local cLink	    := ""
Local lSC		:= .F.
Local cProcess	:= ""
Local chtmlfile  := ""
Local cmailto    := ""
Local chtmltexto := ""
Local cTabela       := ""

//=========================================
//FUNCOES PARA GERAR O HTML
//=========================================
oProcess	:= TWFProcess():New("000001","Gera WF")
oProcess:NewTask('Inicio',cHtml1)
oProcess:bReturn	:= "U_RETWF()"

oHtml	:= oProcess:oHtml

cTabela := " <table> "
cTabela += "     <tr>"
cTabela += "         <td>Linha 1, Daniel</td>"
cTabela += "         <td>Linha 1, Anderson</td>"
cTabela += "     </tr>"
cTabela += "     <tr>"
cTabela += "         <td>Linha 2, Daniel</td>"
cTabela += "         <td>Linha 2, Eraldo</td>"
cTabela += "     </tr>"
cTabela += "     <tr>"
cTabela += "         <td>Linha 3, Coluna 1</td>"
cTabela += "         <td>Linha 3, Coluna 2</td>"
cTabela += "     </tr>"
cTabela += " </table>"

oHtml:ValByName("CABEC"		, "Exemplo de WF com HTML"	)
oHtml:ValByName("HEADER"	, "Abaixo informações sobre a situação ..." 	)
oHtml:ValByName("ITENS"		, cTabela	) 



//=========================================
//Configuração de Envio do WF
//=========================================

//Parte 1 - Gera Arquivo HTML e Salva na Pasta
oProcess:cTo		:= ""
oProcess:cBCC		:= ""
oProcess:cCC		:= ""
oProcess:cSubject	:= "Envio de WF"
oProcess:cBody		:= ""

cProcess := oProcess:Start("\workflow\html\new\")
chtmlfile  := cProcess + ".htm"

//Grava arquivo HTML gerado na Pasta do Server
wfsavefile("\workflow\html\new\", chtmlfile)



//Parte 2 - Envia arquivo  Html gerado como link no email
oProcess	:= TWFProcess():New("000002","ENVIA WF")
oProcess:NewTask('Envio','\workflow\html\home.html')


oHtml	:= oProcess:oHtml

oHtml:ValByName("usuario", "Daniel" )
oHtml:ValByName("proc_link", "http://localhost:8606/wf9901/workflow/html/new/" + chtmlfile)

oProcess:cTo		:= cDestino
oProcess:cBCC		:= ""
oProcess:cCC		:= ""
oProcess:cSubject	:= "Envio de WorkFlow Aula 5 "
oProcess:cBody		:= ""

cProcess := oProcess:Start("\workflow\html\new\")

Return

//=================================================================================

User Function RETWF(oProcess)

Local cRet := oProcess:oHtml:RetByName("OPC")

If cRet == "S"
    Conout(" PROCESSO RECEBIDO E CONFIRMADO PELO USUARIO _+!@#" )
Else
    Conout(" USUARIO REJEITOU O PEDIDO PELO WORKFLOW -----@@@@@" )
EndIF


Return