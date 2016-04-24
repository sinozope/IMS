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
(* Title:Triangle.m *)
(* Context: *)
(* 
  Author:oliver r\[UDoubleDot]benk\[ODoubleDot]nig with comments from darius \
koziol *)
(* Date: 28.2.2005, Imtek, Freiburg, Germany *)
(* 
  Summary: This package provides triangle utilities *)
(* 
  Package Copyright:GNU GPL *)
(* Package Version:0.3.1 *)
(* 
  Mathematica Version:4.2 *)
(* History:
    Added Circumcenter for triangles in 3D;
  Now based on coords rather than Point[];
  TrinagleArea for 3D had a bug;
  Changed TriangleArea computation for speed. did NOT use Point selectors;
  Added TriangleCenterOfMass;
  Added TriangleNormal;
  removed the Abs from triangle area *)
(* Keywords: *)
(* Sources: 
      imsCircumcenter was taken with respect from:
          http://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
  *)
(* Warnings: *)
(* Limitations: *)
(* Discussion: *)
(* 
  Requirements: *)
(* Examples: *)
(* *)



(* Start Package *)

BeginPackage["Imtek`Triangle`", "Imtek`Polygon`", "Imtek`Point`" ];





(* *)
(* docu *)
(* *)
Needs["Imtek`Maintenance`"]
imsCreateObsoleteFunctionInterface[ Triangle2DQ, $Context ];
imsCreateObsoleteFunctionInterface[ Triangle3DQ, $Context ];
imsCreateObsoleteFunctionInterface[ TriangleQ, $Context ];
imsCreateObsoleteFunctionInterface[ TriangleSubArea, $Context ];
imsCreateObsoleteFunctionInterface[ Circumcenter, $Context ];
imsCreateObsoleteFunctionInterface[ CenterOfMass, $Context ];
imsCreateObsoleteFunctionInterface[ Angle, $Context ];

(* constructors *)

(* selectors *)

(* predicates *)

imsTriangle2DQ::usage = \
"imsTriangle2DQ[ expr ] returns True if expr is a 2D triangle.";
imsTriangle3DQ::usage = \
"imsTriangle3DQ[ expr ] returns True if expr is a 3D triangle.";
imsTriangleQ::usage = \
"imsTriangleQ[ expr ] returns True if expr is a triangle.";

(*function usage*)

imsTriangleSubArea::usage="imsTriangleSubArea[ imsTriangle , imsPoint ] gives three sub areas which are spanned by imsTriangle and the additional imsPoint.";\


imsCircumcenter::usage="imsCircumcenter[ imsTriangle ] gives the triangle circumference mid point of imsTriangle.";\


imsCenterOfMass::usage = \
"imsCenterOfMass[ imsTriangle ] returns the center of mass for the triangle imsTriangle.";\


imsNormal::usage = \
"imsNormal[ imsTriangle ] gives the normal to a 3D triangle.";

imsAngle::usage="imsAngle[ imsTriangle ] gives the angles in Radians in the order of the points making up imsTriangle.";



(*package error message*)
imsTriangle::"badarg"="Hello?! - What is this supposed to become?
    You called `1` with wrong argument!";




(* *)
(* define your options *)
(* *)

Options[ imsTriangle ] = { Primitive \[Rule] Line }
(* end define options *)



Begin["`Private`"];



Needs["Utilities`FilterOptions`"];
Needs[ "Imtek`Point`" ];



(* *)
(* implementation part *)
(* *)

(* constructor *)



(* GetCoord[ imsTriangle[ { i_, j_, k_ } ] ] := { i, j, k }; *)




imsTriangle2DQ[ { { _, _ }, { _, _ } ,{ _, _ } } ] := True;
imsTriangle3DQ[ { { _,_, _ }, { _, _, _ }, { _, _, _ } } ] := True;
imsTriangle2DQ[ ___ ] := False;
imsTriangle3DQ[ ___ ] := False;
imsTriangleQ[ expr_ ] := imsTriangle2DQ[ expr ] || imsTriangle3DQ[ expr ];
imsTriangleQ[ ___ ] := False;





(* imsArea is in the Polygon package *)

imsTriangleSubArea[ { a_, b_, c_ }, the_ ] /; imsCoordQ[ the ]:= List[
      imsArea[ { a, b, the } ],
      imsArea[ { b, c, the } ],
      imsArea[ { c, a, the } ]
      ];



imsCircumcenter[ { { xi_,yi_ },{ xj_,yj_ },{xk_,yk_ } } ]:= Module[
      {  A, x, sol },
      
      (* calculate circumcenter of triangle - THANX DAVE *)
      (* 
        this should be implemented directly! *)
      
      A = {{ yj - yi,yk - yi},{ xi - xj, xi - xk } };
      x = {{ xk - xj },{ yk - yj } };
      sol = LinearSolve[ A, x ];
      
      (* we could have chosen sol[[2,1]] instead *)
      Return[
        { ( xi + xj ) / 2 + ( yj - yi ) / 2 * sol[[ 1, 1 ]],
           ( yi + yj ) / 2 + ( xi - xj ) / 2 * sol[[ 1, 1 ]] }
        ]
      ];


