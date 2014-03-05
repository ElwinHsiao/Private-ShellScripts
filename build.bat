@echo off
set pkgName=librarystudyapk
set usrlibName=LibraryStudyApk
set androidLib=D:\PROGRA~1\Android_SDK\platforms\android-15\android.jar

rd /s /q gen bin
mkdir gen bin

echo generate R.java
	aapt p -x -m -f -J gen -M AndroidManifest.xml -S res -I %androidLib%
echo compile java
 	javac -target 1.6 -source 1.6 -d bin -bootclasspath %androidLib% src\com\example\%pkgName%\*.java gen\com\example\%pkgName%\*.java
echo convert to classes.dex
	pause
 	::dx --dex --verbose --output="D:\Eclipse_workspace\%usrlibName%\bin\classes.dex" "D:\Eclipse_workspace\%usrlibName%\bin"
echo compile res to apk
 	aapt p -x -f -F bin\%pkgName%.apk -v -u -z -M AndroidManifest.xml -S res -A assets -I %androidLib%
echo add .dex to apk
 	aapt add -k bin\%usrlibName%.apk bin\classes.dex
echo sign apk
 	cd /d "F:\Setup\develop\android反编译\签名APK\系统签名"
 	java -jar signapk.jar platform.x509.pem platform.pk8 D:\Eclipse_workspace\%usrlibName%\bin\%usrlibName%.apk D:\Eclipse_workspace\%usrlibName%\bin\%usrlibName%-s.apk
	cd /d D:\Eclipse_workspace\%usrlibName%
echo create lib apk
	cp bin\%usrlibName%.apk bin\%usrlibName%_full_class.apk
	::"C:\Program Files\WinRAR\rar" bin\%usrlibName%_full_class.apk
push library
	adb push D:\Eclipse_workspace\%usrlibName%\bin\%usrlibName%-s.apk /system/framework/%usrlibName%.apk
	adb shell chmod 644 /system/framework/%usrlibName%.apk
	::adb shell chown 0.0 /system/framework/%usrlibName%.apk
	
pause