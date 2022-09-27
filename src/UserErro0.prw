#Include "TOTVS.ch"

/*/{Protheus.doc} UserErro0
( Função que realiza o controle e tratamento de erro em ADVPL - Teste
 obs: Tratamento de exceção utilizando final() dentro do begin sequence )
@type function
@version 1.0
@author Leonardo
@since 27/09/2022
@return variant, Nulo
/*/
user Function UserErro0()

    local bError As CodeBlock// TRATAMENTO DE ERRO
    local cError As Character // MENSAGEM DE ERRO

    if (!IsBlind())
        rpcSetEnv("99", "01")
    endIf

    // INICIALIZAÇÃO DE VARIÁVEIS
    cError := space(0)
    bError := errorBlock({|oError| cError := oError:Description})

    // INÍCIO DA SEQUÊNCIA COM FINAL()
    BEGIN SEQUENCE
        final("Encerramento normal")
    END SEQUENCE

    // TRANSFERE OERROR:DESCRIPTION PARA CERROR
    errorBlock(bError)

    // VALIDAÇÃO DE ERRO
    if (!Empty(cError))
        conOut(Repl("-", 80))
        conOut(PadC("Error: " + AllTrim(cError), 80))
        conOut(Repl("-", 80))
    endIf

    // ENCERRAMENTO DE AMBIENTE EM CASO DE ESTADO DE JOB
    if (!IsBlind())
        rpcClearEnv()
    endIf

return (NIL)
