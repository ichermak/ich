﻿601,100
602,"}izi.system.file.delete"
562,"NULL"
586,"Template"
585,"Template"
564,
565,"d\]FaYKFcdkyooi0>A[=uQkVdO9FVn;izWfa0JQCeeDFRRdv12<NyVTg]Uw28I>[:NzC>J2JqD=Tzx9f;=:spLF<GqAP?`7T8y>EWHGe2EV1HN4vqrbY_H58Qhk?Fy\f_J<SORfxV2Ocp_wgvedu<9fe\c::P`ve93TzV\ISdloOvW8KLBffNNcSSLt<<kQ;UsyNufja"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,"."
589," "
568,""""
570,SourceView
571,
569,0
592,0
599,1000
560,6
pDebugMode
pFileDirectory
pFileName
pRecurse
pLastWritetimeMoreThanNbDaysAgo
pWaitForExecution
561,6
1
2
2
1
1
1
590,6
pDebugMode,0
pFileDirectory,""
pFileName,""
pRecurse,0
pLastWritetimeMoreThanNbDaysAgo,0
pWaitForExecution,1
637,6
pDebugMode,"[Optional] 0 = Nothing | 1 = Write to }izi.ProcessMessage cube | 2 = 1 + Keep temporary objects"
pFileDirectory,"[Mandatory] File directory (Example : 'C:\Applications\Tm1\Izi\Temp')"
pFileName,"[Mandatory] File name. Wildcard expressions are supported (Example : '*_2020.csv')"
pRecurse,"[Optional] 0 = Nothing | 1 = Search files recursively within the given directory 'pFileDirectory'"
pLastWritetimeMoreThanNbDaysAgo,"[Optional] 0 = Nothing | <Int> = Age of files to be deleted (Number of days)"
pWaitForExecution,"[Optional] 0 = Asynchronous execution | 1 = Synchronous execution"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,108

#****Begin: Generated Statements***
#****End: Generated Statements****

# ######  ######  ######
#   ##       ##     ##
#   ##      ##      ##
#   ##     ##       ##
# ######  ######  ######
# https://github.com/ichermak/Izi

# ====================================================================================================
# Description : Delete a file in a given directory
#
# Updates :
# 	- 2020/01/09 - Ifthen CHERMAK (www.linkedin.com/in/ichermak) : Creation
# 	- 2020/03/30 - Ifthen CHERMAK (www.linkedin.com/in/ichermak) : Two additional parameters 'pRecurse' and 'pLastWritetimeMoreThanNbDaysAgo' have been added
# ====================================================================================================


# === GLOBAL VARIABLES 
# ====================================================================================================
NumericGlobalVariable('PrologMinorErrorCount');
NumericGlobalVariable('MetadataMinorErrorCount');
NumericGlobalVariable('DataMinorErrorCount');

NumericGlobalVariable('nProcessReturn');
StringGlobalVariable('sProcessReturn');
nProcessReturn = 0;
sProcessReturn = '';


# === CONSTANT VARIABLES 
# ====================================================================================================

# *** Standard variables 
# **************************************** 
cCrLf = Char(13) | Char(10);
If(DimIx('}Clients', Tm1User) = 0); cTM1User = 'Chore'; Else; cTM1User = Tm1User; EndIf;
cStartTime = Now;
cProcessName = GetProcessName;
cIdExecution = cProcessName | '_' | TimSt(cStartTime, '\Y\m\d\h\i\s') | '_' | cTM1User  | '_' | Fill( '0', 5 - Long(NumberToString(Int(Rand * 65536)))) | NumberToString(Int(Rand * 65536));
cDebugFile = GetProcessErrorFileDirectory | cIdExecution | '.dbg';
cTemporaryObject = 1;
If(pDebugMode > 1); cTemporaryObject = 0; EndIf;


# === PARAMETERS VERIFICATION AND OTHER CHECKS
# ====================================================================================================
If((pDebugMode = 1) % (pDebugMode = 2));
    sNewMsg = Expand('Process started with : pFileDirectory=%pFileDirectory%, pFileName=%pFileName%, pRecurse=%pRecurse%, pLastWritetimeMoreThanNbDaysAgo=%pLastWritetimeMoreThanNbDaysAgo%, pWaitForExecution=%pWaitForExecution%.');
    ExecuteProcess('}izi.process.message.add'
                , 'pProcess', cProcessName
                , 'pMessage', sNewMsg
                );
EndIf;

sErrorMsg = '';
pFileDirectory = Trim(pFileDirectory);
pFileDirectory = IF(Subst(pFileDirectory, Long(pFileDirectory), 1) @= '\', pFileDirectory, pFileDirectory | '\');
pFileName = Trim(pFileName);
pRecurse = INT(pRecurse);
pLastWritetimeMoreThanNbDaysAgo = INT(pLastWritetimeMoreThanNbDaysAgo);
pWaitForExecution = INT(pWaitForExecution);

If(FileExists(pFileDirectory) = 0);
    sNewMsg = Expand('Invalid parameter : pFileDirectory=%pFileDirectory%.'); 
    sErrorMsg = sErrorMsg | IF(sErrorMsg @= '', '', cCrLf) | sNewMsg;
EndIf;

If(pFileName @= '');
    sNewMsg = Expand('Invalid parameter : pFileName=%pFileName%.'); 
    sErrorMsg = sErrorMsg | IF(sErrorMsg @= '', '', cCrLf) | sNewMsg;
EndIf;

If( (pRecurse <> 0) & (pRecurse <> 1) );
    sNewMsg = Expand('Invalid parameter : pRecurse=%pRecurse%.'); 
    sErrorMsg = sErrorMsg | IF(sErrorMsg @= '', '', cCrLf) | sNewMsg;
EndIf;

If(pLastWritetimeMoreThanNbDaysAgo < 0);
    sNewMsg = Expand('Invalid parameter : pLastWritetimeMoreThanNbDaysAgo=%pLastWritetimeMoreThanNbDaysAgo%.'); 
    sErrorMsg = sErrorMsg | IF(sErrorMsg @= '', '', cCrLf) | sNewMsg;
EndIf;

If( (pWaitForExecution <> 0) & (pWaitForExecution <> 1) );
    sNewMsg = Expand('Invalid parameter : pWaitForExecution=%pWaitForExecution%.'); 
    sErrorMsg = sErrorMsg | IF(sErrorMsg @= '', '', cCrLf) | sNewMsg;
EndIf;

If(sErrorMsg @<> '');
    If((pDebugMode = 1) % (pDebugMode = 2));
    sNewMsg = sErrorMsg;
        ExecuteProcess('}izi.process.message.add'
                    , 'pProcess', cProcessName
                    , 'pMessage', sNewMsg
                    );
    EndIf;
    ProcessBreak;
EndIf;


# === FILES DELETION
# ====================================================================================================
sLastWritetimeMoreThanNbDaysAgo = NumberToString(pLastWritetimeMoreThanNbDaysAgo);
sPsCmd = Expand('Get-ChildItem -Path ''%pFileDirectory%'' -Filter ''%pFileName%''') | IF(pRecurse <> 0, ' -Recurse', '') | IF(pLastWritetimeMoreThanNbDaysAgo <> 0, Expand(' | Where-Object LastWriteTime -lt (Get-Date).AddDays(-%sLastWritetimeMoreThanNbDaysAgo%)'), '') | ' | Remove-Item';
sCmd = Expand('Powershell -ExecutionPolicy Bypass -command "%sPsCmd%"');
ExecuteCommand(sCmd, pWaitForExecution);
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,21

#****Begin: Generated Statements***
#****End: Generated Statements****

# === EXIT
# ====================================================================================================
If((pDebugMode = 1) % (pDebugMode = 2));
    sProcessErrorFilePath = GetProcessErrorFileDirectory | GetProcessErrorFilename;
    If(FileExists(GetProcessErrorFilename) <> 0);
        ExecuteProcess('}izi.process.message.add'
                        , 'pProcess', cProcessName
                        , 'pMessage', sProcessErrorFilePath
                        ); 
    EndIf;
    
    sNewMsg = Expand('Process finished with : PrologMinorErrorCount=%PrologMinorErrorCount%, MetadataMinorErrorCount=%MetadataMinorErrorCount%, DataMinorErrorCount=%DataMinorErrorCount%.');
    ExecuteProcess('}izi.process.message.add'
                , 'pProcess', cProcessName
                , 'pMessage', sNewMsg
                ); 
EndIf;
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,1
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
