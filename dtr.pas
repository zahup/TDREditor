unit DTR;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils;

Type
  TDTR = Class
   private
   public
     Name     : string;
     N        : Integer;
     TVDSRD   : array of double;
     TVDSRD_SD: array of double;
     TWT      : array of double;
     VINT     : array of double;
     VAVG     : array of double;
     VAVG_SD  : array of double;
     VRMS     : array of double;
     HasVel   : boolean;
     HasTWT   : boolean;
     HasDepth : boolean;
     constructor Create(Wname: string);
     destructor Free;
     procedure LoadFromTXT(Fname: string);           //Load TVDSRD, TWT file
     procedure LoadFromVINT_intime(Fname: string);   //Load TWT, VINT file
     procedure LoadFromVINT_indepth(Fname: string);  //Load TVDSRD, VINT file
     procedure SaveToDTR(Fname: string);             //Save TVDSRD, TWT file
     procedure SaveToVINT_intime(Fname: string);     //Save TWT, VINT file
     procedure SaveToVINT_indepth(Fname: string);    //Save TVDSRD, VINT file
     procedure SaveToFullVelocity(Fname: string);    //Save Full Velocity file
     procedure UpdateDTRPostLoad;
     procedure UpdateDTR;
     procedure DeletePoint(AIndex: Integer);
     procedure VAVGAddPointAfter(AIndex: Integer; AVAVG: double; ATWT: double);
     procedure VINTAddPointAfter(AIndex: Integer; AVINT: double; ATWT: double);
     procedure DTRAddPointAfter(AIndex: Integer; ATVDSRD: double; ATWT: double);
     procedure UpdateByVAVG;
     procedure UpdateByVINT;
     function splint(xa,ya,y2a: array of double; nn: integer; x: double): double;
     procedure spline(x,y: array of double; nn: integer; yp1,ypn: double; VAR y2: array of double);
     procedure SplinePreRegularization;
     function linint(x: double): double;
  end;

implementation

Constructor TDTR.Create(Wname: string);
Begin
  Name    := Wname;
  HasVel  := False;
  HasTWT  := False;
  HasDepth:= False;
End;

Destructor TDTR.Free;
Begin
End;

Procedure TDTR.LoadFromTXT(Fname: string);
var
  DTRFile: TStringlist;
  i: integer;
Begin
  DTRFile:=TStringlist.Create;
  DTRFile.LoadFromFile(Fname);
  i:=0;
  repeat
  if pos('#',DTRFile.Strings[i])>0 then Begin DTRFile.Delete(i); i:=i-1; End;
  i:=i+1;
  until i=DTRFile.Count-1;
  N:=DTRFile.Count;
  SetLength(TVDSRD, N);
  SetLength(TWT, N);
  SetLength(VAVG, N);
  SetLength(VINT, N);
  SetLength(VRMS, N);
  SetLength(VAVG_SD,N);
  SetLength(TVDSRD_SD,N);
  For i:=0 to N-1 do
      Begin
        TVDSRD[i]:=StrToFloat(ExtractWord(1, DTRFile[i], [' ']));
        TWT[i]:=StrToFloat(ExtractWord(2, DTRFile[i], [' ']));
      End;
  HasDepth:=True;
  HasTWT  :=True;
  DTRFile.Free;
End;

Procedure TDTR.LoadFromVINT_intime(Fname: String);
var
  DTRFile: TStringlist;
  i: integer;
Begin
  DTRFile:=TStringlist.Create;
  DTRFile.LoadFromFile(Fname);
  N:=DTRFile.Count;
  SetLength(TWT, N);
  SetLength(VINT, N);
  For i:=0 to N-1 do
      Begin
        TWT[i]:=StrToFloat(ExtractWord(1, DTRFile[i], [' ']));
        VINT[i]:=StrToFloat(ExtractWord(2, DTRFile[i], [' ']));
      End;
  HasVel  :=True;
  HasTWT  :=True;
  DTRFile.Free;
end;

Procedure TDTR.LoadFromVINT_indepth(Fname: String);
var
  DTRFile: TStringlist;
  i: integer;
Begin
  DTRFile:=TStringlist.Create;
  DTRFile.LoadFromFile(Fname);
  N:=DTRFile.Count;
  SetLength(TVDSRD, N);
  SetLength(VINT, N);
  For i:=0 to N-1 do
      Begin
        TVDSRD[i]:=StrToFloat(ExtractWord(1, DTRFile[i], [' ']));
        VINT[i]:=StrToFloat(ExtractWord(2, DTRFile[i], [' ']));
      End;
  HasVel  :=True;
  HasDepth  :=True;
  DTRFile.Free;
