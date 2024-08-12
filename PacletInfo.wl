(* ::Package:: *)

PacletObject[
  <|
    "Name" -> "Yurie/Sync",
    "Description" -> "A Mathematica toy model of Git",
    "Creator" -> "Yurie",
    "SourceControlURL" -> "https://github.com/yuriever/Yurie-Sync",
    "License" -> "MIT",
    "PublisherID" -> "Yurie",
    "Version" -> "1.0.0",
    "WolframVersion" -> "13+",
    "PrimaryContext" -> "Yurie`Sync`",
    "Extensions" -> {
      {
        "Kernel",
        "Root" -> "Kernel",
        "Context" -> {
          "Yurie`Sync`"
        }
      },
      {
        "Kernel",
        "Root" -> "Utility",
        "Context" -> {
          "Yurie`Sync`Info`",
          "Yurie`Sync`Source`"
        }
      },
      {
        "Asset",
        "Root" -> ".",
        "Assets" -> {
          {"License", "LICENSE"},
          {"ReadMe", "README.md"},
          {"Source", "Source"}
        }
      }
    }
  |>
]
