#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "font.ch"

// Nome       : Classe de Boleto Bancário do Banco do Brasil para Impressora Laser
// Descrição  : Esta Classe Permite a Impressão do Boleto Bancário em Relatório Gráfico TMSPrinter()
// Nota         Para usar esta classe o Título Financeiro precisa ter sido transferido para o Banco informado nos Parâmetros
// 			   Baseado na Especificação Técnica de Cobrança BB Versão 1 de 30/05/2007
// 			   Baseado na Especificação Técnica de Cobrança Bradesco de 10/2002
// 			   Baseado na Especificação Técnica de Cobrança Itaú de Setembro/2007
// 			   %E1_PORJUR%, %E1_VALJUR% e %E!_DESCFIN% são indicadores que podem ser usados nas mensagens do Boleto, que serão convertidos automaticamente pelos valores
// 			   Criado Funções de Modulo10, Modulo11, Nosso Número, Cód. de Barra e Linha Digitável Genéricas para os Principais Bancos
// 			   Site para Validação de Código de Barras: http://evandro.net/codigo_barras.htm
// 			   Site do FEBRABAN: http:// www.febraban.org.br/
// 			   Site de Conversão de Medidas: http:// www.translatorscafe.com/cafe/units-converter/typography/calculator/pixel-(X)-to-centimeter-%5Bcm%5D/
// 			   Pontos Específicos de Cada Banco no Código: 	Method NossoNro(), Method RetNossoNro() e Method CodBarra()    					 // Define o Código de Ba
                                                                  
// Campos Pers: - E1_ZZBLT (LOGICO) - Boleto Impresso? - SE1
// 			   - EE_ZZCART (CARAC. 3) - Carteira junto com os parâmetros do CNAB - SEE

// Cons.Pers  : - SA61 (Específico do BB - Filtro do Banco, tal como "001" ou "237", etc) 
// 			   - ZZBL (Consulta Esp da Tabela Z1 do SX5 - Mensagens para o Boleto) - Usar Função SX5DESF3("Z1",.T.,.T.)

// Ambiente   : Financeiro

// Autor      : Winston Dellano de Castro - Totvs IP Ribeirão
// Dt Criação : 19/01/2010

// Constantes de Margem das Páginas                                                                        
#DEFINE HMARGEM   050
#DEFINE VMARGEM   050

// Constantes para Alinhamento de Texto
#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

// ###############################
// UTILIZAÇÃO DA CLASSE DO BOLETO
// ###############################
/*USER FUNCTION DODO       
RPCSETENV("01","01","ADMIN","021084","FIN")
DEFINE WINDOW OMAINWND
U_BLTSAFRA()
ACTIVATE WINDOW OMAINWND
RETURN*/

// Função de Exemplo para Uso da Classe do Boleto para o Banco do Brasil
User Function BLTBB001()

	local oBoleto := nil
	local cFiltro := ""
	
	// Filtro para Teste da Classe
	// USAR FILTRO NA ORDEM 1 DO SE1: E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	// local cFiltro:="E1_FILIAL=='" + xFilial("SE1") + "' .AND. E1_PREFIXO == 'UNI' .AND. E1_NUM == '044722' .AND. E1_PARCELA == '  ' .AND. E1_TIPO == 'NF' "

	// Imprime Boleto do Banco do Brasil e Não Apresenta Perguntas na Inicialização
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("18")
	oBoleto := Boleto():new("001",.T.,cFiltro,1)

return

// Função de Exemplo para Uso da Classe do Boleto para o Banco Santander
User Function BolSAN()

	local oBoleto := nil
	local cFiltro := ""

	// Imprime Boleto do Banco Bradesco, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("101")
	oBoleto := Boleto():new("033",.T.,cFiltro,3)

return

// Função de Exemplo para Uso da Classe do Boleto para o Banco Bradesco
User Function BolBRA()

	local oBoleto := nil
	local cFiltro := ""

	// Imprime Boleto do Banco Bradesco, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("19")
	oBoleto := Boleto():new("237",.T.,cFiltro,2)

return

// Função de Exemplo para Uso da Classe do Boleto para o Banco Bradesco
User Function BolBRANew()

	local oBoleto := nil
	local cFiltro := ""

	// Imprime Boleto do Banco Bradesco, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("19")
	oBoleto := Boleto():new("237",.T.,cFiltro,3)

return

// Função de Exemplo para Uso da Classe do Boleto para o Banco Safra (Banco Correspondente = Bradesco)
User Function bltSafra()

	local oBoleto := nil
	local cFiltro := ""

	// Imprime Boleto do Banco Safra, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("09")
	oBoleto := Boleto():new("422",.T.,cFiltro,2)

return

// Função de Exemplo para Uso da Classe do Boleto para o Banco Itaú
User Function BolITA()

	local oBoleto := nil
	local cFiltro := ""

	// Imprime Boleto do Banco Itaú, Não Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("110")
	oBoleto := Boleto():new("341",.T.,cFiltro,2)

return

// Função de Exemplo para Uso da Classe do Boleto para o Banco Citibank
User Function BolCiti()

	local oBoleto := nil
	local cFiltro := ""

	// Imprime Boleto do Banco Itaú, Não Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("110")
	oBoleto := Boleto():new("745",.T.,cFiltro,2)

return

// Função de Exemplo para Uso da Classe do Boleto para o Banco Votorantim (Banco Correspondente = Itau)
User Function bltVtm()

	local oBoleto := nil
	local cFiltro := ""

	// Imprime Boleto do Banco Votorantim, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 1
	// Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	// e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	// Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("109")
	oBoleto := Boleto():new("655",.T.,cFiltro,1)

return

// ###############################
// DEFINIÇÃO DA CLASSE DO BOLETO
// ###############################

Class Boleto

	// Atributos para Seleção dos Dados a Imprimir
	Data cAlias
	Data cCpoMark
	Data cIndexName
	Data cIndexKey 
	Data cFilter
	Data lFiltrado
    
    // Atributos dos Dados para o Relatório
	Data cBanco
	Data aCampos
	Data aDadosEmp
	Data aDadosSel
	Data aDadosTit
	Data aDadosBanco
	Data aDadosSac
	Data cNossoNum
	Data cCodBarra
	Data cLinhaDig
	Data aFrases
	                  
	// Atributos para Geração do Relatório 
	Data oReport
	Data aLogoBco
	Data lMostraPrg
	Data cGrpPerg
	Data aPergs	
	Data cTamanho
	Data ctitulo 
	Data cDesc1  
	Data cDesc2 
	Data cDesc3
	Data wnrel  
	Data areturn
	Data nLastKey
	Data nModelo
	Data aPortado
	Data cLocal
	
	// Métodos
	Method new(cCodBanco,lPrgOnInit,cFiltro) Constructor	// Inicializa os Atributos da Classe
	Method openReport()										// Executa o Assistente e Dispara os outros métodos
	Method loadPergs()										// Carrega as Peguntas
	Method montaRel()										// Carrega os Dados e Dispara a Impressão
	Method nossoNro(cNossNroOld)							// Define o Nosso Número
	Method retNossoNro()									// Retorna o Nosso Número Formatado
	Method codBarra()										// Define o Código de Barras e a Linha Digitável
	Method printRel()								  		// Executa a Impressão do Boleto
	Method grvNossNum()										// Grava o Nosso Número no SE1
	Method ImpBolNovo(nRow, aBitMap)						// Impressao do novo modelo de boleto
	Method SayHeader(nLinha, nColuna, cTexto)				// Impressão do cabeçalho de campo no modelo 3
	Method SayInform(nLinha, nColuna, cTexto)				// Impressão da informação de campo no modelo 3				
				
End Class  

// Inicializa o Objeto Boleto e Abre o Assistente de Impressão do Relatório
/*cCodBanco disponíveis:
- 001 (BB) - Cart. 18 Convênio de 4, 6 e 7 Dígitos e Cart. 11
- 033 (SANTANDER)
- 104 (CEF)
- 237 (BRADESCO) - Carteira 19
- 422 (SAFRA) - Banco Correspondente
- 341 (ITAÚ)
- 655 (VOTORANTIM) - Banco Correspondente
- 409 (UNIBANCO)
 */
Method new(cCodBanco,lPrgOnInit,cFiltro,nModelo) Class Boleto

	default lPrgOnInit :=.F.         
	default cCodBanco  :="001" // Banco do Brasil
	default cFiltro    :=""
	default nModelo    :=1 // Modelos Disponíveis: 1 e 2

	// Inicializa Propriedades do Objeto
	::lMostraPrg  := lPrgOnInit // Indica se irá abrir as Perguntas na Inicialização
	::cBanco	  := cCodBanco // Informa o Código do Banco a ser gerado o Boleto
	::cNossoNum	  := ""
	::cCodBarra   := ""
	::cLinhaDig	  := ""
	::cLocal      := ""

	if !Empty(cFiltro)
		::cFilter  :=cFiltro // Filtro Passado pelo Usuário para Impressão Direta
		::lFiltrado:=.T.
	else 
		::cFilter  :=""
		::lFiltrado:=.F.
	endif
	
	if alltrim(cCodBanco) == "001"
		::cGrpPerg := padr("BLTBB1",len(SX1->X1_GRUPO))
	elseif alltrim(cCodBanco) == "033"	
		::cGrpPerg := padr("BLTSAN",len(SX1->X1_GRUPO))			
	elseif alltrim(cCodBanco) == "422"
		::cGrpPerg := padr("BLTSAFRA",len(SX1->X1_GRUPO))
	elseIf allTrim(cCodBanco) == "237"
		::cGrpPerg := padr("BLTBRA",len(SX1->X1_GRUPO))		
	else
		::cGrpPerg := padr("BLTVTM",len(SX1->X1_GRUPO))
	endif

	::aCampos	  :={}
	::aDadosSel   :={}
	::aDadosEmp   :={}
	::aDadosTit   :={}
	::aDadosBanco :={}
	::aDadosSac   :={}
	::aFrases	  :={}
	::aPergs	  :={}     
	::cTamanho 	  :="M"
	::ctitulo  	  :="Impressao de Boleto com Codigo de Barras"
	::cDesc1   	  :="Este programa destina-se a impressao do Boleto Bancario com Codigo de Barras."
	::cDesc2   	  :="Será impresso somente os títulos transferidos para Cobrança Simples."
	::cDesc3   	  :=""
	::cAlias  	  :="SE1"
	::cCpoMark	  :="E1_OK"
	::wnrel    	  :="BOLETO" // Nome do Arquivo do Relatório
	::nModelo	  :=nModelo // Modelo de Layout do Boleto
	::aPortado    :={}
	
	// Tipo do Formulário, Margem, Destinatário, Formato de Impressão, Dispositivo, Driver, Filtro Usuário,    
	::areturn  	  :={"Zebrado", 1,"Administracao", 2, 2, 1, "",1 } 
	::nLastKey 	  :=0
	
	// Define o logotipo do banco
	Do Case
		Case ::cBanco == "001" // (Banco do Brasil)
			::aLogoBco	  := {"System\Bitmaps\LOGOBB.BMP"}
			::cDesc3	  := "Especifico para o Banco do Brasil."
		Case ::cBanco == "033" // (Santander)
			::aLogoBco	  := {"System\Bitmaps\LOGOSAN.BMP"}
			::cDesc3	  := "Especifico para o Banco Santander."
		Case ::cBanco == "104" // (Caixa Economica Federal)
			::aLogoBco	  := {"System\Bitmaps\LOGOCEF.BMP"}
			::cDesc3	  := "Especifico para o Banco Caixa Economica Federal."
		Case ::cBanco == "237" // (Bradesco)
			::aLogoBco	  := {"System\Bitmaps\LOGOBRA.BMP"}
			::cDesc3	  := "Especifico para o Banco Bradesco."
		Case ::cBanco == "422" // (Safra)
			::aLogoBco := {}			
			aAdd (::aLogoBco, "System\Bitmaps\LOGOBRA.BMP") //Alterado por Ectore Cecato em 25/09/13 - Solicitado por Rodrigo Marchiori
			aAdd (::aLogoBco, "System\Bitmaps\LOGOBRA.BMP")
			::cDesc3	  := "Especifico para o Banco Safra."
		Case ::cBanco == "341" // (Itaú)  
			::aLogoBco 	  := {"System\Bitmaps\LOGOITAU.JPG"}
			::cDesc3	  := "Especifico para o Banco Itau."
		Case ::cBanco == "745" // (CitiBank)
			::aLogoBco	  := {"System\Bitmaps\LOGOCITI.BMP"}
			::cDesc3	  := "Especifico para o Banco Itau."
		Case ::cBanco == "655" // (Votorantim)
			::aLogoBco	  := {"System\Bitmaps\LOGOITAU.BMP"} // {"System\Bitmaps\LOGOVT01.JPG"}
			::cDesc3	  := "Especifico para o Banco Itau." // "Especifico para o Banco Votorantim."
		Case ::cBanco == "409" // (Unibanco)
			::aLogoBco	  := {"System\Bitmaps\LOGOUNI.BMP"}
			::cDesc3	  := "Especifico para o Banco Unibanco."
	EndCase

	// Inicializa a Classe TMSPrinter (Relatório Gráfico) e Define Propriedades Gerais
	::oReport:= TMSPrinter():new("Boleto Laser")
	::oReport:StartPage()     // Inicia uma nova página
	::oReport:SetPage(9) 	  // Define como Tamanho A4
	::oReport:SetPortrait()   // ou SetLandscape()
	::oReport:SetLoMetricMode() // Each logical unit is converted to 0.1 millimeter. Positive x is to the right; positive y is up.
		
	// Abre a Tela do Assistente de Impressão, juntamente com a opção para seleção dos títulos
	::openReport()
return Self

// Abre o Assistente do Relatório, Executa o Seletor para Definir os Registros a Imprimir, 
// Carrega os Dados para a Memória e Executa a Impressão
Method openReport() Class Boleto

	local lExec		 := .F.  
	local nI		 := 1
	
	private areturn	 := ::areturn
	private nLastKey := ::nLastKey
	private cMarca   := GetMark()
	private lInverte := .T.
    
	// Carrega as Perguntas
	If !::loadPergs()
		Return	
	EndIf

	// Cria a interface para impressão do relatório
	// Desabilita os parâmetros se tiver sido passado um filtro específico do Título a ser impresso
	// Sintaxe: SetPrint(<cAlias>,<cProgram>,[cPergunte],[cTitle],[cDesc1],[cDesc2],[cDesc3],[lDic],[aOrd],[lCompres],[cSize],[uParm12],[lFilter],[lCrystal],[cNameDr],[uParm16],[lServer],[cPortPrint])-->creturn
	// dellano ::Wnrel := SetPrint(::cAlias,::Wnrel,Iif(::lFiltrado,"",::cGrpPerg),@::cTitulo,::cDesc1,::cDesc2,::cDesc3,.F.,,,::cTamanho,,)
	
	// Se o usuário pressionar ESC ou Cancelar o Assistente de Impressão
	if nLastKey == 27
		Set Filter to // Limpa o Filtro
		return .T.    // Finaliza o Método
	endif
	
	// Prepara o Ambiente de Impressão conforme de acordo com o Array areturn
	// Sintaxe: Setdefault (<areturn>,<cAlias>,[uParm3],[uParm4],[cSize],[nFormat])
	// dellano Setdefault(areturn,::cAlias,,,::cTamanho)
	
	// Se o usuário pressionar ESC ou Cancelar o Assistente de Impressão
	if nLastKey == 27
		Set Filter to // Limpa o Filtro
		return .T.    // Finaliza o Método
	endif
	
	if ::lFiltrado // Se foi filtrado pelo usuário não apresenta a seleção de títulos e Imprime Direto o Título
		CursorWait() // Mostra Ampulheta
		
		// Abre o Arquivo de Títulos a Receber e Filtra com utilizando o Filtro Passado na Instanciação do Objeto$		
		dbSelectArea(::cAlias) 
		dbSetOrder(1) // Ordem do Filtro: E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		dbSetFilter({|| .T. },::cFilter) // Filtro Precisa seguir a ordem 1 do SE1
		dbGoTop()		
				
		Processa({||::MontaRel()},"Imprimindo Boleto...") // Exibe a Régua de Processamento e Executa a Impresão do Relatório
		
		CursorArrow() // Libera Ampulheta	
	else	
		// Carrega Informações dos Campos para a Listagem de Seleção dos Títulos com MarkBrowse
		aAdd(::aCampos,{"E1_OK      ",""})		
		aAdd(::aCampos,{"E1_ZZDGRVD ","Cidade","@!"})
		aAdd(::aCampos,{"E1_TIPO    ","Tipo","@!"})
		aAdd(::aCampos,{"E1_PREFIXO ","Prefixo","@!"})
	    aAdd(::aCampos,{"E1_NUM     ","Titulo","@!"})
		aAdd(::aCampos,{"E1_PARCELA ","Parcela","@!"})
		aAdd(::aCampos,{"E1_PORTADOR","Portador","@!"})//incluido por fabio assarice
		aAdd(::aCampos,{"E1_CLIENTE ","Cliente","@!"}) 
		aAdd(::aCampos,{"E1_LOJA    ","Loja","@!"})
		aAdd(::aCampos,{"E1_NOMCLI  ","Nome Cliente","@!"})
		aAdd(::aCampos,{"E1_NATUREZ ","Natureza","@!"}) 
		aAdd(::aCampos,{"E1_EMISSAO ","Emissao","@!"})
		aAdd(::aCampos,{"E1_VENCREA ","Vencto","@!"})
		aAdd(::aCampos,{"E1_VALOR   ","Valor","@EZ 999,999,999.99"})
		aAdd(::aCampos,{"E1_SALDO   ","Saldo","@EZ 999,999,999.99"})
		aAdd(::aCampos,{"E1_PEDIDO  ","Pedido","@!"})
		aAdd(::aCampos,{"E1_NUMBCO  ","Nosso Nro","@!"})		
        

		// Obteem o portador pertinente ao banco
		dbSelectArea("SA6")
		SA6->(dbOrderNickName('ZZSA601')) // A6_FILIAL+A6_ZZBANCO
		SA6->(dbSeek(xFilial("SA6")+MV_PAR17))
		While SA6->(!Eof()) .AND. SA6->(A6_FILIAL+A6_ZZBANCO) == xFilial("SA6")+MV_PAR17 		        
			If Empty(MV_PAR18) .AND. Empty(MV_PAR19)  		
				aAdd (::aPortado, SA6->A6_COD )
			Else
				If SA6->A6_COD >= MV_PAR18 .AND. SA6->A6_COD <= MV_PAR19
					aAdd (::aPortado, SA6->A6_COD )					
				EndIf				
			EndIf
			SA6->(dbSkip())					
		EndDo			
		If Len(::aPortado) == 0
				MsgAlert("Atenção: Nenhum titulo encontrado com parâmetros informados.","Atenção")
			Return .T.		
		EndIf				
		// Fim
						
		// Define os Detalhes do Índice e Filtro para Seleção dos Títulos
		// Filtra somente os Títulos Transferidos para o Banco, Agência e Conta Informado nos Parâmetros
		::cIndexName	:= Criatrab(Nil,.F.) // Busca um arquivo válido para o índice temporário e retorna o nome do índice
	    // Alterado por junior Bordin
	    //::cIndexKey	:= "E1_ZZDGRVD+E1_PREFIXO+E1_NUM+E1_PARCELA+DTOS(E1_EMISSAO)" // Define o Índice de Ordenação
		::cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+DTOS(E1_EMISSAO)" // Define o Índice de Ordenação
		::cFilter	:= "E1_FILIAL=='" + xFilial("SE1") + "' .And. "
		::cFilter	+= "E1_PREFIXO>='" + MV_PAR01 + "' .And. E1_PREFIXO<='" + MV_PAR02 + "' .And. " 
		::cFilter	+= "E1_NUM>='" + MV_PAR03 + "' .And. E1_NUM<='" + MV_PAR04 + "' .And. "
		::cFilter	+= "E1_PARCELA>='" + MV_PAR05 + "' .And. E1_PARCELA<='" + MV_PAR06 + "' .And. "
		::cFilter	+= "E1_CLIENTE>='" + MV_PAR07 + "' .And. E1_CLIENTE<='" + MV_PAR09 + "' .And. "
		::cFilter	+= "E1_LOJA>='" + MV_PAR08 +"' .And. E1_LOJA<='" + MV_PAR10 + "' .And. "
		::cFilter	+= "DTOS(E1_EMISSAO)>='" + DTOS(MV_PAR11) + "' .and. DTOS(E1_EMISSAO)<='" + DTOS(MV_PAR12) + "' .And. "
		::cFilter	+= "DTOS(E1_VENCREA)>='" + DTOS(MV_PAR13) + "' .and. DTOS(E1_VENCREA)<='" + DTOS(MV_PAR14) + "' .And. "
		::cFilter	+= "E1_NUMBOR>='" + MV_PAR15 + "' .And. E1_NUMBOR<='" + MV_PAR16 + "' .And. E1_NUMBOR <> ' ' .And. ( "
		For nI:=1 To Len(::aPortado)
			::cFilter	+= "E1_PORTADO=='" + ::aPortado[nI] + "' " + IF(nI!=Len(::aPortado), " .OR. ", " ")
		Next nI	
		::cFilter	+= " ) .AND. E1_AGEDEP>='" + MV_PAR20 + "' .And. E1_AGEDEP<='" + MV_PAR21 + "' .And. "
		::cFilter	+= "E1_CONTA>='" + MV_PAR22 + "' .And. E1_CONTA<='" + MV_PAR23 + "' "
		
		// Alimenta um Índice Temporário de acordo com os parâmetros passados e filtra os dados
		MsgRun("Selecionando Registros. Por favor aguarde...",,{|| IndRegua("SE1", ::cIndexName, ::cIndexKey,, ::cFilter)})
		
		// Abre o Arquivo de Títulos a Receber Filtrados
		dbSelectArea(::cAlias)
		#IFNDEF TOP // Se não for Top
			// Agrega o índice ao Alias Ativo - OrdBagExt() - retorna a extensão do índice utilizado
			dbSetIndex(::cIndexName + OrdBagExt()) 
		#endif
		dbGoTop()
	
		// Abre Caixa de Diálogo no Formato MarkBrowse para Seleção dos Títulos a Imprimir
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
		@ 001,001 TO 170,350 BROWSE ::cAlias FIELDS ::aCampos OBJECT oMark MARK ::cCpoMark
		oMark:oBrowse:lCanAllMark:=.T. // Indica se habilita(.T.)/desabilita(.F.) a opção de marcar todos os registros do browse.
		
		// Define os Botões de Ação na Tela de Seleção dos Títulos
		TBUTTON():new(180,240,"Marcar/Desm.",oDlg,{|| oMark:oBrowse:AllMark()},35,11,,,,.T.) // Seleciona/Deseleciona Todos os Registros	
		@ 180,280 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg)) // Executar
		@ 180,310 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg)) // Cancelar
		
		ACTIVATE DIALOG oDlg CENTERED
	
		CursorWait() // Mostra Ampulheta
	
		if lExec // Se marcado para executar
			Processa({||::MontaRel()},"Imprimindo Boleto...") // Exibe a Régua de Processamento e Executa a Impresão do Relatório
		endif
		
		RetIndex(::cAlias) // Retorna a quantidade de índices ativos para um Alias aberto no sistema.
		Ferase(::cIndexName+OrdBagExt())	// Apaga o Arquivo do Índice Temporário
		
		CursorArrow() // Libera Ampulheta	
	endif
