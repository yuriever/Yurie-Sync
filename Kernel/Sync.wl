(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Sync`"];


Get["Yurie`Sync`Variable`"];


(* ::Section:: *)
(*Public*)


syncSetCloud::usage =
    "set directory of the cloud.";

syncToCloud::usage =
    "push to the cloud.";

syncFromCloud::usage =
    "pull from the cloud.";

syncClearBackup::usage =
    "clear the backup in the cloud.";

syncClearTemp::usage =
    "clear the temp in the cloud.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Constant*)


$syncDataPattern =
    <|
        "ClusterID"->_String,
        "Cluster"->{
            <|
                "Description"->_String,
                "Directory"->_String?DirectoryQ,
                "SyncID"->_String
            |>...
        }
    |>;


(* ::Subsection:: *)
(*Message*)


syncSetCloud::notfound =
    "the sync directory does not exist.";

syncSetCloud::notset =
    "the sync directory has not been set.";

copyFromTemp::nodir =
    "the cluster has not been pushed.";

createBackup::failed =
    "backup fail!";

syncDataValidQ::invaliddata =
    "the sync data is invalid.";


(* ::Subsection:: *)
(*Main*)


syncSetCloud[dir_] :=
    Module[ {},
        If[ !DirectoryQ@dir,
            Message[syncSetCloud::notfound],
            (*Else*)
            $syncDirectory = <|
                "Root"->dir,
                "Temp"->FileNameJoin@{dir,"Temp"},
                "Backup"->FileNameJoin@{dir,"Backup"}
            |>;
            If[ !DirectoryQ@$syncDirectory["Backup"],
                CreateDirectory@$syncDirectory["Backup"]
            ];
            If[ !DirectoryQ@$syncDirectory["Temp"],
                CreateDirectory@$syncDirectory["Temp"]
            ];
            $hasSyncDirectory = True;
            $syncDirectory["Root"]//File
        ]
    ];


syncClearBackup[] :=
    (
        DeleteDirectory[$syncDirectory["Backup"],DeleteContents->True];
        CreateDirectory[$syncDirectory["Backup"]];
        $syncDirectory["Backup"]//File
    )//checkSyncDir;


syncClearTemp[] :=
    (
        DeleteDirectory[$syncDirectory["Temp"],DeleteContents->True];
        CreateDirectory[$syncDirectory["Temp"]];
        $syncDirectory["Temp"]//File
    )//checkSyncDir;


syncToCloud[syncData_] :=
    (
        If[ !syncDataValidQ@syncData,
            Message[syncDataValidQ::invaliddata],
            (*Else*)
            createBackup["Push"][syncData,$syncDirectory["Backup"]];
            copyToTemp[syncData,$syncDirectory["Temp"]];
            PrintTemporary["Success!"];
            Pause[0.5];
            $syncDirectory["Temp"]//File
        ]
    )//checkSyncDir;


syncFromCloud[syncData_] :=
    (
        If[ !syncDataValidQ@syncData,
            Message[syncDataValidQ::invaliddata],
            (*Else*)
            createBackup["Pull"][syncData,$syncDirectory["Backup"]];
            copyFromTemp[syncData,$syncDirectory["Temp"]];
            PrintTemporary["Success!"];
            Pause[0.5];
            $syncDirectory["Temp"]//File
        ]
    )//checkSyncDir;


(* ::Subsection:: *)
(*Helper*)


checkSyncDir//Attributes =
    {HoldAllComplete};

checkSyncDir[arg_] :=
    If[ !$hasSyncDirectory,
        Message[syncSetCloud::notset],
        (*Else*)
        arg
    ];


copyToTemp[syncData_,tempDir_] :=
    Module[ {tempCluster},
        tempCluster =
            FileNameJoin@{tempDir,syncData["ClusterID"]};
        If[ DirectoryQ@tempCluster,
            DeleteDirectory[tempCluster,DeleteContents->True]
        ];
        CreateDirectory@tempCluster;
        syncData//Query["Cluster",All,CopyDirectory[#Directory,FileNameJoin@{tempCluster,#SyncID}]&];
    ];


copyFromTemp[syncData_,tempDir_] :=
    Module[ {tempCluster},
        tempCluster =
            FileNameJoin@{tempDir,syncData["ClusterID"]};
        If[ DirectoryQ@tempCluster,
            syncData//Query["Cluster",All,DeleteDirectory[#Directory,DeleteContents->True]&];
            syncData//Query["Cluster",All,CopyDirectory[FileNameJoin@{tempCluster,#SyncID},#Directory]&],
            (*Else*)
            Message[copyFromTemp::nodir];
            Abort[]
        ];
    ];


createBackup[action:"Push"|"Pull"][syncData_,backupDir_] :=
    Check[
        Module[ {backupCluster,backupUnique},
            backupCluster =
                FileNameJoin@{backupDir,syncData["ClusterID"]};
            backupUnique =
                FileNameJoin@{backupCluster,StringRiffle[Most@DateList[],"-"]<>CreateUUID["-"<>action<>"-"]};
            If[ !DirectoryQ@backupCluster,
                CreateDirectory@backupCluster
            ];
            CreateDirectory@backupUnique;
            syncData//Query["Cluster",All,CopyDirectory[#Directory,FileNameJoin@{backupUnique,#SyncID}]&];
        ],
        (*Handler*)
        Message[createBackup::fail];
        Abort[]
    ];


syncDataValidQ[syncData_] :=
    MatchQ[syncData,$syncDataPattern]&&
        Unequal@syncData[["Cluster",All,"Directory"]]&&
            Unequal@syncData[["Cluster",All,"SyncID"]];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
