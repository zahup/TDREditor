unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  Grids, ComCtrls;

type

  { TTableForm }

  TTableForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure OnResize(Sender: TObject);
  private

  public

  end;

var
  TableForm: TTableForm;

implementation

{$R *.lfm}

{ TTableForm }

procedure TTableForm.OnResize(Sender: TObject);
begin
  stringgrid1.DefaultColWidth:=(Stringgrid1.Width-28) div 6;
end;

end.

