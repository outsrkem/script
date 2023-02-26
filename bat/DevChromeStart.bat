@title DevChrome
IF NOT EXIST %appdata%\chromeUser MKDIR %appdata%\chromeUser
C:
CD C:\Program Files\Google\Chrome\Application
chrome.exe --disable-web-security --user-data-dir=%appdata%\chromeUser --new-window https://www.baidu.com

::pause

