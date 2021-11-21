unit Unit6;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, TAGraph, TASeries, TASources, TAChartExtentLink, TAFuncSeries;

type

  { TRegularizeForm }

  TRegularizeForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ChartExtentLink1: TChartExtentLink;
    ChartExtentLink2: TChartExtentLink;
    OrigVINT: TLineSeries;
    AlgoSelect: TRadioGroup;
    RegVINTSource: TListChartSource;
    RegVINT: TLineSeries;
    GroupBox1: TGroupBox;
    RegulCurveSource: TListChartSource;
    OrigCurveSource: TListChartSource;
    MaxTWTEdit: TLabeledEdit;
    StepTWTEdit: TLabeledEdit;
    OriginalCurve: TChart;
    OriginalCurveL: TLineSeries;
    TDRorVAVG: TRadioGroup;
    RegularizedCurve: TChart;
    DifferenceCurve: TChart;
    Panel1: TPanel;
    RegularizedCurveL: TLineSeries;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure OnFormResize(Sender: TObject);
    procedure OnOriginalCurveChange(Sender: TObject);
  private

  public

  end;

var
  RegularizeForm: TRegularizeForm;

implementation

{$R *.lfm}

{ TRegularizeForm }
uses unit1;

procedure TRegularizeForm.OnOriginalCurveChange(Sender: TObject);
begin
  If TDRorVAVG.ItemIndex=0 then
  OriginalCurveL.Source:=Unit1.MainForm.DTRListSource else
  OriginalCurveL.Source:=Unit1.MainForm.VAVGListSource;

end;

procedure TRegularizeForm.OnFormResize(Sender: TObject);
begin
  OriginalCurve.Width:=round(RegularizeForm.ClientWidth/3);
  DifferenceCurve.Width:=round(regularizeForm.ClientWidth / 3);
end;

procedure TRegularizeForm.BitBtn1Click(Sender: TObject);
var
  i: integer;
  NewN: integer;
  dtStep, twt: double;
  newValue: double;
begin
  twt:=0;
  dtstep:=StrToFloat(StepTWTEdit.Text);
  NewN:=trunc(StrToFloat(MaxTWTEdit.Text) / dtstep)+1;
//  Unit1.DT.Splinepreregularization;
  RegulCurveSource.Clear;
  RegVINTSource.Clear;
  for i:=0 to NewN-1 do
          Case AlgoSelect.ItemIndex of
          0:
            Begin
              NewValue:=Unit1.DT.linint(twt);
              RegulCurveSource.add(NewValue,twt);
              twt:=twt+dtstep;
            end;
          1:
            Begin
              Unit1.DT.Splinepreregularization;
              NewValue:=Unit1.DT.SPLINT(DT.TWT,DT.TVDSRD,DT.TVDSRD_SD,DT.N,twt);
              if (twt < Unit1.DT.TWT[3]) or (twt > Unit1.DT.TWT[Unit1.DT.N-4]) then NewValue:=Unit1.DT.linint(twt);
              RegulCurveSource.add(NewValue,twt);
              twt:=twt+dtstep;
            end;
          End;
  RegVINTSource.Add(RegulCurveSource.Item[1]^.X/(RegulCurveSource.Item[1]^.Y/2000),0);
  for i:=1 to NewN-1 do RegVintSource.Add((RegulCurveSource.Item[i]^.X-RegulCurveSource.Item[i-1]^.X)/
  ((RegulCurveSource.Item[i]^.Y-RegulCurveSource.Item[i-1]^.Y)/2000),i*dtstep);
end;

procedure TRegularizeForm.BitBtn2Click(Sender: TObject);

begin
Unit1.MainForm.UpdateDTWithResampledDT(Unit1.Mainform);
RegularizeForm.Visible:=False;
end;

end.

