(*******************************************************************
This file was generated automatically by the Mathematica front end.
It contains Initialization cells from a Notebook file, which
typically will have the same name as this file except ending in
".nb" instead of ".m".

This file is intended to be loaded into the Mathematica kernel using
the package loading commands Get or Needs.  Doing so is equivalent
to using the Evaluate Initialization Cells menu command in the front
end.

DO NOT EDIT THIS FILE.  This entire file is regenerated
automatically each time the parent Notebook file is saved in the
Mathematica front end.  Any changes you make to this file will be
overwritten.
***********************************************************************)





(* *)
(* Title: Norms.m *)
(* Context: *)
(* Author:oliver ruebenkoenig *)
(* 
  Date: 1.03.05, Freiburg, Home *)
(* 
  Summary: This is the IMTEK norms packages *)
(* 
  Package Copyright: GNU GPL *)
(* Package Version: 0.1 *)
(* 
  Mathematica Version: 4.2 *)
(* History: *)
(* Keywords: *)
(* Sources: *)
(* 
  Warnings: *)
(* Limitations: *)
(* Discussion: *)
(* Requirements: *)
(* 
  Examples: *)
(* *)



(* Disclaimer *)

(* Whereever the GNU GPL is not applicable, 
  the software should be used in the same spirit. *)

(* Users of this code must verify correctness for their application. *)

(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)

(* Disclaimer: *)

(* This is the IMTEK norms packages *)

(* Copyright (C) 2003-2005 *)

(* This program is free software; *)

(* you can redistribute it and/
      or modify it under the terms of the GNU General Public License *)

(* as published by the Free Software Foundation;
  either version 2 of the License, *)

(* or (at your option) any later version.This program is distributed in the \
hope that *)

(* it will be useful,but WITHOUT ANY WARRANTY; *)

(* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A \
PARTICULAR PURPOSE. *)

(* See the GNU General Public License for more details. 
      You should have received a copy of *)

(* the GNU General Public License along with this program;if not, 
  write to the *)

(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)



(* Start Package *)
BeginPackage["Imtek`Norms`"];





(* *)
(* documentation *)
(* *)

(* functions *)
imsNorm::usage = 
  "imsNorm[ exp, Integer ] returns the norm of a vector, matrix or function" 



(* *)
(* options docu *)
(* *)



(* *)
(* Error Messages *)
(* *)





(* *)
(* implementation part *)
(* *)

(* constructor *)



Begin["`Private`"];





(* *)
(* define your options *)
(* *)



(* selector *)



(* predicates *)



(* functions *)

(* vector norms *)

imsNorm[ v_, p_ ] /; VectorQ[ v ]:= 
    Apply[ Plus, Abs[ Flatten[ v ]^p ] ]^(1/p);
imsNorm[ v_, Infinity ] /; VectorQ[ v ] := Max[ Abs[ v ] ];

(* matrix norms *)

imsNorm[ m_, Infinity ] /; MatrixQ[ m ] :=  
    Max[ Apply[ Plus, Abs[ # ]& /@ m, {1} ] ];
imsNorm[ m_, 1 ] /; MatrixQ[ m  ] := Norm[ Transpose[ m ], Infinity ];
imsNorm[ m_, 2 ] /; MatrixQ[ m ] := 
    Abs[ Sqrt[ 
        Max[Abs[ Eigenvalues[ Transpose[ Conjugate[ m ] ] . m ] ] ] ] ];

(* function norms *)

imsNorm[ f_Function, p_, a_, b_ ]:= 
    NIntegrate[ Abs[ f[ x ] ]^p , { x, a, b } ]^(1/p);



End[] (* of Begin Private *)



(* Protect[] (* anything *) *)
EndPackage[] 
