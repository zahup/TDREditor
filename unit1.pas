unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  ComCtrls, ExtDlgs, TAGraph, TASources, TASeries, DTR, TACustomSource,
  TAChartExtentLink, TATools, TADAtaTools, TAChartUtils, TACustomSeries, Types,
  Unit2, Unit3, Unit4, Unit5, Unit6, Grids;

type

  { TMainForm }

  TMainForm = class(TForm)
    ChartExtentLink1: TChartExtentLink;
    DTRTools: TChartToolset;
    DTRToolsDataPointClickTool1: TDataPointClickTool;
    DTRToolsDataPointCrosshairTool1: TDataPointCrosshairTool;
    DTRToolsDataPointDragTool1: TDataPointDragTool;
    DTRToolsDataPointHintTool1: TDataPointHintTool;
    DTRToolsPanDragTool1: TPanDragTool;
    DTRToolsUserDefinedTool1: TUserDefinedTool;
    DTRToolsZoomDragTool1: TZoomDragTool;
    LoadRefTDR: TSpeedButton;
    LoadMarkers: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SavePictureDialog1: TSavePictureDialog;
    SaveTDR: TSpeedButton;
    Options: TSpeedButton;
    Help: TSpeedButton;
    NewTDR: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Regularize: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    VAVGToolsDataPointHintTool1: TDataPointHintTool;
    VINTToolsDataPointHintTool1: TDataPointHintTool;
    VRMSLine: TLineSeries;
    VINTTools: TChartToolset;
    ShowTable: TSpeedButton;
    StatusBar1: TStatusBar;
    VAVGTools: TChartToolset;
    VAVGToolsDataPointClickTool1: TDataPointClickTool;
    VAVGToolsDataPointCrosshairTool1: TDataPointCrosshairTool;
    VAVGToolsDataPointDragTool1: TDataPointDragTool;
    VAVGToolsPanDragTool1: TPanDragTool;
    VAVGToolsUserDefinedTool1: TUserDefinedTool;
    VAVGToolsZoomDragTool1: TZoomDragTool;
    DTRListSource: TListChartSource;
    VINTListSource: TListChartSource;
    VINTToolsDataPointClickTool1: TDataPointClickTool;
    VINTToolsDataPointCrosshairTool1: TDataPointCrosshairTool;
    VINTToolsDataPointDragTool1: TDataPointDragTool;
    VINTToolsPanDragTool1: TPanDragTool;
    VINTToolsUserDefinedTool1: TUserDefinedTool;
    VINTToolsZoomDragTool1: TZoomDragTool;
    VRMSListSource: TListChartSource;
    VAVGListSource: TListChartSource;
    Panel2: TPanel;
    TVDSRDChart: TChart;
    TVDSRDLine: TLineSeries;
    VAVGLine: TLineSeries;
    VINTLine: TLineSeries;
    VAVGChart: TChart;
    VINTChart: TChart;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    OpenDTR: TSpeedButton;
    procedure AfterDragPointTVDSRD(ATool: TChartTool; APoint: TPoint);
    procedure AfterDragPointVINT(ATool: TChartTool; APoint: TPoint);
    procedure DTRAddNewPointTool(ATool: TChartTool; APoint: TPoint);
    procedure HelpClick(Sender: TObject);
    procedure LoadRefTDRClick(Sender: TObject);
    procedure NewTDRClick(Sender: TObject);
    procedure OnHint(ATool: TDataPointHintTool; const APoint: TPoint;
      var AHint: String);
    procedure OnTVDSRDHint(ATool: TDataPointHintTool; const APoint: TPoint;
      var AHint: String);
    procedure OnVINTHint(ATool: TDataPointHintTool; const APoint: TPoint;
      var AHint: String);
    procedure OptionsClick(Sender: TObject);
    procedure RegularizeClick(Sender: TObject);
    procedure SaveTDRClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure VAVGAddNewPointTool(ATool: TChartTool; APoint: TPoint);
    procedure AfterDragPointVAVG(ATool: TChartTool; APoint: TPoint);
    procedure DeletePointClick(ATool: TChartTool; APoint: TPoint);
    procedure OnFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure OnFormCreate(Sender: TObject);
    procedure OnFormResize(Sender: TObject);
    procedure OpenDTRClick(Sender: TObject);
    procedure ShowTableClick(Sender: TObject);
    Procedure UpdateTable;
    Procedure UpdateChartSources;
    procedure VINTAddNewPointTool(ATool: TChartTool; APoint: TPoint);
  private

  public
    procedure ChangeRefTDRLineWidth(Sender: TObject);
    Procedure ChangeRefTDRLineColor(Sender: TObject);
    Procedure ChangeRefTDRLineStyle(Sender: TObject);
    Procedure DeleteRefTDRLines(Sender: TObject);
    Procedure UpdateDTWithResampledDT(Sender: TObject);
  end;

