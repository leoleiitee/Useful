#include "rwmake.ch"

User Function BOLETOS()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BOLETOS  ³ Autor ³ Evandro Mugnol        ³ Data ³22/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Unidade   ³ Serra Gaucha     ³Contato ³ evandrom@microsiga.com.br      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao dos boletos em impressora laser.                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Grano Alimentos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criar os seguintes campos:                                      ³
//³SEE    EE_CARTEIR   C  3   "Carteira de cobranca"               ³
//³SEE    EE_VARIACA   C  3   "Variacao da Carteira"               ³
//³SEE    EE_MENBOL1   C  50  "Mensagem do Boleto 1"               ³
//³SEE    EE_MENBOL2   C  50  "Mensagem do Boleto 2"               ³
//³SEE    EE_MENBOL3   C  50  "Mensagem do Boleto 3"               ³
//³SEE    EE_MENBOL4   C  50  "Mensagem do Boleto 4"               ³
//³SEE    EE_MENBOL5   C  50  "Mensagem do Boleto 5"               ³
//³SEE    EE_MENBOL6   C  50  "Mensagem do Boleto 6"               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aCampos := { {"E1_NOMCLI"  , "Cliente"    , "@!"              },;
                   {"E1_PREFIXO" , "Prefixo"    , "@!"              },;
                   {"E1_NUM"     , "Titulo"     , "@!"              },;
                   {"E1_PARCELA" , "Parcela"    , "@!"              },;
                   {"E1_VALOR"   , "Valor"      , "@E 9,999,999.99" },;
                   {"E1_VENCREA" , "Vencimento"                     } }
Local nOpc    := 0
Local aMarked := {}
Local aDesc   := "Este programa imprime os boletos de"+chr(13)+"cobranca bancaria de acordo com"+chr(13)+"os parametros informados"

PRIVATE Exec       := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
PRIVATE cPerg      := PADR("BOLETO", LEN(SX1->X1_GRUPO), " ")
PRIVATE _lBcoCorrespondente := .F.

ValidPerg()
dbSelectArea("SE1")    
Pergunte (cPerg,.F.)

If Upper(AllTrim(FunName())) == "MATA460A"
   mv_par01 := _cPrefixo
   mv_par02 := _cPrefixo
   mv_par03 := _cNumero
   mv_par04 := _cNumero
   mv_par05 := _cBanco
   mv_par06 := _cAgencia
   mv_par07 := _cConta
   mv_par08 := _cSubCta
   mv_par09 := "      "
   mv_par10 := "ZZZZZZ"
   mv_par11 := 1
Else
   Pergunte (cPerg,.T.)
Endif

nOpc := Aviso("Impressao do Boleto Laser",aDesc,{"Config. Imp.","Sim","Nao"})
If nOpc == 1           // SE CONFIGURA IMPRESSAO
   U_ConfiguraPrt()
ElseIf nOpc == 2       // SE IMPRIME
   cIndexName := Criatrab(Nil,.F.)
   cIndexKey  := "E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+DTOS(E1_EMISSAO)+E1_CLIENTE"
   cFilter    := "E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " + ;
                 "E1_NUM >= '" + MV_PAR03 + "' .And. E1_NUM <= '" + MV_PAR04 + "' .And. " + ;
                 "E1_PORTADO == '" + MV_PAR05 + "' .And. E1_AGEDEP == '" + MV_PAR06 + "' .And. E1_CONTA == '" + MV_PAR07 + "' .And. " + ;
                 "E1_NUMBOR >= '"+MV_PAR09+"' .And. E1_NUMBOR <= '"+MV_PAR10+"' .And. "+;
                 "E1_FILIAL = '"+xFilial()+"' .And. E1_SALDO > 0 .And. " + ;
                 "SubsTring(E1_TIPO,3,1) != '-' "
	
   IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde, selecionando registros....")
   DbSelectArea("SE1")
   #IFNDEF TOP
      DbSetIndex(cIndexName + OrdBagExt())
   #ENDIF
   dbGoTop()

   If mv_par11 == 1          // SE TRAZ MARCADO  --> MONTA BROWSE
      @ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
      @ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
      @ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,oDlg:End ())
      @ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,oDlg:End ())
      ACTIVATE DIALOG oDlg CENTERED
   EndIf
	
   dbGoTop()
   Do While !Eof()
      If Marked("E1_OK")
         AADD(aMarked,.T.)
      Else
         AADD(aMarked,.F.)
      EndIf
      dbSkip()
   EndDo
   dbGoTop()

   If Exec
      Processa({|lEnd|MontaRel(aMarked)})       // MONTA RELATORIO DOS MARCADOS
   Endif

   DbSelectArea("SE1")
   RetIndex("SE1")
   FErase(cIndexName+OrdBagExt())
EndIf

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CHAMADA DA FUNCAO MONTAREL()                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MontaRel(aMarked)
Local oPrint
Local n := 0
Local aBitmap   := {"\bitmaps\logobanri.bmp" ,;  // Logo do Banco Banrisul
                    "\bitmaps\logosanta.bmp" ,;  // Logo do Banco Santander
                    "\bitmaps\logograno.bmp" ,;  // Logo da Empresa
                    "\bitmaps\logoitau.bmp"  ,;  // Logo do Banco Itaú
                    "\bitmaps\logobrade.bmp" ,;  // Logo do Banco Bradesco
                    "\bitmaps\logocitib.bmp"  }  // Logo do Banco Citibank
                       
Local aDadosEmp := {SM0->M0_NOMECOM                                                           ,;   // Nome da Empresa
                    SM0->M0_ENDCOB                                                            ,;   // Endereço
                    AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,;   // Complemento
                    "CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,;   // CEP
                    "PABX/FAX: "+SM0->M0_TEL                                                  ,;   // Telefones
                    "CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+              ;
                    Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ;
                    Subs(SM0->M0_CGC,13,2)                                                    ,;   // CNPJ
                    "I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ;
                    Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }   // IE

Local aDadosTit                       
Local aDadosBanco                       
Local aDatSacado                          
Local aBolText
Local _nVlrDesc := 0
Local _nVlrJuro := 0
Local aBMP      := aBitMap 
Local i         := 1  
Local CB_RN_NN  := {}
Local nRec      := 0
Local _nVlrAbat := 0

oPrint:=TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait()     // ou SetLandscape()
oPrint:SetPaperSize(9)   // Seta Papel para A4
oPrint:StartPage()       // Inicia uma nova página

dbGoTop()
Do While !Eof()
   nRec := nRec + 1
   dbSkip()
EndDo                         

