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
(* Title: NonlinearSolve.m *)
(* Context: *)
(* 
  Author:oliver ruebenkoenig *)
(* Date: 22.2.2007, Leipzig *)
(* 
  Summary: This is a nonlinear solver package *)
(* 
  Package Copyright: GNU GPL *)
(* Package Version: 0.2.1 *)
(* 
  Mathematica Version: 5.2 *)
(* History:
    fixed a rule to a ruledelayed for the FindRoot wrapper and added a exitQ \
for the case when the solution of the nonlinear equation is found in the \
first step and du contains the entire solution and this the Norm[du] <= 
      Sqrt[tol*10] fails;  
  added imsResidualMonitor
   *)
(* Keywords: *)
(* Sources:
    Nowak;Weimann;Deuflhard;
   This implements NLEQ1 from
    http://www.zib.de/Numerik/numsoft/NewtonLib/;
        http://
    www.zib.de/Numerik/numsoft/ANT/index.en.html;
  U.Nowak and L.Weimann.A family of Newton codes for systems of highly \
nonlinear equations.Technical Report TR 91-10,
  Konrad-Zuse-Zentrum Berlin,1991.
  *)
(* Warnings: *)
(* Limitations: *)
(* Discussion: *)
(* 
  Requirements: *)
(* Examples: *)
(* *)



(* Disclaimer *)

(* Whereever the GNU GPL is not applicable, 
  the software should be used in the same spirit. *)

(* Users of this code must verify correctness for their application. *)

(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)

(* Disclaimer: *)

(* This is a nonlinear solver package *)

(* Copyright (C) 2007 oliver ruebenkoenig *)

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
BeginPackage["Imtek`NonlinearSolve`",{"Imtek`Debug`"}];





(* *)
(* documentation *)
(* *)

(* constructors *)

(* selectors *)

(* predicates *)

(* functions *)

imsJacobian::usage="imsJacobian[ e_List, v_List ] returns the jacobian of list e with respect to variables v.";\


imsNonlinearSolve::usage="imsNonlinearSolve[ jac_, f_, u0_, opts___?OptionQ ] returns the solution to a nonlinear equation f given the starting point u0 and the jacobian.";



(* *)
(* options docu *)
(* *)

imsAffineInvarianteDampedNewton::usage="is the default Method of imsNonlinearSolve.";\


imsDampingFactorMin::usage="sets the minimum damping factor allowed.";

imsNormFunction::usage="allows to specify the internal norm used for calculations. Default is Norm.";\


imsResidualMonitor::usage="allows to monitor the residual of the imsAffineInvarianteDampedNewton method."
\

imsScaleFactor::usage="allows to scale the norms in the imsAffineInvarianteDampedNewton method. Default is 1/10. For highly non-linear problems set to 10^-5.";



(* *)
(* error messages *)
(* *)

imsAffineInvarianteDampedNewton::"dampingFactorMin" = "The damping factor has droped below the allowed minimum to `1`. Try to decrease the DampingFactor and/or reduce the imsDampingFactorMin.";

imsAffineInvarianteDampedNewton::"maxIterations" = "The number of maximum iterations (that is `1`) allowed has been exceeded. The solution returned does not meet the convergence criteria. Try to increase MaxIterations or reduce the required AccuracyGool/WorkingPrecision.";



Begin["`Private`"];



(* *)
(* private imports *)
(* *)
<<Utilities`FilterOptions`
Needs["Imtek`SparseUtils`"]



(* *)
(* implementation part *)
(* *)

(* constructor *)
(* *)



(* *)
(* define your options *)
(* *)
SetAttributes[ imsNonlinearSolve, \
HoldAll ]
Options[imsNonlinearSolve]={Method \[Rule] "imsAffineInvarianteDampedNewton"};

SetAttributes[imsAffineInvarianteDampedNewton, HoldAll ]
Options[imsAffineInvarianteDampedNewton] = { MaxIterations \[Rule] 25, 
      DampingFactor \[Rule] 1, imsDampingFactorMin \[Rule] 10^-4, 
      AccuracyGoal \[Rule] Automatic, 
      WorkingPrecision \[Rule] MachinePrecision, 
      imsNormFunction \[Rule] Norm, EvaluationMonitor \[Rule] None, 
      StepMonitor \[Rule] None, imsResidualMonitor \[Rule] None, 
      imsScaleFactor \[Rule] 1/10 };




(* selector *)
(* *)



(* predicates *)
(* *)



(* private functions *)
(* *)

(* public functions *)
(* *)

