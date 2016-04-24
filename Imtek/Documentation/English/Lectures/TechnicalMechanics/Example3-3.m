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











Off[General::"spell",General::"spell1",ParametricPlot3D::"ppcom"];
Clear[\[Theta],r,rr]

\!\(\(pointC[\[Theta]_] := \((r + rr)\) {\ 
          Sin[\[Theta]], \(-Cos[\[Theta]]\)};\)\n
  \(pointD[\[Theta]_] := \((rr)\) {\ Sin[\[Theta]], \(-Cos[\[Theta]]\)};\)\n
  \(pointArelativeC[\[Phi]_] := r {\(-Sin[\[Phi]]\), Cos[\[Phi]]};\)\n
  \(\[Phi]From\[Theta][\[Theta]_] := \((\(rr + r\)\/r)\) \[Theta];\)\
\[IndentingNewLine]
  \(pointA[\[Theta]_] := 
      pointC[\[Theta]] + 
        pointArelativeC[\[Phi]From\[Theta][\[Theta]]];\)\[IndentingNewLine]
  \(parameters33 = {r \[Rule] 1, rr \[Rule] 5};\)\)











theBigDisk[\[Theta]_]:={
      RGBColor[0,0,1],Circle[{0,0},rr]/.parameters33,
      RGBColor[0,1,0],
      Disk[pointD[\[Theta]],.1]/.parameters33};
theLittleDisk[\[Theta]_]:={
    RGBColor[0,0,1],Circle[pointC[\[Theta]],r]/.parameters33,
    RGBColor[1,0,0],
    Disk[pointA[\[Theta]],.1]/.parameters33}

diskFrame[\[Theta]_]:=Module[{curve},
      curve=Line[Table[pointA[t]/.parameters33,{t,0,\[Theta],\[Pi]/60}]];
      Graphics[{curve,theBigDisk[\[Theta]],theLittleDisk[\[Theta]]}]
      ];