dbGoTop()
ProcRegua(nRec)
Do While !Eof()    
   DbSelectArea("SA6")        // Posiciona o SA6 (Bancos)
   DbSetOrder(1)
   DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)  
      
   DbSelectArea("SEE")        // Posiciona o SEE (Parametros Bancos CNAB)
   DbSetOrder(1)
   DbSeek(xFilial("SEE")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+MV_PAR08)
   _NumBco := Val(SEE->EE_FAXATU)

   DbSelectArea("SA1")        // Posiciona o SA1 (Clientes)
   DbSetOrder(1)
   DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
      
   DbSelectArea("SE1")        // Posiciona o SE1 (Contas a Receber)      
   
   aDadosBanco := {SA6->A6_COD                                                                                    ,;   // 1-Numero do Banco
                   Iif(SA6->A6_COD=="389","MERCANTIL DO BRASIL",SA6->A6_NREDUZ )                                  ,;   // 2-Nome do Banco
                   Agencia(SA6->A6_COD, SA6->A6_AGENCIA)                                                          ,;   // 3-Agência
                   Conta(SA6->A6_COD, SA6->A6_NUMCON)                                                             ,;   // 4-Conta Corrente
                   Iif(SA6->A6_COD $ "479/389","",SubStr(AllTrim(SA6->A6_NUMCON),Len(AllTrim(SA6->A6_NUMCON)),1)) ,;   // 5-Dígito da Conta Corrente
                   AllTrim(SEE->EE_CARTEIR)                                                                       ,;   // 6-Carteira
                   Iif(!Empty(AllTrim(SEE->EE_VARIACA)),"-"+SEE->EE_VARIACA,"")                                   ,;   // 7-Variacao da Carteira
                   ""                                                                                             ,;   // 8-Reservado para o Banco Correspondente
                   SEE->EE_CODEMP                                                                                  }   // 9-Código do Cedente

   If Empty(Alltrim(SA1->A1_ENDCOB))       // Busca o endereco normal
      aDatSacado := {AllTrim(SA1->A1_NOME)                       ,;   // 1-Razão Social 
                     AllTrim(SA1->A1_COD )                       ,;   // 2-Código
                     AllTrim(SA1->A1_END)+"-"+SA1->A1_BAIRRO     ,;   // 3-Endereço
                     AllTrim(SA1->A1_MUN )                       ,;   // 4-Cidade
                     SA1->A1_EST                                 ,;   // 5-Estado
                     SA1->A1_CEP                                 ,;   // 6-CEP     
                     SA1->A1_CGC                                  }   // 7-CNPJ/CPF     
   Else                                    // Busca o endereco de cobrança
      aDatSacado := {AllTrim(SA1->A1_NOME)                       ,;   // 1-Razão Social 
                     AllTrim(SA1->A1_COD )                       ,;   // 2-Código
                     AllTrim(SA1->A1_ENDCOB)+"-"+SA1->A1_BAIRROC ,;   // 3-Endereço
                     AllTrim(SA1->A1_MUNC )                      ,;   // 4-Cidade
                     SA1->A1_ESTC                                ,;   // 5-Estado
                     SA1->A1_CEPC                                ,;   // 6-CEP     
                     SA1->A1_CGC                                  }   // 7-CNPJ/CPF     
   Endif

   aBolText := {SEE->EE_MENBOL1                                  ,;   // 1a. Linha da Instrução Bancária
                SEE->EE_MENBOL2                                  ,;   // 2a. Linha da Instrução Bancária
                SEE->EE_MENBOL3                                  ,;   // 3a. Linha da Instrução Bancária
                SEE->EE_MENBOL4                                  ,;   // 4a. Linha da Instrução Bancária
                SEE->EE_MENBOL5                                  ,;   // 5a. Linha da Instrução Bancária
                SEE->EE_MENBOL6                                   }   // 6a. Linha da Instrução Bancária

   // VALOR DOS TITULOS TIPO "AB-"
   _nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

   // MONTANDO CODIGO DE BARRAS
   If SE1->E1_PORTADO == "041" .And. aMarked[i]
      If Empty(SE1->E1_NUMBCO)
         NossoNumero()

         DECLARE STR_NUM[99]
         AFILL(STR_NUM,0)
         DECLARE _XXA[5]
         DECLARE _XXB[5]
         AFILL(_XXA,"A")
         AFILL(_XXB,"A")

         CB_RN_NN := CODIGOBARRAS()
      Else
         cCodBarra := SE1->E1_CODBAR
         cLinDig   := SE1->E1_CODDIG
         cNossoNum := SE1->E1_NUMBCO
         CB_RN_NN  := {cCodBarra,cLinDig,cNossoNum}
      Endif
   Else
      If Empty(SE1->E1_NUMBCO)
         If SE1->E1_PORTADO == "745"
            CB_RN_NN  := Ret_cBarra(Subs(aDadosBanco[1],1,3),Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],aDadosBanco[6],AllTrim(E1_NUM)+AllTrim(E1_PARCELA),;
                                   (E1_SALDO-_nVlrAbat),SE1->E1_VENCREA,SEE->EE_CODEMP,SEE->EE_FAXATU,Iif(SE1->E1_DECRESC > 0,.t.,.f.),SE1->E1_PARCELA,aDadosBanco[3])
         Else
            CB_RN_NN  := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],aDadosBanco[6],AllTrim(E1_NUM)+AllTrim(E1_PARCELA),;
                                   (E1_SALDO-_nVlrAbat),SE1->E1_VENCREA,SEE->EE_CODEMP,SEE->EE_FAXATU,Iif(SE1->E1_DECRESC > 0,.t.,.f.),SE1->E1_PARCELA,aDadosBanco[3])
         Endif
      Else
         cCodBarra := SE1->E1_CODBAR
         cLinDig   := SE1->E1_CODDIG
         cNossoNum := SE1->E1_NUMBCO
         CB_RN_NN  := {cCodBarra,cLinDig,cNossoNum}
      Endif
   Endif

   aDadosTit := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA) ,;   // 1-Número do título
                 E1_EMISSAO                          ,;   // 2-Data da emissão do título
                 dDataBase                           ,;   // 3-Data da emissão do boleto
                 E1_VENCREA                          ,;   // 4-Data do vencimento
                 (E1_SALDO - _nVlrAbat)              ,;   // 5-Valor do título
                 IIF(SE1->E1_PORTADO="041",SE1->E1_NUMBCO,AllTrim(CB_RN_NN[3])) ,;   // 6-Nosso número (Ver fórmula para calculo)
                 SE1->E1_DECRESC                     ,;   // 7-Valor do Desconto do titulo
                 SE1->E1_VALJUR                       }   // 8-Valor dos juros do titulo

   // MONTAGEM DO BOLETO
   If aMarked[i]
      Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
      n := n + 1

      If Empty(SE1->E1_NUMBCO)
         DbSelectArea("SEE")
         RecLock("SEE",.F.)
         SEE->EE_FAXATU := StrZero(Val(SEE->EE_FAXATU) + 1,12)     // INCREMENTA P/ TODOS OS BANCOS
         DbUnlock()

         DbSelectArea("SE1")
         RecLock("SE1",.F.)
         SE1->E1_CODBAR := CB_RN_NN[1]                             // GRAVA CODIGO DE BARRAS CALCULADO NO TITULO
         SE1->E1_CODDIG := CB_RN_NN[2]                             // GRAVA LINHA DIGITAVEL CALCULADA NO TITULO
         SE1->E1_NUMBCO := CB_RN_NN[3]                             // GRAVA NOSSO NUMERO NO TITULO
         DbUnlock()
      Endif
   EndIf   

   DbSelectArea("SE1")
   dbSkip()          
   IncProc()
   i := i + 1
EndDo   

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CHAMADA DA FUNCAO IMPRESS()                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

Local oFont8
Local oFont8n
Local oFont10
Local oFont16
Local oFont16n     
Local oFont20
Local oFont24
Local i := 0

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8n := TFont():New("Arial",9,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20 := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()          // Inicia uma nova página


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ficha do Caixa                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Line (250,100,250,2300)   

oPrint:SayBitMap(080,100,aBitmap[3], 200, 160)
oPrint:Say  (184,1850,"Comprovante de Entrega"                                       ,oFont10)

oPrint:Line (350,100,350,1300 )
oPrint:Line (450,100,450,1300 )
oPrint:Line (520,100,520,2300 )
oPrint:Line (590,100,590,2300 )

oPrint:Line (450,400,520,400)
oPrint:Line (520,500,590,500)
oPrint:Line (450,625,520,625)
oPrint:Line (450,750,520,750)

oPrint:Line (250,1300,590,1300 )
oPrint:Line (250,2300,590,2300 )
oPrint:Say  (250,1310 ,"MOTIVOS DE NÃO ENTREGA (para uso do entregador)"             ,oFont8) 
oPrint:Say  (300,1310 ,"|   | Mudou-se"                                              ,oFont8) 
oPrint:Say  (370,1310 ,"|   | Recusado"                                              ,oFont8) 
oPrint:Say  (440,1310 ,"|   | Desconhecido"                                          ,oFont8) 

oPrint:Say  (300,1580 ,"|   | Ausente"                                               ,oFont8) 
oPrint:Say  (370,1580 ,"|   | Não Procurado"                                         ,oFont8) 
oPrint:Say  (440,1580 ,"|   | Endereço insuficiente"                                 ,oFont8) 

oPrint:Say  (300,1930 ,"|   | Não existe o Número"                                   ,oFont8) 
oPrint:Say  (370,1930 ,"|   | Falecido"                                              ,oFont8) 
oPrint:Say  (440,1930 ,"|   | Outros(anotar no verso)"                               ,oFont8) 

oPrint:Say  (520,1310 ,"Recebí(emos) o bloqueto"                                     ,oFont8) 
oPrint:Say  (550,1310 ,"com os dados ao lado."                                       ,oFont8) 
oPrint:Line (520,1700,590,1700)
oPrint:Say  (520,1705 ,"Data"                                                        ,oFont8) 
oPrint:Line (520,1900,590,1900)
oPrint:Say  (520,1905 ,"Assinatura"                                                  ,oFont8) 

oPrint:Say  (250,100 ,"Cedente"                                                      ,oFont8) 
If aDadosBanco[1] == "745"   // SE CITIBANK
   oPrint:Say  (280,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],alltrim(aDadosEmp[1])+" - "+alltrim(aDadosEmp[6])),oFont8n)
   oPrint:Say  (310,100 ,(aDadosEmp[2]),oFont8n)
Else
   oPrint:Say  (290,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],aDadosEmp[1])           ,oFont10)
Endif

oPrint:Say  (350,100 ,"Sacado"                                                       ,oFont8) 
oPrint:Say  (390,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                           ,oFont10)

oPrint:Say  (450,100 ,"Data do Vencimento"                                           ,oFont8)  
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (480,100 ,Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)  ,oFont10)
Else
   oPrint:Say  (480,100 ,Dtoc(aDadosTit[4])                                          ,oFont10) 
Endif

oPrint:Say  (450,405 ,"Nro.Documento"                                                ,oFont8) 
oPrint:Say  (480,450 ,aDadosTit[1]                                                   ,oFont10)

oPrint:Say  (450,630,"Moeda"                                                         ,oFont8)
oPrint:Say  (480,655,"R$"                                                            ,oFont10)

oPrint:Say  (450,755,"Valor/Quantidade"                                              ,oFont8) 
oPrint:Say  (480,765,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))            ,oFont10)

oPrint:Say  (520,100 ,"Agencia/Cod. Cedente"                                         ,oFont8)      
If aDadosBanco[1] == "033"   // SE SANTANDER
   oPrint:Say  (550,100,Left(aDadosBanco[3],4)+"/"+aDadosBanco[9]                    ,oFont10)
ElseIf aDadosBanco[1] == "041"   // SE BANRISUL
   oPrint:Say  (550,100,Right(aDadosBanco[3],3)+"."+aDadosBanco[6]+"/"+Substr(aDadosBanco[4],4,6)+"."+Substr(aDadosBanco[4],10,1)+"."+Substr(aDadosBanco[4],11,2),oFont10)
ElseIf aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (550,100,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
ElseIf aDadosBanco[1] == "745"   // SE CITIBANK
   oPrint:Say  (550,100,"011/0277213028",oFont10)
Else
   oPrint:Say  (550,100,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
Endif
oPrint:Say  (520,505,"Nosso Número"                                                  ,oFont8)   
oPrint:Say  (550,520,aDadosTit[6]                                                    ,oFont10)  
 
For i := 100 to 2300 step 50
   oPrint:Line( 620, i, 620, i+30)
Next i

For i := 100 to 2300 step 50
   oPrint:Line( 1145, i, 1145, i+30)
Next i
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ficha do Sacado                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Line (1270,100,1270,2300)   
oPrint:Line (1270,650,1170,650 )
oPrint:Line (1270,900,1170,900 ) 

If aDadosBanco[1] == "041"
   oPrint:SayBitMap(1155,100,aBitmap[1], 350, 110)
ElseIf aDadosBanco[1] == "0"
   oPrint:SayBitMap(1155,100,aBitmap[2], 350, 110)
ElseIf aDadosBanco[1] == "341"
   oPrint:SayBitMap(1155,100,aBitmap[4], 120, 110)
ElseIf aDadosBanco[1] == "237"
   oPrint:SayBitMap(1155,100,aBitmap[5], 290, 110)
ElseIf aDadosBanco[1] == "745"
   oPrint:SayBitMap(1155,100,aBitmap[6], 290, 110)
Else
   oPrint:Say  (1200,100,aDadosBanco[2]                                              ,oFont16)
Endif

oPrint:Say  (1182,680,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1],aDadosBanco[1])     ,oFont20) 

