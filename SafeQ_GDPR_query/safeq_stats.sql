DELETE FROM dwhtenant_1.safeq_stats
WHERE (DATE_PART('year', localtimestamp) - DATE_PART('year', date)) > 2