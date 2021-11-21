unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ColorBox,
  TAStyles, TAChartCombos, TASeries;

type

  { TSettingsForm }

  TSettingsForm = class(TForm)
    Button1: TButton;
    ChartComboBox1: TChartComboBox;
    ChartComboBox2: TChartComboBox;
    ChartComboBox3: TChartComboBox;
    ChartComboBox5: TChartComboBox;
    ChartComboBox6: TChartComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    ColorBox3: TColorBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ChangeCharttitle(Sender: TObject);
    procedure OnBackgroundTDRStyleChange(Sender: TObject);
    procedure OnBackgroundTDRWidthChange(Sender: TObject);
    procedure OnChartTitleChange(Sender: TObject);
    procedure OnRefTDRineColorChange(Sender: TObject);
    procedure OnShowGridChange(Sender: TObject);
    procedure OnShowLegendChange(Sender: TObject);
    procedure OnTDRColorCange(Sender: TObject);
    procedure OnTDRLineStyleChange(Sender: TObject);
    procedure OnTDRMarkerChange(Sender: TObject);
    procedure OnTDRMarkerColorChange(Sender: TObject);
    procedure OnTDRMarkerSizeChange(Sender: TObject);
    procedure OnTDRWidthChange(Sender: TObject);
    procedure OnVRMSLineChange(Sender: TObject);
  private

  public

  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.lfm}

{ TSettingsForm }
uses unit1;

procedure TSettingsForm.OnTDRColorCange(Sender: TObject);
begin
Unit1.MainForm.TVDSRDLine.SeriesColor:=ColorBox1.Selected;
Unit1.MainForm.VAVGLine.SeriesColor:=ColorBox1.Selected;
Unit1.MainForm.VINTLine.SeriesColor:=ColorBox1.Selected;
end;

procedure TSettingsForm.OnBackgroundTDRWidthChange(Sender: TObject);
begin
MainForm.ChangeRefTDRLineWidth(Self);
end;

procedure TSettingsForm.OnChartTitleChange(Sender: TObject);
begin
  MainForm.VAVGChart.Title.Text.Clear;
  MainForm.TVDSRDChart.Title.Text.Clear;
  MainForm.VINTChart.Title.Text.Clear;
  MainForm.VAVGChart.Title.Text.Add(Edit1.Text);
  MainForm.TVDSRDChart.Title.Text.Add(' ');
  MainForm.VINTChart.Title.Text.Add(' ');
end;

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  MainForm.DeleteRefTDRLines(Self);
end;

procedure TSettingsForm.ChangeCharttitle(Sender: TObject);
begin
  If Checkbox2.Checked then
     Begin
       MainForm.TVDSRDChart.Title.Visible:=True;
       MainForm.VAVGChart.Title.Visible:=True;
       MainForm.VINTChart.Title.Visible:=True;
     End Else
     Begin
     MainForm.TVDSRDChart.Title.Visible:=False;
     MainForm.VAVGChart.Title.Visible:=False;
     MainForm.VINTChart.Title.Visible:=False;
     end;
end;

procedure TSettingsForm.OnBackgroundTDRStyleChange(Sender: TObject);
begin
  MainForm.ChangeRefTDRLineStyle(Self);
end;

procedure TSettingsForm.OnRefTDRineColorChange(Sender: TObject);
begin
MainForm.ChangeRefTDRLineColor(Self);
end;