oPrint:Line (1370,100,1370,2300 )
oPrint:Line (1470,100,1470,2300 )
oPrint:Line (1540,100,1540,2300 )
oPrint:Line (1610,100,1610,2300 )

oPrint:Line (1470,500,1610,500)
oPrint:Line (1540,750,1610,750)
oPrint:Line (1470,1000,1610,1000)
oPrint:Line (1470,1350,1540,1350)
oPrint:Line (1470,1550,1610,1550)

oPrint:Say  (1270,100 ,"Local de Pagamento"                                          ,oFont8) 
If aDadosBanco[1] == "237"
   oPrint:Say  (1310,100 ,"Pagável preferencialmente em qualquer Agência Bradesco"   ,oFont10)
ElseIf aDadosBanco[1] == "341"
   oPrint:Say  (1310,100 ,"Até o vencimento, preferencialmente no Itaú ou Banerj e após o vencimento, somente no Itaú ou Banerj" ,oFont10)
Else
   oPrint:Say  (1310,100 ,"Pagável em qualquer agência bancária até o vencimento"    ,oFont10)
Endif

oPrint:Say  (1270,1910,"Vencimento"                                                  ,oFont8)
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (1310,2005,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
Else
   oPrint:Say  (1310,2005,PadL(AllTrim(DTOC(aDadosTit[4])),16)                       ,oFont10)
Endif

oPrint:Say  (1370,100 ,"Cedente"                                                     ,oFont8) 
If aDadosBanco[1] == "745"   // SE CITIBANK
   oPrint:Say  (1400,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],alltrim(aDadosEmp[1])+" - "+alltrim(aDadosEmp[6])),oFont8n)
   oPrint:Say  (1430,100 ,(aDadosEmp[2]),oFont8n)
Else
   oPrint:Say  (1410,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],aDadosEmp[1])          ,oFont10)
Endif

oPrint:Say  (1370,1910,"Agência/Código Cedente"                                      ,oFont8) 
If aDadosBanco[1] == "033"   // SE SANTANDER
   oPrint:Say  (1410,1970,Left(aDadosBanco[3],4)+"/"+aDadosBanco[9]                  ,oFont10)
ElseIf aDadosBanco[1] == "041"   // SE BANRISUL
   oPrint:Say  (1410,1970,Right(aDadosBanco[3],3)+"."+aDadosBanco[6]+"/"+Substr(aDadosBanco[4],4,6)+"."+Substr(aDadosBanco[4],10,1)+"."+Substr(aDadosBanco[4],11,2),oFont10)
ElseIf aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (1410,1970,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
ElseIf aDadosBanco[1] == "745"   // SE CITIBANK
   oPrint:Say  (1410,1970,"011/0277213028",oFont10)
Else
   oPrint:Say  (1410,1970,PadL(AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),18," "),oFont10)
Endif

oPrint:Say  (1470,100 ,"Data do Documento"                                           ,oFont8)  
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (1500,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
Else
   oPrint:Say  (1500,100 ,DTOC(aDadosTit[3])                                         ,oFont10) 
Endif

oPrint:Say  (1470,505 ,"Nro.Documento"                                               ,oFont8) 
oPrint:Say  (1500,595 ,aDadosTit[1]                                                  ,oFont10)

oPrint:Say  (1470,1005,"Espécie Doc."                                                ,oFont8)
If aDadosBanco[1] == "745"   // SE CITIBANK
   oPrint:Say  (1500,1105,"DMI"                                                          ,oFont10)
Else
   oPrint:Say  (1500,1105,"DM"                                                          ,oFont10)
Endif

oPrint:Say  (1470,1355,"Aceite"                                                      ,oFont8) 
oPrint:Say  (1500,1455,"N"                                                           ,oFont10)

oPrint:Say  (1470,1555,"Data do Processamento"                                       ,oFont8) 
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (1500,1655,Substring(Dtos(aDadosTit[2]),7,2)+"/"+Substring(Dtos(aDadosTit[2]),5,2)+"/"+Substring(Dtos(aDadosTit[2]),1,4)  ,oFont10)
Else
   oPrint:Say  (1500,1655,Dtoc(aDadosTit[2])                                         ,oFont10)
Endif

oPrint:Say  (1470,1910,"Nosso Número"                                                ,oFont8)   
oPrint:Say  (1500,1990,PadL(AllTrim(aDadosTit[6]),17," ")                            ,oFont10)  

oPrint:Say  (1540,100 ,"Uso do Banco"                                                ,oFont8)      
If aDadosBanco[1] == "409"
   oPrint:Say  (1570,100,"cvt 5539-5"                                                ,oFont10)
Endif

oPrint:Say  (1540,505 ,"Carteira"                                                    ,oFont8)     
oPrint:Say  (1570,555 ,aDadosBanco[6]+aDadosBanco[7]                                 ,oFont10)     

oPrint:Say  (1540,755 ,"Espécie"                                                     ,oFont8)   
oPrint:Say  (1570,805 ,"R$"                                                          ,oFont10)  

oPrint:Say  (1540,1005,"Quantidade"                                                  ,oFont8) 
oPrint:Say  (1540,1555,"Valor"                                                       ,oFont8)            

oPrint:Say  (1540,1910,"(=)Valor do Documento"                                       ,oFont8) 
oPrint:Say  (1570,2005,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)

If aDadosBanco[1] == "341"
   oPrint:Say  (1610,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)     
Else
   oPrint:Say  (1610,100 ,"Instruções/Texto de responsabilidade do cedente"          ,oFont8)     
Endif

oPrint:Say  (1660,100 ,Iif(aDadosTit[7]>0,"CONCEDER DESCONTO DE R$ "+AllTrim(Transform(aDadosTit[7],"@E 999,999.99"))+" ATÉ O VENCIMENTO","") ,oFont10)
oPrint:Say  (1710,100 ,Iif(aDadosTit[8]>0,"COBRAR JUROS/MORA DIA DE R$ "+AllTrim(Transform(aDadosTit[8],"@E 999,999.99")),"") ,oFont10)
oPrint:Say  (1760,100 ,aBolText[1]                                                   ,oFont10)     
oPrint:Say  (1810,100 ,aBolText[2]                                                   ,oFont10)     
oPrint:Say  (1860,100 ,aBolText[3]                                                   ,oFont10)    

oPrint:Say  (1610,1910 ,"(-)Desconto/Abatimento"                                     ,oFont8) 
If aDadosBanco[1] <> "237"
   oPrint:Say  (1640,2005,PadL(AllTrim(Transform(aDadosTit[7],"@E 999,999,999.99")),16," "),oFont10)
Endif
oPrint:Say  (1680,1910 ,"(-)Outras Deduções"                                         ,oFont8)
oPrint:Say  (1750,1910 ,"(+)Mora/Multa"                                              ,oFont8)
oPrint:Say  (1820,1910 ,"(+)Outros Acréscimos"                                       ,oFont8)
oPrint:Say  (1890,1910 ,"(=)Valor Cobrado"                                           ,oFont8)

oPrint:Say  (1960 ,100 ,"Sacado:"                                                    ,oFont8) 
oPrint:Say  (1988 ,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                         ,oFont8)
oPrint:Say  (2030 ,210 ,aDatSacado[3]                                                ,oFont8)
oPrint:Say  (2070 ,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)
oPrint:Say  (1925,100  ,"Sacador/Avalista"+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)   
oPrint:Say  (2110,1500 ,"Autenticação Mecânica "                                     ,oFont8)  
oPrint:Say  (1204,1850 ,"Recibo do Sacado"                                           ,oFont10)

oPrint:Line (1270,1900,1960,1900 )
oPrint:Line (1680,1900,1680,2300 )
oPrint:Line (1750,1900,1750,2300 )
oPrint:Line (1820,1900,1820,2300 )
oPrint:Line (1890,1900,1890,2300 )  
oPrint:Line (1960,100 ,1960,2300 )

oPrint:Line (2105,100,2105,2300  )     

//Gambiarra, descobrir como mudar tipo da linha.  PONTILHAMENTO
For i := 100 to 2300 Step 50
   oPrint:Line( 2270, i, 2270, i+30)
Next i                                                                   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ficha de Compensacao                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Line (2390,100,2390,2300)
oPrint:Line (2390,650,2290,650 )
oPrint:Line (2390,900,2290,900 ) 

If aDadosBanco[1] == "041"
   oPrint:SayBitMap(2280,100,aBitmap[1], 350, 110)
ElseIf aDadosBanco[1] == "033"
   oPrint:SayBitMap(2280,100,aBitmap[2], 350, 110)
ElseIf aDadosBanco[1] == "341"
   oPrint:SayBitMap(2280,100,aBitmap[4], 120, 110)
ElseIf aDadosBanco[1] == "237"
   oPrint:SayBitMap(2280,100,aBitmap[5], 290, 110)
ElseIf aDadosBanco[1] == "745"
   oPrint:SayBitMap(2280,100,aBitmap[6], 290, 110)
Else
   oPrint:Say  (2324,100,aDadosBanco[2]                                              ,oFont16 )
Endif

oPrint:Say  (2302,680,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1],aDadosBanco[1])     ,oFont20 ) 
oPrint:Say  (2324,920,CB_RN_NN[2]                                                    ,oFont14n)  // LINHA DIGITAVEL

oPrint:Line (2490,100,2490,2300 )
oPrint:Line (2590,100,2590,2300 )
oPrint:Line (2660,100,2660,2300 )
oPrint:Line (2730,100,2730,2300 )