end;

Procedure TDTR.SaveToDTR(Fname: string);
var
  DTRFile: TStringList;
  i: integer;
  S: String;
Begin
DTRFile:=TStringList.Create;
for i:=0 to N-1 do
    Begin
    S:=PadLeft(FloatToStrF(TVDSRD[i],ffGeneral,6,2),14)+PadLeft(FloatToStrF(TWT[i],ffGeneral,6,2),14);
    DTRFile.Add(S);
    end;
DTRFile.SaveToFile(Fname);
DTRFile.Free;
end;

Procedure TDTR.SaveToVINT_intime(Fname: string);
var
  DTRFile: TStringList;
  i: integer;
  S: String;
Begin
DTRFile:=TStringList.Create;
for i:=0 to N-1 do
    Begin
    S:=PadLeft(FloatToStrF(TWT[i],ffGeneral,6,2),14)+PadLeft(FloatToStrF(VINT[i],ffGeneral,6,2),14);
    DTRFile.Add(S);
    end;
DTRFile.SaveToFile(Fname);
DTRFile.Free;
end;

Procedure TDTR.SaveToVINT_indepth(Fname: string);
var
  DTRFile: TStringList;
  i: integer;
  S: String;
Begin
DTRFile:=TStringList.Create;
for i:=0 to N-1 do
    Begin
    S:=PadLeft(FloatToStrF(TVDSRD[i],ffGeneral,6,2),14)+PadLeft(FloatToStrF(VINT[i],ffGeneral,6,2),14);
    DTRFile.Add(S);
    end;
DTRFile.SaveToFile(Fname);
DTRFile.Free;
end;

Procedure TDTR.SaveToFullVelocity(Fname: string);
var
  DTRFile: TStringList;
  i: integer;
  S: String;
Begin
DTRFile:=TStringList.Create;
S:='#TVDSRD,TWT,VAVG,VRMS,VINT';
DTRFile.Add(S);
for i:=0 to N-1 do
    Begin
    S:=PadLeft(FloatToStrF(TVDSRD[i],ffGeneral,6,2),14)
    +PadLeft(FloatToStrF(TWT[i],ffGeneral,6,2),14)
    +PadLeft(FloatToStrF(VAVG[i],ffGeneral,6,2),14)
    +PadLeft(FloatToStrF(VRMS[i],ffGeneral,6,2),14)
    +PadLeft(FloatToStrF(VINT[i],ffGeneral,6,2),14);
    DTRFile.Add(S);
    end;
DTRFile.SaveToFile(Fname);
DTRFile.Free;

end;

Procedure TDTR.UpdateDTRPostLoad;
var
  i: integer;
  dt: array of double;
  summ: array of double;
Begin
SetLength(dt, N);
SetLength(summ, N);

if ( HasDepth=True and HasTWT = True) Then
   Begin
   //Calculate Velocities
   for i:=0 to N-1 do VAVG[i]:=TVDSRD[i]/(TWT[i]/2000);
   VAVG[0]:=VAVG[1];
   VINT[0]:=VAVG[1];
   for i:=1 to N-1 do VINT[i]:=(TVDSRD[i]-TVDSRD[i-1])/((TWT[i]-TWT[i-1])/2000);
   VRMS[0]:=VINT[0];
   summ[0]:=0;
   for i:=1 to N-1 do
       Begin
        dt[i]:=(TWT[i]-TWT[i-1])/2000;
        summ[i]:=summ[i-1]+dt[i]*VINT[i]*VINT[i];
        VRMS[i]:=SQRT(summ[i]/(TWT[i]/2000));
       end;
   end;
if ( HasTWT=True and HasVel=True ) then
   Begin
   //Calculate TVDSRD
   TVDSRD[0]:=0;
   VRMS[0]:=VINT[1];
   for i:=1 to N-1 do
	Begin
	dt[i]:=(TWT[i]-TWT[i-1])/2000;
	TVDSRD[i]:=TVDSRD[i-1]+VINT[i]*(dt[i]/2000);
	VAVG[i]:=TVDSRD[i]/(TWT[i]/2000);
	summ[i]:=summ[i-1]+dt[i]*VINT[i]*VINT[i];
	VRMS[i]:=SQRT(summ[i]/(TWT[i]/2000));
	End;
   end;
