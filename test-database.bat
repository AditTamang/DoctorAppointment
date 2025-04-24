@echo off
echo This script will test the database connection when run in a Java environment.
echo Please run this script in an environment where Java is installed.

set CLASSPATH=src/main/webapp/WEB-INF/lib/*;src/main/java
java com.doctorapp.util.DatabaseTest

pause
