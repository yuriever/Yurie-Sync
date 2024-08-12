(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Sync`Variable`"];


(*clear the states when loading.*)

ClearAll["`*"];


(* ::Section:: *)
(*Public*)


$syncDirectory;

$hasSyncDirectory;


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Main*)


$syncDirectory = <||>;

$hasSyncDirectory = False;


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
