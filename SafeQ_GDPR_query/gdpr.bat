@echo on
set PGPASSWORD=******
C:\SafeQ6\Management\PGSQL\bin\psql.exe --host=1.1.1.1 --port=5433 --username=postgres --dbname=SQDB6 --file=C:\Users\ajakubs\Desktop\SQL_query\safeq_rep_man_users.sql
C:\SafeQ6\Management\PGSQL\bin\psql.exe --host=1.1.1.1 --port=5433 --username=postgres --dbname=SQDB6 --file=C:\Users\ajakubs\Desktop\SQL_query\safeq_stats.sql