imsCircumcenter[ { { x1_, y1_, z1_ },{ x2_, y2_, z2_ }, { x3_, y3_, 
        z3_ } } ] :=  Block[
    {
      xba=x2-x1,
      yba=y2-y1,
      zba=z2-z1,
      xca=x3-x1,
      yca=y3-y1,
      zca=z3-z1,
      baLength, caLength,
      xcross, ycross, zcross,
      denom,
      xcic, ycic,zcic
      },
    
    baLength = xba*xba + yba*yba + zba*zba;
    caLength = xca*xca + yca*yca + zca*zca;
    
    xcross = yba * zca - yca * zba;
    ycross = zba * xca - zca * xba;
    zcross = xba * yca - xca * yba;
    
    denom = (1/2) / ( xcross*xcross + ycross*ycross + zcross*zcross );
    xcic = ( (baLength * yca - caLength * yba) * 
              zcross - (baLength * zca - caLength * zba) * ycross) * denom;
    ycic = ( (baLength * zca - caLength * zba) * 
              xcross - (baLength * xca - caLength * xba) * zcross) * denom;
    zcic = ( (baLength * xca - caLength * xba) * 
              ycross - (baLength * yca - caLength * yba) * xcross) * denom;
    
    Return[ { x1 + xcic, y1 + ycic, z1 + zcic } ];
    ]



imsCenterOfMass[ { { xi_,yi_ },{ xj_,yj_ },{ xk_, yk_ } } ]:=
  1/3 * { xi + xj + xk, yi + yj + yk }

imsCenterOfMass[ { { xi_,yi_, zi_ },{ xj_,yj_, zj_ },{ xk_,yk_, zk_ } } ] := 
  1/3 * { xi + xj + xk, yi + yj + yk, zi + zj + zk }



imsNormal[ { { xi_,yi_ },{ xj_,yj_ },{xk_,yk_ } } ]  := { 0,
     0,
    ( xj - xi ) * ( yk - yi ) - ( xk - xi ) * ( yj - yi )
    }

imsNormal[ { { xi_,yi_, zi_ },{ xj_,yj_, zj_ },{xk_,yk_, zk_ } } ] := 
  {( yj - yi ) * ( zk -zi ) - ( yk - yi ) * ( zj - zi ),
    ( xk - xi ) * ( zj -zi ) - ( xj - xi ) * ( zk -zi ),
    ( xj - xi ) * ( yk - yi ) - ( xk - xi ) * ( yj - yi )
    }



imsAngle[ { a_,b_,c_ } ]:=With[
      {
        (* Make pairs of unit vectors that point away from a corner. *) 
        unitVecs = ( #/Sqrt[ Dot[ #, # ] ] )&/@{ b - a, c - b,  a - c }
        },
      
      (* The dot product is defined by A.B=|A||B|Cos[\[Theta]]. *)
      (* 
        Here A.B=Cos[\[Theta]] because |A|=|B|=1. Hence \[Theta]=ArcCos[A.B] *)

            ArcCos[#]&/@(MapThread[ 
            Dot[  #1, #2  ]&,{unitVecs,-RotateLeft[unitVecs,2]}])
      ];



Unprotect[ Graphics ];
Graphics[ a_imsTriangle, opts___ ] := Graphics[ { { a  } }, opts ];

Graphics[ { a_imsTriangle, restGraphics___ }, opts___ ] := 
    Graphics[ { { a }, restGraphics }, opts ];

Graphics[ { primitiveOpts___ , a_imsTriangle }, opts___ ] := 
    Graphics[ { { primitiveOpts, a } } , opts ];

Graphics[ { { primitiveOpts___ , imsTriangle[ coords_ ] } , 
        restGraphics___ }, graphicsOpts___ ] := With[ 
      {
        primitive  = Primitive /. { graphicsOpts } /. Options[ imsTriangle ]
        }, 
      
      Which[
        primitive === Polygon || primitive === {Polygon},
        Graphics[ #1, FilterOptions[ Graphics, graphicsOpts ] ]& /@ { { 
              primitiveOpts , Polygon[ coords ] }, 
            restGraphics
             },
        
        primitive === Line  || primitive === {Line},
        Graphics[ #1, FilterOptions[ Graphics, graphicsOpts ] ]& /@ { { 
              primitiveOpts , Line[ Append[ coords,  First[ coords ] ]  ] },
            restGraphics },
        
        (* else *)
        True, 
        Print["Something is wrong in the graphics part of the tirangle package."]\
;
        ]
      ];
Protect[ Graphics ];



Unprotect[ Graphics3D ];
Graphics3D[ a_imsTriangle, opts___ ] := Graphics3D[ { { a } }, opts ];

Graphics3D[ { a_imsTriangle, restGraphics3D___ }, opts___ ] := 
    Graphics3D[ { { a }, restGraphics3D }, opts ];

Graphics3D[ { primitiveOpts___ , a_imsTriangle }, opts___ ] := 
    Graphics3D[ { { primitiveOpts, a } } , opts ];

Graphics3D[ { { primitiveOpts___ , imsTriangle[ coords_ ] },
        restGraphics3D___  }, graphics3DOpts___ ] := With[ 
      {
        primitive  = Primitive /. { graphics3DOpts } /. Options[imsTriangle]
        }, 
      
      Which[
        primitive === Polygon || primitive === {Polygon},
        Graphics3D[ #, FilterOptions[ Graphics3D, graphics3DOpts ] ]& /@ {  { 
              primitiveOpts , Polygon[ coords ] }, restGraphics3D } ,
        
        primitive === Line  || primitive === {Line},
        Graphics3D[ #, FilterOptions[ Graphics3D, graphics3DOpts ] ]& /@ { { 
              primitiveOpts , Line[ Append[ coords, First[ coords ] ] ] }, 
            restGraphics3D },
        
        (* else *)
        True, 
        Print["Something is wrong in the graphics 3D part of the tirangle package."]\
;
        ]
      ];
Protect[ Graphics3D ];



End[] (* of Begin Private *)



(* Protect[] (* anything *) *)
EndPackage[] 