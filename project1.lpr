program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, tachartlazaruspkg, DTR, Unit2, Unit3, Unit4, Unit5, Unit6
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTableForm, TableForm);
  Application.CreateForm(TSaveForm, SaveForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(THelpForm, HelpForm);
  Application.CreateForm(TRegularizeForm, RegularizeForm);
  Application.Run;
end.