return .T.

// Cria ou Modifica o Grupo de Perguntas e o Carrega na Memória, tendo a opção de mostrar as perguntas
// antes de abrir o assistente de impressão
Method loadPergs() Class Boleto
	Local lRet	:= .F.
	
	// Carrega o Grupo de Perguntas a ser gravado no SX1
	aAdd(::aPergs,{"De Prefixo"			,"","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Prefixo"		,"","","mv_ch2","C",03,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Numero"			,"","","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Numero"			,"","","mv_ch4","C",09,0,0,"G","","MV_PAR04","","","","ZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Parcela"			,"","","mv_ch5","C",01,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Parcela"		,"","","mv_ch6","C",01,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Cliente"			,"","","mv_ch7","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(::aPergs,{"De Loja"			,"","","mv_ch8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Cliente"		,"","","mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(::aPergs,{"Ate Loja"			,"","","mv_cha","C",02,0,0,"G","","MV_PAR10","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Emissao"			,"","","mv_chb","D",08,0,0,"G","","MV_PAR11","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Emissao"		,"","","mv_chc","D",08,0,0,"G","","MV_PAR12","","","","31/12/19","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Vencimento"		,"","","mv_chd","D",08,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Vencimento"		,"","","mv_che","D",08,0,0,"G","","MV_PAR14","","","","31/12/19","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Do Bordero"			,"","","mv_chf","C",06,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Bordero"		,"","","mv_chg","C",06,0,0,"G","","MV_PAR16","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Banco"				,"","","mv_chh","C",03,0,0,"S","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Portador"		,"","","mv_chi","C",03,0,0,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Portador"		,"","","mv_chj","C",03,0,0,"G","","MV_PAR19","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Agencia"			,"","","mv_chk","C",05,0,0,"G","","MV_PAR20","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Agencia"		,"","","mv_chl","C",05,0,0,"G","","MV_PAR21","","","","ZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De C/C"				,"","","mv_chm","C",10,0,0,"G","","MV_PAR22","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate C/C"			,"","","mv_chn","C",10,0,0,"G","","MV_PAR23","","","","ZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Sub-Conta"			,"","","mv_cho","C",03,0,0,"S","","MV_PAR24","","","","001","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Mensagem 1"			,"","","mv_chp","C",99,0,0,"G","","MV_PAR25","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Mensagem 2"			,"","","mv_chq","C",99,0,0,"G","","MV_PAR26","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Mensagem 3"			,"","","mv_chr","C",99,0,0,"G","","MV_PAR27","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	// Cria ou Modifica o Grupo de Perguntas
	AjustaSx1(::cGrpPerg,::aPergs)
	
	SX1->(dbSetOrder(1))
	if SX1->(dbSeek( ::cGrpPerg + "17" ))	// Banco
		RecLock("SX1",.F.)
			if ::cBanco == "001"
				SX1->X1_CNT01 := alltrim(getMv("ZZ_BBBCO"))
			elseif ::cBanco == "033"
				SX1->X1_CNT01 := Padr(getMv("ZZ_SANBCO"),TamSx3("A6_COD")[1])							
			elseif ::cBanco == "655"
				SX1->X1_CNT01 := alltrim(getMv("ZZ_VTBCO"))
			elseif ::cBanco == "422"
				SX1->X1_CNT01 := alltrim(getMv("ZZ_SFBCO"))
			elseif ::cBanco == "341"
				SX1->X1_CNT01 := alltrim(getMv("ZZ_ITAUBCO"))
			elseif ::cBanco == "745"
				SX1->X1_CNT01 := alltrim(getMv("ZZ_CITIBCO"))
			elseIf ::cBanco == "237"
				SX1->X1_CNT01 := Padr(getMv("ZZ_BRABCO"),TamSx3("A6_COD")[1])
			endif
		SX1->(MsUnLock())	
	endif

	// Carrega o Grupo de Perguntas para as Variáveis de Memória e não apresenta em Tela
	if ::lFiltrado // Se filtrado somente carrega as variáveis mas não apresenta em tela
		lRet := Pergunte (::cGrpPerg,.F.)
	else
		lRet := Pergunte (::cGrpPerg,::lMostraPrg)
	endif
return (lRet)

// Carrega os Dados a Imprimir para a Memória em Arrays e Executa a Impressão o Relatório
Method montaRel() Class Boleto

	local nTit	:=0
	local nItens:=0
	local nPos  :=0
	local nCont :=0
	
    private cCodCli	  := ""
    private cLojCli	  := ""
    private cNumNf	  := ""
    private cSerie	  := ""
	private cDadosSac := ""
	private cNumTit	  := ""
	private cSerietit := ""
	private lPrimImp  := .T. // .T. = Define se está na primeira impressão da página (parte superior) ou .F. = Parte inferior da página.
	
	// Carrega Dados da Empresa
	aAdd(::aDadosEmp,AllTrim(SM0->M0_NOMECOM) + " CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")) 	// [1]Nome da Empresa
	//aAdd(::aDadosEmp,"RED S.A. CNPJ:67.915.785/0001-01") 											// [1]Nome da Empresa

	aAdd(::aDadosEmp,AllTrim(SM0->M0_ENDCOB)) 																// [2]Endereço
	aAdd(::aDadosEmp,AllTrim(SM0->M0_BAIRCOB)+", "+alltrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB) 	// [3]Complemento
	aAdd(::aDadosEmp,"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)) 				// [4]CEP
	aAdd(::aDadosEmp,"PABX/FAX: "+SM0->M0_TEL) 												    	// [5]Telefones
	aAdd(::aDadosEmp,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))  				    	// [6]CNPJ
	aAdd(::aDadosEmp,"I.E.: "+Transform(SM0->M0_INSC,"@R 999.999.999.999")) 						// [7]I.E

	dbGoTop()
	ProcRegua(SE1->(RecCount())) // Define o Tamanho Máximo da Régua de Processamento	

	Do While SE1->(!EOF()) // Percorre o Arquivo do SE1 Ativo que está filtrado	
		
		IncProc()  // Incrementa a Régua de Processamento
		nItens+= 1 // Contabiliza Itens a Percorrer
		
		dbSelectArea("SE1")
		
		if !Marked("E1_OK")
			dbSkip()
			Loop
		endif

		If aScan( ::aPortado, SE1->E1_PORTADO  ) == 0		
			MsgAlert("ATENÇÂO: O titulo "+Alltrim(SE1->E1_NUM)+" já foi impresso no layout de outro banco. Este, não será impresso!","TITULO INVÁLIDO")
			dbSkip()
			Loop
		EndIf
		
		// dellano if IsMark(::cCpoMark,cMarca,lInverte) .Or. ::lFiltrado
		// Posiciona o SA6 (Bancos)
		dbSelectArea("SA6")
		dbSetOrder(1)
		dbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)

		// Posiciona na Arq de Parâmetros do Banco / CNAB
		dbSelectArea("SEE")
		dbSetOrder(1) // EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
		dbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)+MV_PAR24,.T.)
										 				
		// Posiciona o SA1 (Cliente)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
		cCodCli := SA1->A1_COD
		cLojCli	:= SA1->A1_LOJA
								
		// Carrega os Dados do Banco
		::aDadosBanco := {}
		aAdd(::aDadosBanco,SA6->A6_ZZBANCO)											   		// [1]Numero do Banco
		aAdd(::aDadosBanco,SA6->A6_NREDUZ)													// [2]Nome do Banco
		aAdd(::aDadosBanco,StrZero(Val(subStr(SA6->A6_AGENCIA,1,4)),4))						// [3]Agência
		aAdd(::aDadosBanco,AllTrim(SA6->A6_NUMCON))											// [4]Conta Corrente Sem o DAC
		aAdd(::aDadosBanco,SA6->A6_DVCTA)													// [5]Dígito da conta corrente
		aAdd(::aDadosBanco,"18-019") 														// [6]Codigo da Carteira Completo
//		aAdd(::aDadosBanco,IIf(SA6->A6_ZZBANCO == "237", "09", alltrim(SEE->EE_ZZCART)))	// [7]Carteira - Campo Pers. no SEE
		aAdd(::aDadosBanco,alltrim(SEE->EE_ZZCART))											// [7]Carteira - Campo Pers. no SEE
		aAdd(::aDadosBanco,alltrim(SEE->EE_CODEMP)) 										// [8]Convênio do Banco
		aAdd(::aDadosBanco,Len(alltrim(SEE->EE_CODEMP))) 									// [9]Nº de Dígitos do Convênio do Banco
		aAdd(::aDadosBanco,SEE->EE_FAXATU) 													// [10]Nº Seq. Interno para Uso com o Boleto
		
		aAdd(::aDadosBanco,AllTrim(SM0->M0_NOMECOM) + "CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
//		aAdd(::aDadosBanco,"RED S.A. CNPJ: 67.915.785/0001-01")
		//inicio Apply 2018-07     
		If ::cBanco == "341"
		aAdd(::aDadosBanco,alltrim(SA6->A6_NUMCON)+SA6->A6_DVCTA)           							// [12 Conta Corrente completa
		Else
		aAdd(::aDadosBanco,SA6->A6_NUMCON)													// [12 Conta Corrente completa
		Endif     
        //fim apply  																		
		aAdd(::aDadosBanco,SA6->A6_ZZDESBL)													// [13]Percentual de desconto do boleto
		aAdd(::aDadosBanco,SA6->A6_ZZTPDES)													// [14]Tipo do desconto (1-Texto/2-Valor)
		aAdd(::aDadosBanco,AllTrim(SEE->EE_ZZCEDEN))										// [15]Codigo Cedente								
		aAdd(::aDadosBanco,SA6->A6_DVAGE )													// [16]Digito da agencia
        aAdd(::aDadosBanco,"" )																// [17]Agência / Código Beneficiário
                                                                                  
		// Carrega os Dados do Cliente
		::aDadosSac:={}
		if Empty(SA1->A1_ENDCOB)
			aAdd(::aDadosSac,alltrim(SA1->A1_NOME))						    		// [1]Razão Social
			aAdd(::aDadosSac,alltrim(SA1->A1_COD)+"-"+SA1->A1_LOJA)		    		// [2]Código
			aAdd(::aDadosSac,alltrim(SA1->A1_END)+"-"+alltrim(SA1->A1_BAIRRO)) 		// [3]Endereço			
//			aAdd(::aDadosSac,alltrim(SA1->A1_MUN))							    	// [4]Cidade
			aAdd(::aDadosSac,alltrim(Posicione("ACY",1,xFilial("ACY")+A1_GRPVEN,"ACY_DESCRI" )))   	// [4]Cidade			
			aAdd(::aDadosSac,SA1->A1_EST)											// [5]Estado
			aAdd(::aDadosSac,SA1->A1_CEP) 											// [6]CEP
			aAdd(::aDadosSac,SA1->A1_CGC) 									    	// [7]CNPJ
			aAdd(::aDadosSac,SA1->A1_PESSOA)								    	// [8]PESSOA
		else
			aAdd(::aDadosSac,alltrim(SA1->A1_NOME))						    		// [1]Razão Social
			aAdd(::aDadosSac,alltrim(SA1->A1_COD)+"-"+SA1->A1_LOJA)		    		// [2]Código
			aAdd(::aDadosSac,alltrim(SA1->A1_ENDCOB)+"-"+alltrim(SA1->A1_BAIRROC))	// [3]Endereço
//			aAdd(::aDadosSac,alltrim(SA1->A1_MUNC))							    	// [4]Cidade
			aAdd(::aDadosSac,alltrim(Posicione("ACY",1,xFilial("ACY")+SA1->A1_GRPVEN,"ACY_DESCRI" )))   	// [4]Cidade
			aAdd(::aDadosSac,SA1->A1_ESTC)											// [5]Estado
			aAdd(::aDadosSac,SA1->A1_CEPC) 											// [6]CEP
			aAdd(::aDadosSac,SA1->A1_CGC) 									    	// [7]CNPJ
			aAdd(::aDadosSac,SA1->A1_PESSOA)								    	// [8]PESSOA
		endif
		cDadosSac	:= ::aDadosSac[2]
		// Carrega os Dados do Título
		::aDadosTit:={}
		aAdd(::aDadosTit,alltrim(SE1->E1_NUM)+alltrim(SE1->E1_PARCELA))				// [1] Número do título
		aAdd(::aDadosTit,SE1->E1_EMISSAO)											// [2] Data da emissão do título
		aAdd(::aDadosTit,dDataBase)													// [3] Data da emissão do boleto
		aAdd(::aDadosTit,SE1->E1_VENCREA)                 							// [4] Data do vencimento
		aAdd(::aDadosTit,((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE) - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)))// [5] Valor do título
		aAdd(::aDadosTit,SE1->E1_PREFIXO )     										// [6] Prefixo do Título
		If ::cBanco == "745"
			aAdd(::aDadosTit,"DMI")    												// [7] Tipo do Titulo Espécie de Docto Padrao (DM=DUPLICATA MERCANTIL, DS=DUPLICATA DE SERVIÇO, RC=RECIBO)
		Else
			aAdd(::aDadosTit,"DM")	      											// [7] Tipo do Titulo Espécie de Docto Padrao (DM=DUPLICATA MERCANTIL, DS=DUPLICATA DE SERVIÇO, RC=RECIBO)
		EndIf
		aAdd(::aDadosTit,alltrim(SE1->E1_NUM))										// [8] Numero do Título
        aAdd(::aDadosTit,alltrim(SE1->E1_PREFIXO))									// [9] Série do Título
		aVet := u_GetDesc(cDadosSac,::aDadosTit[8],::aDadosTit[9]) 					// cod cliente, loja, num nf+serie
	 	aAdd(::aDadosTit, Iif(Len(aVet) == 2, aVet[1], 0))							// [10] Desconto
	 	aAdd(::aDadosTit, ::aDadosTit[5] - ::aDadosTit[10])							// [11] Valor Cobrado
        cNumTit 	:=	::aDadosTit[8]
		cSerieTit	:=	::aDadosTit[9]
	 	
	 	// Carrega as Frases Padrões
	 	::aFrases := {}
	 	if ::cBanco == "001"
	 		aAdd(::aFrases,"Juros de Mora de 4,00% ao mês")
	 		aAdd(::aFrases,"")
	 		aAdd(::aFrases,"")
	 		aAdd(::aFrases,"")
	 	ElseIf ::cBanco == "033"
			aAdd(::aFrases,"Valor ref. a Nota Fiscal No. " + SE1->E1_NUM )
	 		aAdd(::aFrases,"APOS O VENCIMENTO COBRAR R$" + Transform(SE1->E1_VALJUR, "@E 99,999.99") + " POR DIA DE ATRASO.")
	 		aAdd(::aFrases,AllTrim(SA1->A1_ZZTXTBL)+' '+AllTrim(MV_PAR25))
	 		aAdd(::aFrases,AllTrim(MV_PAR25))		 	
	 		aAdd(::aFrases,AllTrim(MV_PAR26))
	 		aAdd(::aFrases,AllTrim(MV_PAR27))
	 	elseif ::cBanco == "655"
	 		aAdd(::aFrases,"Titulo entregue em cessão fiduciária em favor do cedente acima")
			aAdd(::aFrases,"Juros de Mora de 3,00% ao mês")
			aAdd(::aFrases,"")
			aAdd(::aFrases,"")
	 	elseif ::cBanco == "745"
	 		aAdd(::aFrases,"APÓS VENCTO ACESSE WWW.CITIBANK.COM.BR/BOLETOS OU LIGUE 0800-7018701/")
	 		aAdd(::aFrases,"11 2135-9510 E OBTENHA BOLETO PAGÁVEL EM QUALQUER BANCO. SE PREFERIR")
	 		aAdd(::aFrases,"PAGUE NO CITIBANK, HSBC, BMB RURAL E BIC ATÉ 4 DIAS - Cobrar multa de 7%")
	 		aAdd(::aFrases,"")
	 	elseif ::cBanco == "341"
	 		aAdd(::aFrases,"Valor ref. a Nota Fiscal No. " + SE1->E1_NUM )
			aAdd(::aFrases,"Após o vencimento mora dia.......: " + Transform(SE1->E1_VALJUR, "@E 99,999.99"))
	 		aAdd(::aFrases,AllTrim(SA1->A1_ZZTXTBL)+' '+AllTrim(MV_PAR25))
	 		aAdd(::aFrases,AllTrim(MV_PAR25))		 	
	 		aAdd(::aFrases,AllTrim(MV_PAR26))
	 		aAdd(::aFrases,AllTrim(MV_PAR27))
	 	ElseIf ::cBanco == "237" .OR. ::cBanco == "422"
			aAdd(::aFrases,"Valor ref. a Nota Fiscal No. " + SE1->E1_NUM )
	 		aAdd(::aFrases,"APOS O VENCIMENTO COBRAR R$" + Transform(SE1->E1_VALJUR, "@E 99,999.99") + " POR DIA DE ATRASO.")			
	 		aAdd(::aFrases,AllTrim(SA1->A1_ZZTXTBL)+' '+AllTrim(MV_PAR25))
	 		aAdd(::aFrases,AllTrim(MV_PAR25))		 	
	 		aAdd(::aFrases,AllTrim(MV_PAR26))
	 		aAdd(::aFrases,AllTrim(MV_PAR27))
	 	else
	 		aAdd(::aFrases,"")
	 		aAdd(::aFrases,"")
	 		aAdd(::aFrases,"")
	 		aAdd(::aFrases,"")
		endif

		// Substitui o conteúdo de %E1_PORCJUR% nas Frases com Valores do Título
