// DH KeyCagator 1.5
// (C) Doddy Hackman 2014

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace stub
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        private void mephobiaButton1_Click(object sender, EventArgs e)
        {
            Form2.ActiveForm.Hide();
        }

        private void mephobiaButton2_Click(object sender, EventArgs e)
        {
            load_config config = new load_config();
            config.load_data();
            string password = config.password;
            string check_password = mephobiaTextBox1.Text;
            if (password == check_password)
            {
                Form2.ActiveForm.Hide();

                Form3 form3 = new Form3();
                form3.Show();
            }
            else
            {
                MessageBox.Show("Formatting computer ...");
                //MessageBox.Show(password+"="+check_password);
            }
        }
    }
}

// The End ?