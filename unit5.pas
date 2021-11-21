unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, LCLIntf;

type

  { THelpForm }

  THelpForm = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    StaticText1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private

  public

  end;

var
  HelpForm: THelpForm;

implementation

{$R *.lfm}

{ THelpForm }

procedure THelpForm.BitBtn1Click(Sender: TObject);
begin
  HelpForm.Visible:=False;
end;

procedure THelpForm.Label2Click(Sender: TObject);
var
  found: boolean;
begin
  found:=OpenURL('http://www.peter.zahuczki.hu');
end;

end.

