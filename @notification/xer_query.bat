@echo off
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%
echo %ldt%
set PGPASSWORD=C}Az}W166],J{n
for /f %%i in ('C:\SafeQ5\PGSQL\bin\psql.exe --host=localhost --port=5433 --username=postgres --dbname=SQDB5 -A -F";" --file=C:\@notification\xer_query.sql') do set XER_Q_VAR=%%i
IF %XER_Q_VAR% lss 42 @C:\@notification\sendEmail.exe -f notification@test.pl -t ajakubs@test.pl -s 1.1.1.1:25 -u "Xerox - problem with synchronization" -m "W dniu %ldt%, wykryto znacznie mniejszona ilosc uzytkownikow: %XER_Q_VAR% po synchronizacji, zalecamy sprawdzenie statusu synchronizacji!"