#include 'protheus.ch'
#INCLUDE 'TOPCONN.CH'

user function tstbkp()
	local cQuery := ""
	local lRet := nil
	local cCampos := ''

	RpcSetType(3)
	If !RpcSetEnv('01','01',,,,GetEnvServer(),{ })
		return
	EndIf

	DbSelectArea('SX3')
	SX3->(dbSetOrder(1))

	SX3->(dbseek('SE1'))

	while SX3->( !eof()) .and. SX3->X3_ARQUIVO == 'SE1'

		if alltrim(SX3->X3_CAMPO) != 'E1_XRENEGO' .and. alltrim(SX3->X3_CAMPO) != 'E1_LVRSOCI' .and. alltrim(SX3->X3_CAMPO) != 'E1_LVDECAR' .and. alltrim(SX3->X3_CAMPO) != 'E1_LVIMPDS'
			cCampos += SX3->X3_CAMPO + ', '
		endif

		SX3->(dbSkip())
	endDo

    cCampos += " D_E_L_E_T_, R_E_C_N_O_, R_E_C_D_E_L_ "

	cQuery := "INSERT INTO SE1010 (" + cCampos + ") SELECT " + cCampos + " FROM SE1BK1;"

	lRet := TCSqlExec(cQuery)

return
