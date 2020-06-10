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
            // Execura a página INDEX.APH compilada no RPO
            // A String retornada deve retornar ao Browser
            cReturn := H_INDEX()
        case cAspPage == 'formpost'
            // Executa a pagina FormPost
            cReturn := H_FORMPOST()
        case cAspPage == 'postinfo'
            // Executa a pagina PostInfo
            cReturn := H_POSTINFO()
        otherwise
            // retorna HTML para informar
            // a condição de página desconhecida
            cReturn := "<html><body><center><b>"+;
                "Página AdvPL ASP não encontrada."+;
                "</b></body></html>"
        Endcase
        nTimer := seconds() - nTimer
        conout("ASPCONN - Thread Advpl ASP ["+cValToChar(ThreadID())+"] "+;
            "Processamento realizado em "+ alltrim(str(nTimer,8,3))+ "s.")
    Endif

Return cReturn