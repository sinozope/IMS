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
(* :Title: EasyMeshInterface.m *)
(* :Context: *)
(* :
    Date: 2.3.05 *)
(* : Autor of Version 0.3: Oliver Ruebenkoenig *)
(* :
    Author: darius koziol and oliver ruebenkoenig *)
(* :Summary: 
      This package provieds an interface to EasyMesh *)
(* :
    Copyright: 
      GNU GPL 2002 - 2005 by darius koziol and oliver ruebenkoenig *)
(* :
    Package Version: 0.4 *)
(* :Mathematica Version: 5.1 *)
(* :History:
      Inserted NumerbForm in imsMatrixToStream and fixed the check for \
stream, and removed the Module, removed Protect[].
   *)
(* :Keywords: EasyMesh *)
(* :Sources: http://
    www-dinma.univ.trieste.it/nirftc/research/easymesh/Default.htm *)
(* :
    Warnings: MatrixToStram does not check for validity of stream *)
(* :
    Limitations: aTypeList is not checked *)
(* :Discussion: *)
(* :
    Requirements: *)
(* :Examples: *)
(* *)



(* Disclaimer *)

(* Whereever the GNU GPL is not applicable, 
  the software should be used in the same spirit. *)

(* Users of this code must verify correctness for their application. *)

(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)

(* Disclaimer: *)

(* This package provieds an interface to EasyMesh *)

(* Copyright (C) 2002-2005 darius koziol and oliver ruebenkoenig *)

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



(* *)
BeginPackage["Imtek`Interfaces`EasyMesh`"];

(* *)
(* documentation for functions in package go here *)
(* *)
\
Needs["Imtek`Maintenance`"]
imsCreateObsoleteFunctionInterface[ MatrixToStream, $Context ];
imsCreateObsoleteFunctionInterface[ RunEasyMesh, $Context ];
imsCreateObsoleteFunctionInterface[ ReadEasyMesh, $Context ];
imsCreateObsoleteFunctionInterface[ ReadEasyMeshOutput, $Context ];
imsCreateObsoleteFunctionInterface[ BoundaryTriangulation, $Context ];
imsCreateObsoleteFunctionInterface[ Relaxation, $Context ];

imsCreateObsoleteFunctionInterface[ Fig, $Context ];
imsCreateObsoleteFunctionInterface[ Example, $Context ];
imsCreateObsoleteFunctionInterface[ PathToEasyMeshExecutable, $Context ];
imsCreateObsoleteFunctionInterface[ PathToDos4gwExecutable, $Context ];
imsCreateObsoleteFunctionInterface[ StartNodeNumbering, $Context ];


imsMatrixToStream::usage = 
    "imsMatrixToStream[aStream, aMatrix, function]. This writes a Matrix in a stream aStream. The stream aStream must exist no checking is donne. function default to (NumberForm[ #,ExponentFunction\[Rule](Null&)]&)";\


imsRunEasyMesh::usage =
    "imsRunEasyMesh[file, opts...]. This runs EasyMesh with the file file. The file file has to be given as a string.";\


imsReadEasyMesh::usage =
    "imsReadEasyMesh[file, opts...]. Reads three output files generated by EasyMesh. file.n, file.e and file.s. The file file has to be given as a string. The Result is a list of form {nodeNumber,nodes,elementNumber,elements,sideNumber,sides}. nodeNumber contains the number of nodes in node file.n and nodes is the node file.n. Similar for *.e and *.s";\


imsReadEasyMeshOutput::usage = 
    "imsReadEasyMeshOutput[file.TYPE, aTypeList, opts...]. This function is more atomic than imsReadEasyMesh. You can read in the files produced by EasyMesh one by one. You have to give the file name file and its extension TYPE, which is eather .n, .e or .s. The whole file.TYPE must be a string. For file.n the Type List is {Number, Character, Real, Real, Number}. For file.e it is {Number, Character, Number, Number, Number, Number, Number, Number, Number, Number, Number, Real, Real, Number}. And for file.s it is {Number, Character, Number, Number, Number, Number, Number}.";\


(* end documentation *)


(* *)
(* define your options *)
(* *)

imsBoundaryTriangulation::usage = \
"imsBoundaryTriangulation -> False. Is an option of imsRunEasyMesh that creates boundary triangulation only.";\


imsMessage::usage =
    "imsMessage -> False. Is an option of imsRunEasyMesh that does not display any message. No xterm is spawned to run EasyMesh.";\


imsRelaxation::usage =
    "imsRelaxation -> False. Is an option of imsRunEasyMesh that generates a mesh without relaxation.";\


imsLaplacian::usage =
    "imsLaplacian -> False. Is an option of imsRunEasyMesh that generates mesh without Laplacian smoothing.";\


imsDxf::usage =
    "imsDxf -> False. Is an option of imsRunEasyMesh that creates a drawing with Delaunay and Voronoi mesh in in Autodesk.DXF format.";\