var
  MainForm: TMainForm;
  DT: TDTR;
  refDT: TDTR;
  refCount: Integer;
  DTRexist: boolean;
  refDTExist: boolean;
implementation

{$R *.lfm}

{ TMainForm }

Procedure TMainForm.UpdateChartSources;
var
  i: integer;
Begin
DTRListSource.Clear;
VAVGListSource.Clear;
VRMSListSource.Clear;
VINTListSource.Clear;
for i:=0 to DT.N-1 do
    Begin
     DTRListSource.Add(DT.TVDSRD[i], DT.TWT[i]);
     VAVGListSource.Add(DT.VAVG[i], DT.TWT[i]);
     VRMSListSource.Add(DT.VRMS[i],DT.TWT[i]);
     VINTListSource.Add(DT.VINT[i],DT.TWT[i]);
    end;

end;

procedure TMainForm.VINTAddNewPointTool(ATool: TChartTool; APoint: TPoint);
var
  DP: TDoublePoint;
  i:integer;
  AIndex:integer;
begin
  DP:=VINTChart.ImageToGraph(APoint);
  for i:=0 to DT.N-2 do if (DT.TWT[i] < DP.Y) and (DT.TWT[i+1]>DP.Y) Then AIndex:=i;
  DT.VINTAddPointAfter(AIndex,DP.X,DP.Y);
  UpdateTable;
  UpdateChartSources;

end;

Procedure TMainForm.UpdateTable;
var
  i: integer;
Begin
TableForm.Stringgrid1.RowCount:=DT.N+1;
for i:=0 to DT.N-1 do with TableForm.StringGrid1 do
    Begin
      Cells[0,i+1]:=IntToStr(i);
      Cells[1,i+1]:=FloatToStrF(DT.TWT[i],ffGeneral,6,2);
      Cells[2,i+1]:=FloatToStrF(DT.TVDSRD[i],ffGeneral,6,2);
      Cells[3,i+1]:=FloatToStrf(DT.VAVG[i], ffgeneral,6,2);
      Cells[4,i+1]:=FloatToStrf(DT.VRMS[i],ffGeneral,6,2);
      Cells[5,i+1]:=FloatToStrf(DT.VINT[i],ffGeneral,6,2);
    end;
end;

procedure TMainForm.OpenDTRClick(Sender: TObject);
begin
  If OpenDialog1.Execute then
     Begin
       if DTRExist=True Then DT.Free;
       DT:=TDTR.Create(OpenDialog1.FileName);
       DT.LoadFromTXT(OpenDialog1.FileName);
       DT.UpdateDTRPostLoad;
       Caption:=OpenDialog1.Filename;
       UpdateChartSources;
       UpdateTable;
       DTRExist:=True;
     end;
end;

procedure TMainForm.ShowTableClick(Sender: TObject);
begin
  Tableform.visible:=True;
end;

procedure TMainForm.OnFormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
//  DT.Free;
end;

procedure TMainForm.DeletePointClick(ATool: TChartTool; APoint: TPoint);
begin
  with ATool as TDatapointClickTool do
      if (Series is TLineSeries) then
         Begin
         DTRListSource.Delete(PointIndex);
         VAVGListSource.Delete(PointIndex);
         VRMSListSource.Delete(PointIndex);
         VINTListSource.Delete(PointIndex);
         DT.DeletePoint(PointIndex);
         DT.UpdateDTR;
         UpdateTable;
         UpdateChartSources;
         end;
end;

procedure TMainForm.AfterDragPointVAVG(ATool: TChartTool; APoint: TPoint);
var
  i: integer;
begin
for i:=0 to VAVGListSource.Count-1 do
    Begin
     DT.VAVG[i]:=VAVGListSource[i]^.X;
     DT.TWT[i]:=VAVGListSource[i]^.Y;
    end;
    DT.UpdateByVAVG;
    UpdateTable;
    UpdateChartSources;
end;

procedure TMainForm.VAVGAddNewPointTool(ATool: TChartTool; APoint: TPoint);
var
  DP: TDoublePoint;
  i:integer;
  AIndex:integer;
begin
  DP:=VAVGChart.ImageToGraph(APoint);
  for i:=0 to DT.N-2 do if (DT.TWT[i] < DP.Y) and (DT.TWT[i+1]>DP.Y) Then AIndex:=i;
  DT.VAVGAddPointAfter(AIndex,DP.X,DP.Y);
  UpdateTable;
  UpdateChartSources;