if (HasDepth=True and HasVel=True) Then
   Begin
   //Calculate TWT
   TWT[0]:=0;
   for i:=1 to N-1 do
	Begin
	TWT[i]:=TWT[i-1]+2000*(TVDSRD[i]-TVDSRD[i-1])/VINT[i];
	dt[i]:=(TWT[i]-TWT[i-1])/2000;
	VAVG[i]:=TVDSRD[i]/(TWT[i]/2000);
	summ[i]:=summ[i-1]+dt[i]*VINT[i]*VINT[i];
	VRMS[i]:=SQRT(summ[i]/(TWT[i]/2000));
	End;   
   end;
end;

Procedure TDTR.UpdateDTR;
var
  i: integer;
  dt, summ: array of double;
Begin
SetLength(dt, N);
SetLength(summ, N);
SetLength(VAVG, N);
SetLength(VRMS, N);
SetLength(VINT, N);
SetLength(VAVG_SD,N);
SetLength(TVDSRD_SD,N);
for i:=1 to N-1 do VAVG[i]:=TVDSRD[i]/(TWT[i]/2000);
TWT[0]:=0;
TVDSRD[0]:=0;
VINT[0]:=VAVG[1];
VAVG[0]:=VAVG[1];
for i:=1 to N-1 do VINT[i]:=(TVDSRD[i]-TVDSRD[i-1])/((TWT[i]-TWT[i-1])/2000);
VRMS[0]:=VINT[0];
summ[0]:=0;
for i:=1 to N-1 do
    Begin
     dt[i]:=(TWT[i]-TWT[i-1])/2000;
     summ[i]:=summ[i-1]+dt[i]*VINT[i]*VINT[i];
     VRMS[i]:=SQRT(summ[i]/(TWT[i]/2000));
    end;
end;

Procedure TDTR.DeletePoint(AIndex: Integer);
Begin
Delete(TVDSRD, AIndex,1);
Delete(TWT,AIndex,1);
Delete(VINT,AIndex,1);
Delete(VAVG,AIndex,1);
Delete(VRMS,AIndex,1);
N:=N-1;
UpdateDTR;
End;

Procedure TDTR.UpdatebyVAVG;
var
  i: integer;
  dt, summ: array of double;
Begin
SetLength(dt, N);
SetLength(summ, N);
TWT[0]:=0;
TVDSRD[0]:=0;
summ[0]:=0;
for i:=1 to N-1 do
    Begin
    TVDSRD[i]:=VAVG[i]*(TWT[i]/2000);
    VINT[i]:=(TVDSRD[i]-TVDSRD[i-1])/((TWT[i]-TWT[i-1])/2000);
    dt[i]:=(TWT[i]-TWT[i-1])/2000;
    summ[i]:=summ[i-1]+dt[i]*VINT[i]*VINT[i];
    VRMS[i]:=SQRT(summ[i]/(TWT[i]/2000));
    end;
VRMS[0]:=VINT[1];
VINT[0]:=VINT[1];
VAVG[0]:=VAVG[1];
end;

Procedure TDTR.UpdatebyVINT;
var
  i: integer;
  dt, summ: array of double;
Begin
SetLength(dt,N);
SetLength(summ, N);
TWT[0]:=0;
TVDSRD[0]:=0;
for i:=1 to N-1 do
    Begin
    dt[i]:=(TWT[i]-TWT[i-1])/2000;
    TVDSRD[i]:=TVDSRD[i-1]+VINT[i]*dt[i];
    VAVG[i]:=TVDSRD[i]/(TWT[i]/2000);
    summ[i]:=summ[i-1]+dt[i]*VINT[i]*VINT[i];
    VRMS[i]:=SQRT(summ[i]/(TWT[i]/2000));
    end;
VRMS[0]:=VINT[1];
VINT[0]:=VINT[1];
VAVG[0]:=VAVG[1];
end;

Procedure TDTR.VAVGAddPointAfter(AIndex: Integer; AVAVG: double; ATWT: double);
Begin

insert([ATWT],TWT,AIndex+1);
insert([AVAVG],VAVG,AIndex+1);
insert([0],TVDSRD,AIndex+1);
insert([0],VRMS,AIndex+1);
insert([0],VINT,AIndex+1);
N:=N+1;
UpdatebyVAVG;
End;