imsFig::usage =
    "imsFig -> False. Is an option of imsRunEasyMesh that creates a drwaing with Delaunay and Voronoi mesh in .fig format for xfig.";\


imsExample::usage =
    "imsExample -> False. Is an option of imsRunEasyMesh that creates an example input file example.d";\


imsPathToEasyMeshExecutable::usage =
    "imsPathToEasyMeshExecutable -> easymesh . Is an option of imsRunEasyMesh that specifies where EasyMesh is to be found. You have to give the Path to the binary.";\


imsPathToDos4gwExecutable::usage =
    "imsPathToDos4gwExecutable -> dos4gw. Is an option of imsRunEasyMesh that where Dos4gw is to be found. You have to give the Path to the binary. Only for Dos systems of relevance.";\


imsStartNodeNumbering::usage =
    "imsStartNodeNumbering -> 0. Is an option of imsReadEasyMeshOutput that starts to number the nodes from a given value onwards.";\


(* end define options *)


(* *)
(* create own context: hide local functions and variables *)
(* *)

Begin["`Private`"];

(* *)
(* do we need another package ? *)
(* *)

(* *)
(* default values for options *)
(* *) 
Options[imsRunEasyMesh]={imsBoundaryTriangulation \[Rule] False, 
      imsMessage \[Rule] False, imsRelaxation \[Rule] False, 
      imsLaplacian \[Rule] False, dxf \[Rule] False, fig \[Rule] False, 
      example \[Rule] False, imsPathToEasyMeshExecutable\[Rule]"easymesh", 
      imsPathToDos4gwExecutable\[Rule]"dos4gw" };

Options[imsReadEasyMesh] = {imsStartNodeNumbering \[Rule] 0};

Options[imsReadEasyMeshOutput] = {imsStartNodeNumbering \[Rule] 0};

(* *)
(* functions contained in package start here*)
(* *)

