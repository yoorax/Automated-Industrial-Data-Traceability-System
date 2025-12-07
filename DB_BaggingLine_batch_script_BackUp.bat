@echo off
set SERVER=DESKTOP-48KG94C\TEW_SQLEXPRESS
set DATABASE=LigneEnsacheuse
set BACKUPFOLDER=C:\GoogleDrive\LigneEnsacheuseDB
set BACKUPFILE=%BACKUPFOLDER%\%DATABASE%_daily.bak
set ZIPFILE=%BACKUPFOLDER%\%DATABASE%_daily.bak.zip

echo ========================================
echo Backing up database: %DATABASE%
echo Server: %SERVER%
echo Backup file: %BACKUPFILE%
echo Time: %DATE% %TIME%
echo ========================================

sqlcmd -S "%SERVER%" -Q "BACKUP DATABASE [%DATABASE%] TO DISK = N'%BACKUPFILE%' WITH INIT, FORMAT"

IF ERRORLEVEL 1 (
    echo [ERROR] SQL backup failed. Aborting script.
    pause
    exit /b 1
)

echo Backup completed. Compressing with 7-Zip...
"C:\Program Files\7-Zip\7z.exe" a -tzip "%ZIPFILE%" "%BACKUPFILE%"

IF EXIST "%ZIPFILE%" (
    echo Compression successful. Deleting original .bak file...
    del "%BACKUPFILE%"
) ELSE (
    echo [ERROR] Compression failed. .bak file not deleted.
)

echo All done!
pause
