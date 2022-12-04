#include "totvs.ch"
#include "protheus.ch"
#include "apwebsrv.ch"

/*/{Protheus.doc} cpyfServ
	(Rotina que realiza a copia de um arquivo de uma pasta do servidor ou pasta local
		e transfere para o diretorio selecionado.)
	@type function
	@version  1.0
	@author Leonardo Barboza Ribeiro Leite - Apply System
	@since 25/03/2022
	@return logical, Caso tenha ocorrido tudo corretamente returna true caso tenha ocorrido erro retorna false.
/*/
user function cpyfServ()

	local lOk 		:= .f.
	local cOrigem	:= ''
	local cDestino	:= ''

	cOrigem := cGetFile( '', 'Selecione o arquivo', 0, '', .F., GETF_LOCALHARD  + GETF_NETWORKDRIVE, .T.)

	Sleep(1000)

	cDestino := cGetFile( "Arquivo Texto ( *.TXT ) |*.TXT|", "Selecione a pasta para salvar o arquivo",,, .F., GETF_NETWORKDRIVE + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_RETDIRECTORY )

	aDest := {}
	aDest := strToKarr( cOrigem, '\')

	cDestino := cDestino + aDest[len(aDest)]

	__CopyFile( cOrigem, cDestino )
	//CpyS2T( cOrigem, cDestino )

return lOk