procedure TDTR.VINTAddPointAfter(AIndex: Integer; AVINT: double; ATWT: double);
Begin
insert([ATWT],TWT,AIndex+1);
insert([AVINT],VINT,AIndex+1);
insert([0],TVDSRD,AIndex+1);
insert([0],VRMS,AIndex+1);
insert([0],VAVG,AIndex+1);
N:=N+1;
UpdatebyVINT;

end;

procedure TDTR.DTRAddPointAfter(AIndex: Integer; ATVDSRD: double; ATWT: double);
Begin
insert([ATWT],TWT,AIndex+1);
insert([0],VINT,AIndex+1);
insert([ATVDSRD],TVDSRD,AIndex+1);
insert([0],VRMS,AIndex+1);
insert([0],VAVG,AIndex+1);
N:=N+1;
UpdateDTR;
end;

function TDTR.splint(xa,ya,y2a: array of double; nn: integer; x: double): double;
(* Programs using routine SPLINT must define the type
TYPE
   glnarray = ARRAY [1..n] OF real;
in the main routine. *)
VAR
   klo,khi,k: integer;
   h,b,a,y: double;
BEGIN
   klo := 0;
   khi := nn-1;
   WHILE (khi-klo > 1) DO BEGIN
      k := (khi+klo) DIV 2;
      IF (xa[k] > x) THEN khi := k ELSE klo := k;
   END;
   h := xa[khi]-xa[klo];
   IF (h <> 0.0) THEN
      BEGIN
       a := (xa[khi]-x)/h;
       b := (x-xa[klo])/h;
       y := a*ya[klo]+b*ya[khi]+((a*a*a-a)*y2a[klo]+(b*b*b-b)*y2a[khi])*(h*h)/6.0;
      END;
   result:=y;
END;

procedure TDTR.spline(x,y: array of double; nn: integer; yp1,ypn: double;
       VAR y2: array of double);
(* Programs using routine SPLINE must define the type
TYPE
   glnarray = ARRAY [1..n] OF real;
in the main routine. *)
VAR
   i,k: integer;
   p,qn,sig,un: double;
   u: array of double;
BEGIN
   SetLength(u, nn);
   IF (yp1 > 0.99e30) THEN BEGIN
      y2[0] := 0.0;
      u[0] := 0.0
   END ELSE BEGIN
      y2[0] := -0.5;
      u[0] := (3.0/(x[1]-x[0]))*((y[1]-y[0])/(x[1]-x[0])-yp1);
   END;
   FOR i := 1 TO nn-2 DO BEGIN
      sig := (x[i]-x[i-1])/(x[i+1]-x[i-1]);
      p := sig*y2[i-1]+2.0;
      y2[i] := (sig-1.0)/p;
      u[i] := (y[i+1]-y[i])/(x[i+1]-x[i])-(y[i]-y[i-1])/(x[i]-x[i-1]);
      u[i] := (6.0*u[i]/(x[i+1]-x[i-1])-sig*u[i-1])/p;
   END;
   IF (ypn > 0.99e30) THEN BEGIN
      qn := 0.0;
      un := 0.0;
   END ELSE BEGIN
      qn := 0.5;
      un := (3.0/(x[nn-1]-x[nn-2]))*(ypn-(y[nn-1]-y[nn-2])/(x[nn-1]-x[nn-2]));
   END;
   y2[nn-1] := (un-qn*u[nn-2])/(qn*y2[nn-2]+1.0);
   FOR k := nn-2 DOWNTO 0 DO BEGIN
      y2[k] := y2[k]*y2[k+1]+u[k];
   END;
END;

procedure TDTR.SplinePreRegularization;
Begin
  spline(TWT,TVDSRD,N,1,1,TVDSRD_SD);
end;

function TDTR.linint(x: double): double;
var
   i, LIndex: integer;
   slope,y: double;
Begin
 for i:=0 to N-2 do if (TWT[i] <= x) and (TWT[i+1]>x) Then LIndex:=i;
 if TWT[LIndex+1] < x then Lindex:=N-2;
 slope:=(TVDSRD[Lindex+1]-TVDSRD[LIndex])/(TWT[LIndex+1]-TWT[LIndex]);
  y:=TVDSRD[LIndex]+(x-TWT[LIndex])*slope;
 result:=y;
End;

end.