imsJacobian[ e_List, v_List ] := Outer[ D, e, v ]

imsNonlinearSolve[ myJ_, myF_, u0_, opts___?OptionQ ] /; 
    "FindRoot"===(Method /. Flatten[ {opts} ] /. 
          Options[ imsNonlinearSolve ]):= 
  X /. FindRoot[ myF[ X], {X, u0}, Method\[Rule]{"Newton"}, 
      Jacobian:> {myJ[ X ], Sparse\[Rule]Automatic }, 
      Evaluate[ FilterOptions[ FindRoot, opts ] ] ]

imsNonlinearSolve[ myJ_, myF_, u0_, opts___?OptionQ ] /; 
    "imsAffineInvarianteDampedNewton"===(Method /. Flatten[ {opts} ] /. 
          Options[ imsNonlinearSolve ]):= 
  imsAffineInvarianteDampedNewton[ myJ, myF, u0,
    Evaluate[ FilterOptions[ imsAffineInvarianteDampedNewton, opts ] ] ]

imsAffineInvarianteDampedNewton[ myJ_,myF_, u0_,  opts___?OptionQ ] := Block[
    {k,u,uw,f,lsf,du,h,l,lambda,j,duBar,exitQ,konvQ,uInit=u0,result,
      itmax, lambda0, lambdaMin, linearSolveOpts,accugoal,workprec, myNorm, 
      sf, evaluationStep, successfullStep, residualMon, resid },
    (* options *)
    {itmax, lambda0, lambdaMin, accugoal, workprec, myNorm, 
        sf } = {MaxIterations, DampingFactor, imsDampingFactorMin, 
            AccuracyGoal,WorkingPrecision, imsNormFunction, imsScaleFactor } /. 
          Flatten[ { opts } ] /. Options[imsAffineInvarianteDampedNewton];
    
    evaluationStep := 
      EvaluationMonitor /. Flatten[ { opts } ] /. 
        Options[imsAffineInvarianteDampedNewton];
    successfullStep :=  
      StepMonitor /. Flatten[ { opts } ] /. 
        Options[imsAffineInvarianteDampedNewton];
    residualMon :=  
      imsResidualMonitor /. Flatten[ { opts } ] /. 
        Options[imsAffineInvarianteDampedNewton];
    
    linearSolveOpts = FilterOptions[ LinearSolve, opts ];
    
    (* options processing *)
    (*
      
      If[ accugoal === Automatic, 
        accugoal= Max[ Precision[uInit],$MachinePrecision ] ];
      If[ workprec === MachinePrecision,workprec = accugoal; 
        If[ accugoal > $MachinePrecision, workprec+= extraPrecis ];
        ];
      If[ workprec > $MachinePrecision, 
        uInit = SetPrecision[ uInit,workprec ]; ];
      *)
    If[ accugoal === Automatic, accugoal:= workprec/2; ];
    If[ workprec === MachinePrecision,workprec = $MachinePrecision; 
      If[ accugoal > workprec, workprec+= accugoal ];
      ];
    If[ workprec > $MachinePrecision, 
      uInit = SetPrecision[ uInit,workprec ]; ];
    
    (* $MaxPrecision = workprec *)
    Block[ {  },
      tol = 10^-accugoal;
      
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {"Tolerance: ", tol } ];
      
      k=0;
      u[k] = uInit;
      Unset[uInit];
      uwu = Table[ sf, {Length[u0]} ];
      uw[k]=MapThread[ Max, { Abs[ uwu ], Abs[ u[k] ] } ];
      dInverse[k] = imsSparseDiagonalMatrix[ 1/uw[k] ];
      
      evaluationStep[ u[k] ];
      f[k] = myF[ u[k] ];
      
      (* eval jacobian *)
      Label["newtonStep"];
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {"Newton Step: ", k } ];
      
      (* store linear solve funtion *)
      
      lsf = LinearSolve[ myJ[ u[k] ],linearSolveOpts ];
      du[k] = -lsf[f[k]];
      (*
        Print[ "du: ", du[k] ];
        Print[ "jac",myJ[ u[k] ]//MatrixForm ];
        Print[ "f: ", f[k] ];
        *)
      
      (* compute a priori damping factor *)
      If[ k>0,
        uw[k]=MapThread[ Max, { Abs[ uwu ], 1/2 *Abs[ u[k-1]+u[k] ] } ];
        dInverse[k] = imsSparseDiagonalMatrix[ 1/uw[k] ];
        Unset[ uw[k] ];
        h[k,
            0] = ( myNorm[ dInverse[k].( du[k-1] ) ] * 
                  myNorm[ dInverse[k].( duBar[k] ) ] )/(myNorm[ 
                    dInverse[k].( duBar[k] - du[k] ) ] * 
                  myNorm[ dInverse[k].( du[k] ) ] ) *lambda[k-1];
        lambda[ k, 0 ] = Min[ 1, h[ k, 0 ] ];
        ,
        lambda[ k, 0 ] = lambda0;
        ];
      
      l = Max[ lambda[ k, 0 ], lambdaMin ];
      j=0;
      
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {" Lambda: ", l } ];
      
      
      (* a posteriori loop *)
      Label["posterioriLoop"];
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {" posteriori loop: ", j } ];
      
      (* compute trial iterate *)
      If[ j>0, Unset[ u[k+1,j-1] ] ];
      u[ k+1, j ] = u[k] +  l * du[k];
      
      (* evaluate system *)
      evaluationStep[ u[ k+1, j ] ];
      If[ j>0, Unset[ f[ k+1, j-1 ] ] ];
      f[ k+1, j ] = myF[ u[ k+1,j ] ];
      
      (* compute simplified newton correction *)
      
      If[ j>1, Unset[ duBar[ k+1, j-1 ] ] ];
      duBar[ k+1, j ] = -lsf[ f[ k+1,j ] ];
      
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {"  Norm[du]: ", myNorm[ dInverse[k].( du[ k ] ) ] } ];
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {"  Norm[duBar]: ", myNorm[ dInverse[k]. duBar[ k+1, j ] ] } ];
      
      (* why duBar[blah, 0] ? *)
      
      residualMon[ resid = myNorm[ dInverse[k].( duBar[ k+1, 0 ] ) ] ];
      If[ k==0 && j==0,
        (* 
          if the solution if found in the first and the starting vector was 0 \
then Norm[du] is not smaller Sqrt[10*tol]  *)
        
        exitQ = (  resid \[LessEqual] tol && l \[Equal] 1 );,
        exitQ = (  
              resid \[LessEqual] tol && 
                myNorm[ dInverse[k].( du[ k ] ) ] \[LessEqual] 
                  Sqrt[ 10 * tol ] && l \[Equal] 1 );
        ];
      
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {" exit check: ", exitQ } ];
      If[ exitQ, result = u[ k+1,0 ] + duBar[ k+1,0 ];
        successfullStep[ result ];Return[ result ] ];
      
      (* compute a posteriory damping factor *)
      
      h[ k, j+1 ] = (2/l^2) * 
          myNorm[ dInverse[k].( duBar[ k+1,j ] - (1-l)*du[k] ) ] / 
            myNorm[ dInverse[k].( du[k] ) ];
      lambda[ k, j+1 ] = Min[ 1, 1/h[ k, j+1 ] ];
      
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {" Posteriori Lambda: ", lambda[ k, j+1 ] } ];
      
      (* nonotonicity Check *)
      
      konvQ = myNorm[ dInverse[k].( duBar[ k+1, j ] ) ] \[LessEqual] 
          myNorm[ dInverse[k].( du[k] ) ];
      imsDebugMessage["Imtek`NonlinearSolve`Private`imsAffineInvarianteDampedNewton`",
        1, {" monotonicity check: ", konvQ } ];
      If[
        konvQ,
        duBar[k+1] = duBar[k+1,j];
        u[k+1]= u[k+1,j];
        successfullStep[ u[k+1] ];
        f[k+1]= f[k+1,j];
        Unset[ duBar[k+1,j] ]; If[ j>1,Unset[ duBar[k+1,0] ] ]; 
        Unset[ u[k+1,j ] ]; Unset[ f[k+1,j] ];
        lambda[k] = l;
        k=k+1;
        If[ k>itmax, 
          Message[imsAffineInvarianteDampedNewton::"maxIterations", k - 1]; 
          Return[ u[ k ] ] ];
        Goto["newtonStep"],
        
        j=j+1;
        If[ l \[LessEqual] lambdaMin, 
          Message[imsAffineInvarianteDampedNewton::"dampingFactorMin", l ]; 
          Return[ u[ k ] ]  ];
        (* Print[ " k: ", k, " j: ", j, " l/2 ", l/2, " ", lambda[k,j], " ", 
              lambdaMin ]; *)
        l = Min[ lambda[k,j], l/2 ];
        l =Max[ l, lambdaMin ];
        Goto["posterioriLoop"]
        
        ];
      ];
    ]



(* representors *)
(* *)



(* Begin Private *)
End[]



(* Protect[] *)
EndPackage[] 
