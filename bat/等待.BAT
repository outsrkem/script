::下面这条命令会等待10秒，并且可以按任意键跳过等待

TIMEOUT /T 10

::下面这条命令会等待300秒，并且只能按下CTRL+C来跳过

TIMEOUT /T 300 /NOBREAK

::下面这条命令会持续等待，直到你按下任意按键.功能类似于pause

TIMEOUT /T -1

::下面这条命令会持续等待，直到你按下CTRL+C按键

TIMEOUT /T -1 /NOBREAK