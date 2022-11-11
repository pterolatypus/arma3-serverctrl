rem number of program variables
SET NVARS=8
rem names of program variables which can be changed by the user
SET VARS[1]=SERVER_HOME
SET VARS[2]=STEAMDIR
SET VARS[3]=STEAMUSER
SET VARS[4]=STEAMPASS
SET VARS[5]=ARMADIR
SET VARS[6]=BRANCH
SET VARS[7]=CFGFILE
SET VARS[8]=MODFOLDER

rem non-user-accessible program variables
SET "TAB=	"
SET JQ=%SCRIPTS%\lib\jq\jq.exe

rem custom error codes
rem because I cant be bothered googling every single one
SET ERR_TERMINATE=-1
SET ERR_SUCCESS=0
SET ERR_NO_CMD=2
SET ERR_NO_FILE=3
SET ERR_NO_VAR=4
SET ERR_NO_SERVER=5
SET ERR_SERVER_ALREADY_RUNNING=6
SET ERR_SERVER_NOT_RUNNING=7
SET ERR_NO_MOD=8