imsMatrixToStream[ aStream_OutputStream, aMatrix_?MatrixQ, 
      form_:(NumberForm[ #,ExponentFunction\[Rule](Null&) ]& ) ]:=
    Do[
      WriteString[aStream,
          (* convert row i to string and take out {, }, and "," *)
          
          StringReplace[
            
            ToString[ form[ aMatrix[[i]] ] ], { "{"\[Rule] "", ","\[Rule]"", 
              "}"\[Rule]""}
            ],
          "\n"];
      ,
      {i, Length[aMatrix]}
      ];

imsRunEasyMesh[inputFile_?StringQ, opts___?OptionQ]:=Module[
      {
        inputFileName, (* names + extension .d *)
        boundaryTri, mess, 
        relax, lap, dx, fi, exam ,(* option variables *)
        
        allOptions, (* that are given to esaymesh *)
        whereisEM, 
        whereisD4
        },
      
      inputFileName=StringJoin[inputFile, ".d"];
      
      (* assemble option list *)
      
      boundaryTri = BoundaryTriangle /. {opts} /. Options[imsRunEasyMesh];
      mess = imsMessage /. {opts} /. Options[imsRunEasyMesh];
      relax = imsRelaxation /. {opts} /. Options[imsRunEasyMesh];
      lap = imsLaplacian /. {opts} /. Options[imsRunEasyMesh];
      dx = imsDxf /. {opts} /. Options[imsRunEasyMesh];
      fi = imsFig /. {opts} /. Options[imsRunEasyMesh];
      exam = imsExample/. {opts} /. Options[imsRunEasyMesh];
      
      (* concatenate path and all options. we need strings *)
      
      whereisEM= 
        ToString[
          imsPathToEasyMeshExecutable/. {opts} /. Options[imsRunEasyMesh] ];
      whereisD4= 
        ToString[
          imsPathToDos4gwExecutable/. {opts} /. Options[imsRunEasyMesh] ];
      
      allOptions="";
      
      If[boundaryTri \[Equal]True, 
        allOptions=StringInsert[allOptions, " -d", -1] ];
      If[mess \[Equal]True, allOptions=StringInsert[allOptions, " -m", -1] ];
      If[relax \[Equal]True, 
        allOptions=StringInsert[allOptions, " -r", -1] ];
      If[lap \[Equal]True, allOptions=StringInsert[allOptions, " -s", -1] ];
      If[dx \[Equal]True, allOptions=StringInsert[allOptions, " +dxf", -1] ];
      If[fi \[Equal]True, allOptions=StringInsert[allOptions, " +fig", -1] ];
      If[exam \[Equal]True, 
        allOptions=StringInsert[allOptions, " +example", -1] ];
      
      Which[
        
        StringMatchQ[ $OperatingSystem,"Windows*"],
        (* we need to start dos4gw with path to esaymesh *)
        (* 
          get imsPathToDos4gwExecutable *)
        Run[
          StringJoin[whereisD4, " ", whereisEM], 
          StringJoin[inputFileName,  allOptions]
          ],
        
        StringMatchQ[ $OperatingSystem,"Unix"]  || 
          StringMatchQ[ $OperatingSystem, "MacOSX" ],
        (* need to  filter for -m option (mess): no sense to start xterm *)
  
              If[mess \[Equal] True,
          (* true: dont start xterm *)
          Run[
              whereisEM, 
              StringJoin[inputFileName,allOptions]
              ];
          ,
          (* false: start xterm *)
          Run[
              StringJoin["xterm -geometry 80x10+20+100 -e ", whereisEM], 
              StringJoin[inputFileName,allOptions]
              ];
          ],
        
        (* else *)
        True,
        Print["I do not know how to handle: ", $OperatingSystem];
        ];
      
      ];

imsReadEasyMesh[aPathToFile_?StringQ ,opts___?OptionQ]:=Module[
      {
        fromNode, (* option for imsReadEasyMeshOutput *)
        numOfNodes, 
        nodes, (* are returned *)
        numOfElements, 
        elements,(* are returned *)
        numOfSides, 
        sides  (* are returned *)
        },
      
      (* get opts *)
      
      fromNode=imsStartNodeNumbering /. {opts} /. Options[imsReadEasyMesh]; 
      
      (* retrieve the result *)
      {numOfNodes, nodes}=
        imsReadEasyMeshOutput[StringJoin[aPathToFile, ".n"],
          {Number, Character, Real, Real, Number}, 
          imsStartNodeNumbering\[Rule]fromNode
          ];
      
      {numOfElements, elements}=
        imsReadEasyMeshOutput[StringJoin[aPathToFile, ".e"],
          {Number, Character, Number, Number, Number, Number, Number, Number, 
            Number, Number, Number, Real, Real, Number}, 
          imsStartNodeNumbering\[Rule]fromNode
          ];
      
      {numOfSides, sides}=
        imsReadEasyMeshOutput[StringJoin[aPathToFile, ".s"],
          {Number, Character, Number, Number, Number, Number, Number}, 
          imsStartNodeNumbering\[Rule]fromNode
          ];
      
      
      Return[{numOfNodes, nodes, numOfElements, elements, numOfSides, 
          sides}];
      ];

imsReadEasyMeshOutput[aPathToFileName_?StringQ,  aTypeList_, opts___?OptionQ]:=
    Module[
      {
        fromNode, (* is an option *)
        
        openStrm, (* open stream of file *)
        
        numOfElements, (* number of Elements is returned *)
        
        newTypeList, (* aTypeList with out "Character" *)
        
        tableOfValues (* is returned *)
        },
      
      (* get opts *)
      
      fromNode=imsStartNodeNumbering /. {opts} /. 
          Options[imsReadEasyMeshOutput]; 
      
      openStrm=OpenRead[aPathToFileName];
      If[openStrm==$Failed, Abort[] ];
      numOfElements=Read[openStrm];
      
      (* read the list with given type list *)
      
      tableOfValues=ReadList[openStrm, aTypeList,numOfElements];
      Close[openStrm];
      
      (* drop the characters (i.e. :) from table of values *)
      (* 
        FIX: different positions for characters *)
      
      tableOfValues=Drop[tableOfValues, {}, {2}];
      
      (* do we need to alter node numbering *)
      If[fromNode != 0,
        (* FIX: different positions for Characters *)
        
        newTypeList=Drop[aTypeList, {2}];
        tableOfValues=
          AlterNodeNumbering[tableOfValues, newTypeList, fromNode];
        ];
      
      Return[{numOfElements, tableOfValues}];
      ];

AlterNodeNumbering[tableOfValues_, aTypeList_, fromNode_]:=Module[
      {
        patternToApply, (* 
          is list (pattern) which will be put over each row in matrix *)
     
           newTable (* is returned *)
        },
      
      (* find the "Number" in aTypeList *)
      
      patternToApply=Position[aTypeList, Number, 1];
      
      (* drop the last "Number": 
          it is a marker and does not need to be incremented *)
      (* 
        all other not to be incremented elements are NOT Numbers *)
      
      patternToApply=Drop[patternToApply,-1];
      
      (* replace the "numbers" with fromNode to create a pattern *)
      
      patternToApply=ReplacePart[aTypeList, fromNode, patternToApply];
      
      (* now find the non "numbers" that need to be replaced *)
      
      n=Position[patternToApply, _Symbol,1 ];
      
      (* drop the first result: it is the function itself? *)
      
      n=Drop[n,1];
      
      (* now we insert 0 to not alter an entry *)
      
      patternToApply=ReplacePart[patternToApply, 0, n];
      
      (* we need to alter elements 1 trough to amount of "Number" type \
elements -1 in aTypeList *)
      
      newTable=MapAt[#+patternToApply&,tableOfValues[[All]], 
          Partition[Range[Length[tableOfValues] ],1] ];
      
      Return[newTable];
      ];


End[]; (* of Begin Private *)

EndPackage[]; (* of BeginPackage *) 