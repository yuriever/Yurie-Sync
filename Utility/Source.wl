(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Sync`Source`"];


Needs["Yurie`Sync`Info`"];


(* ::Section:: *)
(*Public*)


$sampleSyncData;


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Main*)


$sampleSyncData = <|
    "ClusterID"->"sample",
    "Cluster"->{
        <|
            "Description"->"test1",
            "Directory"->FileNameJoin@{$thisSourceDir,"dirLocal","dir1"},
            "SyncID"->"test1"
        |>,
        <|
            "Description"->"test2",
            "Directory"->FileNameJoin@{$thisSourceDir,"dirLocal","dir2"},
            "SyncID"->"test2"
        |>
    }
|>;


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