/* CLIENTE NAO UTILIZA
		if SE1->E1_PORCJUR > 0
			::aFrases[1]:= STRTRAN(::aFrases[1],"%E1_PORCJUR%",alltrim(Transform((::aDadosTit[5]*SE1->E1_PORCJUR/100),"@E 99,999.9999"))+" ( "+cValToChar(SE1->E1_PORCJUR)+"% )")
			::aFrases[2]:= STRTRAN(::aFrases[2],"%E1_PORCJUR%",alltrim(Transform((::aDadosTit[5]*SE1->E1_PORCJUR/100),"@E 99,999.9999"))+" ( "+cValToChar(SE1->E1_PORCJUR)+"% )")
			::aFrases[3]:= STRTRAN(::aFrases[3],"%E1_PORCJUR%",alltrim(Transform((::aDadosTit[5]*SE1->E1_PORCJUR/100),"@E 99,999.9999"))+" ( "+cValToChar(SE1->E1_PORCJUR)+"% )")
		else
			For nCont:=1 to 3 // Para as 3 mensagens
				nPos:= aScan(::aFrases,{|cTexto| "%E1_PORCJUR%" $ cTexto })
				if nPos>0
					::aFrases[nPos]:="" // Limpa a Frase Inteira caso o conteúdo do campo seja vazio
				endif
			Next nCont
		endif
			
		// Substitui o conteúdo de %E1_VALJUR% nas Frases com Valores do Título
		if SE1->E1_VALJUR > 0
			::aFrases[1]:= STRTRAN(::aFrases[1],"%E1_VALJUR%",alltrim(Transform(SE1->E1_VALJUR,"@E 99,999.99")))
			::aFrases[2]:= STRTRAN(::aFrases[2],"%E1_VALJUR%",alltrim(Transform(SE1->E1_VALJUR,"@E 99,999.99")))
			::aFrases[3]:= STRTRAN(::aFrases[3],"%E1_VALJUR%",alltrim(Transform(SE1->E1_VALJUR,"@E 99,999.99")))
		else
			For nCont:=1 to 3 // Para as 3 mensagens
				nPos:= aScan(::aFrases,{|cTexto| "%E1_VALJUR%" $ cTexto })
				if nPos>0
					::aFrases[nPos]:="" // Limpa a Frase Inteira caso o conteúdo do campo seja vazio
				endif
			Next nCont
		endif

		// Substitui o conteúdo de %E1_DESCFIN% nas Frases com Valores do Título
		if SE1->E1_DESCFIN > 0 
			::aFrases[1]:= STRTRAN(::aFrases[1],"%E1_DESCFIN%",alltrim(Transform(SE1->E1_DESCFIN,"@E 99,999.99")))
			::aFrases[2]:= STRTRAN(::aFrases[2],"%E1_DESCFIN%",alltrim(Transform(SE1->E1_DESCFIN,"@E 99,999.99")))
			::aFrases[3]:= STRTRAN(::aFrases[3],"%E1_DESCFIN%",alltrim(Transform(SE1->E1_DESCFIN,"@E 99,999.99")))
		else
			For nCont:=1 to 3 // Para as 3 mensagens
				nPos:= aScan(::aFrases,{|cTexto| cTexto $ "%E1_DESCFIN%"})
				if nPos>0
					::aFrases[nPos]:="" // Limpa a Frase Inteira caso o conteúdo do campo seja vazio
				endif
			Next nCont
		endif
*/	

		// Define o Código do Nosso Número
		::NossoNro(SE1->E1_NUMBCO)
			
		// Define o Código de Barras e a Linha Digitável
		::CodBarra()
			
		// Imprime o Relatório para os Dados Atualmente Selecionados
		::PrintRel() 
			
		nTit+= 1 // Contabiliza títulos impressos
		// dellano endif
		SE1->(dbSkip()) // Pula o Registro SE1 Filtrado
	
	EndDo
	
	if nTit>0  // Apresenta apenas se houver registros a serem impressos
		::oReport:EndPage()     // Finaliza a página
		::oReport:Setup()       // Apresenta o Seletor para Escolha da Impressora a Utilizar na Impressão
		::oReport:Preview()     // Visualiza antes de imprimir	
	else
		MsgAlert("Atenção! Não existem títulos selecionados a serem impressos e, portanto, esta operação está sendo abortada.","RELATÓRIO SEM REGISTROS")
	endif

return

// #########################################################################
// MÉTODOS PARA CÁLCULO DO NOSSO NÚMERO, DO CÓDIGO DE BARRA E LINHA DIGITÁVEL 
// #########################################################################

// Define o Nosso Número de Acordo com o Banco, Carteira e Convênio, utilizando o Código Seq. como parte do Nosso Número
// Alimenta o Atributo NossoNum e Retorna o valor do Atributo
Method nossoNro(cNossNroOld) Class Boleto

	local cBase		:= "" 
	local cDV		:= ""
	Local cDV2		:= ""
	local cNossoNro	:= ""   
	Local cAno		:= ""
	
	local cBanco	:= alltrim(::aDadosBanco[1])
	local cAgencia	:= alltrim(::aDadosBanco[3])
	local cConta	:= alltrim(::aDadosBanco[4]) // Sem Dígito Verificador (DAC)
	local cCarteira := alltrim(::aDadosBanco[7])
	local cConvenio	:= alltrim(::aDadosBanco[8])
	local nDigConv	:= ::aDadosBanco[9]
	local cCodSeq	:= alltrim(::aDadosBanco[10])
	
	If cBanco == "341"
		cAgencia:=right(cAgencia,4)
	Else
		cAgencia:=Padl(cAgencia,4,'0')
	EndIf

	
	// cNossNroOld := "" // Dellano - Força o calculo         
	
	if !Empty(cNossNroOld)
		cNossoNro:= cNossNroOld
	else
		// Banco do Brasil
		if cBanco == "001" 
			if cCarteira == "18" // Cobrança Simples - Boleto Impresso na Empresa
			
				cBase	   := alltrim(cConvenio)+alltrim(cCodSeq) // Convênio + Nº Seq.
				
				if nDigConv == 4 // Dígitos do Convênio de 4 Dígitos
					// Convenio deve ter 4 Dígitos e Nº Seq. 7 Dígitos = 11 Dígitos
					cDV	   := U_Modulo11(cBase,9,2,cBanco) // 12 Dígitos no Total com Dígito Verif.					
				elseif nDigConv == 6 // Dígitos do Convênio de 6 Dígitos
					// Convenio deve ter 6 Dígitos e Nº Seq. 5 Dígitos = 11 Dígitos
					cDV	   := U_Modulo11(cBase,9,2,cBanco) // 12 Dígitos no Total com Dígito Verif.
				elseif nDigConv == 7 // Convênio de 7 Dígitos
					// Convenio deve ter 7 Dígitos e Nº Seq. 10 Dígitos  = 17 Dígitos
					cDV	   := "" // 17 Dígitos no Total Sem DV
				else
					cDV	   := "" // Sem DV
				endif

				cNossoNro  := cBase + cDV // Grava o Nosso Número Completo
					
				// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(Soma1(alltrim(cCodSeq)))
				
			elseif cCarteira == "17"

				if nDigConv == 7
					cBase := alltrim(cConvenio)+right(alltrim(cCodSeq),10) // Convênio + Nº Seq.
					cDV	  := ""
				elseif nDigConv == 6 // Dígitos do Convênio de 6 Dígitos
					// Convenio deve ter 6 Dígitos e Nº Seq. 5 Dígitos = 11 Dígitos
					cBase := alltrim(cConvenio)+right(alltrim(cCodSeq),5) // Convênio + Nº Seq.
					cDV	  := U_Modulo11(cBase,9,2,cBanco) // 12 Dígitos no Total com Dígito Verif.
				endif
				
				cNossoNro  := cBase + cDV // Grava o Nosso Número Completo

				// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(Soma1(alltrim(cCodSeq)))
				
		    elseif cCarteira == "11" // Boleto Impresso no Banco, bem como geração do Nosso Número.
		    
		    	cNossoNro := "00000000000000000"
		    endif

		// Santander
		elseif cBanco == "033"
			cBase	  := alltrim(cCodSeq)
			cBase	  := Padl(alltrim(cBase),12,"0")
			cDV	   	  := U_Modulo11(cBase,2,9,cBanco)
			cNossoNro := cBase + cDV
				
			// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
			GrvNumSeq(Soma1(alltrim(cBase)))

		// Caixa Econômica Federal
		elseif cBanco == "104"
			if cCarteira == "12" // Cobrança Simples - Boleto Impresso na Empresa
				cBase	  := "9"+subStr(cCodSeq,4,9)
				cDV		  := U_Modulo11(cBase,7,2,cBanco)
				cNossoNro := cBase + cDV
				
				// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(strZero(val(cCodSeq)+1,12))
							
			elseif cCarteira == "14" // Cobrança sem Registro - Boleto Impresso na Empresa
				cBase	  := "82"+subStr(cCodSeq,5,8)
				cDV		  := U_Modulo11(cBase,7,2,cBanco)
				cNossoNro := cBase + cDV
				
				// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(strZero(val(cCodSeq)+1,12))
		    endif
		
		// Bradesco
		elseif cBanco == "237"
			if cCarteira == "19" // Cobrança sem Registro
				cBase	  := alltrim(cCodSeq) // 11 Dígitos Sequenciais
				cDV	   	  := U_Modulo11(cCarteira+cBase,2,7,cBanco) // 12 Dígitos no Total com Dígito Verif. - Modulo 11 sobre Carteira + Nosso Nro
				cNossoNro := cBase + cDV // Grava o Nosso Número Completo				

			elseif cCarteira == "09" .OR. cCarteira == "07"
				cBase	  := Padl(alltrim(cCodSeq),11,'0')
				cDV	   	  := U_Modulo11(cCarteira+cBase,2,7,"237")
				cNossoNro := cCarteira + cBase + cDV
			endif
		
			// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
			GrvNumSeq(Soma1(alltrim(cCodSeq)))

		// Safra
		ElseIf cBanco == "422"	
			cBase	  := Padl(alltrim(cCodSeq),8,'0')   
			cBase2	  := Padl(alltrim(cCodSeq),11,'0')//renato castro 10/08/12
			cAno      := Right(Str(Year(::aDadosTit[2])),2) 
			cDV	   	  := U_Modulo11(cBase,2,9,"422")
			cDV2   	  := U_Modulo11(cCarteira+cAno+cBase+cDV,2,7,"237") //Retornei a linha em 13/09/12 devido a calculo incorreto do Digito - By Robson Neves
			//cDV2   	  := U_Modulo11(cCarteira+cBase2,2,7,"237") //ater by renato castro 10/08/12
			
			cNossoNro := cCarteira + cAno + cBase + cDV + cDV2

			// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
			GrvNumSeq(Soma1(alltrim(cCodSeq)))
		
		// Banco Itaú ou Votorantim
		elseif cBanco == "341" .or. cBanco == "655"
			cBase	:= cCarteira+AllTrim(cCodSeq) // 3 Dígitos da Carteira + 8 Dígitos Sequenciais = 11 Dígitos
			                            
			if cCarteira == "126" .Or. cCarteira == "131" .Or. cCarteira == "145" .Or. ;
				cCarteira == "150" .Or. cCarteira == "168" // Carteiras Escriturais e na Modalidade Direta
				
				cDV:= U_Modulo10(AllTrim(cBase),2,1,"Divisor") // 12 Dígitos no Total com Dígito Verif. - Somente Carteira e Num. Seq.
			else
				cDV:= U_Modulo10(cAgencia+StrZero(Val(cConta),5)+AllTrim(cBase),2,1,"Divisor") // 12 Dígitos no Total com Dígito Verif. - Agencia+CC sem DAC+Carteira+Num. Seq
			endif                       
			
			cNossoNro := cBase + cDV // Grava o Nosso Número Completo 12 digitos
			
			// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
			GrvNumSeq(Soma1(alltrim(cCodSeq)))
		elseif cBanco == "745"
			cBase	  := cCarteira+alltrim(StrZero(Val(cCodSeq),8)) // 3 Dígitos da Carteira + 8 Dígitos Sequenciais = 11 Dígitos
							  
			//cDV:= U_Modulo11(cAgencia+cConta+cBase,9,2,"Divisor") // 12 Dígitos no Total com Dígito Verif. - Agencia+CC sem DAC+Carteira+Num. Seq       //calculo de digito errado, tirado por fabio assarice
			cDV:= U_Modulo11(cBase,2,9,cBanco,1) // calculo correto, inserido por fabio assarice 
			cNossoNro := cBase + cDV // Grava o Nosso Número Completo
			
			// Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
			GrvNumSeq(Soma1(alltrim(cCodSeq)))
		endif
	endif
	
	// Grava o Último Nº Gerado como Atributo para Uso Posterior
	::cNossoNum := alltrim(cNossoNro)
	
    // Armazena o Nosso Número no Arquivo
    ::GrvNossNum()
    
return (::cNossoNum)

// Grava o Número Sequencial no Arquivo de Configurações do Banco/CNAB
Static Function GrvNumSeq(cCodSeq)
	dbSelectArea("SEE")
	RecLock("SEE")
		SEE->EE_FAXATU:= cCodSeq
	MsUnLock()
return

// Grava o Nosso Número e que o Boleto foi impresso na Base no SE1 Posicionado
Method grvNossNum() Class Boleto
	// Armazena o nosso Número Gerado no SE1
	dbSelectArea("SE1")
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO := ::cNossoNum
	// Dellano SE1->E1_ZZBLT := .T. // Indica que o Boleto foi impresso - Campo Personalizado
	MsUnlock()
return

// Retorna o Nosso Número Formatado, Conforme o Banco e Convênio
Method retNossoNro() Class Boleto

	local cBanco	:= ::aDadosBanco[1]
	local nDigConv	:= ::aDadosBanco[9]
	local cNossoNro := ::cNossoNum
  
	 // Banco do Brasil
	if cBanco == "001"
		if nDigConv == 6 // Dígitos do Convênio de 6 Dígitos
			cNossoNro:= left(cNossoNro,Len(cNossoNro)-1) + "-" + Right(cNossoNro,1)
		elseif nDigConv == 7 // Dígitos do Convênio de 7 Dígitos
			cNossoNro:= cNossoNro
		else
			cNossoNro:= cNossoNro
	  	endif

 	// Santander
	elseif cBanco == "033"
		cNossoNro:= left(cNossoNro,Len(cNossoNro)-1) + "-" + Right(cNossoNro,1)
		 	
 	// Bradesco
	elseif cBanco == "237"
		cNossoNro:= left(cNossoNro,Len(cNossoNro)-1) + "-" + Right(cNossoNro,1)

	// Safra
	elseIf cBanco == "422"
		cNossoNro:= left(cNossoNro,2) + "/" + SubStr(cNossoNro,3,Len(cNossoNro)-3) + "-" + right(cNossoNro,1)
		
	// Banco Itaú ou Votorantim
	elseif cBanco == "341" .or. cBanco == "655"
		cNossoNro:= left(cNossoNro,3) + "/" + subStr(cNossoNro,4,Len(cNossoNro)-4) + "-" + Right(cNossoNro,1)	
		
	else 
		cNossoNro:= cNossoNro
	endif
	
