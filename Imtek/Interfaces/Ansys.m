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
(* Title: Ansys.m *)
(* Context: *)
(* Author: Jan Lienemann *)
(* 
  Date: 10.5.2005, Freiburg *)
(* 
  Summary: This package parses ANSYS binary files *)
(* 
  Package Copyright: GNU GPL *)
(* Package Version: 1.0 *)
(* 
  Mathematica Version: 5.11 *)
(* History: *)
(* 
  Keywords: ANSYS binary files *)
(* Sources: *)
(* Warnings: *)
(* 
  Limitations: Is incomplete, and will probably only be extended as needed
    TO DO!
    Test!
    Support for frontal assembly
    Support for constraint equations
    Assembler for the.emat files,interface to ims functions
    Dirichlet boundary conditions
    Other binary file formats
   *)
(* Discussion: *)
(* Requirements: *)
(* Examples: *)
(* *)



(* Disclaimer *)

(* Whereever the GNU GPL is not applicable, 
  the software should be used in the same spirit. *)

(* Users of this code must verify correctness for their application. *)

(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)

(* Disclaimer: *)

(* This package parses ANSYS binary files *)

(* Copyright (C) 2005 jan lienemann *)

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

BeginPackage["Imtek`Interfaces`Ansys`",{"Imtek`BoundaryConditions`"}];





(* *)
(* documentation *)
(* *)

(* constructors *)

(* selectors *)

(* predicates *)

(* functions *)
\
(*imsReadAnsysBinaryFileHeader::usage="imsReadAnsysBinaryFileHeader[InputStream str]";\

  imsReadAnsysFullFileHeader::usage="imsReadAnsysFullFileHeader[InputStream str]";\

  imsReadAnsysFullFileDOFs::usage="imsReadAnsysFullFileDOFs[InputStream str]";\

  imsReadAnsysFullFileNET::usage="imsReadAnsysFullFileNET[InputStream str]";
  imsReadAnsysFullFileMatricesSymbolic::usage="imsReadAnsysFullFileMatricesSymbolic[InputStream str, Integer numberofequations, Integer numberofmatrices, Boolean iscomplex, Boolean isunsymmetric, Boolean lumpedmass]";\

  imsReadAnsysFullFileMatricesFrontal::usage="imsReadAnsysFullFileMatricesFrontal[InputStream str, Integer numberofequations, Integer numberofmatrices, Boolean iscomplex, Boolean isunsymmetric, Boolean lumpedmass]";\

  imsReadAnsysEmatFileHeader::usage="imsReadAnsysEmatFileHeader[InputStream str]";\
*)

imsReadAnsysBinaryFile::usage="imsReadAnsysBinaryFile[String filename] returns the contents of the file as list of rules.";\

imsReadAnsysBinaryFileDescriptions::usage="imsReadAnsysBinaryFileDescriptions[expr] converts the ANSYS variable symbols to human readable descriptive names.";\

imsReadAnsysBinaryFileRecords::usage="imsReadAnsysBinaryFileRecords[String filename, Integer n] returns a list of all records found in the binary file. The optional argument n is the number of records to read.";\

imsAssembleSystemFromAnsys::usage="imsAssembleSystemFromAnsys[List fileRecordsFull, List fileRecordsEmat] creates an imsSystem from the data read from an ANSYS file."

imsInvertAnsysEquivList::usage=""

imsReadAnsysListFile::usage=
  "imsReadAnsysListFile[filename] is a filter to read in a file produced by, e.g., Ansys' NLIST command. It removes all column headings and empty lines."



(* *)
(* options docu *)
(* *)

imsExcludeElements::usage="Elements to exclude from building the matrices. Automagically sets imsGetStiffnessFromFull to False.";\

imsGetStiffnessFromFull::usage="Get stiffness matrix from .full file (otherwise use .emat file)";\

(*imsRemoveDirichlets::usage=
      "Remove Dirichlet degrees of freedoms from matrices";*)

System`imsDisplayStatus::usage="Use ShowStatus to show current process";
imsApplyDirichlets::usage="Apply Dirichlet boundary conditions to system";
imsFullFileMatrices::usage="Extract matrices from full file";
imsNamesFormat::usage="Format of the names vector";



(* *)
(* error messages *)
(* *)

imsReadAnsysBinary::substr="Substructure matrices not supported";
imsReadAnsysBinary::nyi="Sorry, `1` not yet implemented";
imsReadAnsysBinary::parse="Parse error `1` while reading ANSYS file";
imsReadRecord::wrongtype="Wrong record type; `1` expected";



Begin["`Private`"];



(* *)
(* private imports *)
(* *)

Needs["Imtek`Assembler`"]
Needs["Imtek`System`"]
Needs["Imtek`ShowStatus`"]
(*Needs["Imtek`BoundaryConditions`"]*)



(* *)
(* implementation part *)
(* *)

(* constructor *)
(* *)



(* *)
(* define your options *)
(* *)

Options[imsReadAnsysBinaryFileDescriptions]={imsShort\[Rule]True};
Options[imsAssembleSystemFromAnsys]={imsExcludeElements\[Rule]None,
      imsGetStiffnessFromFull\[Rule]True,imsRemoveDirichlets\[Rule]False,
      imsDisplayStatus\[Rule]True,imsApplyDirichlets\[Rule]True,
      imsNamesFormat->"String"};
Options[imsReadAnsysBinaryFile]={imsFullFileMatrices\[Rule]True};



(* selector *)
(* *)



(* predicates *)
(* *)





ReadRecord[s_,type_String,size_Integer]:=
  Block[{len=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1],t},
    If[len\[LessEqual]0,Return[{}]];
    t=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1];
    Return[{len,t,BinaryReadList[s,type,(len-4)/size,ByteOrdering\[Rule]1],
        BinaryRead[s,"Integer32",ByteOrdering\[Rule]1]}]]

ReadRecord[s_]:=
  Block[{len=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1],t},
    If[len\[LessEqual]0,Return[{}]];
    t=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1];
    Return[{len,t,
        BinaryReadList[s,
          If[t\[Equal]0,"Real64","Integer32"],(len-4)/If[t\[Equal]0,8,4],
          ByteOrdering\[Rule]1],
        BinaryRead[s,"Integer32",ByteOrdering\[Rule]1]}]]

ReadRecord[s_,integ:(True|False)]:=
  Block[{len=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1],t},
    If[len\[LessEqual]0,Return[{}]];
    t=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1];
    If[Xor[integ,(t!=0)],
      Message[imsReadRecord::wrongtype,If[integ,"Integer","Real"]]];
    Return[{len,t,
        BinaryReadList[s,
          If[t\[Equal]0,"Real64","Integer32"],(len-4)/If[t\[Equal]0,8,4],
          ByteOrdering\[Rule]1],
        BinaryRead[s,"Integer32",ByteOrdering\[Rule]1]}]]

(* ** for debugging **
        ReadRecord[s_,type_,size_]:=
    Module[{len=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1],t,tmp},
      If[len\[LessEqual]0,Return[{}]];
      t=BinaryRead[s,"Integer32",ByteOrdering\[Rule]1];
      tmp=BinaryReadList[s,type,(len-4)/size,ByteOrdering\[Rule]1];
      Print[tmp];{len,t,tmp,
        BinaryRead[s,"Integer32",ByteOrdering\[Rule]1]}]*)

GetByte[i_,b_]:=BitAnd[255,Developer`BitShiftRight[i,(b-1)*8]]

