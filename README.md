## It works!
In the other branch, I tried using Ancestry to store a materialized path system that can be fetched in order in constant time. However, it failed (spectacularly), and I had to implement my own solution.

Unfortunately, the solution is *not* database-agnostic. Even if I could rewrite the triggers into MySQL-compliant version, the model relies on a Postgres-only feature: array columns. In fact, there are *two* array columns (both of type `int[]`) to allow sorting by new *and* old!

This is notable, because most (all?) materialized path solutions either doesn't allow you to order by path, or only allows ordering in one direction, wherein sorting by the other direction *really* messes things up.

The reason I can sort both ways is because I'm using the said `int[]` columns as the path instead of the usual string. And by storing "positive" values in one path and "negative" values in the other (see the migration files for details), I can sort both ways in a way that is suitable for a threaded/nested comment system!

Also, the performance (at least for seeding) is noticeably faster than the Ruby-based solution. YMMV.