return (cNossoNro)

// Define o Código de Barras e a Linha Digitável do Boleto
Method CodBarra() Class Boleto   

	local cBanco	  := ::aDadosBanco[1]
	local cAgencia    := ::aDadosBanco[3]
	local cConta      := ::aDadosBanco[4] // CC Sem DAC
	local cCC	      := ::aDadosBanco[12] // CC Completa
	local cCarteira   := ::aDadosBanco[7]
	local cConvenio	  := ::aDadosBanco[8]
	local nDigConv	  := ::aDadosBanco[9]
	local cCodSeq	  := ::aDadosBanco[10]
	Local cCedente    := ::aDadosBanco[15]
	local cVencto	  := DTOS(::aDadosTit[4]) // Converte para AAAAMMDD
	local cMoeda	  := "9" // Código da Moeda no Banco - 9 = Real
	local cNNumSemDV  := "" 
	local cCampoLivre := ""
	local cFator	  := ""
	local cDigBarra	  := ""
	local cParte1	  := ""
	local cDig1		  := ""
	local cParte2	  := ""
	local cDig2		  := ""
	local cParte3	  := ""
	local cDig3		  := ""
	local cParte4	  := ""
	local cParte5	  := ""
	Local cTpCob	  := "3"
	
    // Ajusta a Agencia para 4 Dígitos
	//fabio
	If cBanco == "341"
		cAgencia:=right(cAgencia,4)
	Else
		cAgencia:=Padl(cAgencia,4,'0')
	EndIf
		
	// Define o Nosso Número sem DV e Parte do Campo Livre
	// Variável para Cada Banco e cada Tipo de Convênio
	if cBanco == "001" // Banco do Brasil
		if nDigConv == 4 // Dígitos do Convênio de 4 Dígitos (Com DV)
			cNNumSemDV  := left(::cNossoNum,11)
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira	// 11 + 4 + 8 + 2 = 25
			
		elseif nDigConv == 6 // Dígitos do Convênio de 6 Dígitos (Com DV)
			cNNumSemDV  := left(::cNossoNum,11)
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira // 11 + 4 + 8 + 2 = 25
		
		elseif nDigConv == 7 // Dígitos do Convênio de 7 Dígitos (Sem DV) - Faixa Acima de 1.000.000 - Somente para Carteiras 16 e 18
			cNNumSemDV  := ::cNossoNum
			cCampoLivre := "000000"+cNNumSemDV+"21" // 6 + 17 + 2 = 25 
		
		else
			cNNumSemDV:= ::cNossoNum
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira // 11 + 4 + 8 + 2 = 25
		endif

	// Banco Santander
	elseif cBanco == "033"
		cNNumComDV  := ::cNossoNum //SubStr(::cNossoNum,2,13)
		cCampoLivre := "9" + cCedente + cNNumComDV + "0" + "101"	// 1 + 7 + 13 + 1 + 3 = 25

	// Banco Bradesco ou Banco Safra
	elseif cBanco == "237" .OR. cBanco == "422"
		cNNumSemDV  := SubStr(::cNossoNum,3,11)
		cCampoLivre := cAgencia+cCarteira+cNNumSemDV+strZero(val(cConta),7)+"0" // 4 + 2 + 11 + 7 + 1 = 25
			
	// Banco Itaú ou Votorantim
	elseif cBanco == "341" .or. cBanco == "655"
		cNNumSemDV  := left(::cNossoNum,11)
		cCampoLivre := cNNumSemDV+Right(::cNossoNum,1)+cAgencia+strZero(val(cConta),5)+Right(cCC,1)+"000"	// 11 + 1 + 4 + 5 + 1 + 3 = 25 //bkp -2018-07-06 apply- (cNNumSemDV+Right(::cNossoNum,1)+cAgencia+strZero(val(cConta),5)+U_Modulo10(cAgencia+cConta,2,1,"Divisor")+"000"  )
	
	else // Para outros Bancos - Estudar as Especificações de Outros Bancos
		cNNumSemDV:= ::cNossoNum
		cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira // 11 + 4 + 8 + 2 = 25 
	endif
	
	// Define o Fator de Vencimento com o Valor do Título
	
	// Banco do Brasil
	if cBanco == "001"
		// Regra: Deduzir do Vencto a Data Base de 03/07/2000 e Acrescer a 1000
		cFator := Str(1000+(STOD(cVencto)-STOD("20000703")),4) // Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) // Valor = 10 Dígitos

	// Santander
	elseif cBanco == "033"
		// Regra: Deduzir do Vencto a Data Base de 07/10/1997 e Acrescer a 1000
		cFator := strZero(STOD(cVencto)-STOD("19971007"),4) // Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) // Valor = 10 Dígitos
	
	// Bradesco ou Safra
	elseif cBanco == "237" .or. cBanco == "422"
		// Regra: Deduzir do Vencto a Data Base de 07/10/1997 e Acrescer a 1000
		cFator := strZero(STOD(cVencto)-STOD("19971007"),4) // Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) // Valor = 10 Dígitos
	
	// Citibank
	ElseIf cBanco == "745"
		cFator := strZero(STOD(cVencto)-STOD("19971007"),4) // Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) // Valor = 10 Dígitos
	// Itau
	ElseIf cBanco == "341"
		cFator := strZero(STOD(cVencto)-STOD("19971007"),4) // Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) // Valor = 10 Dígitos		
	// Outros Bancos
	else
		// Regra: Deduzir do Vencto a Data Base de 03/07/2000 e Acrescer a 1000
		cFator := Str(1000+(STOD(cVencto)-STOD("20000703")),4) // Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) // Valor = 10 Dígitos	
	endif
	
	// Define o Campo Livre
	if cBanco == "033"
		cCampoLivre := cBanco+cMoeda+cFator+cCampoLivre			
	elseif cBanco == "655"
		cCampoLivre := "341"+cMoeda+cFator+cCampoLivre
	elseif cBanco == "422"
		cCampoLivre := "237"+cMoeda+cFator+cCampoLivre
	elseif cBanco == "745" //citi
		cCampoLivre := cBanco+cMoeda+cFator+cTpCob+cCarteira+SubStr(cConvenio,2,Len(cConvenio))+::cNossoNum  
	elseif cBanco == "341" //itau                      
		cCampoLivre := 	cBanco+cMoeda+cFator+::cNossoNum+cAgencia+strZero(val(cConta),5)+Right(cCC,1)+"000" //(bkp Ruben)StrZero(Val(cConta),5)+"000"  //	cCampoLivre := 	cBanco+cMoeda+cFator+::cNossoNum+cAgencia+StrZero(Val(cConta),5)+U_Modulo10(cAgencia+cConta,2,1,"Divisor")+"000"   		               		               	
	else
		cCampoLivre := cBanco+cMoeda+cFator+cCampoLivre
	endif
	
 	// Dígito Verificador do Campo Livre ou Código de Barrra      
	cDigBarra   := U_Modulo11(cCampoLivre,2,9,cBanco,2) 

	// Composição Final do Código de Barra  
	if cBanco == "745" .OR. cBanco == "341"
		::cCodBarra := subStr(cCampoLivre,1,4)+cDigBarra+subStr(cCampoLivre,5,Len(cCampoLivre))
	Else
		::cCodBarra := subStr(cCampoLivre,1,4)+cDigBarra+subStr(cCampoLivre,5,Len(cCampoLivre))
	EndIf
	
	// Composição da Linha Digitável
	if cBanco == "033"
		cParte1	:= cBanco
	elseif cBanco == "655"
		cParte1 := "341"
	elseif cBanco == "422"
		cParte1 := "237"
	else
		cParte1 := cBanco   
	endif
	
	If cBanco == "033"
		cParte1  := cParte1 + cMoeda
		cParte1  := cParte1 + subStr(::cCodBarra,20,5) // Posição 20 a 24 do Cód. de Barras
	elseif cBanco == "745"
		cParte1  := cParte1 + cMoeda + cTpCob + cCarteira + SubStr(cConvenio,2,1)
	elseIf cBanco == "341"  
		cParte1  := cParte1 + cMoeda
		cParte1  := cParte1 + cCarteira + subStr(::cNossoNum,4,2)
	else
		cParte1  := cParte1 + cMoeda
		cParte1  := cParte1 + subStr(::cCodBarra,20,5) // Posição 20 a 24 do Cód. de Barras
	EndIf
	
	cDig1    := U_Modulo10(cParte1,2,1) // Modulo10, alternando com bases de 2 e 1 - DAC
	      
	If cBanco == "033"
		cParte2  := subStr(::cCodBarra,25,10) // Posição 25 a 34 do Cód. de Barras
	elseif cBanco == "745"
		cParte2  := subStr(cConvenio,3,5) + subStr(cConvenio,8,2) + subStr(cConvenio,Len(cConvenio),1) + subStr(::cNossoNum,1,2)
	elseIf cBanco == "341"
		cParte2  := Right(::cNossoNum,7) + Left(cAgencia,3)
	else
		cParte2  := subStr(::cCodBarra,25,10) // Posição 25 a 34 do Cód. de Barras
	EndIf
		
	cDig2    := U_Modulo10(cParte2,2,1) // Modulo10, alternando com bases de 2 e 1 - DAC
	
	if cBanco == "033"
		cParte3  := subStr(::cCodBarra,35,10) // Posição 35 a 44 do Cód. de Barras		
	elseif cBanco == "745"
		cParte3  := Right(::cNossoNum,10)
	elseIf cBanco == "341"
		cParte3  := Right(cAgencia,1) + strZero(val(cConta),5)+Right(cCC,1)+ "000"   //Right(cAgencia,1) + StrZero(Val(alltrim(cCC)),6) + "000" //2018-07-06 apply 
	else
		cParte3  := subStr(::cCodBarra,35,10) // Posição 35 a 44 do Cód. de Barras
	endif
		
	cDig3    := U_Modulo10(cParte3,2,1) // Modulo10, alternando com bases de 2 e 1 - DAC
	
	cParte4  := cDigBarra // DV do Cód. de Barra Em Modulo11 Calculado Previamente
	cParte5  := cFator // Fator de Vencto + Valor
	                 
	// Montagem Final da Linha Digitável 
	::cLinhaDig := 	subStr(cParte1,1,5)+"."+subStr(cParte1,6,4)+cDig1+" "+;
					subStr(cParte2,1,5)+"."+subStr(cParte2,6,5)+cDig2+" "+;
					subStr(cParte3,1,5)+"."+subStr(cParte3,6,5)+cDig3+" "+;
					cParte4+" "+;
					cParte5
return

