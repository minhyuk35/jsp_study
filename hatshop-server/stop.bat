@echo off
chcp 65001 > nul
cd /d "%~dp0"
set CATALINA_HOME=%~dp0tomcat

if defined JAVA_HOME goto :stop

for %%P in (
  "C:\Program Files\Java\jdk-21"
  "C:\Program Files\Java\jdk-21.0.5"
  "C:\Program Files\Java\jdk-17"
  "C:\Program Files\Eclipse Adoptium\jdk-21.0.5.11-hotspot"
  "C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot"
  "C:\Program Files\Microsoft\jdk-21.0.5.11-hotspot"
  "D:\Android\tools\jdk-21.0.5+11"
) do (
  if exist %%P\bin\java.exe (
    set JAVA_HOME=%%P
    goto :stop
  )
)

:stop
echo Tomcat 종료 중...
call "%CATALINA_HOME%\bin\shutdown.bat"
echo 종료 완료.
pause
