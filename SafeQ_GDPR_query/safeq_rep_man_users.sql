DELETE FROM dwhtenant_1.safeq_rep_man_users
WHERE (DATE_PART('year', localtimestamp) - year) > 2