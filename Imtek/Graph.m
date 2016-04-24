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
(* Title: Graph.m *)
(* Context: *)
(* Author:oliver ruebenkoenig *)
(* 
  Date: 13.3.2006,IMTEK, Freiburg *)
(* 
  Summary: This is the IMTEK graph a mathematica packages *)
(* 
  Package Copyright: GNU GPL *)
(* Package Version: 0.3.6 *)
(* 
  Mathematica Version: 5.2 *)
(* History:
  ;
  for mma6.0 - swaped imsDrawElementText definitions, 
  that _imsNexus is scanned first;
  rename: imsSetNodesCoords \[Rule] imsSetNexusCoords;
  extended imsDrawNodeText to 1D element;
  added imsSetNodesCoords (christian moosmann);
  Fixed bug: imsGetNodes did not return a sorted list; it does now;
  Added, imsGetBoundaryElements, imsGetBoundaryElementIds;
  Added, imsDrawElementText and imsDrawNodeText;
  Made name change, from MakeGraph to MakeNexus;
  Default Sequence is now Sequence[1];
  Public export of symbol Graph;
  Changed the publicly loaded context;
  In Version 0.2 the internal data has changed i.e. 
      moved away from Dispatch[] to direct element access. 
      For performance reasons. *)
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

(* This is the IMTEK graph a mathematica packages *)

(* Copyright (C) 2002-2005 oliver ruebenkoenig *)

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
BeginPackage["Imtek`Graph`", { "Imtek`Nodes`" } ];





(* *)
(* documentation *)
(* *)
Needs["Imtek`Maintenance`"]
imsCreateObsoleteFunctionInterface[ MakeNexus, $Context ];
imsCreateObsoleteFunctionInterface[ Nexus, $Context ];
imsCreateObsoleteFunctionInterface[ GetBoundaryNodes, $Context ];
imsCreateObsoleteFunctionInterface[ GetInteriorNodes, $Context ];
imsCreateObsoleteFunctionInterface[ GetNodes, $Context ];
imsCreateObsoleteFunctionInterface[ GetElements, $Context ];
imsCreateObsoleteFunctionInterface[ GetIncidentsIds, $Context ];
(* imsCreateObsoleteFunctionInterface[ GetIds, $Context ]; *)

imsCreateObsoleteFunctionInterface[ To3DNexus, $Context ];
imsCreateObsoleteFunctionInterface[ NodePoints, $Context ];
imsCreateObsoleteFunctionInterface[ NodeValueTexts, $Context ];
imsCreateObsoleteFunctionInterface[ DrawElements, $Context ];
imsCreateObsoleteFunctionInterface[ DrawElementIdText, $Context ];
imsCreateObsoleteFunctionInterface[ DrawElementSolution, $Context ];

(* constructors *)
imsMakeNexus::usage = 
  "imsMakeNexus[ { boundaryNodes..},{ interiorNodes..}, { NexusElements.. } ] returns a imsNexus made up from imsNode list and NexusElement list."
\

imsNexus::usage = 
  "imsNexus is the data structure returned by imsMakeNexus."

(* selectors *)
imsGetBoundaryNodes::usage=
  "imsGetBoundaryNodes[ imsNexus ] returns the List of boundary nodes from imsNexus."
\

imsGetInteriorNodes::usage=
  "imsGetInteriorNodes[ imsNexus ] returns the List of interior nodes from imsNexus."
\

imsGetNodes::usage="imsGetNodes[ imsNexus, { nodeIds } ] returns the List of nodes from imsNexus with nodeIds."
\

imsGetElements::usage="imsGetElements[ imsNexus, { elementIds } ] returns the List of Elements from imsNexus with elementIds."
\

imsGetBoundaryElements::usage = 
    "imsGetBoundaryElements[ imsNexus ] returns a list of lists. Each sub list is an element, where at least one of the element's incident ids points to a boundary node and a list with those incident ids which point to a boundary node.";\


imsGetBoundaryElementIds::usage = \
"imsGetBoundaryElementIds[ imsNexus ] returns a list of element ids, where at least one of the element`s incident ids points to a boundary node.";\


