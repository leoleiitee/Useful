#include 'totvs.ch'

/*/{Protheus.doc} imgenc01
(Rotina genérica de importação de planilha csv via reclock)
@type function
@version  1.0
@author Leonardo Barboza Ribeiro Leite
@since 29/09/2022
@return variant, Nil
/*/
user function imgenc01()
    local bError  as CodeBlock
    local cError  as Character
    local nBegin  as numeric
    local cArq    as character
    local cAlias  as character
    local cRotina as character
    local aCab    as array
    local aDados  as array
    local aErro   as array

    nBegin := Seconds()
    cError := space(0)
    bError := errorBlock({|oError| cError := oError:Description})

    cArq := selecionaArquivo()

    BEGIN SEQUENCE

        if !empty( cArq )

            aCab    := {}
            aDados  := {}

            abreArquivo( @cArq, @aCab, @aDados, @cAlias, @cRotina )

            if empty(cRotina )
                grvRecl( @cArq, @aCab, @aDados, @cAlias, @aErro )
            else
                grvExec( @cArq, @aCab, @aDados, @cAlias, @cRotina, @aErro )
            endif

            if !empty( aErro )
                grvErro( @cAlias, @cRotina, @aErro )
            else
                // aviso( 'Finalizado', 'Processo de importação finalizado com sucesso.', {'OK'} )
            endif

        else
            final('Erro ao selecionar o arquivo.')
        endif

    END SEQUENCE

    errorBlock(bError)

    if (!Empty(cError))

        aviso( 'Erro:', cError, {'OK'} )

    endIf

return (nil)

/*/{Protheus.doc} selecionaArquivo
(Função que realiza a seleção de arquivo)
@type function
@version  1.0
@author Leonardo Barboza Ribeiro Leite
@since 29/09/2022
@return variant, retorna o diretóro + nome do arquivo selecionado.
/*/
static function selecionaArquivo()

    local cDiret as character

    //Abre uma tela para escolher o arquivo.
    cDiret := cGetFile('Arquivo CSV|*.csv',; 	//cMascara
        'Selecao de Arquivos',;						//cTitulo
        0,;											//nMascpadrao
        'C:',;										//cDirinicial
        .F.,;										//lSalvar
        GETF_LOCALHARD + GETF_NETWORKDRIVE,;		//nOpcoes
        .T.)

return cDiret

/*/{Protheus.doc} abreArquivo
Função que realiza a abertura do arquivo/valid
@type function
@version 1.0
@author Leonardo Barboza Ribeiro Leite
@since 29/09/2022
@param cDiret, character, diretóro + nome do arquivo selecionado.
@return array, linhas do arquivo
/*/
static function abreArquivo( cDiret as character, aCab as array, aDados as array, cAlias as character, cRotina as character )

    local aAuxiliar as character
    local lRet      as logical
    local oFile     as object
    local nX        as numeric

    lRet := .t.

    oFile := FwFileReader():New(cDiret)

    if (oFile:Open())

        aAuxiliar := {}

        aAuxiliar := oFile:GetAllLines()

        cAlias := allTrim( StrTokArr2( aAuxiliar[1], ";" )[1] )
        cRotina := allTrim( StrTokArr2( aAuxiliar[1], ";" )[2] )

        ADel(aAuxiliar, 1)
        ASize(aAuxiliar, Len(aAuxiliar) - 1)

        aCab := StrTokArr2( aAuxiliar[1], ";" )

        ADel(aAuxiliar, 1)
        ASize(aAuxiliar, Len(aAuxiliar) - 1)

        for nX := 1 to len( aAuxiliar )
            if len( StrTokArr( aAuxiliar[nX], ";" ) ) == len( aCab )
                aAdd( aDados, StrTokArr( decodeUTF8(aAuxiliar[nX], 'cp1252'), ";" ) )
            else
                final( 'Erro na validação da linha: ' + cValtoChar( nX ) )
                lRet := .f.
                exit
            endif
        next nX

    else
        lRet := .f.
        final( 'Erro na abertura do arquivo: ' + cDiret )
    endif

return lRet