procedure TSettingsForm.OnShowGridChange(Sender: TObject);
begin
  If CheckBox4.Checked then
     Begin
     Unit1.MainForm.TVDSRDChart.BottomAxis.Grid.Visible:=True;
     Unit1.MainForm.TVDSRDChart.LeftAxis.Grid.Visible:=True;
     Unit1.MainForm.VAVGChart.BottomAxis.Grid.Visible:=True;
     Unit1.MainForm.VAVGChart.LeftAxis.Grid.Visible:=True;
     Unit1.MainForm.VINTChart.BottomAxis.Grid.Visible:=True;
     Unit1.MainForm.VINTChart.LeftAxis.Grid.Visible:=True;
     end
  Else
     Begin
     Unit1.MainForm.TVDSRDChart.BottomAxis.Grid.Visible:=False;
     Unit1.MainForm.TVDSRDChart.LeftAxis.Grid.Visible:=False;
     Unit1.MainForm.VAVGChart.BottomAxis.Grid.Visible:=False;
     Unit1.MainForm.VAVGChart.LeftAxis.Grid.Visible:=False;
     Unit1.MainForm.VINTChart.BottomAxis.Grid.Visible:=False;
     Unit1.MainForm.VINTChart.LeftAxis.Grid.Visible:=False;
     end;
end;

procedure TSettingsForm.OnShowLegendChange(Sender: TObject);
begin
  If CheckBox3.Checked then
     Begin
      Unit1.MainForm.TVDSRDChart.Legend.Visible:=True;
      Unit1.MainForm.VAVGChart.Legend.Visible:=True;
      Unit1.MainForm.VINTChart.Legend.Visible:=True;
     end
     Else
     Begin
     Unit1.MainForm.TVDSRDChart.Legend.Visible:=False;
     Unit1.MainForm.VAVGChart.Legend.Visible:=False;
     Unit1.MainForm.VINTChart.Legend.Visible:=False;
     end;
end;

procedure TSettingsForm.OnTDRLineStyleChange(Sender: TObject);
begin
Unit1.MainForm.TVDSRDLine.LinePen.Style:=ChartComboBox1.PenStyle;
Unit1.MainForm.VAVGLine.LinePen.Style:=ChartComboBox1.PenStyle;
Unit1.MainForm.VINTLine.LinePen.Style:=ChartComboBox1.PenStyle;

end;

procedure TSettingsForm.OnTDRMarkerChange(Sender: TObject);
begin
Unit1.MainForm.TVDSRDLine.Pointer.Style:=ChartComboBox3.PointerStyle;
Unit1.MainForm.VAVGLine.Pointer.Style:=ChartCombobox3.PointerStyle;
Unit1.MainForm.VINTLine.Pointer.Style:=ChartCombobox3.PointerStyle;

end;

procedure TSettingsForm.OnTDRMarkerColorChange(Sender: TObject);
begin
Unit1.MainForm.TVDSRDLine.Pointer.Pen.Color:=Colorbox2.Selected;
Unit1.MainForm.VAVGLine.Pointer.Pen.Color:=Colorbox2.Selected;
Unit1.MainForm.VINTLine.Pointer.Pen.Color:=Colorbox2.Selected;

end;

procedure TSettingsForm.OnTDRMarkerSizeChange(Sender: TObject);
begin
Unit1.MainForm.TVDSRDLine.Pointer.HorizSize:=StrToInt(ComboBox1.Text);
Unit1.MainForm.TVDSRDLine.Pointer.VertSize:=StrToInt(ComboBox1.Text);
Unit1.MainForm.VAVGLine.Pointer.HorizSize:=StrToInt(ComboBox1.Text);
Unit1.MainForm.VAVGLine.Pointer.VertSize:=StrToInt(ComboBox1.Text);
Unit1.MainForm.VINTLine.Pointer.HorizSize:=StrToInt(ComboBox1.Text);
Unit1.MainForm.VINTLine.Pointer.VertSize:=StrToInt(ComboBox1.Text);

end;

procedure TSettingsForm.OnTDRWidthChange(Sender: TObject);
begin
Unit1.MainForm.TVDSRDLine.LinePen.Width:=ChartComboBox2.PenWidth;
Unit1.MainForm.VAVGLine.LinePen.Width:=ChartComboBox2.PenWidth;
Unit1.MainForm.VINTLine.LinePen.Width:=ChartComboBox2.PenWidth;
end;

procedure TSettingsForm.OnVRMSLineChange(Sender: TObject);
begin
  If Checkbox1.Checked= True then Unit1.MainForm.VRMSLine.Active:=True else
    Unit1.MainForm.VRMSLine.Active:=False;
end;

end.