oPrint:Line (2590,500,2730,500)
oPrint:Line (2660,750,2730,750)
oPrint:Line (2590,1000,2730,1000)
oPrint:Line (2590,1350,2660,1350)
oPrint:Line (2590,1550,2730,1550)

oPrint:Say  (2390,100 ,"Local de Pagamento"                                          ,oFont8) 
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (2430,100 ,"Pagável preferencialmente em qualquer Agência Bradesco"   ,oFont10)
ElseIf aDadosBanco[1] == "341"
   oPrint:Say  (2430,100 ,"Até o vencimento, preferencialmente no Itaú ou Banerj e após o vencimento, somente no Itaú ou Banerj" ,oFont10)
ElseIf aDadosBanco[1] == "745" //SE CITIBANK
   oPrint:Say  (2430,100 ,"Pagável em qualquer agência bancária até o vencimento"    ,oFont10)
Else
   oPrint:Say  (2430,100 ,"Pagável em qualquer agência bancária até o vencimento"    ,oFont10)
Endif

oPrint:Say  (2390,1910,"Vencimento"                                                  ,oFont8)
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (2430,2005,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
Else
   oPrint:Say  (2430,2005,PadL(AllTrim(DTOC(aDadosTit[4])),16," ")                   ,oFont10)
Endif
 
oPrint:Say  (2490,100 ,"Cedente"                                                     ,oFont8) 
If aDadosBanco[1] == "745"   // SE CITIBANK
   oPrint:Say  (2520,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],alltrim(aDadosEmp[1])+" - "+alltrim(aDadosEmp[6])),oFont8n)
   oPrint:Say  (2550,100 ,(aDadosEmp[2]),oFont8n)
Else
   oPrint:Say  (2530,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],aDadosEmp[1])          ,oFont10)
Endif

oPrint:Say  (2490,1910,"Agência/Código Cedente"                                      ,oFont8)
If aDadosBanco[1] == "033"   // SE SANTANDER
   oPrint:Say  (2530,1970,Left(aDadosBanco[3],4)+"/"+aDadosBanco[9]                  ,oFont10)
ElseIf aDadosBanco[1] == "041"   // SE BANRISUL
   oPrint:Say  (2530,1970,Right(aDadosBanco[3],3)+"."+aDadosBanco[6]+"/"+Substr(aDadosBanco[4],4,6)+"."+Substr(aDadosBanco[4],10,1)+"."+Substr(aDadosBanco[4],11,2),oFont10)
ElseIf aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (2530,1970,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
ElseIf aDadosBanco[1] == "745"   // SE CITIBANK
   oPrint:Say  (2530,1970,"011/0277213028",oFont10)
Else
   oPrint:Say  (2530,1970,PadL(AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),18," "),oFont10)
Endif

