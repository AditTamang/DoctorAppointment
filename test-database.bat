@echo off
echo This script will test the database connection when run in a Java environment.
echo Please run this script in an environment where Java is installed.

set CLASSPATH=src/main/webapp/WEB-INF/lib/*;src/main/java
echo.
echo NOTE: The DatabaseTest utility has been removed.
echo To test database connection, please use the application's built-in functionality.
echo You can start the application and check if it connects to the database successfully.
echo.

pause