/*/{Protheus.doc} grvRecl
Rotina que realiza a gravação dos dados na tabela.
@type function
@version 1.0
@author Leonardo Barboza Ribeiro Leite
@since 29/09/2022
@param cArq, character, Caminho + nome do arquivo.
@param aCab, array, Array com o cabeçalho da tabela.
@param aDados, array, Array com os dados que serão gravados na tabela.
@param cAlias, character, Alias/tabela para gravação dos dados.
@return variant, nil
/*/
static function grvRecl( cArq as character, aCab as array, aDados as array, cAlias as character, aErro as array )

    local nX as numeric
    local nY as numeric

    default xEmp := '01'
    default xFil := '010002'

    if ValType(xEmp) =='A'
        xFil := xEmp[2]
        xEmp := xEmp[1]
    endif

    //Abre o sistema empresa filial sem interface visual.
    rpcSetType(3)
    if !rpcSetEnv( xEmp,xFil )
        final('Erro ao abrir empresa.')
        return .f.
    else
        lRet:= .t.
    endif

    lRet:= .t.

    chkFile(cAlias)

    dbSelectArea(cAlias)
    &(cAlias)->(dbSetOrder(1))

    for nX := 1 to len( aDados )

        if reclock( cAlias, .t. )
            for nY := 1 to len( aCab )
                if existSx3( allTrim( aCab[nY] ) ) 
                    if alltrim(aDados[nX][nY]) != ''
                        Do Case
                            Case TamSX3(aCab[nY])[3] == 'C'
                                &( cAlias + "->(FieldPut( " + cAlias + "->(fieldPos(allTrim( aCab[nY] ))), alltrim(aDados[nX][nY]) ) )")
                            Case TamSX3(aCab[nY])[3] == 'N'
                                &( cAlias + "->(FieldPut( " + cAlias + "->(fieldPos(allTrim( aCab[nY] ))), val(alltrim(aDados[nX][nY])) ) )")
                            Case TamSX3(aCab[nY])[3] == 'D'
                                &( cAlias + "->(FieldPut( " + cAlias + "->(fieldPos(allTrim( aCab[nY] ))), stod(alltrim(aDados[nX][nY])) ) )")
                            Case TamSX3(aCab[nY])[3] == 'L'
                                &( cAlias + "->(FieldPut( " + cAlias + "->(fieldPos(allTrim( aCab[nY] ))), iif( upper(alltrim(aDados[nX][nY])) == 'T' .or. upper(alltrim(aDados[nX][nY])) == '.T.', .T., .F. ) )")
                            Case TamSX3(aCab[nY])[3] == 'M'
                                &( cAlias + "->(FieldPut( " + cAlias + "->(fieldPos(allTrim( aCab[nY] ))), alltrim(aDados[nX][nY]) ) )")
                        EndCase
                    endif
                endif
            next nY
            MsUnlock()
        else
            final( 'Erro ao realizar o lock na tabela: ' + cAlias )
            lret := .f.
        endif

    next nX

return lRet

/*/{Protheus.doc} grvExec
Rotina que faz a gravação dos dados via execauto
@type function
@version 1.0
@author Leonardo Barboza Ribeiro Leite
@since 29/09/2022
@return variant, lret
/*/
static function grvExec( cArq as character, aCab as array, aDados as array, cAlias as character, cRotina as character, aErro as array )

    local nX     as numeric
    local nY     as numeric
    local nZ     as numeric
    local lRet   as logical
    Local aCabec as array
    local aErr   as array
    local cErr   as character

    private lMsErroAuto    := .F.
    private lAutoErrNoFile := .T.

    default xEmp := '01'
    default xFil := '010002'

    if ValType(xEmp) =='A'
        xFil := xEmp[2]
        xEmp := xEmp[1]
    endif

    //Abre o sistema empresa filial sem interface visual.
    rpcSetType(3)
    if !rpcSetEnv( xEmp,xFil )
        final('Erro ao abrir empresa.')
        return .f.
    else
        lRet:= .t.
    endif

    lRet   := .t.
    aErr   := {}
    aErro  := {}
    aCabec := {}

    for nX := 1 to len( aDados )

        aCabec := {}

        for nY := 1 to len( aCab )

            aCabec := {}

            if existSx3( allTrim( aCab[nY] ) )
                Do Case
                    Case TamSX3(aCab[nY])[3] == 'C'
                        aAdd( aCabec, { aCab[nY], alltrim(aDados[nX][nY]), Nil } )
                    Case TamSX3(aCab[nY])[3] == 'N'
                        aAdd( aCabec, { aCab[nY], val(alltrim(aDados[nX][nY])), Nil } )
                    Case TamSX3(aCab[nY])[3] == 'D'
                        aAdd( aCabec, { aCab[nY], stod(alltrim(aDados[nX][nY])), Nil } )
                    Case TamSX3(aCab[nY])[3] == 'L'
                        aAdd( aCabec, { aCab[nY], iif( upper(alltrim(aDados[nX][nY])) == 'T' .or. upper(alltrim(aDados[nX][nY])) == '.T.', .T., .F. ), Nil } )
                    Case TamSX3(aCab[nY])[3] == 'M'
                        aAdd( aCabec, { aCab[nY], alltrim(aDados[nX][nY]), Nil } )
                EndCase
            endif
        next nY

        if !empty( aCabec )

            &( 'MSExecAuto({|x,y| ' + cRotina + '(x,y)},aCabec,3)')
            // MSExecAuto({|x,y| Mata080(x,y)},aCabec,3)

            If lMsErroAuto

                aErr  := GetAutoGRLog()

                cErr := ''

                for nZ := 1 To Len(aErr)
                    cErr +=  if(valtype(aErr[nZ])=='C',AllTrim(aErr[nZ]),'') + CRLF
                next

                aAdd( aErro, { nX, cErr } )
            Endif
        else
            aAdd( aErro, { nX, 'linha vazia ou com problemas'} )
        endif

    next nX

return lRet