end;

procedure TMainForm.AfterDragPointVINT(ATool: TChartTool; APoint: TPoint);
var
  i:integer;
begin
  for i:=0 to VINTListSource.Count-1 do
      Begin
       DT.VINT[i]:=VINTListSource[i]^.X;
       DT.TWT[i]:=VINTListSource[i]^.Y;
      end;
      DT.UpdateByVINT;
      UpdateTable;
      UpdateChartSources;
end;

procedure TMainForm.DTRAddNewPointTool(ATool: TChartTool; APoint: TPoint);
var
  DP: TDoublePoint;
  i:integer;
  AIndex:integer;
begin
  DP:=TVDSRDChart.ImageToGraph(APoint);
  for i:=0 to DT.N-2 do if (DT.TWT[i] < DP.Y) and (DT.TWT[i+1]>DP.Y) Then AIndex:=i;
  DT.DTRAddPointAfter(AIndex,DP.X,DP.Y);
  UpdateTable;
  UpdateChartSources;
end;

procedure TMainForm.HelpClick(Sender: TObject);
begin
  Unit5.HelpForm.Visible:=True;
end;

procedure TMainForm.LoadRefTDRClick(Sender: TObject);
var
  i,j: integer;
  refTVDSRDLine: TLineSeries;
  refTVDSRDSource: TListChartSource;
  refVAVGLine: TLineSeries;
  refVAVGSource: TListChartSource;
  refVINTLine: TLineSeries;
  refVINTSource: TListChartSource;
begin
  If OpenDialog1.Execute then
     Begin
       for i:=0 to Opendialog1.Files.Count-1 do
       Begin
       refDT:=TDTR.Create(OpenDialog1.Files.Strings[i]);
       refDT.LoadFromTXT(OpenDialog1.Files.Strings[i]);
       refDT.UpdateDTRPostLoad;
       refTVDSRDLine:=TLineSeries.Create(MainForm);
       refVAVGLine:=TLineSeries.Create(MainForm);
       refVINTLine:=TLineSeries.Create(MainForm);
       refTVDSRDSource:=TListChartSource.Create(MainForm);
       refVAVGSource:=TListChartSource.Create(MainForm);
       refVINTSource:=TListChartSource.Create(MainForm);
       refCount:=refCount+1;
       with refTVDSRDLine do
           Begin
           Name:='ref_TVDSRD_'+IntToStr(refCount);
           Source:=refTVDSRDSource;
           SeriesColor:=ClSilver;
           ZPosition:=i+1;
           ShowInLegend:=False;
           end;
       with refVAVGLine do
           Begin
           Name:='ref_VAVG_'+IntToStr(refCount);
           Source:=refVAVGSource;
           SeriesColor:=clSilver;
           ZPosition:=i+1;
           ShowInLegend:=False;
           end;
       with refVINTLine do
           Begin
           Name:='ref_VINT_'+IntToStr(refCount);
           Source:=refVINTSource;
           LineType:=ltStepXY;
           SeriesColor:=clSilver;
           ZPosition:=i+1;
           ShowInLegend:=False;
           end;
       for j:=0 to refDT.N-1 do
           Begin
           refTVDSRDSource.Add(refDT.TVDSRD[j],refDT.TWT[j]);
           refVAVGSource.Add(refDT.VAVG[j], refDT.TWT[j]);
           refVINTSource.Add(refDT.VINT[j], refDT.TWT[j]);
           end;
       TVDSRDChart.AddSeries(refTVDSRDLine);
       VAVGChart.AddSeries(refVAVGLine);
       VINTChart.AddSeries(refVINTLine);
       refDT.Free;
       end;
     end;
end;

procedure TMainForm.NewTDRClick(Sender: TObject);
begin
If DTRExist=True then DT.Free;
DT:=TDTR.Create('Unknown');
DT.N:=2;
SetLength(DT.TVDSRD,2);
SetLength(DT.TWT,2);
DT.TVDSRD[0]:=0;
DT.TWT[0]:=0;
DT.TVDSRD[1]:=2000;
DT.TWT[1]:=1500;
DT.HasDepth:=True;
DT.HasTWT  :=True;
DT.UpdateDTR;
UpdateChartSources;
UpdateTable;
With VAVGChart.Extent do
    Begin
     XMin:=1000;
     XMax:=6000;
     UseXMin:=True;
     UseXMax:=True;

    end;
end;

