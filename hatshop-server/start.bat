@echo off
chcp 65001 > nul
cd /d "%~dp0"
set CATALINA_HOME=%~dp0tomcat

echo ================================================
echo   HATSHOP 서버 시작
echo ================================================

:: 시스템 JAVA_HOME 이미 설정되어 있으면 그대로 사용
if defined JAVA_HOME goto :start

:: JDK 자동 탐색 (설치 경로 공통 후보)
for %%P in (
  "C:\Program Files\Java\jdk-21"
  "C:\Program Files\Java\jdk-21.0.5"
  "C:\Program Files\Java\jdk-17"
  "C:\Program Files\Java\jdk-17.0.0"
  "C:\Program Files\Eclipse Adoptium\jdk-21.0.5.11-hotspot"
  "C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot"
  "C:\Program Files\Microsoft\jdk-21.0.5.11-hotspot"
  "C:\Program Files\Microsoft\jdk-17.0.9.8-hotspot"
  "D:\Android\tools\jdk-21.0.5+11"
) do (
  if exist %%P\bin\java.exe (
    set JAVA_HOME=%%P
    goto :start
  )
)

echo [오류] JDK를 찾을 수 없습니다.
echo   JDK 17 이상을 설치하거나 JAVA_HOME 환경변수를 수동으로 설정하세요.
echo   예) set JAVA_HOME=C:\Program Files\Java\jdk-21
pause
exit /b 1

:start
echo JDK 경로: %JAVA_HOME%
echo Tomcat  : %CATALINA_HOME%
echo.
call "%CATALINA_HOME%\bin\startup.bat"
echo.
echo 서버 시작 완료!
echo 브라우저에서 http://localhost:8080/hatshop 접속하세요.
echo (처음 시작 시 WAR 배포 때문에 10~20초 걸릴 수 있습니다)
echo.
pause
