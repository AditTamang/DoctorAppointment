@echo off
echo Updating classpath...

REM Create a temporary file to store the new classpath
echo ^<?xml version="1.0" encoding="UTF-8"?^> > new_classpath.xml
echo ^<classpath^> >> new_classpath.xml
echo ^	^<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-17"^> >> new_classpath.xml
echo ^		^<attributes^> >> new_classpath.xml
echo ^			^<attribute name="maven.pomderived" value="true"/^> >> new_classpath.xml
echo ^		^</attributes^> >> new_classpath.xml
echo ^	^</classpathentry^> >> new_classpath.xml
echo ^	^<classpathentry kind="src" output="target/classes" path="src/main/java"^> >> new_classpath.xml
echo ^		^<attributes^> >> new_classpath.xml
echo ^			^<attribute name="optional" value="true"/^> >> new_classpath.xml
echo ^			^<attribute name="maven.pomderived" value="true"/^> >> new_classpath.xml
echo ^		^</attributes^> >> new_classpath.xml
echo ^	^</classpathentry^> >> new_classpath.xml
echo ^	^<classpathentry kind="con" path="org.eclipse.jst.server.core.container/org.eclipse.jst.server.tomcat.runtimeTarget/apache-tomcat-11.0.0-M22"^> >> new_classpath.xml
echo ^		^<attributes^> >> new_classpath.xml
echo ^			^<attribute name="owner.project.facets" value="jst.web"/^> >> new_classpath.xml
echo ^		^</attributes^> >> new_classpath.xml
echo ^	^</classpathentry^> >> new_classpath.xml
echo ^	^<classpathentry kind="con" path="org.eclipse.jst.j2ee.internal.web.container"/^> >> new_classpath.xml
echo ^	^<classpathentry kind="con" path="org.eclipse.jst.j2ee.internal.module.container"/^> >> new_classpath.xml

REM Add all JAR files in WEB-INF/lib to the classpath
for %%f in (src\main\webapp\WEB-INF\lib\*.jar) do (
    echo ^	^<classpathentry kind="lib" path="src/main/webapp/WEB-INF/lib/%%~nxf"/^> >> new_classpath.xml
)

echo ^	^<classpathentry excluding="**" kind="src" output="target/classes" path="src/main/resources"^> >> new_classpath.xml
echo ^		^<attributes^> >> new_classpath.xml
echo ^			^<attribute name="maven.pomderived" value="true"/^> >> new_classpath.xml
echo ^			^<attribute name="optional" value="true"/^> >> new_classpath.xml
echo ^		^</attributes^> >> new_classpath.xml
echo ^	^</classpathentry^> >> new_classpath.xml
echo ^	^<classpathentry kind="src" output="target/test-classes" path="src/test/java"^> >> new_classpath.xml
echo ^		^<attributes^> >> new_classpath.xml
echo ^			^<attribute name="optional" value="true"/^> >> new_classpath.xml
echo ^			^<attribute name="maven.pomderived" value="true"/^> >> new_classpath.xml
echo ^			^<attribute name="test" value="true"/^> >> new_classpath.xml
echo ^		^</attributes^> >> new_classpath.xml
echo ^	^</classpathentry^> >> new_classpath.xml
echo ^	^<classpathentry excluding="**" kind="src" output="target/test-classes" path="src/test/resources"^> >> new_classpath.xml
echo ^		^<attributes^> >> new_classpath.xml
echo ^			^<attribute name="maven.pomderived" value="true"/^> >> new_classpath.xml
echo ^			^<attribute name="test" value="true"/^> >> new_classpath.xml
echo ^			^<attribute name="optional" value="true"/^> >> new_classpath.xml
echo ^		^</attributes^> >> new_classpath.xml
echo ^	^</classpathentry^> >> new_classpath.xml
echo ^	^<classpathentry kind="con" path="org.eclipse.m2e.MAVEN2_CLASSPATH_CONTAINER"^> >> new_classpath.xml
echo ^		^<attributes^> >> new_classpath.xml
echo ^			^<attribute name="maven.pomderived" value="true"/^> >> new_classpath.xml
echo ^		^</attributes^> >> new_classpath.xml
echo ^	^</classpathentry^> >> new_classpath.xml
echo ^	^<classpathentry kind="output" path="target/classes"/^> >> new_classpath.xml
echo ^</classpath^> >> new_classpath.xml

REM Replace the old classpath with the new one
copy new_classpath.xml .classpath
del new_classpath.xml

echo Classpath updated successfully!
echo Please refresh your project in Eclipse (F5) and clean the project (Project -> Clean...).