procedure TMainForm.OnHint(ATool: TDataPointHintTool; const APoint: TPoint;
  var AHint: String);
begin
  AHint:= FloatToStrF(DT.VAVG[ATool.PointIndex], ffGeneral,6,2)+' m/s , '
  +FloatToStrF(DT.TWT[ATool.PointIndex],ffGeneral,6,2)+' ms';
  If Unit2.TableForm.Visible then
  With Unit2.TableForm.StringGrid1 do
      Begin
       Row:=ATool.PointIndex+1;
       Selection:=TGridRect(Rect(0,1,1,1));
       SetFocus;
      end;
end;

procedure TMainForm.OnTVDSRDHint(ATool: TDataPointHintTool;
  const APoint: TPoint; var AHint: String);
begin
AHint:= FloatToStrF(DT.TVDSRD[ATool.PointIndex], ffGeneral,6,2)+' m , '
+FloatToStrF(DT.TWT[ATool.PointIndex],ffGeneral,6,2)+' ms';
  If Unit2.TableForm.Visible then
  With Unit2.TableForm.StringGrid1 do
      Begin
       Row:=ATool.PointIndex+1;
       Selection:=TGridRect(Rect(0,1,1,1));
       SetFocus;
      end;
end;

procedure TMainForm.OnVINTHint(ATool: TDataPointHintTool; const APoint: TPoint;
  var AHint: String);
begin
    AHint:= FloatToStrF(DT.VINT[ATool.PointIndex], ffGeneral,6,2)+' m/s , '
  +FloatToStrF(DT.TWT[ATool.PointIndex],ffGeneral,6,2)+' ms';
  If Unit2.TableForm.Visible then
  With Unit2.TableForm.StringGrid1 do
      Begin
       Row:=ATool.PointIndex+1;
       Selection:=TGridRect(Rect(0,1,1,1));
       SetFocus;
      end;
end;

procedure TMainForm.OptionsClick(Sender: TObject);
begin
  Unit4.SettingsForm.Visible:=True;
end;

procedure TMainForm.RegularizeClick(Sender: TObject);
begin
  If Unit6.RegularizeForm.TDRorVAVG.ItemIndex=0 then
  Unit6.RegularizeForm.OriginalCurveL.Source:=DTRListSource else
  Unit6.RegularizeForm.OriginalCurveL.Source:=VAVGListSource;
//  Unit6.RegularizeForm.MaxTWTEdit.Caption:=IntToStr(trunc(DT.TWT[DT.N-1] / StrToFloat(Unit6.RegularizeForm.StepTWTEdit.Text))*
//           StrToInt(Unit6.RegularizeForm.StepTWTEdit.Text));
Unit6.RegularizeForm.MaxTWTEdit.Caption:=FloattoStr(trunc(DT.TWT[DT.N-1]));
Unit6.RegularizeForm.RegulCurveSource.Clear;
Unit6.RegularizeForm.RegVINTSource.Clear;
Unit6.RegularizeForm.Visible:=True;
end;

procedure TMainForm.SaveTDRClick(Sender: TObject);
begin
Unit3.SaveForm.Visible:=True;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
    bmp: TBitmap;
    Arect,destrect: TRect;
    pic: TPicture;
begin
if savepicturedialog1.Execute then
Begin
bmp:=TBitmap.Create;
pic:=TPicture.Create;
bmp.Width:=Panel2.width;
bmp.Height:=Panel2.Height;
ARect := Rect(panel1.width,0,MainForm.ClientWidth,MainForm.ClientHeight-Statusbar1.Height);
destrect:=Rect(0,0,bmp.Width,bmp.Height);
bmp.Canvas.CopyRect(destrect,MainForm.Canvas,Arect);
pic.Bitmap:=bmp;
pic.SaveToFile(SavePictureDialog1.FileName);
bmp.Free;
pic.free;
Showmessage('Image saved!');
end
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  TVDSRDChart.Width:=Panel2.Width div 3;
  VINTChart.Width:=Panel2.Width div 3;
end;

procedure TMainForm.AfterDragPointTVDSRD(ATool: TChartTool; APoint: TPoint);
var
  i: integer;
begin
  for i:=0 to DTRListSource.Count-1 do
      Begin
       DT.TVDSRD[i]:=DTRListSource[i]^.X;
       DT.TWT[i]:=DTRListSource[i]^.Y;
      end;
      DT.UpdateDTR;
      UpdateTable;
      UpdateChartSources;
end;