(* for global` selector to work *)

imsGetIncidentsIds::usage="This function has to be specified by the user of the Nexus package. See HelpBrowser for more information.";\


imsGetIds::usage="This function has to be specified by the user of the Nexus package. See HelpBrowser for more information.";\


(* mutators *)

imsSetNexusCoords::usage = " imsSetNexusCoords[imsNexus, newCoords] changes the coordinates of a nexus' nodes to newCoords"
\

(* predicates *)

(* functions *)
imsTo3DNexus::usage =
  "imsTo3DNexus[ imsNexus, default ] returns a imsNexus expression to be dissplayed by Graphics3D."
\

(* graphics *)
imsNodePoints::usage = 
  "imsNodePoints[ imsNexus, opts ] returns a list of imsPoint expressions at coords of imsNexus nodes. Optinaly can can specify a list of node ids contained in imsNexus to be returned."
\

imsNodeIdTexts::usage = 
  "imsNodeIdTexts[ imsNexus, offset, dir ] returns a list of Text expressions at coords of imsNexus nodes with the nodes id as text. Offset and dir are the same as for a Text expression."
\

imsNodeValueTexts::usage = 
  "imsNodeValueTexts[ imsNexus, part, offset, dir ] returns a list of Text expressions at coords of imsNexus nodes with part of nodes value as text. Part defaults to Sequence[1,1]. Offset and dir are the same as for a Text expression."
\

imsDrawElements::usage = 
  "imsDrawElements[ imsNexus, { elementIds } ] is special interface function. It will call imsDrawElements[ _elementType, { nodes.. } ], with _elementType being the head of imsNexus element. A list of element ids is optional."
\

imsDrawElementIdText::usage = 
  "imsDrawElementIdText[ imsNexus, { elementIds } ] is special interface function. It will call imsDrawElementIdText[ _elementType, { nodes.. } ], with _elementType being the head of imsNexus element. A list of element ids is optional."
\

imsDrawElementSolution::usage =
  "imsDrawElementSolution[ imsNexus, Sequence, { elementIds } ] is special interface function. It will call imsDrawElementSolution[ _elementType, Sequence, { nodes.. } ], with _elementType being the head of imsNexus element. Sequence (default Sequence[1]) specifies which node vaule is to be taken. A list of element ids is optional."
\

imsDrawElementText::usage= "imsDrawElementText[ imsNexus, function1, function2, offset, dir ] returns a list of Text expressions at the midpoint of imsNexus nodes corresponding to the elements. The text string is selcted by function1, which defaults to imsGetIds. function2 defaults to imsGetElements. Offset and dir are the same as for a Text expression."
\

imsDrawNodeText::usage = "imsDrawNodeText[ imsNexus, function1, function2, offset, dir ] returns a list of Text expressions at coords of imsNexus nodes. The text string is selcted by function1, which defaults to imsGetIds. Function2 defaults to imsGetNodes, but can choose imsGetBoundaryNodes or imsGetInteriorNodes. Offset and dir are the same as for a Text expression.";



(* *)
(* options docu *)
(* *)



(* *)
(* Error Messages *)
(* *)



Begin["`Private`"];



(* *)
(* implementation part *)
(* *)

(* constructor *)

imsMakeNexus[ boundaryNodes_List, interiorNodes_List, elements_List ] := 
    imsNexus[ boundaryNodes, interiorNodes, 
      Sort[ elements, OrderedQ[ imsGetIds[ { #1, #2 } ] ]& ],
      Sort[ Join[ boundaryNodes, interiorNodes ], 
        OrderedQ[ imsGetIds[ { #1, #2 } ] ]& ] ];

Format[ a_imsNexus,StandardForm ]:="- imsNexus -";



(* private functions *)

SetAttributes[ getNodesByIds, Listable ]
SetAttributes[ getElementsByIds, Listable ]




(* selector *)
imsGetBoundaryNodes[ a_imsNexus ] := a[[ 1 ]];
imsGetInteriorNodes[ a_imsNexus ] := a[[ 2 ]];
imsGetNodes[ a_imsNexus ] := a[[ 4 ]];
imsGetElements[ a_imsNexus ] := a[[ 3 ]];

imsGetNodes[ a_imsNexus, ids_ ] := a[[4, ids ]];
imsGetElements[ a_imsNexus, ids_ ] := a[[ 3, ids ]];

imsGetBoundaryElements[ n_imsNexus ] := Module[
      { bnids, allElements, bnQ, belms, activeIncidents },
      bnids =imsGetIds[ imsGetBoundaryNodes[ n ] ];
      allElements = imsGetElements[ n ];
      (bnQ[ # ] := True)& /@ bnids;
      bnQ[ ___ ] := False;
      belms =Select[ allElements, (Or @@ (bnQ /@ imsGetIncidentsIds[#])&) ];
      activeIncidents = 
        Select[ #, (bnQ[#]&) ]& /@ imsGetIncidentsIds[ belms ];
      Return[ Transpose[ { belms, activeIncidents } ] ];
      ];

imsGetBoundaryElementIds[ n_imsNexus ] := 
    imsGetIds[ imsGetBoundaryElements[ n ][[ All, 1 ]] ];



imsSetNexusCoords[nexus_,newCoords_]:=
  Module[{newBoundaryNodes,newInteriorNodes,myNode},
    newBoundaryNodes=
      imsGetBoundaryNodes[nexus]/.myNode_imsNode\[RuleDelayed]
          If[imsDataNodeQ[myNode],
            imsMakeNode[imsGetIds[myNode],newCoords[[imsGetIds[myNode]]],
              imsGetMarkers[myNode],imsGetValues[myNode],imsGetDatas[myNode]],
            imsMakeNode[imsGetIds[myNode],newCoords[[imsGetIds[myNode]]],
              imsGetMarkers[myNode],imsGetValues[myNode]]];
    newInteriorNodes=
      imsGetInteriorNodes[nexus]/.myNode_imsNode\[RuleDelayed]
          If[imsDataNodeQ[myNode],
            imsMakeNode[imsGetIds[myNode],newCoords[[imsGetIds[myNode]]],
              imsGetMarkers[myNode],imsGetValues[myNode],imsGetDatas[myNode]],
            imsMakeNode[imsGetIds[myNode],newCoords[[imsGetIds[myNode]]],
              imsGetMarkers[myNode],imsGetValues[myNode]]];
    Return[
      imsMakeNexus[newBoundaryNodes,newInteriorNodes,imsGetElements[nexus]]]]



(* predicates *)



(* functions *)

(*
  imsTo3DNexus[ 
        imsNexus[ boundaryNodes_, interiorNodes_, elements_,
          nodeByIdsRelation_,elementsByIdsRelation_ ], myValue_:0. ] := 
      imsMakeNexus[ imsTo3DNodes[ boundaryNodes, myValue ], 
        imsTo3DNodes[ interiorNodes, myValue ], elements ]; 
  *)
imsTo3DNexus[ 
      imsNexus[ boundaryNodes_, interiorNodes_, elements_,sortedNodes_ ], 
      myValue_:0. ] := 
    imsMakeNexus[ imsTo3DNodes[ boundaryNodes, myValue ], 
      imsTo3DNodes[ interiorNodes, myValue ], elements ]; 




(* representors *)
imsNexus /: imsNodePoints[ a_imsNexus, nodeIds___ ] := 
  imsNodePoint /@ imsGetNodes[ a, nodeIds ]

imsNexus /: imsNodeIdTexts[ a_imsNexus, offset_:{ 0,0 }, dir_:{ 1,0 } ] := 
  imsNodeIdText[ #, offset, dir ]& /@ imsGetNodes[ a ]

SetAttributes[ imsNodeValueTexts, SequenceHold ];
Default[ imsNodeValueTexts, 2 ] = Sequence[ 1, 1 ];
imsNexus /: 
  imsNodeValueTexts[ a_imsNexus, part_., offset_:{ 0,0 }, dir_:{ 1,0 } ] := 
  imsNodeValueText[ #, part, offset, dir ]& /@ imsGetNodes[ a ]

imsNexus /: imsDrawElements[ a_imsNexus, ids___ ] := 
  imsDrawElements[  #,  imsGetNodes[ a,  imsGetIncidentsIds[ # ] ] ]& /@ 
    imsGetElements[ a, ids  ]

(* {}, offset_, dir_ *) 
imsNexus /: imsDrawElementIdText[ a_imsNexus, ids___ ] :=
  
  imsDrawElementIdText[  #,  imsGetNodes[ a,  imsGetIncidentsIds[ # ] ] ]& /@ 
    imsGetElements[ a,ids ]

SetAttributes[ imsDrawElementSolution, SequenceHold ];
Default[ imsDrawElementSolution, 2 ] = Sequence[ 1 ];
imsNexus /: imsDrawElementSolution[ a_imsNexus, part_., ids___ ] := 
  imsDrawElementSolution[ #,  part, 
        imsGetNodes[ a, imsGetIncidentsIds[ # ] ] ]& /@ 
    imsGetElements[ a, ids ]

imsDrawNodeText[n_imsNexus, function_:imsGetIds,nodeSelection_:imsGetNodes, 
    offset_:{0,0},dir_:{1,0}]:=
  Text[ToString[function[#]],imsGetCoords[#]/.{x_?NumericQ}\[Rule]{x,0},
        offset,dir]&/@nodeSelection[ n ]

imsDrawElementText[n_imsNexus, function1_:imsGetIds, 
    function2_:imsGetElements,offset_:{0,0},dir_:{1,0}]:=
  imsDrawElementText[#,imsGetNodes[n,imsGetIncidentsIds[#]], function1,offset,
        dir]&/@function2[n]

imsDrawElementText[e_,nodes_, function_:imsGetIds,offset_:{0,0},dir_:{1,0}]:=
  Text[ToString[function[e]],
    Plus@@(#/Length[#])&[ imsGetCoords[ nodes ]/.{x_?NumericQ}\[Rule]{x,0}],
    offset,dir]



End[] (* of Begin Private *)



(* Protect[] (* anything *) *)
EndPackage[] 
