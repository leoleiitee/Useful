#Include "TOTVS.ch"
#include 'RPTDEF.ch'

/*/{Protheus.doc} UserErro0
( Função que realiza o controle e tratamento de erro em ADVPL - Teste )
@obs Tratamento de exceção utilizando final() dentro do begin sequence 
@type function
@version 1.0
@author Leonardo Barboza Ribeiro Leite
@since 27/09/2022
@return variant, Nulo
@link https://tdn.totvs.com/display/public/framework/FWLogMsg
/*/
user Function UserErro0()

    local bError   as CodeBlock
    local cError   as Character
    local aMessage as Array 
    local nBegin   as numeric

    nBegin := Seconds()
    cError := space(0)
    bError := errorBlock({|oError| cError := oError:Description})

    if (!IsBlind())
        rpcSetEnv("99", "01")
        // rpcSetEnv("01", "AADXD5")
    endIf

    BEGIN SEQUENCE

        NdADOS := 1 + XIZ
        MsgAlert( NdADOS )

    END SEQUENCE

    // TRANSFERE OERROR:DESCRIPTION PARA CERROR
    errorBlock(bError)

    // VALIDAÇÃO DE ERRO
    if (!Empty(cError))

        aMessage := {}
        aAdd(aMessage, {"Date", Date()})
        aAdd(aMessage, {"Hour", Time()})

        if getRemoteType() != NO_REMOTE
            aAdd(aMessage, {"Computer", GetClientIP()})
            aAdd(aMessage, {"IP", GetClientIP()})
        endif

        aAdd(aMessage, {"Erro", cError})

        FWLogMsg("ERROR", "LAST", "Grupo", "Categoria", 0 , "ID", '', 1, Seconds() - nBegin, aMessage)

    endIf

    // ENCERRAMENTO DE AMBIENTE EM CASO DE ESTADO DE JOB
    if (!IsBlind())
        rpcClearEnv()
    endIf

return (NIL)
