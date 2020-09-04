#include 'protheus.ch'

User Function ASPInit()
    conout("ASPINIT - Iniciando Thread Advpl ASP ["+cValToChar(ThreadID())+"]")
    SET DATE BRITISH
    SET CENTURY ON
Return .T.

//=====================================================================================================

USER Function ASPConn()
    Local cReturn := ''
    Local cAspPage
    Local nTimer

    cAspPage := HTTPHEADIN->MAIN

    If !empty(cAspPage)
        nTimer := seconds()
        cAspPage := LOWER(cAspPage)
        conout("ASPCONN - Thread Advpl ASP ["+cValToChar(ThreadID())+"] "+;
            "Processando ["+cAspPage+"]")
        do case
        case cAspPage == 'index'
            // Execura a p√°gina INDEX.APH compilada no RPO
            // A String retornada deve retornar ao Browser
            cReturn := H_INDEX()
        case cAspPage == 'formpost'
            // Executa a pagina FormPost
            cReturn := H_FORMPOST()
        case cAspPage == 'postinfo'
            // Executa a pagina PostInfo
            cReturn := H_POSTINFO()
            Migra()
        case cAspPage == 'aulaasp'
            cReturn := H_AULAASP()
        case cAspPage == 'tela'
            cReturn := H_TELA()
        case cAspPage == 'pesq'
            cReturn := H_PESQ()
        otherwise
            // retorna HTML para informar
            // a condi√ß√£o de p√°gina desconhecida
            cReturn := "<html><body><center><b>"+;
                "Pagina AdvPL ASP n„o encontrada."+;
                "</b></body></html>"
        Endcase
        nTimer := seconds() - nTimer
        conout("ASPCONN - Thread Advpl ASP ["+cValToChar(ThreadID())+"] "+;
            "Processamento realizado em "+ alltrim(str(nTimer,8,3))+ "s.")
    Endif

Return cReturn

//==================================

Static Function Migra()

Local cNome := HTTPPOST->FIRSTNAME
Local cSobrenome := HTTPPOST->LASTNAME

Conout("Retorno da funÁ„o de inclus„o xx como valor " + cNome + " " + cSobrenome ) 


Return