oPrint:Say  (2590,100 ,"Data do Documento"                                           ,oFont8)  
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (2620,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
Else                                                                                
   oPrint:Say  (2620,100 ,Dtoc(aDadosTit[3])                                         ,oFont10) 
Endif

oPrint:Say  (2590,505 ,"Nro.Documento"                                               ,oFont8) 
oPrint:Say  (2620,605 ,aDadosTit[1]                                                  ,oFont10)

oPrint:Say  (2590,1005,"Espécie Doc."                                                ,oFont8)
If aDadosBanco[1] == "745" 
   oPrint:Say  (2620,1105,"DMI"                                                          ,oFont10)
Else
   oPrint:Say  (2620,1105,"DM"                                                          ,oFont10)
Endif

oPrint:Say  (2590,1355,"Aceite"                                                      ,oFont8) 
oPrint:Say  (2620,1455,"N"                                                           ,oFont10)

oPrint:Say  (2590,1555,"Data do Processamento"                                       ,oFont8) 
If aDadosBanco[1] == "237"   // SE BRADESCO
   oPrint:Say  (2620,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
Else
   oPrint:Say  (2620,1655,DTOC(aDadosTit[2])                                         ,oFont10)
Endif

oPrint:Say  (2590,1910,"Nosso Número"                                                ,oFont8)   
oPrint:Say  (2620,1990,PadL(AllTrim(aDadosTit[6]),17," ")                            ,oFont10)  

oPrint:Say  (2660,100 ,"Uso do Banco"                                                ,oFont8)      
If aDadosBanco[1] == "409"
   oPrint:Say  (2690,100 ,"cvt 5539-5"  ,oFont10)
Endif

oPrint:Say  (2660,505 ,"Carteira"                                                    ,oFont8)     
oPrint:Say  (2690,555 ,aDadosBanco[6]+aDadosBanco[7]                                 ,oFont10)     

oPrint:Say  (2660,755 ,"Espécie"                                                     ,oFont8)   
oPrint:Say  (2690,805 ,"R$"                                                          ,oFont10)  

oPrint:Say  (2660,1005,"Quantidade"                                                  ,oFont8) 
oPrint:Say  (2660,1555,"Valor"                                                       ,oFont8)            

oPrint:Say  (2660,1910,"(=)Valor do Documento"                                       ,oFont8) 
oPrint:Say  (2690,2010,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)

If aDadosBanco[1] == "341"
   oPrint:Say  (2730,100 ,"Instruções (Todas as informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)     
Else
   oPrint:Say  (2730,100 ,"Instruções/Texto de responsabilidade do cedente"          ,oFont8)
Endif

oPrint:Say  (2780,100 ,Iif(aDadosTit[7]>0,"CONCEDER DESCONTO DE R$ "+AllTrim(Transform(aDadosTit[7],"@E 999,999.99"))+" ATÉ O VENCIMENTO","") ,oFont10)
oPrint:Say  (2830,100 ,Iif(aDadosTit[8]>0,"COBRAR JUROS/MORA DIA DE R$ "+AllTrim(Transform(aDadosTit[8],"@E 999,999.99")),"") ,oFont10)
oPrint:Say  (2880,100 ,aBolText[1]                                                   ,oFont10)     
oPrint:Say  (2930,100 ,aBolText[2]                                                   ,oFont10)     
oPrint:Say  (2980,100 ,aBolText[3]                                                   ,oFont10)    

oPrint:Say  (2730,1910,"(-)Desconto/Abatimento"                                      ,oFont8) 
If aDadosBanco[1] <> "237"
   oPrint:Say  (2760,2005,PadL(AllTrim(Transform(aDadosTit[7],"@E 999,999,999.99")),16," "),oFont10)
Endif
oPrint:Say  (2800,1910,"(-)Outras Deduções"                                          ,oFont8)
oPrint:Say  (2870,1910,"(+)Mora/Multa"                                               ,oFont8)
oPrint:Say  (2940,1910,"(+)Outros Acréscimos"                                        ,oFont8)
oPrint:Say  (3010,1910,"(=)Valor Cobrado"                                            ,oFont8)

oPrint:Say  (3080,100 ,"Sacado"                                                      ,oFont8) 
oPrint:Say  (3108,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                          ,oFont8)
oPrint:Say  (3148,210 ,aDatSacado[3]                                                 ,oFont8)
oPrint:Say  (3188,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"        CNPJ/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

oPrint:Say  (3045,100 ,"Sacador/Avalista"+Iif(_lBcoCorrespondente,aDadosEmp[1],"")   ,oFont8)   
oPrint:Say  (3230,1500,"Autenticação Mecânica -"                                     ,oFont8)  

If aDadosBanco[1] == "341"
   oPrint:Say  (3230,1850,"Ficha de Compensação"                                     ,oFont8)
Else
   oPrint:Say  (3230,1850,"Ficha de Compensação"                                     ,oFont10)
Endif

oPrint:Line (2390,1900,3080,1900 )
oPrint:Line (2800,1900,2800,2300 )
oPrint:Line (2870,1900,2870,2300 )
oPrint:Line (2940,1900,2940,2300 )
oPrint:Line (3010,1900,3010,2300 )  
oPrint:Line (3080,100 ,3080,2300 )

oPrint:Line (3225,100,3225,2300  )     

If cFilAnt == "01"   // Caso seja na filial de Serafina Correa
   //MSBAR("INT25"  ,14.3,0.9,CB_RN_NN[1],oPrint,.F.,,,0.011,0.7,,,,.F.)
   MSBAR("INT25"  ,27.9,1.5,CB_RN_NN[1],oPrint,.F.,,,0.0255,1.6,,,,.F.)
ElseIf cFilAnt == "02"   // Caso seja na filial de Esteio
   MSBAR("INT25"  ,27.9,1.5,CB_RN_NN[1],oPrint,.F.,,,0.0255,1.6,,,,.F.)
Else
   //MSBAR("INT25"  ,14.3,0.9,CB_RN_NN[1],oPrint,.F.,,,0.011,0.7,,,,.F.)
   MSBAR("INT25"  ,27.9,1.5,CB_RN_NN[1],oPrint,.F.,,,0.0255,1.6,,,,.F.)
Endif
     
oPrint:EndPage()     // Finaliza a página

Return

/*/
MSBAR("INT25"  , 21  ,  3 ,"123456789012",oPr,,,.T.)
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±±
±±³          ³             "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     ³±±
±±³          ³             "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"    ³±±
±±³          ³ 02 nRow     Numero da Linha em centimentros                ³±±
±±³          ³ 03 nCol     Numero da coluna em centimentros               ³±±
±±³          ³ 04 cCode    String com o conteudo do codigo                ³±±
±±³          ³ 05 oPr      Objeto Printer                                 ³±±
±±³          ³ 06 lcheck   Se calcula o digito de controle                ³±±
±±³          ³ 07 Cor      Numero  da Cor, utilize a "common.ch"          ³±±
±±³          ³ 08 lHort    Se imprime na Horizontal                       ³±±
±±³          ³ 09 nWidth   Numero do Tamanho da barra em centimetros      ³±±
±±³          ³ 10 nHeigth  Numero da Altura da barra em milimetros        ³±±
±±³          ³ 11 lBanner  Se imprime o linha em baixo do codigo          ³±±
±±³          ³ 12 cFont    String com o tipo de fonte                     ³±±
±±³          ³ 13 cMode    String com o modo do codigo de barras CODE128  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADA DA FUNCAO MODULO10()                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Modulo10(cData)
Local L,D,P := 0
Local B     := .F.
L := Len(cData)       // TAMANHO DE BYTES DO CARACTER
B := .T.   
D := 0                // DIGITO VERIFICADOR
While L > 0 
   P := Val(SubStr(cData, L, 1))
   If (B) 
      P := P * 2
      If P > 9 
         P := P - 9
      End
   End
   D := D + P
   L := L - 1
   B := !B
End
D := 10 - (Mod(D,10))
If D = 10
   D := 0
End
Return(D)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADA DA FUNCAO MOD11_B7()  Nodulo 11 com base 7              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Mod11_B7(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1      
DV:= " "
While L > 0
   P := P + 1
   D := D + (Val(SubStr(cData, L, 1)) * P)
   If P = 7            // Volta para o inicio, ou seja comeca a multiplicar por 2,3,4...
      P := 1
   End
   L := L - 1
End                   

_nResto := mod(D,11)   // Resto da Divisao
D := 11 - _nResto 
DV:=STR(D)

If _nResto == 0
   DV := "0"
End
If _nResto == 1
   DV := "P"
End

Return(DV)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADA DA FUNCAO MODULO11()                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Modulo11(cData,cBanc)
Local L, D, P := 0  

If cBanc == "001"        // BANCO DO BRASIL
   L := Len(cdata)
   D := 0
   P := 10
   While L > 0 
      P := P - 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 2 
         P := 10
      End
      L := L - 1
   End
   D := mod(D,11)
   If D == 10
      D := "X"
   Else
      D := AllTrim(Str(D))
   End           
ElseIf cBanc == "033"    // SANTANDER
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0
      P := P + 1
      D := D + (Val(Substr(cData, L, 1)) * P)
      If P = 9
         P := 1
      Endif
      L := L - 1
   End
   D := 11 - (mod(D,11))
   If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
       D := 1
   Endif
   D := AllTrim(Str(D))
ElseIf cBanc == "041"    // BANRISUL
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0
      P := P + 1
      D := D + (Val(Substr(cData, L, 1)) * P)
      If P = 7
         P := 1
      Endif
      L := L - 1
   End
   D := 11 - (mod(D,11))
   If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
      D := 1
   Endif
   D := AllTrim(Str(D))
ElseIf cBanc == "237" .Or. cBanc == "341" .Or. cBanc == "453" .Or. cBanc == "399" .Or. cBanc == "422"    // BRADESCO/ITAU/MERCANTIL/RURAL/HSBC/SAFRA
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9 
         P := 1
      End
      L := L - 1
   End
   D := 11 - (mod(D,11))  
   If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "237" .Or. cBanc == "341" .Or. cBanc == "422")
      D := 1
   End
   If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453" .Or. cBanc == "399")
      D := 0
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "389" .Or. cBanc == "745"    // MERCANTIL ou CITIBANK
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9 
         P := 1
      End
      L := L - 1
   End   
   D := mod(D,11)
   If D == 1 .Or. D == 0
      D := 0
   Else
      D := 11 - D
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "479"    // BOSTON
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9 
         P := 1
      End
      L := L - 1
   End
   D := Mod(D*10,11)
   If D == 10
      D := 0
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "409"    // UNIBANCO
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9 
         P := 1
      End
      L := L - 1
   End
   D := Mod(D*10,11)
   If D == 10 .or. D == 0
      D := 0
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "356"    // REAL
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9 
         P := 1
      End
      L := L - 1
   End
   D := Mod(D*10,11)
   If D == 10 .or. D == 0
      D := 0
   End
   D := AllTrim(Str(D))
Else
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9 
         P := 1
      End
      L := L - 1
   End
   D := 11 - (mod(D,11))
   If (D == 10 .Or. D == 11)
      D := 1
   End
   D := AllTrim(Str(D))
Endif   
Return(D)   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADA DA FUNCAO RET_CBARRA()                                  ³
//³ Retorna os strings para inpressão do Boleto                     ³
//³ CB = String para o cód.barras, RN=String com o número digitável ³
//³ Cobrança não identificada, número do boleto = Título + Parcela  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)

Local cCodEmp      := StrZero(Val(SubStr(cConvenio,1,6)),6)
Local cNumSeq      := Strzero(val(cSequencial),5)
Local bldocnufinal := cAgencia+Strzero(val(cNroDoc),7)
Local blvalorfinal := Strzero(nValor*100,10)
Local cNNumSDig    := cCpoLivre := cCBSemDig := cCodBarra := cNNum := cFatVenc := ''
Local cNossoNum
Local _cDigito     := ""
Local _cSuperDig   := ""

_cParcela := NumParcela(_cParcela)
cFatVenc  := STRZERO(dvencimento - CtoD("07/10/1997"),4)                    // Fator Vencimento - POSICAO DE 06 A 09

//Campo Livre (Definir campo livre com cada banco)
If Substr(cBanco,1,3) == "001"       // BANCO DO BRASIL
   If Len(AllTrim(cConvenio)) == 7
      cNNumSDig := AllTrim(cConvenio)+strzero(val(cSequencial),10)          // Nosso Numero sem digito
      cNNum     := cNNumSDig                                                // Nosso Numero com digito
      cNossoNum := cNNumSDig                                                // Nosso Numero para impressao
      cCpoLivre := "000000"+cNNumSDig+cCarteira
   Else
      cNNumSDig := cCodEmp+cNumSeq                                          // Nosso Numero sem digito
      cNNum     := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))       // Nosso Numero com digito
      cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))   // Nosso Numero para impressao
      cCpoLivre := cNNumSDig+cAgencia + StrZero(Val(cConta),8) + cCarteira
   Endif
Elseif Substr(cBanco,1,3) == "033"   // BANCO SANTANDER
   cNNumSDig := Strzero(val(cSequencial),12)                                          // Nosso Numero sem digito
   cNNum     := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))                    // Nosso Numero
   cNossoNum := cNNumSDig + "-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))               // Nosso Numero para impressao
   cCpoLivre := "9"+Strzero(Val(SubStr(cConvenio,1,7)),7)+cNNumSDig+modulo11(cNNumSDig,SubStr(cBanco,1,3))+"0"+"101"
Elseif Substr(cBanco,1,3) == "041"   // BANCO BANRISUL
   cNNumSDig := Strzero(val(cSequencial),8)                                                                                                                                               // Nosso Numero sem digito
   cNNum     := cNNumSDig + AllTrim(Str(modulo10(cNNumSDig)))                                                                                                                             // Nosso Numero
   cNNum     := cNNumSDig + AllTrim(Str(Val(AllTrim(Str(modulo10(cNNumSDig))))+Val(AllTrim(modulo11(cNNum,SubStr(cBanco,1,3))))))                                                         // Nosso Numero
   cNossoNum := cNNumSDig + "-" + Right(AllTrim(cNNum),1) + AllTrim(modulo11(cNNum,SubStr(cBanco,1,3)))     // Nosso Numero para impressao
   cCpoLivre := "2"+"1"+Substr(cAgencia,2,3)+Strzero(Val(SubStr(cConvenio,1,7)),7)+cNNumSDig+"041"
   cCpoLivre := cCpoLivre + AllTrim(Str(modulo10(cCpoLivre)))+AllTrim(modulo11(cCpoLivre,SubStr(cBanco,1,3)))
Elseif Substr(cBanco,1,3) == "389"   // BANCO MERCANTIL
   cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)                 // Nosso Numero sem digito
   cNNum     := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))      // Nosso Numero
   cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))  // Nosso Numero para impressao
   cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")
Elseif Substr(cBanco,1,3) == "237"   // BANCO BRADESCO
   cNNumSDig := Strzero(val(cSequencial),11)                                                              // Nosso Numero sem digito
   cNNum     := cCarteira + '/' + cNNumSDig + '-' + AllTrim( Mod11_B7( cCarteira + cNNumSDig ) )          // Nosso Numero
   cNossoNum := cCarteira + '/' + cNNumSDig + '-' + AllTrim( Mod11_B7( cCarteira + cNNumSDig ) )          // Nosso Numero para impressao
   cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"
Elseif Substr(cBanco,1,3) == "453"   // BANCO RURAL
   cNNumSDig := strzero(val(cSequencial),7)                                 // Nosso Numero sem digito
   cNNum     := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )         // Nosso Numero
   cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )     // Nosso Numero para impressao
   cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"
Elseif Substr(cBanco,1,3) == "341"   // BANCO ITAU
   //If _lBcoCorrespondente
      cNNumSDig := cCarteira+strzero(val(cSequencial),8)                    // Nosso Numero sem digito
      cNNum     := cCarteira+strzero(val(cSequencial),8) + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )                      // Nosso Numero
      cNossoNum := cCarteira+"/"+strzero(val(cSequencial),8) +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )           // Nosso Numero para impressao
   //Else
   //   cNNumSDig := cCarteira+strzero(val(cNroDoc),6)+ _cParcela             // Nosso Numero sem digito
   //   cNNum     := cCarteira+strzero(val(cNroDoc),6) + _cParcela + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )              // Nosso Numero
   //   cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),6)+ _cParcela +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )    // Nosso Numero para impressao
   //Endif
   cCpoLivre := cNNumSDig+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) ) ) )+"000"
Elseif Substr(cBanco,1,3) == "399"   // BANCO HSBC
   cNNumSDig := StrZero(Val(SubStr(cConvenio,1,5)),5)+strzero(val(cSequencial),5)     // Nosso Numero sem digito
   cNNum     := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))                    // Nosso Numero
   cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))                // Nosso Numero para impressao
   cCpoLivre := cNNum+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+"001"
Elseif Substr(cBanco,1,3) == "422"   // BANCO SAFRA
   cNNumSDig := strzero(val(cSequencial),8)                                           // Nosso Numero sem digito
   cNNum     := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))                    // Nosso Numero
   cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))                // Nosso Numero para impressao
   cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10)+cNNum+"2"
Elseif Substr(cBanco,1,3) == "479"   // BANCO BOSTON
   cNumSeq   := Strzero(val(cSequencial),8)
   cCodEmp   := Strzero(Val(SubStr(cConvenio,1,9)),9)
   cNNumSDig := Strzero(val(cSequencial),8)                                           // Nosso Numero sem digito
   cNNum     := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))                    // Nosso Numero
   cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))                // Nosso Numero para impressao
   cCpoLivre := cCodEmp+"000000"+cNNum+"8"
Elseif Substr(cBanco,1,3) == "409"   // BANCO UNIBANCO
   cNumSeq   := Strzero(val(cSequencial),10)
   cCodEmp   := Strzero(Val(SubStr(cConvenio,1,9)),9)
   cNNumSDig := Strzero(val(cSequencial),10)                                          // Nosso Numero sem digito
   _cDigito  := modulo11(cNNumSDig,SubStr(cBanco,1,3))                                // Nosso Numero
   _cSuperDig:= modulo11("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))                 // Calculo do super digito
   cNNum     := "1"+cNNumSDig + _cDigito + _cSuperDig
   cNossoNum := "1/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig                  // Nosso Numero para impressao
   cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig   // O codigo fixo "04" e para a combranco sem registro
Elseif Substr(cBanco,1,3) == "356"   // BANCO REAL
   cNumSeq   := strzero(val(cNumSeq),13)
   cNNumSDig := cNumSeq                                                               // Nosso Numero sem digito
   cNNum     := cNumSeq                                                               // Nosso Numero
   cNossoNum := cNNum                                                                 // Nosso Numero para impressao
   cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig
Elseif Substr(cBanco,1,3) == "745"   // BANCO CITIBANK
   cNNumSDig := Strzero(val(cSequencial),11)                                          // Nosso Numero sem digito
   cNNum     := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))                    // Nosso Numero
   cNossoNum := cNNumSDig + "-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))               // Nosso Numero para impressao
   cCpoLivre := "3"+cCarteira+"277213028"+cNNum
Endif

If Substr(cBanco,1,3) == "033"   // BANCO SANTANDER
   cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre                                                // Dados para Calcular o Dig Verificador Geral
   cCodBarra := cBanco + Modulo11(cCBSemDig,SubStr(cBanco,1,3)) + cFatVenc + blvalorfinal + cCpoLivre       // Codigo de Barras Completo
	
   cPrCpo   := cBanco+"9"+SubStr(cCodBarra,21,4)                                         // Digito Verificador do Primeiro Campo
   cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))

   cSgCpo   := SubStr(cCodBarra,25,10)                                                   // Digito Verificador do Segundo Campo
   cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
   cTrCpo   := SubStr(cCodBarra,35,10)                                                   // Digito Verificador do Terceiro Campo
   cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
   cDvGeral := SubStr(cCodBarra,5,1)                                                     // Digito Verificador Geral do Quarto Campo
	 
   cQrCpo   := SubStr(cCodBarra,06,14)                                                   // Digito Verificador do Quinto Campo
   cDvQrCpo := AllTrim(Str(Modulo10(cQrCpo)))
	
   //Linha Digitavel
   cLinDig := SubStr(cPrCpo,1,09) + "." + cDvPrCpo + " "                                 // Primeiro campo
   cLinDig += SubStr(cSgCpo,1,10) + "." + cDvSgCpo + " "                                 // Segundo campo
   cLinDig += SubStr(cTrCpo,1,10) + "." + cDvTrCpo + " "                                 // Terceiro campo
   cLinDig += cDvGeral + " "                                                             // Dig verificador geral Quarto campo
   cLinDig += SubStr(cQrCpo,1,14)                                                        // Quinto campo
ElseIf Substr(cBanco,1,3) == "745"
   cCBSemDig := Substr(cBanco,1,3) + "9" +cFatVenc + blvalorfinal + cCpoLivre                                                // Dados para Calcular o Dig Verificador Geral
   cCodBarra := Substr(cBanco,1,3) + "9" +Modulo11(cCBSemDig,SubStr(cBanco,1,3)) + cFatVenc + blvalorfinal + cCpoLivre       // Codigo de Barras Completo

   cPrCpo   := Substr(cBanco,1,3) +"9"+Substr(cCodBarra,20,5)
   cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))                                            // Digito Verificador do Primeiro Campo

   cSgCpo   := SubStr(cCodBarra,25,10)
   cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))                                            // Digito Verificador do Segundo Campo

   cTrCpo   := SubStr(cCodBarra,35,10)          
   cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))                                            // Digito Verificador do Terceiro Campo

   cDvGeral := SubStr(cCodBarra,5,1)                                                     // Digito Verificador Geral
	
   //Linha Digitavel             
   cLinDig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "             // Primeiro campo
   cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "             // Segundo campo
   cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "             // Terceiro campo
   cLinDig += " " + cDvGeral                                                             // Dig verificador geral
   cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)                       // Fator de vencimento e valor nominal do titulo
Else                             // DEMAIS BANCOS
   cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre                                                // Dados para Calcular o Dig Verificador Geral
   cCodBarra := cBanco + Modulo11(cCBSemDig,SubStr(cBanco,1,3)) + cFatVenc + blvalorfinal + cCpoLivre       // Codigo de Barras Completo
	
   cPrCpo   := cBanco + SubStr(cCodBarra,20,5)                                           // Digito Verificador do Primeiro Campo
   cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
   cSgCpo   := SubStr(cCodBarra,25,10)                                                   // Digito Verificador do Segundo Campo
   cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
   cTrCpo   := SubStr(cCodBarra,35,10)                                                   // Digito Verificador do Terceiro Campo
   cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
   cDvGeral := SubStr(cCodBarra,5,1)                                                     // Digito Verificador Geral
	
   //Linha Digitavel
   cLinDig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "             // Primeiro campo
   cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "             // Segundo campo
   cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "             // Terceiro campo
   cLinDig += " " + cDvGeral                                                             // Dig verificador geral
   cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)                       // Fator de vencimento e valor nominal do titulo
Endif

// MsgAlert("Cod. Barra = "+cCodBarra+CHR(13)+CHR(13)+"Linha Digitavel = "+cLinDig+CHR(13)+CHR(13)+"Nosso Numero = "+cNossoNum)

Return({cCodBarra,cLinDig,cNossoNum})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PARA CONFIGURAR SETUP DE IMPRESSAO (LOCAL OU SERVER)     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function ConfiguraPrt()
Local oPrint
oPrint:=TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait()      // ou SetLandscape()
oPrint:Setup()            // setup de impressao
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADA DA FUNCAO AGENCIA()                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Agencia(_cBanco,_nAgencia)
Local _cRet := ""
If _cBanco $ "479/389"
   _cRet := AllTrim(SEE->EE_AGBOSTO)
ElseIf _cBanco == "341" .or. _cBanco == "422" .Or. _cBanco == "041" .or. _cBanco == "745"
   _cRet := StrZero(Val(AllTrim(_nAgencia)),4)
Else
   _cRet := SubStr(StrZero(Val(AllTrim(_nAgencia)),5),1,4)+"-"+SubStr(StrZero(Val(AllTrim(_nAgencia)),5),5,1)
Endif
Return(_cRet)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADA DA FUNCAO CONTA()                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Conta(_cBanco,_cConta)
Local _cRet := ""
If _cBanco $ "479/389/041"
   _cRet := AllTrim(SEE->EE_CODEMP)
ElseIf _cBanco == "341"
   _cRet := StrZero(Val(SubStr(AllTrim(_cConta),1,Len(AllTrim(_cConta))-1)),5)
ElseIf _cBanco == "237"
   _cRet := StrZero(Val(Substr(_cConta,1,Len(AllTrim(_cConta))-1)),7)
Else
   _cRet := SubStr(AllTrim(_cConta),1,Len(AllTrim(_cConta))-1)
Endif
Return(_cRet)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADA DA FUNCAO NUMPARCELA()                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function NumParcela(_cParcela)
Local _cRet := ""
If ASC(_cParcela) >= 65 .Or. ASC(_cParcela) <= 90
   _cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),2)
Else
   _cRet := StrZero(Val(_cParcela),2)
Endif
Return(_cRet)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao NOSSONUMERO()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function NOSSONUMERO()

DbSelectArea("SE1")
RecLock("SE1",.F.)
DO CASE
   CASE SE1->E1_PORTADO == "041"
      _char2 := StrZero(_NumBco,08,0)
      Z_DVBCO()
      SE1->E1_NUMBCO := StrZero(_NumBco,08,0)+"-"+_char2
      _NumBco := _NumBco + 1
ENDCASE

DbSelectArea("SEE")
RecLock("SEE",.F.)
SEE->EE_FAXATU := Str(_NumBco,08)
MsUnlock()

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao Z_DVBCO()                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Syntax: Z_DVBCO( <expC1>,<expC2> )  && Cod. Banco e Nosso Numero
// Return: Retorna <expN1>             && Retorna Digito Verificador p/ Banco
Static Function Z_DVBCO()
DO CASE
   CASE SE1->E1_PORTADO == "041"    // BANCO BANRISUL
      _num3 := (val(subs(_char2,1,1)) * 1) - iif(val(subs(_char2,1,1)) * 1 >9,9,0) +;
               (val(subs(_char2,2,1)) * 2) - iif(val(subs(_char2,2,1)) * 2 >9,9,0) +;
               (val(subs(_char2,3,1)) * 1) - iif(val(subs(_char2,3,1)) * 1 >9,9,0) +;
               (val(subs(_char2,4,1)) * 2) - iif(val(subs(_char2,4,1)) * 2 >9,9,0) +;
               (val(subs(_char2,5,1)) * 1) - iif(val(subs(_char2,5,1)) * 1 >9,9,0)
               _num3:=_num3+ (val(subs(_char2,6,1)) * 2) - iif(val(subs(_char2,6,1)) * 2 >9,9,0) +;
               (val(subs(_char2,7,1)) * 1) - iif(val(subs(_char2,7,1)) * 1 >9,9,0) +;
               (val(subs(_char2,8,1)) * 2) - iif(val(subs(_char2,8,1)) * 2 >9,9,0)
      If _num3<10
         _num2:=_num3
      Else
         _num2 := mod(_num3,10)
      Endif
      If _num2 == 0
         _num4 := 0
      Else
         _num4 := 10 - _num2
      Endif
      _char2 := _char2+str(_num4,1)
                _num3 := (val(subs(_char2,1,1)) * 4) +;
		(val(subs(_char2,2,1)) * 3) + (val(subs(_char2,3,1)) * 2) +;
		(val(subs(_char2,4,1)) * 7) + (val(subs(_char2,5,1)) * 6) +;
		(val(subs(_char2,6,1)) * 5) + (val(subs(_char2,7,1)) * 4) +;
		(val(subs(_char2,8,1)) * 3) + (val(subs(_char2,9,1)) * 2)
      If _num3<11
         _num2:=_num3
      Else
         _num2 := mod(_num3,11)
      Endif
      If _num2 == 1
         If VAL(RIGHT(_CHAR2,1))+1==10
            _CHAR2:=LEFT(_CHAR2,8)+"0"
         Else
            _CHAR2:=LEFT(_CHAR2,8)+STR(VAL(RIGHT(_CHAR2,1))+1,1)
         Endif
         _num3 := (val(subs(_char2,1,1)) * 4) +;
                  (val(subs(_char2,2,1)) * 3) + (val(subs(_char2,3,1)) * 2) +;
                  (val(subs(_char2,4,1)) * 7) + (val(subs(_char2,5,1)) * 6) +;
                  (val(subs(_char2,6,1)) * 5) + (val(subs(_char2,7,1)) * 4) +;
                  (val(subs(_char2,8,1)) * 3) + (val(subs(_char2,9,1)) * 2)
         If _num3<11
            _num2:=_num3
         Else
            _num2 := mod(_num3,11)
         Endif
      Endif
      If _num2 == 0
         _num4 := 0
      Else
         _num4 := 11 - _num2
      Endif
      _char2 := right(_char2,1)+str(_num4,1)
ENDCASE

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao CODIGOBARRAS()                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function CODIGOBARRAS()
cLinDig   := ""
cCodBarra := ""
DO CASE
   CASE SE1->E1_PORTADO == "041"  // Banrisul
      i:=1
      Do While i<= 44
         STR_NUM[i] := 1
         i:=i+1
      Enddo
      _XX := str(SE1->E1_VENCTO-ctod('07/10/1997'),4) + strzero(SE1->E1_VALOR*100,10,0)
      STR_NUM[1]:=0
      STR_NUM[2]:=4
      STR_NUM[3]:=1
      STR_NUM[4]:=9    // MOEDA
      STR_NUM[6]:=VAL(SUBSTR(_XX,1,1))
      STR_NUM[7]:=VAL(SUBSTR(_XX,2,1))
      STR_NUM[8]:=VAL(SUBSTR(_XX,3,1))
      STR_NUM[9]:=VAL(SUBSTR(_XX,4,1))
      STR_NUM[10]:=VAL(SUBSTR(_XX,5,1))
      STR_NUM[11]:=VAL(SUBSTR(_XX,6,1))
      STR_NUM[12]:=VAL(SUBSTR(_XX,7,1))
      STR_NUM[13]:=VAL(SUBSTR(_XX,8,1))
      STR_NUM[14]:=VAL(SUBSTR(_XX,9,1))
      STR_NUM[15]:=VAL(SUBSTR(_XX,10,1))
      STR_NUM[16]:=VAL(SUBSTR(_XX,11,1))
      STR_NUM[17]:=VAL(SUBSTR(_XX,12,1))
      STR_NUM[18]:=VAL(SUBSTR(_XX,13,1))
      STR_NUM[19]:=VAL(SUBSTR(_XX,14,1))
      STR_NUM[20]:=2
      STR_NUM[21]:=1   
      
      _XX:=SEE->EE_AGENCIA
      STR_NUM[22]:=VAL(SUBSTR(_XX,2,1))
      STR_NUM[23]:=VAL(SUBSTR(_XX,3,1))
      STR_NUM[24]:=VAL(SUBSTR(_XX,4,1))
      
      _XX:=substr(SEE->EE_CODEMP,4,7)
      STR_NUM[25]:=VAL(SUBSTR(_XX,1,1))
      STR_NUM[26]:=VAL(SUBSTR(_XX,2,1))
      STR_NUM[27]:=VAL(SUBSTR(_XX,3,1))
      STR_NUM[28]:=VAL(SUBSTR(_XX,4,1))
      STR_NUM[29]:=VAL(SUBSTR(_XX,5,1))
      STR_NUM[30]:=VAL(SUBSTR(_XX,6,1))
      STR_NUM[31]:=VAL(SUBSTR(_XX,7,1))
      
      _XX:=SUBSTR(SE1->E1_NUMBCO,1,8)
      STR_NUM[32]:=VAL(SUBSTR(_XX,1,1))
      STR_NUM[33]:=VAL(SUBSTR(_XX,2,1))
      STR_NUM[34]:=VAL(SUBSTR(_XX,3,1))
      STR_NUM[35]:=VAL(SUBSTR(_XX,4,1))
      STR_NUM[36]:=VAL(SUBSTR(_XX,5,1))
      STR_NUM[37]:=VAL(SUBSTR(_XX,6,1))
      STR_NUM[38]:=VAL(SUBSTR(_XX,7,1))
      STR_NUM[39]:=VAL(SUBSTR(_XX,8,1))
      STR_NUM[40]:=0
      STR_NUM[41]:=4
      STR_NUM[42]:=1
      //-------------------------------------------- DIG MOD 10
      _AA1:=20
      _XX1:=0
      _BB1:=2
      DO WHILE _AA1<=42
         _XX1:=_XX1+(STR_NUM[_AA1]*_BB1-IIF(STR_NUM[_AA1]*_BB1>9,9,0))
         IF _BB1==1
            _BB1:=2
         ELSE
            _BB1:=1
         ENDIF
         _AA1:=_AA1+1
      ENDDO
      IF _XX1<10
         _YY:=_XX1
      ELSE
         _YY:=mod(_XX1,10)
      ENDIF
      IF _YY==0
         _XX1:=0
      ELSE
         _XX1:=10-_YY
      ENDIF
      STR_NUM[43]:=_XX1
      //-------------------------------------------- DIG MOD 11
      _xx:=43
      _yy:=2
      _ZZ:=0
      do while _XX>=20
         if _yy>7
            _YY:=2
         Endif
         _ZZ:=_ZZ+(STR_NUM[_xx]*_YY)
         _YY:=_YY+1
         _XX:=_XX-1
      enddo
      IF _ZZ<11
         _XX2:=_ZZ
      ELSE
         _XX2:=MOD(_ZZ,11)
      ENDIF
      IF _XX2==1
         IF STR_NUM[43]+1==10
            STR_NUM[43]:=0
         ELSE
            STR_NUM[43]:=STR_NUM[43]+1
         ENDIF
         _xx:=43
         _yy:=2
         _ZZ:=0
         do while _XX>=20
            if _yy>7
               _YY:=2
            Endif
            _ZZ:=_ZZ+(STR_NUM[_xx]*_YY)
            _YY:=_YY+1
            _XX:=_XX-1
         enddo
         IF _ZZ<11
            _XX2:=_ZZ
         ELSE
            _XX2:=MOD(_ZZ,11)
         ENDIF
      ENDIF
      IF _XX2<>0
         _XX2:=11-_XX2
      ENDIF
      STR_NUM[44]:=_XX2

      //--------------------------------- CALCULO DIGITO POS. 5
      _xx:=44
      _yy:=2
      _ZZ:=0
      do while _XX<>0
         if _yy>9
            _YY:=2
         Endif
         IF _XX==5
            _XX:=_XX-1
         ENDIF
         _ZZ:=_ZZ+(STR_NUM[_xx]*_YY)
         _YY:=_YY+1
         _XX:=_XX-1
      enddo
      IF _ZZ<11
         _DIG5:=_ZZ
      ELSE
         _DIG5:=MOD(_ZZ,11)
      ENDIF
      IF _DIG5<>0
         _DIG5:=11-_DIG5
      ENDIF
      IF _DIG5==10
         _DIG5:=1
      ENDIF
      IF _DIG5==11
         _DIG5:=1
      ENDIF
      IF _DIG5==0
         _DIG5:=1
      ENDIF
      STR_NUM[5]:=_DIG5
		
      //---------------------------------- DIGITO VERIFICADOR 1
      _XX:=(0*2)+(4*1)+(1*2)+(9*1)+(2*2)+(1*1)
      _XX:=_XX+VAL(SUBS(SEE->EE_AGENCIA,2,1))*2-IIF(VAL(SUBS(SEE->EE_AGENCIA,2,1))*2>9,9,0)
      _XX:=_XX+VAL(SUBS(SEE->EE_AGENCIA,3,1))*1-IIF(VAL(SUBS(SEE->EE_AGENCIA,3,1))*1>9,9,0)
      _XX:=_XX+VAL(SUBS(SEE->EE_AGENCIA,4,1))*2-IIF(VAL(SUBS(SEE->EE_AGENCIA,4,1))*2>9,9,0)
      IF _XX<10
         _YY:=_XX
      ELSE
         _YY:=mod(_XX,10)
      ENDIF
      IF _YY==0
         _XX:=0
      ELSE
         _XX:=10-_YY
      ENDIF

      //---------------------------------- DIGITO VERIFICADOR 2
      _XX1:=     VAL(SUBS(SEE->EE_CODEMP,04,1))*1-IIF(VAL(SUBS(SEE->EE_CODEMP,04,1))*1>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SEE->EE_CODEMP,05,1))*2-IIF(VAL(SUBS(SEE->EE_CODEMP,05,1))*2>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SEE->EE_CODEMP,06,1))*1-IIF(VAL(SUBS(SEE->EE_CODEMP,06,1))*1>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SEE->EE_CODEMP,07,1))*2-IIF(VAL(SUBS(SEE->EE_CODEMP,07,1))*2>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SEE->EE_CODEMP,08,1))*1-IIF(VAL(SUBS(SEE->EE_CODEMP,08,1))*1>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SEE->EE_CODEMP,09,1))*2-IIF(VAL(SUBS(SEE->EE_CODEMP,09,1))*2>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SEE->EE_CODEMP,10,1))*1-IIF(VAL(SUBS(SEE->EE_CODEMP,10,1))*1>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),1,1))*2-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),1,1))*2>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),2,1))*1-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),2,1))*1>9,9,0)
      _XX1:=_XX1+VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),3,1))*2-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),3,1))*2>9,9,0)
      IF _XX1<10
         _YY:=_XX1
      ELSE
         _YY:=mod(_XX1,10)
      ENDIF
      IF _YY==0
         _XX1:=0
      ELSE
         _XX1:=10-_YY
      ENDIF

      //---------------------------------- DIGITO VERIFICADOR 3
      _XX2:=     VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),4,1))*1-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),4,1))*1>9,9,0)
      _XX2:=_XX2+VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),5,1))*2-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),5,1))*2>9,9,0)
      _XX2:=_XX2+VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),6,1))*1-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),6,1))*1>9,9,0)
      _XX2:=_XX2+VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),7,1))*2-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),7,1))*2>9,9,0)
      _XX2:=_XX2+VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),8,1))*1-IIF(VAL(SUBS(SUBSTR(SE1->E1_NUMBCO,1,8),8,1))*1>9,9,0)
      _XX2:=_XX2+(0*2)+(4*1)+(1*2)
      _XX2:=_XX2+STR_NUM[43]*1-IIF(STR_NUM[43]*1>9,9,0)
      _XX2:=_XX2+STR_NUM[44]*2-IIF(STR_NUM[44]*2>9,9,0)
      IF _XX2<10
         _YY:=_XX2
      ELSE
         _YY:=mod(_XX2,10)
      ENDIF
      IF _YY==0
         _XX2:=0
      ELSE
         _XX2:=10-_YY
      ENDIF

      cLinDig := "04192.1"+Substr(SEE->EE_AGENCIA,2,3)+Str(_XX,1,0)+"  "
      cLinDig += Substr(SEE->EE_CODEMP,4,5)+"."+Substr(SEE->EE_CODEMP,09,2)+Left(Substr(SE1->E1_NUMBCO,1,8),3)+Str(_XX1,1,0)+"  "
      cLinDig += Substr(Substr(SE1->E1_NUMBCO,1,8),4,5)+".041"+Str(STR_NUM[43],1,0)+Str(STR_NUM[44],1,0)+Str(_XX2,1,0)+"  "+STR(STR_NUM[5],1,0)+"  "
      cLinDig += Str(SE1->E1_VENCTO-Ctod("07/10/1997"),4)+Strzero(SE1->E1_VALOR*100,10,0)

      _Flag1:=1
      cCodBarra:=""
      FOR I:=1 to 44
          cCodBarra:=cCodBarra+STR(STR_NUM[i],1,0)
      NEXT
ENDCASE

DbSelectArea("SE1")
RecLock("SE1",.F.)
SE1->E1_CODBAR := cCodBarra
SE1->E1_CODDIG := cLinDig
MsUnlock()

Return({cCodBarra,cLinDig})


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VALIDPERG ³ Autor ³ Evandro Mugnol       ³ Data ³ 19/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria perguntas no SX1. Se a pergunta ja existir, atualiza. ³±±
±±³          ³ Se houver mais perguntas no SX1 do que as definidas aqui,  ³±±
±±³          ³ deleta as excedentes do SX1.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()
Local _aArea  := GetArea()
Local _aRegs  := {}
Local _aHelps := {}
Local _i      := 0
Local _j      := 0

_aRegs = {}
//             GRUPO  ORDEM PERGUNT                     PERSPA PERENG VARIAVL   TIPO TAM DEC PRESEL GSC  VALID VAR01       DEF01         DEFSPA1 DEFENG1 CNT01 VAR02 DEF02        DEFSPA2 DEFENG2 CNT02 VAR03 DEF03    DEFSPA3 DEFENG3 CNT03 VAR04 DEF04 DEFSPA4 DEFENG4 CNT04 VAR05 DEF05 DEFSPA5 DEFENG5 CNT05 F3     GRPSXG
AADD (_aRegs, {cPerg, "01", "Do Prefixo             ?", "",    "",    "mv_ch1", "C", 03, 0,  0,     "G", "",   "mv_par01", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "02", "Ate o Prefixo          ?", "",    "",    "mv_ch2", "C", 03, 0,  0,     "G", "",   "mv_par02", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "03", "Do Título              ?", "",    "",    "mv_ch3", "C", 06, 0,  0,     "G", "",   "mv_par03", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "04", "Ate o Título           ?", "",    "",    "mv_ch4", "C", 06, 0,  0,     "G", "",   "mv_par04", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "05", "Banco                  ?", "",    "",    "mv_ch5", "C", 03, 0,  0,     "G", "",   "mv_par05", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   "SA6"})
AADD (_aRegs, {cPerg, "06", "Agência                ?", "",    "",    "mv_ch6", "C", 05, 0,  0,     "G", "",   "mv_par06", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "07", "Conta                  ?", "",    "",    "mv_ch7", "C", 10, 0,  0,     "G", "",   "mv_par07", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "08", "Sub Conta              ?", "",    "",    "mv_ch8", "C", 03, 0,  0,     "G", "",   "mv_par08", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "09", "Do Borderô             ?", "",    "",    "mv_ch9", "C", 06, 0,  0,     "G", "",   "mv_par09", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "10", "Do Borderô             ?", "",    "",    "mv_cha", "C", 06, 0,  0,     "G", "",   "mv_par10", "",           "",     "",     "",   "",   "",          "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})
AADD (_aRegs, {cPerg, "11", "Traz Marcado           ?", "",    "",    "mv_chb", "N", 01, 0,  0,     "C", "",   "mv_par11", "Sim",        "",     "",     "",   "",   "Nao",       "",     "",     "",   "",   "",      "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",   ""})

// Definicao de textos de help (versao 7.10 em diante): uma array para cada linha.
_aHelps = {}
//              Ordem   1234567890123456789012345678901234567890    1234567890123456789012345678901234567890    1234567890123456789012345678901234567890
AADD (_aHelps, {"01", {"Prefixo inicial a ser considerado na    ", "filtragem dos títulos a receber. (SE1)  ", "                                        "}})
AADD (_aHelps, {"02", {"Prefixo final a ser considerado na      ", "filtragem dos títulos a receber. (SE1)  ", "                                        "}})
AADD (_aHelps, {"03", {"Título inicial a ser considerado na     ", "filtragem dos títulos a receber. (SE1)  ", "                                        "}})
AADD (_aHelps, {"04", {"Título final a ser considerado na       ", "filtragem dos títulos a receber. (SE1)  ", "                                        "}})
AADD (_aHelps, {"05", {"Banco o qual deseja imprimir os         ", "boletos.                                ", "                                        "}})
AADD (_aHelps, {"06", {"Agencia o qual deseja imprimir os       ", "boletos.                                ", "                                        "}})
AADD (_aHelps, {"07", {"Conta o qual deseja imprimir os         ", "boletos.                                ", "                                        "}})
AADD (_aHelps, {"08", {"Sub Conta o qual deseja imprimir os     ", "boletos.                                ", "                                        "}})
AADD (_aHelps, {"09", {"Borderô inicial a ser considerado na    ", "filtragem dos títulos.                  ", "                                        "}})
AADD (_aHelps, {"10", {"Borderô final a ser considerado na      ", "filtragem dos títulos.                  ", "                                        "}})
AADD (_aHelps, {"11", {"Informe Sim para trazer todos os títulos", "marcados automaticamente ou Não para    ", "caso contrário.                         "}})

DbSelectArea ("SX1")
DbSetOrder (1)
For _i := 1 to Len (_aRegs)
   If ! DbSeek (cPerg + _aRegs [_i, 2])
      RecLock("SX1", .T.)
   Else
      RecLock("SX1", .F.)
   Endif
   For _j := 1 to FCount ()
      // Campos CNT nao sao gravados para preservar conteudo anterior.
      If _j <= Len (_aRegs [_i]) .and. left (fieldname (_j), 6) != "X1_CNT" .and. fieldname (_j) != "X1_PRESEL"
         FieldPut(_j, _aRegs [_i, _j])
      Endif
   Next
   MsUnlock()
Next

// Deleta do SX1 as perguntas que nao constam em _aRegs
DbSeek (cPerg, .T.)
Do While !Eof() .And. x1_grupo == cPerg
   If Ascan(_aRegs, {|_aVal| _aVal [2] == sx1 -> x1_ordem}) == 0
      Reclock("SX1", .F.)
      Dbdelete()
      Msunlock()
   Endif
   Dbskip()
enddo

// Gera helps das perguntas
For _i := 1 to Len(_aHelps)
   PutSX1Help ("P." + cPerg + _aHelps [_i, 1] + ".", _aHelps [_i, 2], {}, {})
Next

Restarea(_aArea)

Return