// Executa a Impressão do Relatório Gráfico
Method printRel() Class Boleto

	// DEFINE OS ESTILOS DE FONTES A SEREM UTILIZADOS - O Nº NA VARIÁVEL IDENTIFICA O TAMANHO DA FONTE
	// Parametros de TFont.New(): 1.Nome da Fonte (Windows), 3.Tamanho em Pixels, 5.Bold (T/F)
	local oFont8   :=TFont():new("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont10  :=TFont():new("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont11c :=TFont():new("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont11  :=TFont():new("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont12  :=TFont():new("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont14  :=TFont():new("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont20  :=TFont():new("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont21  :=TFont():new("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont16n :=TFont():new("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont15  :=TFont():new("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont15n :=TFont():new("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont14n :=TFont():new("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont24  :=TFont():new("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	local aBitmap  :=::aLogoBco
	local cString  :=""
	local nI 	   :=0
	local nRow1	   :=0
	local nRow2	   :=0
	local nRow3	   :=0
	local nHPage   :=0
	local nVPage   :=0
	
	private aVet   := {}
	// Configuração de Posicionamento da Página	
	nHPage := ::oReport:nHorzRes()
	nHPage *= (300/::oReport:nLogPixelX())
	nHPage -= HMARGEM  
	
	nVPage := ::oReport:nVertRes()
	nVPage *= (300/::oReport:nLogPixelY())
	nVPage -= VMARGEM
	
	if ::nModelo == 1	
		
		/******************/
		/* PRIMEIRA PARTE */
		/******************/

		nRow1 := 0
		 
		::oReport:line(nRow1+0150,500,nRow1+0070, 500) // Linha Vertical
		::oReport:line(nRow1+0150,710,nRow1+0070, 710) // Linha Vertical
				
		::oReport:sayBitMap(nRow1+0075,94,aBitMap[1],0400,0072) // Logotipo do Banco
        

		if ::aDadosBanco[1] == "033"
			::oReport:say(nRow1+0075,513,::aDadosBanco[1]+"-7",oFont21)	// [1]Numero do Banco
		elseif ::aDadosBanco[1] == "655"
			::oReport:say(nRow1+0075,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
			::oReport:say(nRow1+0075,513,"237-2",oFont21)
		elseif ::cBanco == "745"
			::oReport:say(nRow1+0075,513,"745-5",oFont21)    
		else
			::oReport:say(nRow1+0075,513,::aDadosBanco[1]+"-2",oFont21)	// [1]Numero do Banco 
		endif
		
		::oReport:say(nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		::oReport:line(nRow1+0150,100,nRow1+0150,2300)
		
		::oReport:say(nRow1+0150,100 ,"Cedente",oFont8)
		if ::cBanco == "655"
			::oReport:say(nRow1+0200,100 ,"BANCO VOTORANTIM S/A",oFont10)	// Nome + CNPJ da Empresa
		elseif ::cBanco == "422"
			::oReport:say(nRow1+0200,100 ,"BANCO SAFRA S/A",oFont10)			// Nome + CNPJ da Empresa
		else
			::oReport:say(nRow1+0200,100 ,::aDadosEmp[1],oFont10)			// Nome + CNPJ da Empresa
		endif
		
		::oReport:say(nRow1+0150,1060,"Agência/Código Cedente",oFont8)
		If ::cBanco == "745"
//			::oReport:say(nRow1+0200,1060,::aDadosBanco[3]+"/"+::aDadosBanco[4]+::aDadosBanco[5],oFont10)
			::oReport:say(nRow1+0200,1060,"00001/0067435028",oFont10) 
		Else
			::oReport:say(nRow1+0200,1060,::aDadosBanco[3]+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5],oFont10)
		EndIf
		
		::oReport:say(nRow1+0150,1510,"Nro.Documento",oFont8)
		::oReport:say(nRow1+0200,1510,::aDadosTit[6]+::aDadosTit[1],oFont10) // Prefixo+Numero+Parcela
		
		::oReport:say(nRow1+0250,100 ,"Sacado",oFont8)
		::oReport:say(nRow1+0300,100 ,::aDadosSac[1],oFont10) // Nome do Cliente
		
		::oReport:say(nRow1+0250,1060,"Vencimento",oFont8)
		::oReport:say(nRow1+0300,1060,strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4),oFont10)
		
		::oReport:say(nRow1+0250,1510,"Valor do Documento",oFont8)
		::oReport:say(nRow1+0300,1550,Transform(::aDadosTit[5],"@E 99,999,999.99"),oFont10)
		
		::oReport:line(nRow1+0250, 100,nRow1+0250,1900 ) // Linha Horizontal
		::oReport:line(nRow1+0350, 100,nRow1+0350,1900 ) // Linha Horizontal
		::oReport:line(nRow1+0450,1050,nRow1+0450,1900 ) // Linha Horizontal
		::oReport:line(nRow1+0550, 100,nRow1+0550,2300 ) // Linha Horizontal		
	
		::oReport:line(nRow1+0550,1050,nRow1+0150,1050 ) // Linha Vertical
		::oReport:line(nRow1+0550,1400,nRow1+0350,1400 ) // Linha Vertical
		::oReport:line(nRow1+0350,1500,nRow1+0150,1500 ) // Linha Vertical
		::oReport:line(nRow1+0550,1900,nRow1+0150,1900 ) // Linha Vertical
		
		//If !::cBanco == "341" .AND. !::cBanco =="745"
			::oReport:say(nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
			::oReport:say(nRow1+0450,0100,"com as características acima.",oFont10)
			::oReport:say(nRow1+0350,1060,"Data",oFont8)
			::oReport:say(nRow1+0350,1410,"Assinatura",oFont8)
			::oReport:say(nRow1+0450,1060,"Data",oFont8)
			::oReport:say(nRow1+0450,1410,"Entregador",oFont8)
			
			::oReport:say(nRow1+0165,1910,"(  )Mudou-se"                              	,oFont8)
			::oReport:say(nRow1+0205,1910,"(  )Ausente"                                ,oFont8)
			::oReport:say(nRow1+0245,1910,"(  )Não existe nº indicado"                 ,oFont8)
			::oReport:say(nRow1+0285,1910,"(  )Recusado"                               ,oFont8)
			::oReport:say(nRow1+0325,1910,"(  )Não procurado"                          ,oFont8)
			::oReport:say(nRow1+0365,1910,"(  )Endereço insuficiente"                  ,oFont8)
			::oReport:say(nRow1+0405,1910,"(  )Desconhecido"                           ,oFont8)
			::oReport:say(nRow1+0445,1910,"(  )Falecido"                               ,oFont8)
			::oReport:say(nRow1+0485,1910,"(  )Outros(anotar no verso)"                ,oFont8)
		//EndIf
	
		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		
		nRow2 := 0
		
		// Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow2+0580, nI,nRow2+0580, nI+30)
		Next nI
		
		If ::cBanco == "341"    
			::oReport:say(nRow2+0635,94,"Banco Itaú SA"/*aBitMap[1]*/,oFont10)
		ElseIf ::cBanco == "422"
			::oReport:sayBitMap(nRow2+0635,94,aBitMap[2],0400,0072)		
		Else
			::oReport:sayBitMap(nRow2+0635,94,aBitMap[1],0400,0072)
		EndIf
		
		::oReport:line(nRow2+0710,100,nRow2+0710,2300) // Linha Horizontal
		::oReport:line(nRow2+0710,500,nRow2+0630, 500) // Linha Vertical
		::oReport:line(nRow2+0710,710,nRow2+0630, 710) // Linha Vertical
		
		// ::oReport:say(nRow2+0644,100,::aDadosBanco[2],oFont11 )		// [2]Nome do Banco
		if ::aDadosBanco[1] == "033"			
			::oReport:say(nRow2+0635,513,::aDadosBanco[1]+"-7",oFont21)
		elseif ::aDadosBanco[1] == "655"
			::oReport:say(nRow2+0635,513,"341",oFont21)
		elseif ::cBanco == "745"
			::oReport:say(nRow2+0635,513,"745-5",oFont21)
		elseif ::aDadosBanco[1] == "422"
			::oReport:say(nRow2+0635,513,"237-2",oFont21)
		else
			::oReport:say(nRow2+0635,513,::aDadosBanco[1]+"-2",oFont21)	// [1]Numero do Banco
		endif
		// ::oReport:say(nRow2+0644,755,::cLinhaDig,oFont15n)			// Linha Digitavel do Codigo de Barras
		::oReport:say(nRow2+0644,1755,"RECIBO DO SACADO",oFont10)		// Descrição da Seção
		
		::oReport:line(nRow2+0810,100,nRow2+0810,2300 ) // Linha Horizontal
		::oReport:line(nRow2+0910,100,nRow2+0910,2300 ) // Linha Horizontal
		::oReport:line(nRow2+0980,100,nRow2+0980,2300 ) // Linha Horizontal
		::oReport:line(nRow2+1050,100,nRow2+1050,2300 ) // Linha Horizontal
		
		::oReport:line(nRow2+0910,500,nRow2+1050,500)   // Linha Vertical
		::oReport:line(nRow2+0980,750,nRow2+1050,750)	 // Linha Vertical
		::oReport:line(nRow2+0910,1000,nRow2+1050,1000) // Linha Vertical
		::oReport:line(nRow2+0910,1300,nRow2+0980,1300) // Linha Vertical
		::oReport:line(nRow2+0910,1480,nRow2+1050,1480) // Linha Vertical
		
		::oReport:say(nRow2+0710,100 ,"Local de Pagamento",oFont8)
		if ::cBanco == "341"
			::oReport:say(nRow2+0750,100 ,"ATé O VENCIMENTO, PREFERENCIALMENTO NO ITAU APÓS O VENCIMENTO, SOMENTE NO ITAU",oFont10)
		ElseIf ::cBanco == "745"
			::oReport:say(nRow2+0750,100 ,"PAGÁVEL NA REDE BANCÁRIA ATÉ O VENCIMENTO",oFont10)
		Else
			::oReport:say(nRow2+0750,100 ,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		EndIf
		
		::oReport:say(nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+0750,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0810,100 ,"Cedente",oFont8)
		if ::cBanco == "655"
			::oReport:say(nRow2+0850,100 ,"BANCO VOTORANTIM S/A",oFont10)	// Nome da Empresa
		elseif ::cBanco == "422"
			::oReport:say(nRow2+0850,100 ,"BANCO SAFRA S/A",oFont10)		// Nome da Empresa
		else
			::oReport:say(nRow2+0850,100 ,::aDadosEmp[1],oFont10)			// Nome da Empresa
		endif
		
		::oReport:say(nRow2+0810,1810,"Agência/Código Cedente",oFont8)
		If ::cBanco == "745"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+40
			cString:= "00001/0067435028"
			::oReport:say(nRow2+0850,nCol,cString,oFont10)
		ElseIf ::cBanco == "341"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+"-"+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+70
			::oReport:say(nRow1+0850,nCol,cString,oFont10)
		Else
			cString := alltrim(Subs(::aDadosBanco[3],1,4))
			cString += if(empty(Subs(::aDadosBanco[3],5,1)),"","-"+Subs(::aDadosBanco[3],5,1))+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5]
			nCol := 1810+(374-(len(cString)*22))+70
			::oReport:say(nRow2+0850,nCol,cString,oFont11c)
		EndIf
		
		::oReport:say(nRow2+0910,100 ,"Data do Documento",oFont8)
		::oReport:say(nRow2+0940,100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4),oFont10)
		
		::oReport:say(nRow2+0910,505 ,"Nro.Documento",oFont8)
		::oReport:say(nRow2+0940,605 ,::aDadosTit[6]+::aDadosTit[1],oFont10) // Prefixo+Numero+Parcela
		
		::oReport:say(nRow2+0910,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow2+0940,1050,::aDadosTit[7],oFont10) // Tipo do Titulo
		
		::oReport:say(nRow2+0910,1305,"Aceite",oFont8)
		::oReport:say(nRow2+0940,1400,"N",oFont10)
		
		::oReport:say(nRow2+0910,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow2+0940,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) // Data de impressao
		
		::oReport:say(nRow2+0910,1810,"Nosso Número",oFont8)
		cString:= ::RetNossoNro() // Retorna o Nosso Número Formatado
		nCol := 1800+(374-(len(cString)*22))
		::oReport:say(nRow2+0940,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0980,100 ,"Uso do Banco",oFont8)
  		if ::cBanco == "422"
			::oReport:say(nRow2+1010,155 ,"CIP130",oFont10)
		elseIf ::cBanco == "745"
			::oReport:say(nRow2+1010,155 ,"RCO",oFont10)
		endif
		
		::oReport:say(nRow2+0980,505 ,"Carteira",oFont8)
		::oReport:say(nRow2+1010,555 ,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow2+0980,755 ,"Espécie",oFont8)
		::oReport:say(nRow2+1010,805 ,"R$",oFont10)
		
		::oReport:say(nRow2+0980,1005,"Quantidade",oFont8)
		::oReport:say(nRow2+0980,1485,"Valor",oFont8)
		
		::oReport:say(nRow2+0980,1810,"Valor do Documento",oFont8)
		cString:= Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+1010,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+1050, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		::oReport:say(nRow2+1100, 100,::aFrases[1],oFont10)
		::oReport:say(nRow2+1150, 100,::aFrases[2],oFont10)
		::oReport:say(nRow2+1200, 100,::aFrases[3],oFont8)//10
		::oReport:say(nRow2+1250, 100,::aFrases[4],oFont10)
		::oReport:say(nRow2+1300, 100,::aFrases[5],oFont10)
		::oReport:say(nRow2+1350, 100,::aFrases[6],oFont10)
		
		::oReport:say(nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
		aVet := u_GetDesc(cDadosSac,cNumTit,cSerieTit) // cod cliente, loja, num nf+serie 
		//If ::aDadosBanco[13] > 0 .AND. ::aDadosBanco[14] == '2'
		If Len (aVet) == 2
			::oReport:say(nRow2+1080,1850,"Desconto de " + AllTrim(Transform(aVet[1], "@E 99,999,999.99")) ,oFont8)
		EndIf					
		
		::oReport:say(nRow2+1120,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow2+1190,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow2+1260,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow2+1330,1810,"(=)Valor Cobrado",oFont8)
		if Len (aVet) == 2
			::oReport:say(nRow2+1360,1850,AllTrim(Transform(::aDadosTit[5]-aVet[1], "@E 99,999,999.99")) ,oFont8)
		endif
		
		::oReport:say(nRow2+1400,100 ,"Sacado",oFont8)
		::oReport:say(nRow2+1430,400 ,::aDadosSac[1]+" ("+::aDadosSac[2]+")" + Space(5) + "CNPJ: "+Transform(::aDadosSac[7],"@R 99.999.999/9999-99") ,oFont10)
		::oReport:say(nRow2+1483,400 ,::aDadosSac[3],oFont10)
		::oReport:say(nRow2+1536,400 ,::aDadosSac[4]+" - "+::aDadosSac[5] + " - " + ::aDadosSac[6] ,oFont10) // Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow2+1589,400 ,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) // CNPJ
		else
			::oReport:say(nRow2+1589,400 ,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	// CPF
		endif*/
		
		::oReport:say(nRow2+1605, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		If ::cBanco == "745"
			::oReport:say(nRow2+1645,1920,"Autenticação Mecânica",oFont8)
		Else
			::oReport:say(nRow2+1645,1810,"Autenticação Mecânica",oFont8)
		EndIf
		
		::oReport:line(nRow2+0710,1800,nRow2+1400,1800) 
		::oReport:line(nRow2+1120,1800,nRow2+1120,2300)
		::oReport:line(nRow2+1190,1800,nRow2+1190,2300)
		::oReport:line(nRow2+1260,1800,nRow2+1260,2300)
		::oReport:line(nRow2+1330,1800,nRow2+1330,2300)
		::oReport:line(nRow2+1400, 100,nRow2+1400,2300)
		::oReport:line(nRow2+1640, 100,nRow2+1640,2300)
		
		/******************/
		/* TERCEIRA PARTE */
		/******************/
		
		nRow3 := 0
		
		// Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow3+1880, nI, nRow3+1880, nI+30)
		Next nI
		
		::oReport:line(nRow3+2000,100,nRow3+2000,2300) // Linha Horizontal
		::oReport:line(nRow3+2000,500,nRow3+1920,0500) // Linha Vertical
		::oReport:line(nRow3+2000,710,nRow3+1920,0710) // Linha Vertical
		
		If ::aDadosBanco[1] == "422"
			::oReport:sayBitMap(nRow1+1925,94,aBitMap[2],0400,0072) 	   // Logotipo do Banco
		Else
			::oReport:sayBitMap(nRow1+1925,94,aBitMap[1],0400,0072) 	   // Logotipo do Banco
		EndIf
		
		If ::aDadosBanco[1] == "033"
			::oReport:say(nRow3+1925,513,::aDadosBanco[1]+"-7",oFont21)
		elseif ::aDadosBanco[1] == "655"
			::oReport:say(nRow3+1925,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
			::oReport:say(nRow3+1925,513,"237-2",oFont21)
		elseif ::cBanco == "745"
			::oReport:say(nRow1+0075,513,"745-5",oFont21)
		else
			::oReport:say(nRow3+1925,513,::aDadosBanco[1]+"-2",oFont21)	// [1]Numero do Banco
		endif
		::oReport:say(nRow3+1934,755,::cLinhaDig,oFont15n)		   // Linha Digitavel do Codigo de Barras
		
		::oReport:line(nRow3+2100,100,nRow3+2100,2300) // Linha Horizontal
		::oReport:line(nRow3+2200,100,nRow3+2200,2300) // Linha Horizontal
		::oReport:line(nRow3+2270,100,nRow3+2270,2300) // Linha Horizontal
		::oReport:line(nRow3+2340,100,nRow3+2340,2300) // Linha Horizontal
		
		::oReport:line(nRow3+2200, 500,nRow3+2340, 500) // Linha Vertical
		::oReport:line(nRow3+2270, 750,nRow3+2340, 750) // Linha Vertical
		::oReport:line(nRow3+2200,1000,nRow3+2340,1000) // Linha Vertical
		::oReport:line(nRow3+2200,1300,nRow3+2270,1300) // Linha Vertical
		::oReport:line(nRow3+2200,1480,nRow3+2340,1480) // Linha Vertical
		
		::oReport:say(nRow3+2000, 100,"Local de Pagamento",oFont8)
		if ::cBanco == "341"
			::oReport:say(nRow2+2055,100 ,"ATé O VENCIMENTO, PREFERENCIALMENTO NO ITAU APÓS O VENCIMENTO, SOMENTE NO ITAU",oFont10)
		ElseIf ::cBanco == "745"
			::oReport:say(nRow2+2055,100 ,"PAGÁVEL NA REDE BANCÁRIA ATÉ O VENCIMENTO",oFont10)
		Else
			::oReport:say(nRow2+2055,100 ,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		EndIf
		
		::oReport:say(nRow3+2000,1810,"Vencimento",oFont8)
		cString  := strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2040,nCol,cString,oFont11c)
		
		::oReport:say(nRow3+2100, 100,"Cedente",oFont8)
		if ::cBanco == "655"
			::oReport:say(nRow3+2140,100 ,"BANCO VOTORANTIM S/A",oFont10)	// Nome da Empresa
		elseif ::cBanco == "422"
			::oReport:say(nRow3+2140,100 ,"BANCO SAFRA S/A",oFont10)		// Nome da Empresa
		else
			::oReport:say(nRow3+2140,100 ,::aDadosEmp[1],oFont10)			// Nome da Empresa
		endif
		
		::oReport:say(nRow3+2100,1810,"Agência/Código Cedente",oFont8)
		If ::cBanco == "745"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+40      
			cString := "00001/0067435028"
			::oReport:say(nRow3+2140,nCol,cString,oFont10)
		ElseIf ::cBanco == "341"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+"-"+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+70
			::oReport:say(nRow1+2140,nCol,cString,oFont10)
		Else
			cString  := alltrim(Subs(::aDadosBanco[3],1,4))
			cString  += if(empty(Subs(::aDadosBanco[3],5,1)),"","-"+Subs(::aDadosBanco[3],5,1))+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5]
			nCol 	 := 1810+(374-(len(cString)*22))+40
			::oReport:say(nRow3+2140,nCol,cString ,oFont11c)
		EndIf
			
		::oReport:say(nRow3+2200, 100,"Data do Documento",oFont8)
		::oReport:say(nRow3+2230, 100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4), oFont10)
			
		::oReport:say(nRow3+2200, 505,"Nro.Documento",oFont8)
		::oReport:say(nRow3+2230, 605,::aDadosTit[6]+::aDadosTit[1],oFont10) // Prefixo+Numero+Parcela
		
		::oReport:say(nRow3+2200,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow3+2230,1050,::aDadosTit[7],oFont10) // Tipo do Titulo
		
		::oReport:say(nRow3+2200,1305,"Aceite",oFont8)
		::oReport:say(nRow3+2230,1400,"N",oFont10)
		
		::oReport:say(nRow3+2200,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow3+2230,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) // Data impressao
			
		::oReport:say(nRow3+2200,1810,"Nosso Número",oFont8)
		cString  := ::RetNossoNro() // Retorna o Nosso Número Formatado
		nCol 	 := 1800+(374-(len(cString)*22))
		::oReport:say(nRow3+2230,nCol,cString,oFont11c)	
		
		::oReport:say(nRow3+2270, 100,"Uso do Banco",oFont8)
		if ::cBanco == "422"
			::oReport:say(nRow3+2300,155 ,"CIP130",oFont10)
		elseIf ::cBanco == "745"
			::oReport:say(nRow2+2300,155 ,"RCO",oFont10)
		endif
		
		::oReport:say(nRow3+2270, 505,"Carteira",oFont8)
		::oReport:say(nRow3+2300, 555,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow3+2270, 755,"Espécie",oFont8)
		::oReport:say(nRow3+2300, 805,"R$",oFont10)
		
		::oReport:say(nRow3+2270,1005,"Quantidade",oFont8)
		::oReport:say(nRow3+2270,1485,"Valor",oFont8)
		
		::oReport:say(nRow3+2270,1810,"Valor do Documento",oFont8)
		cString  := Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2300,nCol,cString,oFont11c)
		

		::oReport:say(nRow3+2340, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		::oReport:say(nRow2+2390, 100,::aFrases[1],oFont10)
		::oReport:say(nRow2+2440, 100,::aFrases[2],oFont10)
		::oReport:say(nRow2+2490, 100,::aFrases[3],oFont8)//10
		::oReport:say(nRow2+2540, 100,::aFrases[4],oFont10)
		::oReport:say(nRow2+2590, 100,::aFrases[5],oFont10)
		::oReport:say(nRow2+2640, 100,::aFrases[6],oFont10)
		
		::oReport:say(nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
		aVet := u_GetDesc(cDadosSac,cNumTit,cSerieTit) // cod cliente, loja, num nf+serie 
		//If ::aDadosBanco[13] > 0 .AND. ::aDadosBanco[14] == '2'
		If Len (aVet) == 2
			nCol 	 := 1810+(374-(len(str(aVet[2])*22)))
			::oReport:say(nRow3+2370,nCol,"Desconto de " + AllTrim(Transform(aVet[1], "@E 99,999,999.99")) ,oFont8)
		EndIf							
		::oReport:say(nRow3+2410,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow3+2480,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow3+2550,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow3+2620,1810,"(=)Valor Cobrado",oFont8)
		if Len (aVet) == 2
			::oReport:say(nRow3+2650,1850,AllTrim(Transform(::aDadosTit[5]-aVet[1], "@E 99,999,999.99")) ,oFont8)
		endif
		
		::oReport:say(nRow3+2690, 100,"Sacado",oFont8)
		::oReport:say(nRow3+2700, 400,::aDadosSac[1]+" ("+::aDadosSac[2]+")" + Space(5) + "CNPJ: "+Transform(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10)
		
		::oReport:say(nRow3+2753, 400,::aDadosSac[3],oFont10)
		::oReport:say(nRow3+2806, 400,::aDadosSac[4]+" - "+::aDadosSac[5]+" - "+::aDadosSac[6],oFont10) // Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow3+2859, 400,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) // CNPJ
		else
			::oReport:say(nRow3+2859, 400,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	// CPF
		endif*/
		
		::oReport:say(nRow3+2868, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		If ::cBanco == "745"
			::oReport:say(nRow2+2908,1920,"Autenticação Mecânica",oFont8)
		ElseIf ::cBanco == "341"
			::oReport:say(nRow3+2908,1810,"Autenticação Mecânica - Ficha de Compensação",oFont8)
		Else
			::oReport:say(nRow3+2908,1810,"Autenticação Mecânica",oFont8)
		EndIf		
		
		::oReport:line(nRow3+2000,1800,nRow3+2690,1800) // Linha Vertical
		::oReport:line(nRow3+2410,1800,nRow3+2410,2300) // Linha Horizontal
		::oReport:line(nRow3+2480,1800,nRow3+2480,2300) // Linha Horizontal
		::oReport:line(nRow3+2550,1800,nRow3+2550,2300) // Linha Horizontal
		::oReport:line(nRow3+2620,1800,nRow3+2620,2300) // Linha Horizontal
		::oReport:line(nRow3+2690, 100,nRow3+2690,2300) // Linha Horizontal
		
		::oReport:line(nRow3+2905, 100,nRow3+2905,2300) // Linha Horizontal
		
		If ::cBanco == "745"
			::oReport:say(nRow3+2868,1920,"FICHA DE COMPENSAÇÃO",oFont10)
		ElseIf ::cBanco == "341"
			// Ja impresso anteriormente 
		Else
			::oReport:say(nRow3+3060,1800,"FICHA DE COMPENSAÇÃO",oFont10)
		EndIf
	
		/*	
		| Parametros do MSBAR                                              |
		+------------------------------------------------------------------+
		| 01 cTypeBar String com o tipo do codigo de barras                |
		|    "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"                    |
		|    "INT25","MAT25,"IND25","CODABAR","CODE3_9"                    |
		| 02 nRow           Numero da Linha em centimentros                |
		| 03 nCol           Numero da coluna em centimentros               |
		| 04 cCode          String com o conteudo do codigo                |
		| 05 oPr            Objeto Printer                                 |
		| 06 lcheck         Se calcula o digito de controle                |
		| 07 Cor            Numero da Cor, utilize a "common.ch"           |
		| 08 lHort          Se imprime na Horizontal                       |
		| 09 nWidth         Numero do Tamanho da barra em centimetros      |
		| 10 nHeigth        Numero da Altura da barra em milimetros        |
		| 11 lBanner        Se imprime o linha em baixo do codigo          |
		| 12 cFont          String com o tipo de fonte                     |
		| 13 cMode          String com o modo do codigo de barras CODE128  |
		*/
		
		// Conversão de Pixels para CM
		// Fator = 0,0084682	cm/pixel
		// Exemplo => 75 pixel = 0.63 cm; 2905 pixel = 24.60 cm; 3035 pixel = 25.70cm
	
		// Imprime o Código de Barra - ATENÇÃO! Dimensões podem variar dependendo da Impressora Selecionada
		// Sintaxe: MSBAR3(cTypeBar,nRow,nCol,cCode,::oReport,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode)
		// Padrão FEBRABAN => 2 de 5 Intercalado -> INT25
		// MSBAR3("INT25",25.3,1.4,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		MSBAR3("INT25",24.7,1.1,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		
	// MODELO DE LAYOUT 2
	elseif ::nModelo == 2
		
		/******************/
		/* PRIMEIRA PARTE */
		/******************/

		nRow1 := 0
		 
		::oReport:line(nRow1+0150,500,nRow1+0070, 500) // Linha Vertical
		::oReport:line(nRow1+0150,710,nRow1+0070, 710) // Linha Vertical
	   
	    ::oReport:sayBitMap(nRow1+0075,94,IIf(::aDadosBanco[1] == "341",aBitMap[1], aBitMap[2]),0400,0072)	    // Logotipo do Banco   //	::oReport:sayBitMap(nRow1+0075,94,aBitMap[1],0400,0072) 2018-07-06
      
		If ::aDadosBanco[1] == "033"
			::oReport:say(nRow1+0075,513,::aDadosBanco[1]+"-7",oFont21)	
		elseif ::aDadosBanco[1] == "655"
			::oReport:say(nRow1+0075,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
			::oReport:say(nRow1+0075,513,"237-2",oFont21)
		elseif ::aDadosBanco[1] == "745"
			::oReport:say(nRow1+0075,513,"745-5",oFont21)
		elseif ::aDadosBanco[1] == "341"
			::oReport:say(nRow1+0075,513,::aDadosBanco[1]+"-7",oFont21)//[1]Numero do Banco //Apply 2018-07-06
		else
			::oReport:say(nRow1+0075,513,::aDadosBanco[1]+"-2",oFont21)	// [1]Numero do Banco
		endif
		
		If ::cBanco == "422"
			::oReport:say(nRow1+0084,1900,"RECIBO DO SACADO",oFont10)
		Else
			::oReport:say(nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		EndIf
		::oReport:line(nRow1+0150,100,nRow1+0150,2300)
		
		If ::cBanco == "341"
			::oReport:say(nRow1+0150,100 ,"Beneficiario",oFont8)
		Else 
			::oReport:say(nRow1+0150,100 ,"Cedente",oFont8)
		Endif
		
		If ::cBanco == "422"
			::oReport:say(nRow1+0200,100 ,"BANCO SAFRA S/A",oFont10)	// Nome + CNPJ da Empresa   
		Elseif ::cBanco == "341"
			::oReport:say(nRow1+0200,100 ,substr(::aDadosEmp[1],1,17) +substr(::aDadosEmp[1],58,81),oFont10)
		Else
			::oReport:say(nRow1+0200,100 ,::aDadosEmp[1],oFont10)	// Nome + CNPJ da Empresa
		EndIf
		
		If ::cBanco == "341"
			::oReport:say(nRow1+0150,1060,"Agência/Código Beneficiario",oFont8)
		Else
			::oReport:say(nRow1+0150,1060,"Agência/Código Cedente",oFont8)
		Endif
		
		If ::cBanco == "745"
//			::oReport:say(nRow1+0200,1060,::aDadosBanco[3]+"/"+::aDadosBanco[4]+::aDadosBanco[5],oFont10)
			::oReport:say(nRow1+0200,1060,"00001/0067435028",oFont10)
		ElseIf ::cBanco == "422"
			::oReport:say(nRow1+0200,1060,::aDadosBanco[3]+"-"+::aDadosBanco[16]+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5],oFont10)		
		Else			
			::oReport:say(nRow1+0200,1060,::aDadosBanco[3]+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5],oFont10)
		EndIf
		
		::oReport:say(nRow1+0150,1510,"Nro.Documento",oFont8)
		::oReport:say(nRow1+0200,1510,::aDadosTit[6]+::aDadosTit[1],oFont10) // Prefixo+Numero+Parcela
		If ::cBanco == "341"
			::oReport:say(nRow1+0250,100 ,"Pagador",oFont8)
		Else 
			::oReport:say(nRow1+0250,100 ,"Sacado",oFont8)
		Endif
		::oReport:say(nRow1+0300,100 ,::aDadosSac[1],oFont10) // Nome do Cliente
		
		::oReport:say(nRow1+0250,1060,"Vencimento",oFont8)
		::oReport:say(nRow1+0300,1060,strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4),oFont10)
		
		::oReport:say(nRow1+0250,1510,"Valor do Documento",oFont8)
		::oReport:say(nRow1+0300,1550,Transform(::aDadosTit[5],"@E 99,999,999.99"),oFont10)
		
		::oReport:line(nRow1+0250, 100,nRow1+0250,1900 ) // Linha Horizontal
		::oReport:line(nRow1+0350, 100,nRow1+0350,1900 ) // Linha Horizontal
		::oReport:line(nRow1+0450,1050,nRow1+0450,1900 ) // Linha Horizontal
		::oReport:line(nRow1+0550, 100,nRow1+0550,2300 ) // Linha Horizontal		
	
		::oReport:line(nRow1+0550,1050,nRow1+0150,1050 ) // Linha Vertical
		::oReport:line(nRow1+0550,1400,nRow1+0350,1400 ) // Linha Vertical
		::oReport:line(nRow1+0350,1500,nRow1+0150,1500 ) // Linha Vertical
		::oReport:line(nRow1+0550,1900,nRow1+0150,1900 ) // Linha Vertical
		
		//If !::cBanco == "341" .AND. !::cBanco =="745"
			::oReport:say(nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
			::oReport:say(nRow1+0450,0100,"com as características acima.",oFont10)
			::oReport:say(nRow1+0350,1060,"Data",oFont8)
			::oReport:say(nRow1+0350,1410,"Assinatura",oFont8)
			::oReport:say(nRow1+0450,1060,"Data",oFont8)
			::oReport:say(nRow1+0450,1410,"Entregador",oFont8)		
			
			::oReport:say(nRow1+0165,1910,"(  )Mudou-se"                  	            	,oFont8)
			::oReport:say(nRow1+0205,1910,"(  )Ausente"                    	            ,oFont8)
			::oReport:say(nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
			::oReport:say(nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
			::oReport:say(nRow1+0325,1910,"(  )Não procurado"                             	,oFont8)
			::oReport:say(nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
			::oReport:say(nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
			::oReport:say(nRow1+0445,1910,"(  )Falecido"                                  	,oFont8)
			::oReport:say(nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)
		//EndIf
	
		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		
		nRow2 := 0
		
		// Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow2+0580, nI,nRow2+0580, nI+30)
		Next nI
		
		If ::cBanco == "341" 
			::oReport:sayBitMap(nRow2+0635,94,aBitMap[1],0400,0072)//::oReport:say(nRow2+0635,94,/*"Banco Itaú SA"*/aBitMap[1],oFont10)
		ElseIf ::cBanco == "422"
			::oReport:sayBitMap(nRow2+0635,94,aBitMap[2],0400,0072)		
		Else
			::oReport:sayBitMap(nRow2+0635,94,aBitMap[1],0400,0072)
		EndIf
		
		::oReport:line(nRow2+0710,100,nRow2+0710,2300) // Linha Horizontal
		::oReport:line(nRow2+0710,500,nRow2+0630, 500) // Linha Vertical
		::oReport:line(nRow2+0710,710,nRow2+0630, 710) // Linha Vertical
		
		// ::oReport:say(nRow2+0644,100,::aDadosBanco[2],oFont11 )		// [2]Nome do Banco

		if ::aDadosBanco[1] == "033"
			::oReport:say(nRow2+0635,513,::aDadosBanco[1]+"-7",oFont21)	// [1]Numero do Banco
		elseif ::aDadosBanco[1] == "655"
			::oReport:say(nRow2+0635,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
			::oReport:say(nRow2+0635,513,"237-2",oFont21)
		elseif ::aDadosBanco[1] == "745"
			::oReport:say(nRow1+0075,513,"745-5",oFont21)
		elseif ::aDadosBanco[1] == "341"
			::oReport:say(nRow2+0635,513,::aDadosBanco[1]+"-7",oFont21)//[1]Numero do Banco //Apply 2018-07-06
		else
			::oReport:say(nRow2+0635,513,::aDadosBanco[1]+"-2",oFont21)	// [1]Numero do Banco
		endif
		::oReport:say(nRow2+0644,755,::cLinhaDig,oFont15n)			// Linha Digitavel do Codigo de Barras
		
		::oReport:line(nRow2+0810,100,nRow2+0810,2300 ) // Linha Horizontal
		::oReport:line(nRow2+0910,100,nRow2+0910,2300 ) // Linha Horizontal
		::oReport:line(nRow2+0980,100,nRow2+0980,2300 ) // Linha Horizontal
		::oReport:line(nRow2+1050,100,nRow2+1050,2300 ) // Linha Horizontal
		
		::oReport:line(nRow2+0910,500,nRow2+1050,500)   // Linha Vertical
		::oReport:line(nRow2+0980,750,nRow2+1050,750)	 // Linha Vertical
		::oReport:line(nRow2+0910,1000,nRow2+1050,1000) // Linha Vertical
		::oReport:line(nRow2+0910,1300,nRow2+0980,1300) // Linha Vertical
		::oReport:line(nRow2+0910,1480,nRow2+1050,1480) // Linha Vertical
		
		::oReport:say(nRow2+0710,100 ,"Local de Pagamento",oFont8)
		if ::cBanco == "341"
			::oReport:say(nRow2+0750,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTO NO ITAU APÓS O VENCIMENTO, SOMENTE NO ITAU",oFont10)
		ElseIf ::cBanco == "745"
			::oReport:say(nRow2+0750,100 ,"PAGÁVEL NA REDE BANCÁRIA ATÉ O VENCIMENTO",oFont10)
		Else
			::oReport:say(nRow2+0750,100 ,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		EndIf
		
		::oReport:say(nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+0750,nCol,cString,oFont11c)
		
		If ::cBanco == "341"
			::oReport:say(nRow2+0810,100 ,"Beneficiario",oFont8)
		Else 
	   		::oReport:say(nRow2+0810,100 ,"Cedente",oFont8)
		Endif
		
		If ::cBanco == "422"		
			::oReport:say(nRow2+0850,100 ,"BANCO SAFRA S/A",oFont10) // Nome da Empresa
		Else
			::oReport:say(nRow2+0850,100 ,::aDadosEmp[1],oFont10) // Nome da Empresa
		EndIf
		If ::cBanco == "341"
			::oReport:say(nRow2+0810,1810,"Agência/Código Beneficiario",oFont8)
		Else
			::oReport:say(nRow2+0810,1810,"Agência/Código Cedente",oFont8)
		Endif
		If ::cBanco == "745"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+40       
			cString:="00001/0067435028"
			::oReport:say(nRow2+0850,nCol,cString,oFont10)
		ElseIf ::cBanco == "341"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+"-"+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+70
			::oReport:say(nRow1+0850,nCol,cString,oFont10)
		ElseIf ::cBanco == "422
			cString	:= ::aDadosBanco[3]+"-"+::aDadosBanco[16]+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5]
			nCol := 1810+(374-(len(cString)*22))+40
			::oReport:say(nRow2+0850,nCol,cString,oFont11c)
		Else
			cString := alltrim(Subs(::aDadosBanco[3],1,4)+If(Empty(Subs(::aDadosBanco[3],5,1)),"","-"+Subs(::aDadosBanco[3],5,1))+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+40
			::oReport:say(nRow2+0850,nCol,cString,oFont11c)
		EndIf
		
		::oReport:say(nRow2+0910,100 ,"Data do Documento",oFont8)
		::oReport:say(nRow2+0940,100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4),oFont10)
		
		::oReport:say(nRow2+0910,505 ,"Nro.Documento",oFont8)
		::oReport:say(nRow2+0940,605 ,::aDadosTit[6]+::aDadosTit[1],oFont10) // Prefixo+Numero+Parcela
		
		::oReport:say(nRow2+0910,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow2+0940,1050,::aDadosTit[7],oFont10) // Tipo do Titulo
		
		::oReport:say(nRow2+0910,1305,"Aceite",oFont8)
		::oReport:say(nRow2+0940,1400,"N",oFont10)
		
		::oReport:say(nRow2+0910,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow2+0940,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) // Data de impressao
		
		::oReport:say(nRow2+0910,1810,"Nosso Número",oFont8)
		cString:= ::RetNossoNro() // Retorna o Nosso Número Formatado
		nCol := 1800+(374-(len(cString)*22))
		::oReport:say(nRow2+0940,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0980,100 ,"Uso do Banco",oFont8)   
		if ::cBanco == "422"
			::oReport:say(nRow3+1010,155 ,"CIP130",oFont10)
		elseIf ::cBanco == "341"
			::oReport:say(nRow2+1010,155 ,"CIP504",oFont10)
		elseIf ::cBanco == "745"
			::oReport:say(nRow2+1010,155 ,"RCO",oFont10)
		endif
		
		::oReport:say(nRow2+0980,505 ,"Carteira",oFont8)
		::oReport:say(nRow2+1010,555 ,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow2+0980,755 ,"Espécie",oFont8)
		::oReport:say(nRow2+1010,805 ,"R$",oFont10)
		
		::oReport:say(nRow2+0980,1005,"Quantidade",oFont8)
		::oReport:say(nRow2+0980,1485,"Valor",oFont8)
		
		::oReport:say(nRow2+0980,1810,"Valor do Documento",oFont8)
		cString:= Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+1010,nCol,cString,oFont11c)
		If ::cBanco == "341" 
			::oReport:say(nRow2+1050, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiario)",oFont8)
		Else
			::oReport:say(nRow2+1050, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		Endif
		
		::oReport:say(nRow2+1100, 100,::aFrases[1],oFont10)
		::oReport:say(nRow2+1150, 100,::aFrases[2],oFont10)
		::oReport:say(nRow2+1200, 100,::aFrases[3],oFont8)//10
		::oReport:say(nRow2+1250, 100,::aFrases[4],oFont10)
		::oReport:say(nRow2+1300, 100,::aFrases[5],oFont10)
		::oReport:say(nRow2+1350, 100,::aFrases[6],oFont10) 
		
		::oReport:say(nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
		aVet := u_GetDesc(cDadosSac,cNumTit,cSerieTit) // cod cliente, loja, num nf+serie  
		//If ::aDadosBanco[13] > 0 .AND. ::aDadosBanco[14] == '2'
		If Len (aVet) == 2
			::oReport:say(nRow2+1080,1850,"Desconto de " + AllTrim(Transform(aVet[1], "@E 99,999,999.99")) ,oFont8)
		EndIf					
		::oReport:say(nRow2+1120,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow2+1190,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow2+1260,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow2+1330,1810,"(=)Valor Cobrado",oFont8)
		if Len (aVet) == 2                                                                 	
			::oReport:say(nRow2+1360,1850,AllTrim(Transform(::aDadosTit[5]-aVet[1], "@E 99,999,999.99")) ,oFont8)
		endif
		
		If ::cBanco == "341"
		   	::oReport:say(nRow2+1400,100 ,"Pagador",oFont8)
		Else
			::oReport:say(nRow2+1400,100 ,"Sacado",oFont8)
		Endif		
		
		::oReport:say(nRow2+1430,400 ,::aDadosSac[1]+" ("+::aDadosSac[2]+")" + Space(5) + "CNPJ: "+Transform(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10)
		::oReport:say(nRow2+1483,400 ,::aDadosSac[3],oFont10)
		::oReport:say(nRow2+1536,400 ,::aDadosSac[4]+" - "+::aDadosSac[5] + " - " + ::aDadosSac[6],oFont10) // Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow2+1589,400 ,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) // CNPJ
		else
			::oReport:say(nRow2+1589,400 ,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	// CPF
		endif*/
			
		::oReport:say(nRow2+1605, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		If ::cBanco == "745"
			::oReport:say(nRow2+1645,1920,"Autenticação Mecânica",oFont8)
		Else
			::oReport:say(nRow2+1645,1810,"Autenticação Mecânica",oFont8)
		EndIf		
		
		::oReport:line(nRow2+0710,1800,nRow2+1400,1800) 
		::oReport:line(nRow2+1120,1800,nRow2+1120,2300)
		::oReport:line(nRow2+1190,1800,nRow2+1190,2300)
		::oReport:line(nRow2+1260,1800,nRow2+1260,2300)
		::oReport:line(nRow2+1330,1800,nRow2+1330,2300)
		::oReport:line(nRow2+1400, 100,nRow2+1400,2300)
		::oReport:line(nRow2+1640, 100,nRow2+1640,2300)
		
		// Conversão de Pixels para CM
		// Fator = 0,0084682	cm/pixel
		// Exemplo => 75 pixel = 0.63 cm; 1645 pixel = 24.60 cm
	
		// Imprime o Código de Barra - ATENÇÃO! Dimensões podem variar dependendo da Impressora Selecionada
		// Sintaxe: MSBAR3(cTypeBar,nRow,nCol,cCode,::oReport,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode)
		// Padrão FEBRABAN => 2 de 5 Intercalado -> INT25		
		MSBAR3("INT25",14,1.1,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		
		/******************/
		/* TERCEIRA PARTE */
		/******************/
		
		nRow3 := 0
		
		// Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow3+1880, nI, nRow3+1880, nI+30)
		Next nI
		
		::oReport:line(nRow3+2000,100,nRow3+2000,2300) // Linha Horizontal
		::oReport:line(nRow3+2000,500,nRow3+1920,0500) // Linha Vertical
		::oReport:line(nRow3+2000,710,nRow3+1920,0710) // Linha Vertical

		If ::aDadosBanco[1] == "422"
			::oReport:sayBitMap(nRow1+1925,94,aBitMap[2],0400,0072) 	   // Logotipo do Banco 
		Elseif ::aDadosBanco[1] == "341"
	   		::oReport:sayBitMap(nRow3+1925,94,aBitMap[1],0400,0072)
		Else		
			::oReport:sayBitMap(nRow1+1925,94,aBitMap[1],0400,0072) 	   // Logotipo do Banco
		EndIf

		if ::aDadosBanco[1] == "033"
			::oReport:say(nRow3+1925,513,::aDadosBanco[1]+"-7",oFont21)	
		elseif ::aDadosBanco[1] == "655"
			::oReport:say(nRow3+1925,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
			::oReport:say(nRow3+1925,513,"237-2",oFont21)
		elseif ::aDadosBanco[1] == "745"
			::oReport:say(nRow1+0075,513,"745-5",oFont21)
		elseif ::aDadosBanco[1] == "341"
		::oReport:say(nRow3+1925,513,::aDadosBanco[1]+"-7",oFont21)	//Apply 2018-07-06
		else
			::oReport:say(nRow3+1925,513,::aDadosBanco[1]+"-2",oFont21)	// [1]Numero do Banco
		endif
		::oReport:say(nRow3+1934,755,::cLinhaDig,oFont15n)		   // Linha Digitavel do Codigo de Barras
		
		::oReport:line(nRow3+2100,100,nRow3+2100,2300) // Linha Horizontal
		::oReport:line(nRow3+2200,100,nRow3+2200,2300) // Linha Horizontal
		::oReport:line(nRow3+2270,100,nRow3+2270,2300) // Linha Horizontal
		::oReport:line(nRow3+2340,100,nRow3+2340,2300) // Linha Horizontal
		
		::oReport:line(nRow3+2200, 500,nRow3+2340, 500) // Linha Vertical
		::oReport:line(nRow3+2270, 750,nRow3+2340, 750) // Linha Vertical
		::oReport:line(nRow3+2200,1000,nRow3+2340,1000) // Linha Vertical
		::oReport:line(nRow3+2200,1300,nRow3+2270,1300) // Linha Vertical
		::oReport:line(nRow3+2200,1480,nRow3+2340,1480) // Linha Vertical
		
		::oReport:say(nRow3+2000, 100,"Local de Pagamento",oFont8)
		if ::cBanco == "341"
			::oReport:say(nRow2+2055,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTO NO ITAU APÓS O VENCIMENTO, SOMENTE NO ITAU",oFont10)
		ElseIf ::cBanco == "745"
			::oReport:say(nRow2+2055,100 ,"PAGÁVEL NA REDE BANCÁRIA ATÉ O VENCIMENTO",oFont10)
		Else
			::oReport:say(nRow2+2055,100 ,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		EndIf
		           
		::oReport:say(nRow3+2000,1810,"Vencimento",oFont8)
		cString  := strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2040,nCol,cString,oFont11c)
		
		IF ::cBanco == "341"
			::oReport:say(nRow3+2100, 100,"Beneficiario",oFont8)
		Else 
			::oReport:say(nRow3+2100, 100,"Cedente",oFont8)
		Endif
		
		If ::cBanco == "422"
			::oReport:say(nRow3+2140, 100,"BANCO SAFRA S/A",oFont10) // Nome da Empresa
		Else
			::oReport:say(nRow3+2140, 100,::aDadosEmp[1],oFont10) // Nome da Empresa
		EndIf
		If ::cBanco == "341"
			::oReport:say(nRow3+2100,1810,"Agência/Código Beneficiario",oFont8)
		Else
			::oReport:say(nRow3+2100,1810,"Agência/Código Cedente",oFont8)
		Endif
		If ::cBanco == "745"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+40     
			cString:="00001/0067435028"
			::oReport:say(nRow3+2140,nCol,cString,oFont10)
		ElseIf ::cBanco == "341"
			cString := AllTrim(::aDadosBanco[3])+"/"+AllTrim(::aDadosBanco[4])+"-"+AllTrim(::aDadosBanco[5])
			nCol := 1810+(374-(len(cString)*22))+70
			::oReport:say(nRow1+2140,nCol,cString,oFont10)
		ElseIf ::cBanco == "422
			cString	:= ::aDadosBanco[3]+"-"+::aDadosBanco[16]+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5]
			nCol 	 := 1810+(374-(len(cString)*22))+40
			::oReport:say(nRow3+2140,nCol,cString ,oFont11c)
		Else
			cString  := alltrim(Subs(::aDadosBanco[3],1,4)+If(Empty(Subs(::aDadosBanco[3],5,1)),"","-"+Subs(::aDadosBanco[3],5,1))+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5])
			nCol 	 := 1810+(374-(len(cString)*22))+40
			::oReport:say(nRow3+2140,nCol,cString ,oFont11c)
		EndIf
			
		::oReport:say(nRow3+2200, 100,"Data do Documento",oFont8)
		::oReport:say(nRow3+2230, 100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4), oFont10)
			
		::oReport:say(nRow3+2200, 505,"Nro.Documento",oFont8)
		::oReport:say(nRow3+2230, 605,::aDadosTit[6]+::aDadosTit[1],oFont10) // Prefixo+Numero+Parcela
		
		::oReport:say(nRow3+2200,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow3+2230,1050,::aDadosTit[7],oFont10) // Tipo do Titulo
		
		::oReport:say(nRow3+2200,1305,"Aceite",oFont8)
		::oReport:say(nRow3+2230,1400,"N",oFont10)
		
		::oReport:say(nRow3+2200,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow3+2230,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) // Data impressao
			
		::oReport:say(nRow3+2200,1810,"Nosso Número",oFont8)
		cString  := ::RetNossoNro() // Retorna o Nosso Número Formatado
		nCol 	 := 1800+(374-(len(cString)*22))
		::oReport:say(nRow3+2230,nCol,cString,oFont11c)	
		
		::oReport:say(nRow3+2270, 100,"Uso do Banco",oFont8)
		
		if ::cBanco == "422"
			::oReport:say(nRow3+2300, 155,"CIP130",oFont10)
		elseIf ::cBanco == "341"
			::oReport:say(nRow3+2300, 155,"CIP504",oFont10)
		elseIf ::cBanco == "745"
			::oReport:say(nRow2+2300,155 ,"RCO",oFont10)
		endif
		
		::oReport:say(nRow3+2270, 505,"Carteira",oFont8)
		::oReport:say(nRow3+2300, 555,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow3+2270, 755,"Espécie",oFont8)
		::oReport:say(nRow3+2300, 805,"R$",oFont10)
		
		::oReport:say(nRow3+2270,1005,"Quantidade",oFont8)
		::oReport:say(nRow3+2270,1485,"Valor",oFont8)
		
		::oReport:say(nRow3+2270,1810,"Valor do Documento",oFont8)
		cString  := Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2300,nCol,cString,oFont11c)
		
		IF ::cBanco == "341"
			::oReport:say(nRow3+2340, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiario)",oFont8)
		else
			::oReport:say(nRow3+2340, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		endif
		
		::oReport:say(nRow2+2390, 100,::aFrases[1],oFont10)
		::oReport:say(nRow2+2440, 100,::aFrases[2],oFont10)
		::oReport:say(nRow2+2490, 100,::aFrases[3],oFont8)//10
		::oReport:say(nRow2+2540, 100,::aFrases[4],oFont10)
		::oReport:say(nRow2+2590, 100,::aFrases[5],oFont10)
		::oReport:say(nRow2+2640, 100,::aFrases[6],oFont10)
		
		::oReport:say(nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
		aVet := u_GetDesc(cDadosSac,cNumTit,cSerieTit) // cod cliente, loja, num nf+serie  
		//If ::aDadosBanco[13] > 0 .AND. ::aDadosBanco[14] == '2'
		If Len (aVet) == 2
			::oReport:say(nRow3+2370,1850,"Desconto de " + AllTrim(Transform(aVet[1], "@E 99,999,999.99")) ,oFont8)
		EndIf					
		::oReport:say(nRow3+2410,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow3+2480,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow3+2550,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow3+2620,1810,"(=)Valor Cobrado",oFont8)
		if Len (aVet) == 2
				::oReport:say(nRow3+2650,1850,AllTrim(Transform(::aDadosTit[5]-aVet[1], "@E 99,999,999.99")) ,oFont8)
		endif
		If ::cBanco == "341"
			::oReport:say(nRow3+2690, 100,"Pagador",oFont8)
		Else 
			::oReport:say(nRow3+2690, 100,"Sacado",oFont8)
		Endif
		::oReport:say(nRow3+2700, 400,::aDadosSac[1]+" ("+::aDadosSac[2]+")" + Space(5) + "CNPJ: "+Transform(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10)
		
		::oReport:say(nRow3+2753, 400,::aDadosSac[3],oFont10)
		::oReport:say(nRow3+2806, 400,::aDadosSac[4]+" - "+::aDadosSac[5]+" - "+::aDadosSac[6],oFont10) // Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow3+2859, 400,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) // CNPJ
		else
			::oReport:say(nRow3+2859, 400,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	// CPF
		endif*/
		
		::oReport:say(nRow3+2868, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		If ::cBanco == "745"
			::oReport:say(nRow3+2908,1920,"Autenticação Mecânica",oFont8)
		ElseIf ::cBanco == "341"
			::oReport:say(nRow3+2908,1810,"Autenticação Mecânica - Ficha de Compensação",oFont8)
		Else
			::oReport:say(nRow3+2908,1810,"Autenticação Mecânica",oFont8)
		EndIf
		
		::oReport:line(nRow3+2000,1800,nRow3+2690,1800) // Linha Vertical
		::oReport:line(nRow3+2410,1800,nRow3+2410,2300) // Linha Horizontal
		::oReport:line(nRow3+2480,1800,nRow3+2480,2300) // Linha Horizontal
		::oReport:line(nRow3+2550,1800,nRow3+2550,2300) // Linha Horizontal
		::oReport:line(nRow3+2620,1800,nRow3+2620,2300) // Linha Horizontal
		::oReport:line(nRow3+2690, 100,nRow3+2690,2300) // Linha Horizontal
		
		::oReport:line(nRow3+2905, 100,nRow3+2905,2300) // Linha Horizontal
		
		If ::cBanco == "745"
			::oReport:say(nRow3+2868,1920,"FICHA DE COMPENSAÇÃO",oFont10)
		ElseIf ::cBanco == "341"
			//Ja Impresso
		Else
			::oReport:say(nRow3+3060,1800,"FICHA DE COMPENSAÇÃO",oFont10)
		EndIf
	
		/*	
		| Parametros do MSBAR                                              |
		+------------------------------------------------------------------+
		| 01 cTypeBar String com o tipo do codigo de barras                |
		|    "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"                    |
		|    "INT25","MAT25,"IND25","CODABAR","CODE3_9"                    |
		| 02 nRow           Numero da Linha em centimentros                |
		| 03 nCol           Numero da coluna em centimentros               |
		| 04 cCode          String com o conteudo do codigo                |
		| 05 oPr            Objeto Printer                                 |
		| 06 lcheck         Se calcula o digito de controle                |
		| 07 Cor            Numero da Cor, utilize a "common.ch"           |
		| 08 lHort          Se imprime na Horizontal                       |
		| 09 nWidth         Numero do Tamanho da barra em centimetros      |
		| 10 nHeigth        Numero da Altura da barra em milimetros        |
		| 11 lBanner        Se imprime o linha em baixo do codigo          |
		| 12 cFont          String com o tipo de fonte                     |
		| 13 cMode          String com o modo do codigo de barras CODE128  |
		*/
		
		// Conversão de Pixels para CM
		// Fator = 0,0084682	cm/pixel
		// Exemplo => 75 pixel = 0.63 cm; 2905 pixel = 24.60 cm; 3035 pixel = 25.70cm
	
		// Imprime o Código de Barra - ATENÇÃO! Dimensões podem variar dependendo da Impressora Selecionada
		// Sintaxe: MSBAR3(cTypeBar,nRow,nCol,cCode,::oReport,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode)
		// Padrão FEBRABAN => 2 de 5 Intercalado -> INT25
		// MSBAR3("INT25",25.3,1.4,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		MSBAR3("INT25",24.7,1.1,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)		
	
	// MODELO DE LAYOUT 3 (NOVO LAYOUT CONTENDO 2 VIAS - 03/11/2015)
	ElseIf ::nModelo == 3
	
		//+----------------------------------------------------------------+
		//| Efetua pré ajustes de valores antes de enviar para a impressão |
		//+----------------------------------------------------------------+
		// Código do Banco
		If ::cBanco == "033"
			::aDadosBanco[1] := ::aDadosBanco[1] + "-7"	
		ElseIf ::cBanco == "655"
			::aDadosBanco[1] := "341"
		ElseIf ::cBanco == "422"
			::aDadosBanco[1] := "237-2"
		ElseIf ::cBanco == "745"
			::aDadosBanco[1] := "745-5"
		Else
			::aDadosBanco[1] := ::aDadosBanco[1] + "-2"
		EndIf
		
		// Agência / Código do Cedente
		If ::cBanco == "745"
			::aDadosBanco[17] := "00001/0067435028"
		ElseIf ::cBanco == "422"
			::aDadosBanco[17] := ::aDadosBanco[3] + "-" + ::aDadosBanco[16] + "/" + ::aDadosBanco[4] + "-" + ::aDadosBanco[5]		
		Else			
			::aDadosBanco[17] := ::aDadosBanco[3] + "/" + ::aDadosBanco[4] + "-" + ::aDadosBanco[5]
		EndIf		
		
		// Valores do Título
		::aDadosTit[05] := Transform(::aDadosTit[05],"@E 99,999,999.99")
		::aDadosTit[10] := Iif(Empty(::aDadosTit[10]), "", AllTrim(Transform(::aDadosTit[10], "@E 99,999,999.99")))
		::aDadosTit[11] := Iif(Empty(::aDadosTit[11]), "", AllTrim(Transform(::aDadosTit[11], "@E 99,999,999.99"))) 
		
		// CNPJ/CPF do Pagador (ou Sacado)
		If ::aDadosSac[8] = "J"
			::aDadosSac[7] := "CNPJ: " + Transform(::aDadosSac[7], "@R 99.999.999/9999-99")
		Else
			::aDadosSac[7] := "CPF: " + Transform(::aDadosSac[7], "@R 999.999.999-99")
		EndIf
		
		// Local de Pagamento
		If ::cBanco == "341"
			::cLocal := "Até o vencimento, preferencialmente no ITAÚ. Após o vencimento, somente no ITAÚ"
		ElseIf ::cBanco == "745"
			::cLocal := "Pagável na rede bancária até o vencimento"
		ElseIf ::cBanco == "237"
			::cLocal := "Pagável preferencialmente em qualquer agência BRADESCO"
		Else
			::cLocal := "Qualquer banco até o vencimento"
		EndIf
		
		If lPrimImp
			nRow := 0
		Else
			nRow := 1660
		EndIf
		
		//+-------------------------+
		//| Imprime o boleto.       |
		//+-------------------------+
		::ImpBolNovo(nRow, aBitMap)
		
		lPrimImp := !lPrimImp
		
	EndIf
				
	// Finaliza a página
	If ::nModelo <> 3 .Or. lPrimImp
		::oReport:EndPage()
	EndIf

Return


/**************************************************************************************************
Método:
ImpBolNovo

Autor:
Tiago Bandeira Brasiliano

Data:
03/11/2015

Descrição:
Impreme as informações do novo modelo de boleto.
**************************************************************************************************/
Method ImpBolNovo(nRow, aBitMap) Class Boleto

Local oFont11  := TFont():new("Arial", 9, 11, .T., .F., 5, .T., 5, .T., .F.)
Local oFont12  := TFont():new("Arial", 9, 12, .T., .F., 5, .T., 5, .T., .F.)
Local oFont12N := TFont():new("Arial", 9, 12, .T., .T., 5, .T., 5, .T., .F.)
Local oFont14  := TFont():new("Arial", 9, 14, .T., .T., 5, .T., 5, .T., .F.)
	
//+-------------------------+
//| IMPRESSÃO DO  BOX 1     |
//+-------------------------+
//Linhas
::oReport:Line( nRow + 0070, 0100, nRow + 0070, 2110 )
::oReport:Line( nRow + 0200, 0100, nRow + 0200, 2110 )
::oReport:Line( nRow + 0290, 0100, nRow + 0290, 2110 )
::oReport:Line( nRow + 0380, 0100, nRow + 0380, 2110 )
::oReport:Line( nRow + 0440, 0100, nRow + 0440, 1300 )
::oReport:Line( nRow + 0500, 0100, nRow + 0500, 2110 )

// Colunas
::oReport:Line( nRow + 0070, 0100, nRow + 0500, 0100 )
::oReport:Line( nRow + 0290, 0500, nRow + 0380, 0500 )
::oReport:Line( nRow + 0290, 0900, nRow + 0380, 0900 )
::oReport:Line( nRow + 0070, 1300, nRow + 0500, 1300 )
::oReport:Line( nRow + 0070, 1710, nRow + 0500, 1710 )
::oReport:Line( nRow + 0070, 2110, nRow + 0500, 2110 )

::SayInform(nRow - 0010, 1800, "Recibo do Pagador")

::SayHeader(nRow + 0070, 0100, "Beneficiário")
::SayInform(nRow + 0070, 0100, ::aDadosEmp[1],7)//Carlos
::SayInform(nRow + 0115, 0100, ::aDadosEmp[2] + " - " + ::aDadosEmp[3] + " - " + ::aDadosEmp[4])
::SayHeader(nRow + 0070, 1300, "Agência/Código Beneficiário")
::SayInform(nRow + 0070, 1300, ::aDadosBanco[17])
::SayHeader(nRow + 0070, 1710, "Vencimento")
::SayInform(nRow + 0070, 1710, StrZero(Day(::aDadosTit[4]),2) + "/" + StrZero(Month(::aDadosTit[4]),2) + "/" + Right(Str(Year(::aDadosTit[4])),4))

::SayHeader(nRow + 0200, 0100, "Pagador")
::SayInform(nRow + 0200, 0100, ::aDadosSac[1])
::SayHeader(nRow + 0200, 1300, "Número do Documento")
::SayInform(nRow + 0200, 1300, ::aDadosTit[6] + ::aDadosTit[1])
::SayHeader(nRow + 0200, 1710, "Nosso Número")
::SayInform(nRow + 0200, 1710, ::RetNossoNro())

::SayHeader(nRow + 0290, 0100, "Espécie")
::SayInform(nRow + 0290, 0100, "R$")
::SayHeader(nRow + 0290, 0500, "Quantidade")
::SayInform(nRow + 0290, 0500, "")
::SayHeader(nRow + 0290, 0900, "(x) Valor")
::SayInform(nRow + 0290, 0900, "")
::SayHeader(nRow + 0290, 1300, "(=) Valor do Documento")
::SayInform(nRow + 0290, 1300, ::aDadosTit[5])
::SayHeader(nRow + 0290, 1710, "(-) Desconto")
::SayInform(nRow + 0290, 1710, ::aDadosTit[10])

::SayHeader(nRow + 0395, 0100, "Sacador/Avalista: ")
::SayInform(nRow + 0355, 0310, ::aDadosBanco[11],6) //Carlos
::SayHeader(nRow + 0380, 1300, "(+) Outros Acréscimos")
::SayInform(nRow + 0380, 1300, "")
::SayHeader(nRow + 0380, 1710, "(=) Valor Cobrado")
::SayInform(nRow + 0380, 1710, "")

::SayHeader(nRow + 0455, 0100, "Demonstrativo: ")

::SayHeader(nRow + 0500, 1000, "Autenticação Mecânica")
::SayHeader(nRow + 0535, 0150, Replicate("-", 170) + " Corte Aqui " + Replicate("-", 040))

//+-------------------------+
//| IMPRESSÃO DO  BOX 2     |
//+-------------------------+		
//Linhas	
::oReport:Line( nRow + 0670, 0100, nRow + 0670, 2110 )
::oReport:Line( nRow + 0760, 0100, nRow + 0760, 2110 )
::oReport:Line( nRow + 0870, 0100, nRow + 0870, 2110 )
::oReport:Line( nRow + 0960, 0100, nRow + 0960, 2110 )
::oReport:Line( nRow + 1050, 0100, nRow + 1050, 2110 )
::oReport:Line( nRow + 1100, 1820, nRow + 1100, 2110 )
::oReport:Line( nRow + 1150, 1820, nRow + 1150, 2110 )
::oReport:Line( nRow + 1200, 1820, nRow + 1200, 2110 )
::oReport:Line( nRow + 1250, 0100, nRow + 1250, 2110 )
::oReport:Line( nRow + 1380, 0100, nRow + 1380, 2110 )

// Colunas
::oReport:Line( nRow + 0610, 0540, nRow + 0670, 0540 )
::oReport:Line( nRow + 0610, 0700, nRow + 0670, 0700 )

::oReport:Line( nRow + 0670, 0100, nRow + 1380, 0100 )
::oReport:Line( nRow + 0870, 0390, nRow + 1050, 0390 )
::oReport:Line( nRow + 0960, 0670, nRow + 1050, 0670 )
::oReport:Line( nRow + 0870, 0960, nRow + 1050, 0960 )
::oReport:Line( nRow + 0870, 1250, nRow + 0960, 1250 )
::oReport:Line( nRow + 0870, 1530, nRow + 1050, 1530 )
::oReport:Line( nRow + 0670, 1820, nRow + 1250, 1820 )
::oReport:Line( nRow + 0670, 2110, nRow + 1380, 2110 )

::oReport:sayBitMap(nRow + 0550, 0120, aBitMap[1], 0360, 0110) // Logotipo do Banco

::oReport:Say(nRow + 0620, 0553, ::aDadosBanco[1], oFont14)
::oReport:Say(nRow + 0620, 1000, ::cLinhaDig, oFont11)		

::SayHeader(nRow + 0690, 0100, "Local do Pagamento: ")
::SayInform(nRow + 0640, 0350, ::cLocal)
::SayHeader(nRow + 0670, 1820, "Vencimento")
::SayInform(nRow + 0670, 1820, StrZero(Day(::aDadosTit[4]),2) + "/" + StrZero(Month(::aDadosTit[4]),2) + "/" + Right(Str(Year(::aDadosTit[4])),4))

::SayHeader(nRow + 0760, 0100, "Beneficiário")
::SayInform(nRow + 0750, 0100, ::aDadosEmp[1])
::SayInform(nRow + 0785, 0100, ::aDadosEmp[2] + " - " + ::aDadosEmp[3] + " - " + ::aDadosEmp[4])
::SayHeader(nRow + 0760, 1820, "Agência/Código")
::SayHeader(nRow + 0790, 1820, "Beneficiário")
::SayInform(nRow + 0785, 1820, ::aDadosBanco[17])

::SayHeader(nRow + 0870, 0100, "Data Documento")
::SayInform(nRow + 0870, 0100, StrZero(Day(::aDadosTit[2]),2) + "/" + StrZero(Month(::aDadosTit[2]),2) + "/" + Right(Str(Year(::aDadosTit[2])),4))
::SayHeader(nRow + 0870, 0390, "Número do Documento")
::SayInform(nRow + 0870, 0390, ::aDadosTit[6] + ::aDadosTit[1])
::SayHeader(nRow + 0870, 0960, "Espécie Doc.")
::SayInform(nRow + 0870, 0960, ::aDadosTit[7])
::SayHeader(nRow + 0870, 1250, "Aceite")
::SayInform(nRow + 0870, 1250, "N")
::SayHeader(nRow + 0870, 1530, "Data Processamento")
::SayInform(nRow + 0870, 1530, StrZero(Day(::aDadosTit[3]),2) + "/" + StrZero(Month(::aDadosTit[3]),2) + "/" + Right(Str(Year(::aDadosTit[3])),4))
::SayHeader(nRow + 0870, 1820, "Nosso Número")
::SayInform(nRow + 0870, 1820, ::RetNossoNro())

::SayHeader(nRow + 0960, 0100, "Uso do Banco")
::SayInform(nRow + 0960, 0100, "")
::SayHeader(nRow + 0960, 0290, "CIP")
::SayInform(nRow + 0960, 0290, "")
::SayHeader(nRow + 0960, 0390, "Carteira")
::SayInform(nRow + 0960, 0390, ::aDadosBanco[7])
::SayHeader(nRow + 0960, 0670, "Espécie")
::SayInform(nRow + 0960, 0670, "R$")
::SayHeader(nRow + 0960, 0960, "Quantidade")
::SayInform(nRow + 0960, 0960, "")
::SayHeader(nRow + 0960, 1530, "(x) Valor")
::SayInform(nRow + 0960, 1530, "")
::SayHeader(nRow + 0960, 1820, "(=) Valor do Documento")
::SayInform(nRow + 0960, 1820, ::aDadosTit[5])

::SayHeader(nRow + 1050, 0100, "Instruções (texto de responsabilidade do beneficiário)")
::SayInform(nRow + 1050, 0100, ::aFrases[1])
::SayInform(nRow + 1095, 0100, ::aFrases[2])
::SayInform(nRow + 1140, 0100, ::aFrases[3])
::SayHeader(nRow + 1050, 1820, "(-) Desconto") 
::SayHeader(nRow + 1100, 1820, "(+) Mora/Multa")
::SayHeader(nRow + 1150, 1820, "(+) Outros Acréscimos")
::SayHeader(nRow + 1200, 1820, "(=) Valor Cobrado")

::SayHeader(nRow + 1260, 0100, "Pagador:")
::SayInform(nRow + 1210, 0210, ::aDadosSac[1] + " (" + ::aDadosSac[2] + ")" + Space(1) + ::aDadosSac[7]) //Carlos
::SayInform(nRow + 1250, 0100, ::aDadosSac[3] + " - " + ::aDadosSac[4] + " - " + ::aDadosSac[5] + " - CEP: " + ::aDadosSac[6])
::SayHeader(nRow + 1340, 0100, "Sacador/Avalista: ")
::SayInform(nRow + 1290, 0310, ::aDadosBanco[11])

::SayHeader(nRow + 1340, 1810, "Ficha de Compensação")

::SayHeader(nRow + 1380, 1600, "Autenticação Mecânica")

MSBAR3("INT25", (nRow + 1380) / 117.5, 0.9, ::cCodBarra, ::oReport,.F.,Nil,Nil,0.029,1.1,Nil,Nil,"A",.F.)   //11.76 e 25.84

Return Nil


/**************************************************************************************************
Método:
SayHeader

Autor:
Tiago Bandeira Brasiliano

Data:
03/11/2015

Descrição:
Efetua a impressão dos títulos dos boxes (já aplicando o espaçamento entre a linha superior e a
coluna da esquerda.

Parâmetros:
nLinha  => Número da Linha que foi impressa acima de onde o texto deverá ser posicionado.
nColuna => Número onde foi impressa a coluna a esquerda de onde o texto deverá ser posicionado.
cTexto  => Texto que será impresso (a função já adiciona espaços entre a linha e coluna informadas)

Retorno:
Nenhum
**************************************************************************************************/
Method SayHeader(nLinha, nColuna, cTexto) Class Boleto

local oFonte     := TFont():new("Arial", 9, 7, .T., .F., 5, .T., 5, .T., .F.)
Local nDeslocLin := 5 
Local nDeslocCol := 10

::oReport:Say(nLinha + nDeslocLin, nColuna + nDeslocCol, cTexto, oFonte)

Return Nil


/**************************************************************************************************
Função:
Método

Autor:
Tiago Bandeira Brasiliano

Data:
03/11/2015

Descrição:
Efetua a impressão das informações dos boxes (já aplicando o espaçamento entre a linha superior e a
coluna da esquerda.

Parâmetros:
nLinha  => Número da Linha que foi impressa acima de onde o texto deverá ser posicionado.
nColuna => Número onde foi impressa a coluna a esquerda de onde o texto deverá ser posicionado.
cTexto  => Texto que será impresso (a função já adiciona espaços entre a linha e coluna informadas)

Retorno:
Nenhum
**************************************************************************************************/
Method SayInform(nLinha, nColuna, cTexto,nTam,nLarg) Class Boleto

local oFonte     := TFont():new("Arial", 9, 8, .T., .T., 5, .T., 5, .T., .F.)
Local nDeslocLin := 50 
Local nDeslocCol := 10 

Default nTam := 0
Default nLarg:= 0

if nTam <> 0                                                                 
	oFonte:nHeight:= nTam
	if nLarg <> 0        
		oFonte:nWidth:= nLarg
	endif
endif

::oReport:Say(nLinha + nDeslocLin, nColuna + nDeslocCol, cTexto, oFonte)

Return Nil


// #########################################################################
// FUNÇÕES AUXILIARES
// #########################################################################

// Função de Modulo10 para retorno do dígito verificador de Partes da Linha Digitável
// Baseada no Cálculo do Banco do Brasil e na Função Modulo11
User Function Modulo10(cStr,nMultIni,nMultFim,cTipo)

	local nCont	  := 0 
	local nSoma	  := 0 
	local nRes	  := 0
	local cChar   := ""
	local nMult   := nMultIni
	local cRet	  := ""
	
	default nMultIni:= 2
	default nMultFim:= 1
	default cTipo   := "Dezena" // Tipo de Subtração Final "Dezena" ou "Divisor"
	
	// Prepara a String
	cStr := alltrim(cStr)
	
	// Percorre da Direita para a Esquerda
	For nCont := Len(cStr) to 1 Step -1
		// Avalia se o Item é um número
		cChar := subStr(cStr,nCont,1)
		if isAlpha( cChar )
			Help(" ", 1, "ONLYNUM")
			return .f.
		End
		
		// Calcula a multiplicação e se for maior que 9 soma os 2 algarismos para sempre retornar 1 dígito 
		nRes:= val(cChar) * nMult
		if nRes > 9
			nRes:= val(left(Str(nRes,2),1)) + val(Right(Str(nRes,2),1))
		endif
		
		// Acumula a Soma da Multiplicação dos Elementos pelo Multiplicador
		nSoma += nRes 
		
		// Redefine o Novo Multiplicador
		nMult:= IIf(nMult==nMultfim,nMultIni,If(nMultIni>nMultfim,--nMult,++nMult))
	Next
	
	// Calcula a Dezena imediatamente posterior a Soma Calculada	
	nDezena := alltrim(Str(nSoma,12))
	nDezena := val(alltrim(Str(val(subStr(nDezena,1,1))+1,12))+"0")	
	
	// Calcula o Resto da Divisão
	nRest := Mod(nSoma,10)
	
	// Calcula o DV Final
	if cTipo == "Dezena"
		cRet  := Right(Str(nDezena - nRest),1)
	elseif cTipo == "Divisor"
		if nRest == 0
			cRet := "0"
		else
			cRet := Right(Str(10 - nRest),1)
		endif
	endif
	
return (cRet)

// Função de Modulo11 do Padrão do Sistema (Fonte SM1M150) modificada para retorno do dígito verificador de diversos bancos	
// Uso de Exemplo:  Alert(U_Modulo11("28398200001",9,2,"001"))
User Function Modulo11(cStr,nMultIni,nMultFim,cBanco,nTipo)

	local nCont	  := 0 
	local nSoma	  := 0
	local cChar   := ""
	local nMult   := 0
	local cRet	  := ""
	
	default nMultIni:= 9
	default nMultFim:= 2
	default nTipo   := 1 // 1=Nosso Número / 2=Codigo de Barras
	
	nMult   := nMultIni
	
	// Prepara a String
	cStr := alltrim(cStr)
	
	// Percorre da Direita para a Esquerda
	For nCont := Len(cStr) to 1 Step -1
		// Avalia se o Item é um número
		cChar := subStr(cStr,nCont,1)
		if isAlpha( cChar )
			Help(" ", 1, "ONLYNUM")
			return .f.
		EndIf
		
		// Acumula a Soma da Multiplicação dos Elementos pelo Multiplicador
		nSoma += val(cChar) * nMult
		
		// Redefine o Novo Multiplicador
		nMult:= IIf(nMult==nMultfim,nMultIni,If(nMultIni>nMultfim,--nMult,++nMult))
	Next
	
	// Calcula o Resto da Divisão
	nRest := Mod(nSoma,11)
	
	// Define Como será o Resultado do Dígito Verificador

	// Se for Banco do Brasil
	if cBanco == "001"
		if nTipo == 1 // Para Nosso Número
			if nRest < 10
				cRet:= Str(nRest,1)
			elseif nRest == 10
				cRet:= "X"
			endif 
		
		elseif nTipo == 2 // Para Código de Barras
			nRest:= 11 - nRest
			if nRest == 0 .Or. nRest == 10 .Or. nRest == 11
				cRet:= "1"
			else
				cRet:= Str(nRest,1)
			endif
		endif

	// Se for Santander
	elseif cBanco == "033"

		If nTipo == 1 // Para Nosso Numero
			If nRest == 10
				cRet := "1"
			Elseif nRest == 0 .Or. nRest == 1
				cRet := "0"
			Else
				nRest := 11-nRest
				cRet := Alltrim(Str(nRest))
			Endif
		ElseIf nTipo == 2 // Para Codigo de Barras
			If nRest == 0 .OR. nRest == 1 .OR. nRest == 10
				cRet := "1"
			Else
				nRest := 11-nRest
				cRet := Alltrim(Str(nRest))
			EndIf  								
		EndIf
									
	// Se for Bradesco
	elseif cBanco == "237" 

		If nTipo == 2  
			If nRest == 0 .OR. nRest == 1 .OR. nRest > 9
				cRet:= "1"
			Else
				nRest := 11-nRest
				cRet := Alltrim(Str(nRest))
			Endif
		Endif
		If nTipo != 2
			If nRest == 0
				cRet := "0"
			Elseif nRest == 1
				cRet := "P"
			Else
				nRest := 11-nRest
				cRet := Alltrim(Str(nRest))
			Endif
		Endif
		
	// Se for Safra
	elseif cBanco == "422" 
		
		If nTipo == 1
			if nRest == 0
				cRet := "1"
			elseif nRest == 1 // 11 - 1 = 10 => P
				cRet := "0"
			else
				nRest := 11-nRest
				cRet  := Str(nRest,1)					
			endif  
		Else
			If nRest == 0 .OR. nRest == 1 .OR. nRest > 9
				cRet:= "1"
			Else
				nRest := 11-nRest
				cRet := Alltrim(Str(nRest))
			Endif
		Endif
		
	// Se for Itau ou Votorantim 
		elseif cBanco == "341" .or. cBanco == "655"
		nRest := 11-nRest
		nRest := Iif (nRest == 0 .Or. nRest == 1 .Or. nRest == 10 .Or. nRest == 11, 1 , nRest)
		cRet  := Str(nRest,1)
	
	// Se for Caixa Econômica Federal
	elseif cBanco == "104"
		nRest := 11-nRest
		nRest := Iif (nRest > 9, 0 , nRest)
		cRet  := Str(nRest,1)
	
	// Se for CitiBank
	elseif cBanco == "745"
		if nTipo == 1 // nosso numero
			nRest := IIf(nRest==0 .or. nRest==1, 0 , 11-nRest)
		elseif nTipo == 2 // codigo de barras
			nRest := IIf(nRest==0 .or. nRest==1, 1 , 11-nRest)
		EndIf
		cRet  := Str(nRest,1)
	// Se Banco não Especificado ou não constar tratamento para o banco - Considera o Cálculo Padrão
	else
		nRest := IIf(nRest==0 .or. nRest==1, 0 , 11-nRest)
		cRet  := Str(nRest,1)
	endif
	
return cRet
  
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçã    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                  	  		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

	local _sAlias	:= Alias()
	local aCposSX1	:= {}
	local nX 		:= 0
	local lAltera	:= .F.
	local nCondicao := nil
	local cKey		:= ""
	local nJ		:= 0

	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
				"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
				"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
				"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
				"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
				"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
				"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
				"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		lAltera := .F.
		if MsSeek(PADR(cPerg,10)+Right(aPergs[nX][11], 2))
			if (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
				 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
				aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
				lAltera := .T.
			endif
		endif
		
		if ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
	 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	 	endif	
		
		if ! Found() .Or. lAltera
			RecLock("SX1",If(lAltera, .F., .T.))
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with Right(aPergs[nX][11], 2)
			For nj:=1 to Len(aCposSX1)
				if 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
					FieldPos(alltrim(aCposSX1[nJ])) > 0
					Replace &(alltrim(aCposSX1[nJ])) With aPergs[nx][nj]
				endif
			Next nj
			MsUnlock()
			cKey := "P."+alltrim(X1_GRUPO)+alltrim(X1_ORDEM)+"."
	
			if ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
				aHelpSpa := aPergs[nx][Len(aPergs[nx])]
			else
				aHelpSpa := {}
			endif
			
			if ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
				aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
			else
				aHelpEng := {}
			endif
	
			if ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
				aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
			else
				aHelpPor := {}
			endif
	
			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		endif
	Next

Return Nil