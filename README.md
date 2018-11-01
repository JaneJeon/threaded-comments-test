## Postmortem
In this experiment, I've tried to use Ancestry (which uses materialized paths) for storing a threaded/nested comment system, as I wanted a system where you could paginate comments in constant time.

However, a couple of things fell short:
- The paths do not contain the record's `id`, meaning that the top-level (think head of the tree) records had the same `ancestry` value. This is undesirable for my needs, as I need to be able to sort by path to retrieve comments
- The gem builds the path literally just by sticking the raw `id` at the end of the parent's `ancestry` value. And that means I can't sort comments by `ancestry`. For example, suppose there are two replies to comment #1: #2 and #10. While I would like the ordering to be #1 -> #2 -> #10, the gem returns #1 -> #10 -> #2, as `1` < `1/10` < `1/2`.
