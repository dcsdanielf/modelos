#Include 'Protheus.ch'
#Include 'ParmType.ch'


//+------------+------------+--------+--------------------------------------------+
//| Fun��o:    | xFormula   | Autor: | David Alves dos Santos                     | 
//+------------+------------+--------+--------------------------------------------+
//| Descri��o: | Rotina para execu��o de fun��es dentro do Protheus.              |
//+------------+------------------------------------------------------------------+
//|------------------------> SigaMDI.net - Cursos Online <------------------------|
//+-------------------------------------------------------------------------------+
User Function xFormula()
	
	//-> Declara��o de vari�veis.
	Local bError 
	Local cGet1Frm := PadR("Ex.: u_NomeFuncao() ", 50)
	Local oDlg1Frm := Nil
	Local oSay1Frm := Nil
	Local oGet1Frm := Nil
	Local oBtn1Frm := Nil
	Local oBtn2Frm := Nil
	
	//-> Recupera e/ou define um bloco de c�digo para ser avaliado quando ocorrer um erro em tempo de execu��o.
	bError := ErrorBlock( {|e| cError := e:Description } ) //, Break(e) } )
	
	//-> Inicia sequencia.
	BEGIN SEQUENCE
	
		//-> Constru��o da interface.
		oDlg1Frm := MSDialog():New( 091, 232, 225, 574, " Fórmulas" ,,, .F.,,,,,, .T.,,, .T. )
		
		//-> R�tulo. 
		oSay1Frm := TSay():New( 008 ,008 ,{ || "Informe a sua função aqui:" } ,oDlg1Frm ,,,.F. ,.F. ,.F. ,.T. ,CLR_BLACK ,CLR_WHITE ,084 ,008 )
		
		//-> Campo.
		oGet1Frm := TGet():New( 020 ,008 ,{ | u | If( PCount() == 0 ,cGet1Frm ,cGet1Frm := u ) } ,oDlg1Frm ,150 ,008 ,'!@' ,,CLR_BLACK ,CLR_WHITE ,,,,.T. ,"" ,,,.F. ,.F. ,,.F. ,.F. ,"" ,"cGet1Frm" ,,)
		
		//-> Bot�es.
		oBtn1Frm := TButton():New( 040 ,008 ,"Executar" ,oDlg1Frm ,{ || &(cGet1Frm)    } ,037 ,012 ,,,,.T. ,,"" ,,,,.F. )
		oBtn2Frm := TButton():New( 040 ,120 ,"Sair"     ,oDlg1Frm ,{ || oDlg1Frm:End() } ,037 ,012 ,,,,.T. ,,"" ,,,,.F. )
		
		//-> Ativa��o da interface.
		oDlg1Frm:Activate( ,,,.T.)
	
	RECOVER
		
		//-> Recupera e apresenta o erro.
		ErrorBlock( bError )
		MsgStop( cError )
		
	END SEQUENCE
	
Return