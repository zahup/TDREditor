unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, StrUtils;

type

  { TSaveForm }

  TSaveForm = class(TForm)
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    AvDTRData: TListBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    SaveDialog1: TSaveDialog;
    SelDTRData: TListBox;
    Header: TMemo;
    StaticText1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure RemoveData(Sender: TObject);
    procedure SelectData(Sender: TObject);
  private

  public

  end;

var
  SaveForm: TSaveForm;

implementation

{$R *.lfm}

{ TSaveForm }

uses Unit1;

procedure TSaveForm.SelectData(Sender: TObject);
begin
  SelDTRData.Items.Add(AvDTRData.Items[AvDTRData.ItemIndex]);
  avDTRData.Items.Delete(AvDTRData.ItemIndex);
end;

procedure TSaveForm.RemoveData(Sender: TObject);
begin
  avDTRData.Items.Add(SelDTRData.Items[SelDTRData.ItemIndex]);
  SelDTRData.Items.Delete(SelDTRData.ItemIndex);

end;

procedure TSaveForm.BitBtn1Click(Sender: TObject);
var
  i,j: integer;
  ExportDTRfile: TStringList;
  S: String;
  Prec, Digit, RLength: Integer;
begin
  If SelDTRData.Count > 0 then
  Begin
  If SaveDialog1.Execute then
     Begin
     TryStrToInt(LabeledEdit1.Text, Prec);
     TryStrToInt(LabeledEdit2.Text, Digit);
     TryStrToInt(LabeledEdit3.Text, RLength);
     ExportDTRFile:=TStringlist.Create;
     for i:=0 to Header.Lines.Count-1 do ExportDTRFile.Add(Header.Lines[i]);
     for j:=0 to Unit1.DT.N-1 do
     Begin
     S:='';
     for i:=0 to selDTRData.Items.Count-1 do
         Begin
         If SelDTRData.Items[i]='TVDSRD' Then S:=S+PadLeft(FloatToStrF(DT.TVDSRD[j],ffGeneral,Prec,Digit),RLength);
         If SelDTRData.Items[i]='TWT' Then S:=S+PadLeft(FloatToStrF(DT.TWT[j],ffGeneral,Prec,Digit),RLength);
         If SelDTRData.Items[i]='VAVG' Then S:=S+PadLeft(FloatToStrF(DT.VAVG[j],ffGeneral,Prec,Digit),RLength);
         If SelDTRData.Items[i]='VRMS' Then S:=S+PadLeft(FloatToStrF(DT.VRMS[j],ffGeneral,Prec,Digit),RLength);
         If SelDTRData.Items[i]='VINT' Then S:=S+PadLeft(FloatToStrF(DT.VINT[j],ffGeneral,Prec,Digit),RLength);
         end;
     ExportDTRFile.Add(S);
     end;
     ExportDTRFile.SaveToFile(SaveDialog1.FileName);
     ExportDTRFile.Free;
     SaveForm.Visible:=False;
     end;
  end
     else ShowMessage('Choose something to export!');
end;

end.