Procedure TMainForm.OnFormCreate(Sender: TObject);
Begin
  TVDSRDChart.Width:=Panel2.Width div 3;
  VINTChart.Width:=Panel2.Width div 3;
 Statusbar1.Panels[0].Width:=Splitter1.Left;
 Statusbar1.Panels[1].Width:=Splitter2.Left-Splitter1.Left;
 refDTExist:=False;
 DTRExist:=False;
 refCount:=0;
 TVDSRDChart.Title.Text.Clear;
 VAVGChart.Title.Text.Clear;
 VINTChart.Title.Text.Clear;
 TVDSRDLine.Title:='TVDSRD[m] vs. TWT[ms]';
 VAVGLine.Title:='VAVG[m/s] vs. TWT[ms]';
 VRMSLine.Title:='VRMS[m/s] vs. TWT[ms]';
 VINTLine.Title:='VINT[m/s] vs. TWT[ms]';
end;

procedure TMainForm.OnFormResize(Sender: TObject);
begin
end;

Procedure TMainForm.ChangeRefTDRLineWidth(Sender: TObject);
var
  i: integer;
  activeSeries: TLineSeries;
Begin
  for i := 0 to TMainForm(Self).ComponentCount-1 do
    if TMainForm(Self).Components[i] is tlineseries then
           Begin
              activeSeries:=Findcomponent(tMainForm(Self).Components[i].name) as TLineSeries;
              if Assigned(activeSeries) then
                    Begin
                    If POS('ref_',ActiveSeries.Name)>0 then activeSeries.LinePen.Width:=SettingsForm.ChartComboBox6.PenWidth;
                    end;

           end;
end;

Procedure TMainForm.ChangeRefTDRLineColor(Sender: TObject);
var
  i: integer;
  activeSeries: TLineSeries;
Begin
  for i := 0 to TMainForm(Self).ComponentCount-1 do
    if TMainForm(Self).Components[i] is tlineseries then
           Begin
              activeSeries:=Findcomponent(tMainForm(Self).Components[i].name) as TLineSeries;
              if Assigned(activeSeries) then
                    Begin
                    If POS('ref_',ActiveSeries.Name)>0 then activeSeries.LinePen.Color:=SettingsForm.Colorbox3.Selected;
                    end;

           end;
end;

Procedure TMainForm.ChangeRefTDRLineStyle(Sender: TObject);
var
  i: integer;
  activeSeries: TLineSeries;
Begin
  for i := 0 to TMainForm(Self).ComponentCount-1 do
    if TMainForm(Self).Components[i] is tlineseries then
           Begin
              activeSeries:=Findcomponent(tMainForm(Self).Components[i].name) as TLineSeries;
              if Assigned(activeSeries) then
                    Begin
                    If POS('ref_',ActiveSeries.Name)>0 then activeSeries.LinePen.Style:=SettingsForm.ChartCombobox5.PenStyle;
                    end;

           end;
end;

Procedure TMainForm.DeleteRefTDRLines(Sender: TObject);
var
  i: integer;
  activeSeries: TLineSeries;
Begin
i:=0;
Repeat
  if TMainForm(Self).Components[i] is tlineseries then
         Begin
            activeSeries:=Findcomponent(tMainForm(Self).Components[i].name) as TLineSeries;
            if Assigned(activeSeries) then
                  Begin
                  If POS('ref_',ActiveSeries.Name)>0 then
                        Begin
                        ActiveSeries.Free;
                        i:=i-1;
                        end;
                  end;
         end;
    i:=i+1;
until i=TMainForm(Self).ComponentCount-1;
refCount:=0;
end;

Procedure TMainForm.UpdateDTWithResampledDT(Sender: TObject);
var
  i: integer;
Begin
DT.N:=Unit6.RegularizeForm.RegulCurveSource.Count-1;
SetLength(DT.TVDSRD, DT.N);
SetLength(DT.TWT, DT.N);
SetLength(DT.VAVG, DT.N);
SetLength(DT.VINT, DT.N);
SetLength(DT.VRMS, DT.N);
SetLength(DT.VAVG_SD, DT.N);
SetLength(DT.TVDSRD_SD, DT.N);
for i:=0 to Unit6.RegularizeForm.RegulCurveSource.Count-1 do
        Begin
          DT.TVDSRD[i]:=Unit6.RegularizeForm.RegulCurveSource.Item[i]^.X;
          DT.TWT[i]:=Unit6.RegularizeForm.RegulCurveSource.Item[i]^.Y;
        end;
DT.HasDepth:=True;
DT.HasTWT:=True;
DT.HasVel:=False;
DT.UpdateDTRPostLoad;
UpdateTable;
UpdateChartSources;
end;

end.