GetBytes[i_]:=GetByte[i,#]&/@Reverse[Range[4]]

GetChars[i_]:=FromCharacterCode/@GetBytes[i]

StringTrim[s_]:=Module[{IFS={" ","\t","\n"},s2},
    s2=If[(StringLength[s]>0)&&(MemberQ[IFS,StringTake[s,-1]]),
        StringTrim[StringDrop[s,-1]],s];
    Return[
      If[(StringLength[s2]>0)&&(MemberQ[IFS,StringTake[s2,1]]),
        StringTrim[StringDrop[s2,1]],s2]]]

IntsToString[i_List]:=StringTrim[StringJoin[Flatten[GetChars/@i]]]

imsReadAnsysFullFilePossiblyComplex[str_,compl_]:=
    If[compl,Return[ReadRecord[str,"Complex64",8]],
      Return[ReadRecord[str,False]] (*TODO:check*)];

(*removeZeros[l:{Except[_List]...},dof_]:=Module[{nnpos},
      nnpos=Flatten[Position[dof,Except[0],{1},Heads\[Rule]False]];
      {l[[nnpos]],dof[[nnpos]]}
      ]
    removeZeros[l:{__List},dof_]:=Module[{nnpos},
        nnpos=Flatten[Position[dof,Except[0],{1},Heads\[Rule]False]];
        {l[[nnpos,nnpos]],dof[[nnpos]]}
        ]*)

myMakeElementMatrix[m_,
    dof_]:=(*Module[{nzm,nzd},{nzm,nzd}=removeZeros[m,dof];*)
  
  imsMakeElementMatrix[Take[m,Length[dof],Length[dof]], dof, dof ]

myMakeElementMatrix[m_,dof_,keep_]:=
  imsMakeElementMatrix[m[[keep,keep]],dof,dof]

assembleVec[vec_,val_,
      dof_]:=(*Module[{nzval,nzd},{nzval,nzd}=removeZeros[val,dof];*)
    
    vec[[dof]]+=Take[val,Length[dof]];

assembleVec[vec_,val_,dof_,keep_]:=vec[[dof]]+=val[[keep]]

SetAttributes[assembleVec, HoldFirst];

deleteRowsCols[m_,rr_]:=Module[{r=List/@rr},
    (*cond=
        Alternatives@@
          Flatten[{{#}\[Rule]_,{#,_}\[Rule]_,{_,#}\[Rule]_}&/@r,1];
      m=SparseArray[DeleteCases[ArrayRules[m],cond],dim];
      don't know which is better *)
    
    If[TensorRank[m]>1,m=Transpose[Delete[Transpose[Delete[m,r]],r]],
        m=Delete[m,r]];
    ]

zeroRowsCols[m_,rr_]:=
    If[TensorRank[m]>1,m[[All,rr]]=0.;m[[rr,All]]=0.;,m[[rr]]=0.];

SetAttributes[deleteRowsCols,HoldFirst];
SetAttributes[zeroRowsCols,HoldFirst];

imsInvertAnsysEquivList[l_List]:=
  Module[{li=Table[0,{Max[l]}]},MapIndexed[If[#1>0,li[[#1]]=#2[[1]]]&,l];
    Return[li]]



imsReadAnsysBinaryFileHeader[str_]:=Module[{r},
      r=ReadRecord[str,True];
      
      Return[{"fnum"\[Rule]Switch[r[[3,1]],4,"FULL",2,"EMAT",_,r[[3,1]]],
          "fformat"->r[[3,2]],
          "time"->r[[3,3]],
          "date"->r[[3,4]],
          "units"->r[[3,5]],
          "ANSYSrel"->IntsToString[r[[3,{10}]]],
          "ANSYSreldate"->r[[3,11]],
          "machid"->IntsToString[r[[3,{12,13,14}]]],
          "jobname"->IntsToString[r[[3,{15,16}]]],
          "ANSYSpnam"->IntsToString[r[[3,{17,18}]]],
          "ANSYSsverl"->IntsToString[r[[3,{19}]]],
          "user"->IntsToString[r[[3,{20,21,22}]]],
          (*"machid2"->IntsToString[r[[3,{23,24,25}]]], returned bullshit *)
 
                   "sysrec"->r[[3,26]],
          "flenmax"->r[[3,27]],
          "recmax"->r[[3,28]],
          "noproc"->r[[3,29]],
          "title"->IntsToString[r[[3,Range[41,60]]]],
          "subtitle"->IntsToString[r[[3,Range[61,80]]]]}]];



imsReadAnsysFullFileHeader[str_]:=Module[{r0,r,ret,symb},
      r0=ReadRecord[str,True];
      r=r0[[3]];
      If[Abs[r[[1]]]\[NotEqual]4,
        Message[imsReadAnsysBinary::parse,{1,r[[1]]}];Return[$Failed]];
      symb=(r[[1]]<0);
      If[symb,r=Join[r,Table[0,{24-Length[r]}]],
        r=Join[r,Table[0,{39-Length[r]}]]];
      ret={"fun04"->r[[1]],"Assembly"\[Rule]If[symb,"Symbolic","Frontal"],
          "neqn"->r[[2]],
          "nmrow"->r[[3]],
          "nmatrx"->r[[4]],
          "kan"->r[[5]],
          "wfmax"->r[[6]],
          "lenbac"->r[[7]],
          "numdof"->r[[8]],
          (*"Pointer to EOF 1"->r[[9]],
            "Pointer to EOF 2"->r[[10]], obsolete *)
          
          "lumpm"\[Rule](r[[11]]\[Equal]1)};
      
      ret=Join[ret,If[symb,
            {"nmrow2"->r[[12]],
              "ntrmStif"->r[[13]]},
            {"jcgeqn"->r[[12]],
              "jcgtrm"->r[[13]]}]];
      
      ret=Join[ret,
          {"keyuns"->r[[14]]\[Equal]1,
            "extopt"\[Rule]r[[15]],
            "keyse"\[Rule](r[[16]]\[Equal]1),
            "sclstf"->r[[17]],
            "nxrows"\[Rule]r[[18]]}];
      
      ret=Join[ret,If[symb,
            {"ptrSTFl"\[Rule]r[[19]],"ptrSTFl"\[Rule]r[[20]],
              "ncefull"\[Rule]r[[21]],"ptrENDl"\[Rule]r[[23]],
              "ptrENDh"\[Rule]r[[24]],"ptrIRHSl"\[Rule]r[[25]],
              "ptrIRHSh"\[Rule]r[[26]],"ptrMASl"\[Rule]r[[27]],
              "ptrMASh"\[Rule]r[[28]],"ptrDMPl"\[Rule]r[[29]],
              "ptrDMPl"\[Rule]r[[30]],"ptrCEl"\[Rule]r[[31]],
              "ptrCEh"\[Rule]r[[32]],
              "nNodes"\[Rule]r[[33]],
              "ntrmMass"\[Rule]r[[34]],
              "ntrmDamp"\[Rule]r[[34]],
              "ptrDOFl"\[Rule]r[[35]],"ptrDOFh"\[Rule]r[[36]],
              "ptrRHSl"\[Rule]r[[37]],"ptrRHSh"\[Rule]r[[38]]},
            {"ptrIDXl"\[Rule]r[[19]],"ptrIDXh"\[Rule]r[[20]],
              "ncefull"\[Rule]r[[21]],
              "ncetrm"\[Rule]r[[22]],
              "ptrENDl"\[Rule]r[[23]],"ptrENDh"\[Rule]r[[24]]}]];
      
      r=ReadRecord[str,True];
      AppendTo[ret,"DOF"\[Rule]r[[3]]];
      r=ReadRecord[str,True];
      AppendTo[ret,"BAC"\[Rule]r[[3]]];
      
      Return[ret]
      ];



imsReadAnsysFullFilePossiblyComplex[str_,compl_]:=If[compl,
      Return[ReadRecord[str,"Complex64",8]],
      Return[ReadRecord[str,False]] (* TODO: check *)
      ];

imsReadAnsysFullFileMatrixSymbolic[str_,compl_,keyuns_,nontp_,True]:=
  Module[{rows,r,col,m},
    m=Flatten[Table[
          rows=ReadRecord[str,True][[3]];
          r=imsReadAnsysFullFilePossiblyComplex[str,compl][[3]];
          Join[Transpose[{rows,Table[col,{Length[rows]}],r}],
            
            If[Not[keyuns],
              Drop[Transpose[{Table[col,{Length[rows]}],rows,r}],-1],{}]],
          {col,nontp}],1];
    
    Return[m[[All,{1,2}]]\[Rule]m[[All,3]]];
    ]

imsReadAnsysFullFileMatrixSymbolic[str_,compl_,keyuns_,nontp_,False]:=
  
  With[{},
    Do[
      ReadRecord[str,True];
      imsReadAnsysFullFilePossiblyComplex[str,compl];,
      {nontp}];
    Return[{}]
    ]

imsReadAnsysFullFileMatricesSymbolic[str_,nontp_,nomats_,compl_,keyuns_,
    lumpm_,ffMat_]:=Block[{mm={},dm={},sm={},f,fimg,r,rows,rules={},m0},
    
    (************* Stiffness matrix *************)
    
    sm=imsReadAnsysFullFileMatrixSymbolic[str,compl,keyuns,nontp,ffMat];
    
    (************* Load vector ******************)
    
    f=imsReadAnsysFullFilePossiblyComplex[str,compl][[3]];
    
    If[compl,fimg=
        ReadRecord[str,False][[3]]]; (* 
      TODO: when does this vector appear? *)
    
    AppendTo[rules,"nextvec"->ReadRecord[str,True][[3]]];
    AppendTo[rules,"dofvec"->ReadRecord[str,True][[3]]];
    AppendTo[rules,"dofimp"->ReadRecord[str,True][[3]]];
    AppendTo[rules,
      "impval"->imsReadAnsysFullFilePossiblyComplex[str,compl][[3]]];
    
    (* Mass matrix *)
    If[nomats>1,
      mm=If[lumpm,
          
          MapIndexed[({#2[[1]],#2[[1]]}\[Rule]#1)&,
            imsReadAnsysFullFilePossiblyComplex[str,compl][[3]]],
          imsReadAnsysFullFileMatrixSymbolic[str,compl,keyuns,nontp,ffMat]
          ]];
    
    (* Damping matrix *)
    If[nomats>2,
      dm=imsReadAnsysFullFileMatrixSymbolic[str,compl,keyuns,nontp,ffMat]
      ];
    
    (* ..... TODO: G matrix *)
    
    Return[Join[{"mmat"->SparseArray[mm,{nontp,nontp}],
          "dmat"->SparseArray[dm,{nontp,nontp}],
          "stmat"->SparseArray[sm,{nontp,nontp}],"lvec"->f},rules]]
    ]







imsReadAnsysFullFileMatricesFrontal[str_,nmrow_,nomats_,compl_,keyuns_,
    lumpm_]:=Module[{mm={},sm={},dm={},f={},rows,r,flm},
    (*
      Do[
        rows=ReadRecord[str,True][[3]];
        ReadRecord[str,True][[3]]; (* 
          second level of indexing for the matrix. 
              I don't know what this is *)
        
        flm=
          imsReadAnsysFullFileMatrixFrontalPart[sm,str,col,rows,compl,keyuns,
            True];
        AppendTo[f,flm[[1]]];
        If[lumpm,AppendTo[mm,{col,col}\[Rule]flm[[2]]]];
        
        (************* Mass matrix *************)
        (* 
          not sure what happens for lumped mass matrix... *)
        
        If[nomats>1,
          
          msReadAnsysFullFileMatrixFrontalPart[mm,str,rows,col,compl,keyuns,
              False];
          ];
        
        (************* Damping matrix *************)
        If[nomats>2,
          
          msReadAnsysFullFileMatrixFrontalPart[dm,str,rows,col,compl,keyuns,
              False];
          ];
        
        ,{col,nmrow}];
      
      Return[{"mmat"->SparseArray[mm,{nmrow,nmrow}],
          "dmat"->SparseArray[dm,{nmrow,nmrow}],
          "stmat"->SparseArray[sm,{nmrow,nmrow}],"lvec"->f}]
      *)
    Message[imsReadAnsysBinary::nyi,"frontal assembly"];
    Return[$Failed]
    ]



imsReadAnsysEmatFileHeader[str_]:=Module[{r,ret},
      r=ReadRecord[str,True];
      ret={"fun02"->r[[3,1]],"nume"->r[[3,2]],
          "numdof"->r[[3,3]],
          "lenu"->r[[3,4]],
          "lenbac"->r[[3,5]],
          "maxn"->r[[3,6]],
          "nodref"\[Rule]r[[3,9]],
          "lumpm"\[Rule](r[[3,10]]\[Equal]1),
          "kygst"\[Rule](r[[3,11]]\[Equal]1),
          "kygm"\[Rule](r[[3,12]]\[Equal]1),
          "kygd"\[Rule](r[[3,13]]\[Equal]1),
          "kygss"\[Rule](r[[3,14]]\[Equal]1),
          "kygaf"\[Rule](r[[3,15]]\[Equal]1),
          "kygrf"\[Rule](r[[3,16]]\[Equal]1),
          "numCE"\[Rule]r[[3,27]],
          "maxLeng"\[Rule]r[[3,28]],
          "ptrCEl"\[Rule]r[[3,29]],"ptrCEh"\[Rule]r[[3,30]],
          "ptrDOF"\[Rule]r[[3,31]],
          "ptrBAC"\[Rule]r[[3,32]],
          "ptrELM"\[Rule]r[[3,33]],
          "ptrFST"\[Rule]r[[3,34]],
          "ptrLST"\[Rule]r[[3,35]],
          "ptrEHD"\[Rule]r[[3,37]],
          "ptrIDX"\[Rule]r[[3,38]],
          "ptrendH"\[Rule]r[[3,39]],
          "ptrendL"\[Rule]r[[3,40]]
          };
      
      r=ReadRecord[str,False];
      ret=Join[ret,{"timval"\[Rule]r[[3,1]],
            "timinc"\[Rule]r[[3,2]],
            "frqval"\[Rule]r[[3,3]],
            "timbeg"\[Rule]r[[3,4]],
            "timend"\[Rule]r[[3,5]]}];
      r=ReadRecord[str,True];
      AppendTo[ret,"DOF"\[Rule]r[[3]]];
      r=ReadRecord[str,True];
      AppendTo[ret,"BAC"\[Rule]r[[3]]];
      r=ReadRecord[str,True];
      AppendTo[ret,"ELM"\[Rule]r[[3]]];
      r=ReadRecord[str,True];
      AppendTo[ret,"FST"\[Rule]r[[3]]];
      r=ReadRecord[str,True];
      AppendTo[ret,"LST"\[Rule]r[[3]]];
      r=ReadRecord[str,True];
      AppendTo[ret,"IDX"\[Rule]r[[3]]];
      Return[ret];
      ];



imsReadAnsysEmatFileMatrix[str_,nmrow_]:=Block[{r,m},
    r=ReadRecord[str,False][[3]];
    If[Length[r]\[Equal]nmrow, (* Diagonal *)
      
      Return[DiagonalMatrix[r]],
      If[Length[r]\[Equal]nmrow*(nmrow+1)/2, (* Symmetric *)
        
        m=Table[Join[Take[r,{1+(n^2-n)/2,(n^2+n)/2}],Table[0,{nmrow-n}]],{n,
              nmrow}];
        Return[m+Transpose[m]-Tr[m,DiagonalMatrix[List[##]]&]],
        If[Length[r]\[Equal]nmrow*nmrow,(* Full *)
          
          Return[Transpose[Partition[r,nmrow]]] (* 
            I'm not sure about that... *),
          Message[imsReadAnsysBinary::parse,{2,r,nmrow}];Return[$Failed]
          ]
        ]
      ]
    ]

imsReadAnsysEmatFileMatrices[str_,nume_]:=
  Block[{r,m,stkey,mkey,dkey,sskey,akey,nrkey,ikey,nmrow},
    
    Return[
      Table[
        r=ReadRecord[str,True];
        m={"stkey"\[Rule](stkey=(r[[3,1]])\[NotEqual]0),
            "mkey"\[Rule](mkey=(r[[3,2]]\[NotEqual]0)),
            "dkey"\[Rule](dkey=(r[[3,3]]\[NotEqual]0)),
            "sskey"\[Rule](sskey=(r[[3,4]]\[NotEqual]0)),
            "akey"\[Rule](akey=(r[[3,5]]\[NotEqual]0)),
            "nrkey"\[Rule](nrkey=(r[[3,6]]\[NotEqual]0)),
            "ikey"\[Rule](ikey=(r[[3,7]]\[NotEqual]0)),
            "nmrow"\[Rule](nmrow=Abs[r[[3,10]]]),
            "lowtri"\[Rule](r[[3,10]]<0),
            "dofidx"->ReadRecord[str,True][[3]]
            };
        If[stkey,
          AppendTo[m,"stmat"\[Rule]imsReadAnsysEmatFileMatrix[str,nmrow]],
          AppendTo[m,"stmat"\[Rule]{}]];
        If[mkey,
          AppendTo[m,"mmat"\[Rule]imsReadAnsysEmatFileMatrix[str,nmrow]],
          AppendTo[m,"mmat"\[Rule]{}]];
        If[dkey,
          AppendTo[m,"dmat"\[Rule]imsReadAnsysEmatFileMatrix[str,nmrow]],
          AppendTo[m,"dmat"\[Rule]{}]];
        If[sskey,
          AppendTo[m,"ssmat"\[Rule]imsReadAnsysEmatFileMatrix[str,nmrow]],
          AppendTo[m,"ssmat"\[Rule]{}]];
        
        r=ReadRecord[str,False];
        If[akey,AppendTo[m,"lvec"\[Rule]Take[r[[3]],nmrow]],
          AppendTo[m,"lvec"\[Rule]{}]];
        If[nrkey,AppendTo[m,"nrvec"\[Rule]Take[r[[3]],-nmrow]],
          AppendTo[m,"nrvec"\[Rule]{}]];
        If[ikey,AppendTo[m,"ilvec"\[Rule]Take[r[[3]],-nmrow]],
          AppendTo[m,"ilvec"\[Rule]{}]];
        m,{nume}]] (* Internal CE stuff is missing, 
      but probably makes no sense anyways *)
    ]





imsReadAnsysBinaryFileDescriptionsDOFs[n:(_List|_Integer)]:={
        "UX","UY","UZ","ROTX","ROTY",
        "ROTZ","AX","AY","AZ","VX",
        "VY","VZ",0,0,0,
        0,0,0,"PRES","TEMP",
        "VOLT","MAG","ENKE","ENDS","EMF",
        "CURR",0,0,0,0,0,0}[[n/.{0\[Rule]30}]];
imsReadAnsysBinaryFileDescriptionsTime[d_Integer]:=
  Module[{s=ToString[d]},
    StringDrop[s,-4]<>":"<>StringTake[s,{-4,-3}]<>":"<>StringTake[s,-2]]

imsReadAnsysBinaryFileDescriptions[expr_,opts___]:=Module[{short},
    short[x_]:=
      If[imsShort/.{opts}/.Options[imsReadAnsysBinaryFileDescriptions],
        Short[x],x];
    expr/.Join[{
          
          (**** Header ****)
          ("fnum"\[Rule]
                n_)\[Rule]("file number"\[Rule]
                Switch[n,4,"FULL",2,"EMAT",_,n]),
          "fformat"->"file format",
          ("time"\[Rule]s_)\[Rule]("time"\[Rule]
                imsReadAnsysBinaryFileDescriptionsTime[s]),("date"\[Rule]
                s_)\[Rule]("date"\[Rule]
                imsReadAnsysBinaryFileDescriptionsTime[s]),
          ("units"\[Rule]n_)\[Rule]("units of measurement"\[Rule]
                Switch[n,0,"User",1,"SI",2,"CSG",3,"Feet",4,"Inches",_,n]),
          "ANSYSrel"->"ANSYS release","ANSYSreldate"->"ANSYS release date",
          "machid"->"machine identifier","jobname"->"jobname","ANSYSpnam"->"ANSYS product name",
          "ANSYSsverl"->"ANSYS special version label","user"->"username",
          "machid2"->"machine identifier2","sysrec"->"system record size",
          "flenmax"->"max file length","recmax"->"max record Nr","noproc"->"# processors",
          "title"->"main analysis title","subtitle"->"first subtitle",
          
          (**** Full file ****)
          "fun04"->"unit number","neqn"->"number of equations on file",
          "nmrow"->"number of rows in matrices","nmatrx"->"number of matrices on file",
          "kan"->"analysis type","wfmax"->"maximum wavefront","lenbac"->"number of nodes",
          "numdof"->"number of dofs per node","ptrEND"->"pointer to end of file (obsolete)",
          "lumpm"->"lumped mass key","jcgeqn"->"number of jcg equations",
          "jcgtrm"->"number of coefficients in sparse jcg storage",
          "keyuns"->"unsymmetric key",
          ("extopt"\[Rule]n_)\[Rule]("mode extraction method"\[Rule]
                Switch[n,0,"reduced",1,"lumped",3,"unsymmetric Lanczos",4,"damped Lanczos",
                  6,"block Lanczos",_,n]),
          "keyse"->"superelement key","sclstf"->"scale factor for matrices",
          "nxrows"->"maximum rank for this solution",
          "ptrIDXl"->"pointer to matrix row indices low",
          "ptrIDXl"->"pointer to matrix row indices high","ncefull"->"Number of constraint equations CE+CP on full file",
          "ncetrm"->"Total number of terms in constraint equations",
          "ptrENDl"->"pointer to end of file low","ptrENDh"->"pointer to end of file high",
          "nmrow2"->"Number of rows in matrices 2","ntrmStif"->"number of terms in K matrix",
          "ptrSTFl"->"pointer to Stiffness matrix low",
          "ptrSTFh"->"pointer to Stiffness matrix high",
          "ptrIRHSl"->"pointer to imaginary RHS (F) low",
          "ptrIRHSh"->"pointer to imaginary RHS (F) high",
          "ptrMASl"->"pointer to Mass matrix low",
          "ptrMASh"->"pointer to Mass matrix high",
          "ptrDMPl"->"pointer to Damping matrix low",
          "ptrDMPh"->"pointer to Damping matrix high",
          "ptrCEl"->"pointer to Gt and g matrices/int. CE list low",
          "ptrCEh"->"pointer to Gt and g matrices/int. CE list high",
          "nNodes"->"number of internal Nodes",
          "ntrmMass"->"number of terms in Mass matrix",
          "ntrmDamp"->"number of terms in Damping matrix",
          "ptrDOFl"->"pointer to DOF info low",
          "ptrDOFh"->"pointer to DOF info high",
          "ptrRHSl"->"pointer to RHS (F) low",
          "ptrRHSh"->"pointer to RHS (F) high",
          ("DOF"\[Rule]n_)\[Rule]("degrees of freedom per node"\[Rule]\
imsReadAnsysBinaryFileDescriptionsDOFs[n]),
          
          (**** Emat file ****)
          "fun02"\[Rule]"unit number",
          "nume"\[Rule]"number of elements","lenu"\[Rule]"total DOFs of model",
          "maxn"\[Rule]"maximum node number","nodref"\[Rule]"actual number of nodes referenced",
          "kygst"\[Rule]"global stiffness matrix calculate key","kygm"\[Rule]"global mass matrix calculate key",
          "kygd"\[Rule]"global damping matrix calculate key","kygss"\[Rule]"global stress stiffening matrix calculate key",
          "kygaf"\[Rule]"global applied force vector calculate key",
          "kygrf"\[Rule]"global restoring force vector calculate key",
          "numCE"\[Rule]"number of internal CEs","maxLeng"\[Rule]"maximum length of any internal CE",
          "ptrDOF"\[Rule]"pointer to degrees of freedom per node used in model",
          "ptrBAC"\[Rule]"pointer to nodal equivalence table","ptrELM"\[Rule]"pointer to element equivalence table",
          "ptrFST"\[Rule]"pointer to first element at a DOF table",
          "ptrLST"\[Rule]"pointer to last element at a DOF table",
          "ptrEHD"\[Rule]"pointer to the start of the element matrices",
          "ptrIDX"\[Rule]"pointer to element matrices index table",
          "ptrendH"\[Rule]"pointer to end of file high",
          "ptrendL"\[Rule]"pointer to end of file low", "ELM"->"Element equivalence table",
          "FST"->"First element at DOF table","LST"->"Last element at DOF table",
          "IDX"->"Element index table","stkey"\[Rule]"stiffness matrix key",
          "mkey"\[Rule]"mass matrix key",
          "dkey"\[Rule]"damping matrix key",
          "sskey"\[Rule]"stress stiffening matrix key",
          "akey"\[Rule]"applied load vector key",
          "nrkey"\[Rule]"newton-raphson load vector key",
          "ikey"\[Rule]"imaginary load vector key",
          "nmrow"\[Rule]"numbers/columns in matrices",
          "dofidx"->"DOF index table","timval"->"current time","timinc"->"time increment",
          "frqval"->"current frequency","timbeg"->"start time for the analysis",
          "timend"->"end time for the analysis",
          "lowtri"\[Rule]"lower triangular form"
          },
        Map[((#[[1]]\[Rule]n_)\[Rule](#[[2]]\[Rule]short[n]))&,{{"BAC",
              "nodal equivalence table"},{"nextvec",
              "Number of DOFs at nodes"},{"dofvec","DOF vector"},{"dofimp",
              "DOFs with imposed value"},{"impval","Imposed values"},{"stmat",
              "stiffness matrix"},{"dmat","damping matrix"},{"mmat",
              "mass matrix"},{"lvec","load vector"},{"ssmat",
              "stress stiffening matrix"},{"nrvec",
              "newton-raphson load vector"},{"ilvec",
              "imaginary load vector"}}]]]



imsReadAnsysBinaryFile[filename_,opts___]:=
  Block[{str=OpenRead[filename,BinaryFormat->True],ftype,header,fheader,
      fdata={},ffMat},
    
    ffMat=imsFullFileMatrices/.{opts}/.Options[imsReadAnsysBinaryFile];
    header=imsReadAnsysBinaryFileHeader[str];
    ftype="fnum"/.header;
    Switch[ftype,"FULL",
      
      (********** Full file ************) 
      fheader=imsReadAnsysFullFileHeader[str];
      fdata=
        If[("Assembly"/.fheader)=="Symbolic",
          imsReadAnsysFullFileMatricesSymbolic[str,"neqn"/.fheader,
            "nmatrx"/.fheader,("kan"/.fheader)\[Equal]3,"keyuns"/.fheader,
            "lumpm"/.fheader,ffMat],
          imsReadAnsysFullFileMatricesFrontal[str,"neqn"/.fheader,
            "nmatrx"/.fheader,("kan"/.fheader)\[Equal]3,"keyuns"/.fheader,
            "lumpm"/.fheader]];,
      "EMAT",
      
      (********** Emat file ************) 
      fheader=imsReadAnsysEmatFileHeader[str];
      fdata=imsReadAnsysEmatFileMatrices[str,"nume"/.fheader];
      ];
    
    Close[str];
    Return[{header,fheader,fdata}]
    ]







imsReadAnsysBinaryFileRecords[filename_]:=
  Module[{str=OpenRead[filename,BinaryFormat->True],a,l={}},
    While[(a=ReadRecord[str])\[NotEqual]{},AppendTo[l,a];];
    Close[str];
    Return[l];
    ]

imsReadAnsysBinaryFileRecords[filename_,nn_]:=
  Module[{n=nn,str=OpenRead[filename,BinaryFormat\[Rule]True],a,l={}},
    While[(a=ReadRecord[str])\[NotEqual]{}&&(n--)>0,AppendTo[l,a];];
    Close[str];
    Return[l];]



imsAssembleSystemFromAnsys[fulls_List,emat_List,opts___]:=Module[
    {totalDOF,nfulls,dlist,actdof2dof,dof2actdof,nactdof,stmat,mmat,dmat,
      ssmat,nrvec,ilvec,lvec0,lvecm,bac,DOFnames,names,lvec,dofidx,i,xelem,
      xelemlist,nxelemlist,kfromf,removeDBC,applyDBC,dnodes,ldnodes,dvalues,
      stmatignored,myDisplayStatus,j,k,STAT,rowcommand,DBCremoved2actdof,
      nformat,deleteRowsCols},
    
    (* Parse options *)
    {xelem,kfromf,removeDBC,applyDBC,myDisplayStatus,
        nformat}={imsExcludeElements,imsGetStiffnessFromFull,
              imsRemoveDirichlets,imsApplyDirichlets,imsDisplayStatus,
              imsNamesFormat}/.{opts}/.Options[
            imsAssembleSystemFromAnsys]/.None\[Rule]{};
    If[myDisplayStatus, STAT[s_]:=imsShowStatus[s],STAT[s_]:=Null];
    
    STAT["Preparing matrices and vectors..."];
    
    (* Convert element number to element index *)
    If[xelem=!={},
      kfromf=False;
      xelem=imsInvertAnsysEquivList["ELM"/.emat[[2]]][[xelem]];
      ];
    
    totalDOF="lenu"/.emat[[2]]; (* 
      Number of total dofs = dofspernode * numbernodes *)
    
    nfulls=Length[fulls];                 (* Number of .full files *)
    
    (* Non-activated DOFs (e.g., for nodes without VOLT dof *)
    
    dlist=Flatten[Position["LST"/.emat[[2]],0,{1}]];   
    (* Convert active DOF index to original DOF number (with non-
            reordered DOFs as in the BAC list) *)
    
    actdof2dof=Delete[Range[totalDOF],Transpose[{dlist}]];
    (* Complement: Convert original DOF number to active DOF index *)
    
    dof2actdof=imsInvertAnsysEquivList[actdof2dof];
    (* Number of active DOFs *)
    nactdof=Length[actdof2dof];
    
    (* Initialize matrices *)
    
    mmat=dmat=ssmat=stmatignored=SparseArray[{},{nactdof,nactdof}];
    nrvec=ilvec=SparseArray[{},{nactdof}];
    lvec0=Table[0.,{nactdof}];
    
    bac="BAC"/.emat[[2]];                (* Sorting of node numbers *)
    
    DOFnames=imsReadAnsysBinaryFileDescriptionsDOFs["DOF"/.fulls[[1,2]]];
    names=Switch[nformat,
        "Numeric",
        Flatten[
            Table[dummyHead[bac[[i]],#]&/@("DOF"/.fulls[[1,2]]),{i,
                Length[bac]}],1][[actdof2dof]],
        _, (* String *)
        
        Flatten[Table[("Node_"<>ToString[bac[[i]]]<>"_"<>#)&/@DOFnames,{i,
                Length[bac]}],1][[actdof2dof]]];
    
    lvec= "lvec"/.fulls[[All,3]]; (* Get load vectors from full files *)
    
    (* If kfromf, get K matrix from first full file *)
    
    If[kfromf,STAT["Extracting stmat..."];
      stmat="stmat"/.fulls[[1,3]],
      stmat=SparseArray[{},{nactdof,nactdof}]];
    
    (* Assemble matrices from elem file *)
    j=0; 
    k=Length[emat[[3]]]-Length[xelem];
    
    (* The elements which should not be ignored plus the transformed (BAC-1) \
dofidx plus the non-null positions in dofidx *)
    
    nxelemlist={dof2actdof[[Cases["dofidx"/.#,Except[0],Heads\[Rule]False]]],
            Flatten[Position["dofidx"/.#,Except[0],{1},
                Heads\[Rule]False]],#}&/@
        If[xelem==={},emat[[3]],
          emat[[3,Complement[Range[Length[emat[[3]]]],xelem]]]]; (* 
      seems Complement is faster than Delete[...] *)
    
    (* The elements which should be ignored plus the transformed (BAC-1) \
dofidx plus the non-null positions in dofidx *)
    If[xelem=!={},
      xelemlist={dof2actdof[[Cases["dofidx"/.#,Except[0],Heads\[Rule]False]]],
              Flatten[Position["dofidx"/.#,Except[0],{1},
                  Heads\[Rule]False]],#}&/@emat[[3,xelem]];
      STAT["Assembling stmatignored"];
      imsAssemble[
        myMakeElementMatrix["stmat"/.#[[3]],#[[1]],#[[2]]]&/@
          Select[xelemlist,("stkey"/.#[[3]])&],stmatignored];
      ];
    (*Print[MaxMemoryUsed[]/1024.^2];*)
    
    If[Not[kfromf],STAT["Assembling stmat"];
      imsAssemble[
        myMakeElementMatrix["stmat"/.#[[3]],#[[1]],#[[2]]]&/@
          Select[nxelemlist,("stkey"/.#[[3]])&],stmat];
      ];
    (*Print[MaxMemoryUsed[]/1024.^2];*)
    STAT["Assembling mmat"];
    imsAssemble[
      myMakeElementMatrix["mmat"/.#[[3]],#[[1]],#[[2]]]&/@
        Select[nxelemlist,("mkey"/.#[[3]])&],mmat];
    (*Print[MaxMemoryUsed[]/1024.^2];*)
     STAT["Assembling dmat"];
    imsAssemble[
      myMakeElementMatrix["dmat"/.#[[3]],#[[1]],#[[2]]]&/@
        Select[nxelemlist,("dkey"/.#[[3]])&],dmat];
    (*Print[MaxMemoryUsed[]/1024.^2];*)
    STAT["Assembling ssmat"];
    imsAssemble[
      myMakeElementMatrix["ssmat"/.#[[3]],#[[1]],#[[2]]]&/@
        Select[nxelemlist,("sskey"/.#[[3]])&],ssmat];
    STAT["Assembling lvec"];
    (lvec0[[#[[1]]]]+=("lvec"/.#[[3]])[[#[[2]]]])&/@
      Select[nxelemlist,("akey"/.#[[3]])&];
    STAT["Assembling nrvec"];
    (nrvec[[#[[1]]]]+=("nrvec"/.#[[3]])[[#[[2]]]])&/@
      Select[nxelemlist,("nrkey"/.#[[3]])&];
    STAT["Assembling ilvec"];
    (ilvec[[#[[1]]]]+=("ilvec"/.#[[3]])[[#[[2]]]])&/@
      Select[nxelemlist,("ikey"/.#[[3]])&];
    DBCremoved2actdof=Range[nactdof];
    
    (*Print[MaxMemoryUsed[]/1024.^2];*)
    If[applyDBC,
      (* Apply boundary conditions to stmat *)
      
      STAT["Applying Dirichlet BCs to stmat"];
      dnodes=
        Flatten[Position["dofimp"/.fulls[[1,3]],Except[0],{1},
            Heads\[Rule]False]];
      dvalues="impval"/.fulls[[1,3]];
      
      imsDirichlet[ { stmat, lvec0}, dnodes, dvalues, 1.,
        imsRemoveDirichlets\[Rule]removeDBC ];
      
      (* Remove spurious load vector entries from ignored elements *)
      
      If[xelem=!={},
        lvecm=Table[0.,{Length[lvec[[1]]]}];
        imsDirichlet[ { stmatignored, lvecm}, dnodes, dvalues ];
        lvecm[[dnodes]]=0.;
        lvec=(#-lvecm)&/@lvec;
        ];
      
      (* Apply Dirichlet to other matrices *)
      (*Print[
            MaxMemoryUsed[]/1024.^2];*)
      
      STAT["Applying Dirichlet to other matrices"];
      ldnodes=List/@dnodes;
      If[removeDBC,
        lvec=Transpose[Delete[Transpose[lvec],ldnodes]];
        names=Delete[names,ldnodes];
        mmat=Transpose[Delete[Transpose[Delete[mmat,ldnodes]],ldnodes]];
        dmat=Transpose[Delete[Transpose[Delete[dmat,ldnodes]],ldnodes]];
        ssmat=Transpose[Delete[Transpose[Delete[ssmat,ldnodes]],ldnodes]];
        nrvec=Delete[nrvec,ldnodes];
        ilvec=Delete[ilvec,ldnodes];
        DBCremoved2actdof=Delete[DBCremoved2actdof,ldnodes];,
        
        (* not removeDBC *)
        lvec[[All,dnodes]]=0.;
        mmat[[All,dnodes]]=0.;mmat[[dnodes,All]]=0.;
        dmat[[All,dnodes]]=0.;dmat[[dnodes,All]]=0.;
        nrvec[[dnodes]]=0.;
        ilvec[[dnodes]]=0.;
        DBCremoved2actdof[[dnodes]]=0.;];
      
      AppendTo[lvec,lvec0];,
      dnodes=dvalues={};
      ];
    
    imsClearStatus[];
    (*Print[MaxMemoryUsed[]/1024.^2];
      Print["-----"];*)
    Return[{
        If["kygm"/.emat[[2]],
          imsMakeSystem[ 
            Transpose[lvec], { SparseArray[stmat] }, { SparseArray[dmat] }, { 
              SparseArray[mmat] } ],
          
          If["kygd"/.emat[[2]],
            imsMakeSystem[ 
              Transpose[lvec], { 
                SparseArray[stmat] }, {SparseArray[dmat]  } ],
            imsMakeSystem[ Transpose[lvec], { SparseArray[stmat] } ]]],
        Transpose[{dnodes,dvalues}],List@@@names,
        ssmat,nrvec,ilvec,actdof2dof,dof2actdof,dlist,DBCremoved2actdof}
      ]
    ]




imsReadAnsysListFile[filename_String]:=
  Flatten[
        ToExpression[
          If[ Head[ # ] === String, 
                
                ToExpression[ 
                      StringReplace[ #, "E" \[RuleDelayed] "* 10^" ] ]& /@ 
                  StringSplit[ 
                    StringInsert[ #, " ",
                      Union[ Flatten[ StringPosition[ #, "E" ] ] ]+4 ], 
                    " "], #
                 ]&/@#
          ]
        ]&/@Cases[Import[filename,"Table"],{_Integer,rest___}]



(* representors *)
(* *)



(* Begin Private *)
End[];



(* Protect[] *)
EndPackage[] ;
