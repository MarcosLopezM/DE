#import "@preview/typsidian:0.0.3": *
#show: typsidian.with(
  theme: "light",
  title: "Learning SQL",
  author: "Marcos",
)

#make-title()

= Introduction to SQL

#term("Relational databases")[

  A relational database represents a collection of related (two-dimensional) tables.
]

== SELECT queries

To retrieve data from a SQL database, we need to write *SELECT* statements, which are
often referred to as _queries_. A query is just a statement which declares what data we
are looking for, where to find it in the database, and optionally, how to transform it
before it is returned.

Given a table of data, the most basic query we could write would be one that selects for
a couple of columns of the table with all the rows.


```sql
  SELECT column, another_column, ...
  FROM mytable;
```

The result of this query will be a two-dimensional set of rows and columns, but only
with the columns that we requested.

If we want to retrieve absolutely all the columns of ata from a table, we can then use
the asterisk (#c("*")) shorthand in place of listing all the column name individually.

```sql
SELECT *
FROM mytable;
```

== Queries with constraints

In order to filter certain results from being returned, we nee to use a #c("WHERE")
clause in the query. The clause is applied to each row of data by checking specific
column values to determine whether it should be included in the results or not.

```sql
SELECT colum, another_column, ...
FROM mytable
WHERE condition
    AND/OR another_condition
    AND/OR ...;
```

More complex clauses can be constructed by joining numerous #c("AND") or #c("OR")
logical keywords. Below are some useful operator that you can use for numerical data:


#table(
  columns: (auto, auto, auto),
  align: horizon,
  table.header([*Operator*], [*Condtion*], [*SQL Example*]),
  [#c("=, !=, <, <=, >, >=")], [Standard numerical operators], [#c("col_name != 4")],
  [#c("BETWEEN ...") \ #c("AND ...")],
  [Number is within a range of two values
    (inclusive)],
  [#c("col_name BETWEEN 1.5 AND 10.5")],

  [#c("NOT BETWEEN ...") \ #c("... AND ...")],
  [Number is not withing range of two
    values],
  [#c("col_name NOT BETWEEN 1 AND 10")],

  [#c("IN (...)")], [Number exists in a list], [#c("col_name IN (2, 4, 6)")],
  [#c("NOT IN (...)")], [Number does not exist in a list], [#c("col_name NOT IN (1, 3, 5)")],
)

When writing #c("WHERE") clauses with columns containing text data, SQL supports a
number of useful operators to do thing like case-insensitive string comparison and
wildcard pattern matching.


#table(
  columns: (auto, auto, auto),
  align: horizon,
  table.header([*Operator*], [*Condtion*], [*SQL Example*]),
  [#c("=")], [Case sensitive exact string comparison], [#c("col_name = 'abc'")],
  [#c("!= or <>")], [Case sensitive exact string inequality comparison], [#c("col_name != 'abcd'")],

  [#c("LIKE")], [Case insensitive exact string comparison], [#c("col_name LIKE 'ABC'")],
  [#c("NOT LIKE")], [Case insensitive exact string inequality comparison], [#c("col_name
    NOT LIKE 'ABCD'")],
  [#c("%")], [Used anywhere in a string to match a sequence of zero or more characters], [#c("col_name LIKE '%AT%'")],
  [#c("_")], [Used anywhere in a string to match a single character], [#c("col_name LIKE
    'AN_'")],
  [#c("IN (...)")], [String exists in a list], [#c("col_name IN ('A', 'B', 'C')")],
  [#c("NOT IN (...)")], [String does not exist in a list], [#c("col_name NOT IN ('D', 'E', 'F')")],
)

== Filtering and sorting query results

Even though the data in a database may be unique, the results of any particular query
may not be. In such cases, SQL provides a convenient way to discard rows that have a
duplicate column value by using the ``DISTINCT`` keyword.

```sql
SELECT DISTINCT column, another_column, ...
FROM mytable
WHERE condition(s);
```

#box(
  [
    Since the ``DISTINCT`` keyword will blindly remove duplicate rows, we will learn in a
    future lesson how to discard duplicates based on specific columns using grouping and
    the ``GROUP BY`` clause.
  ],
  theme: "info",
)

=== Ordering results

SQL provides a way to sort your results by a given column in ascending or descending
order using the ``ORDER BY`` clause.

```sql
SELECT column, another_column, ...
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC;
```

=== Limiting results to a subset

Another clause which is commonly used with the ``ORDER BY`` clause are the ``LIMIT`` and
``OFFSET`` clauses, which are a useful optimization to indicate to the database the
subset of the results you care about.
The ``LIMIT`` will reduce the number of rows to return, and the optional ``OFFSET`` will
specify where to begin counting the number rows from.

```sql
SELECT column, another_column, ...
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

== Multi-table queries with JOINs

We've been working with a single table, but entity data in the real world is often
broken down into pieces and stored across multiple orthogonal tables using a process
known as _normalization_.

=== Database normalization

Database normalization is useful because it minimizes duplicate data in any single
table, and allows for data in the database to grow independently of each other. As a
trade-off, queries get slightly more complex since they have to be able to find data
from different parts of the database, and performance issues can arise when working with
many large tables.

=== Multi-table queries with JOINs

Tables that share information about a single entity need to have a _primary key_ that
identifies that entity _uniquely_ across the database. One common primary key type is an
auto-incrementing integer, but it can also be a string, hashed value, so long as it is unique.

Using the ``JOIN`` clause in a query, we can combine row data across two separate table
using this unique key. The first of the joins is the *INNER JOIN*:

```sql
SELECT column, another_table_column, ...
FROM mytable
INNER JOIN another_table
  ON mytable.id = another_table.id
WHERE condition(s)
ORDER BY column, ... ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

The *INNER JOIN* is a process that matches rows from the first table and the second
table which have the same key (as defined by the ``ON`` constraint) to create a result
row with the combined columns from both tables. After the tables are joined, the other
clauses we learned previously are then applied.

== OUTER JOINs

Sometimes *INNER JOIN* might not be sufficient because the resulting table only contains
data that belongs in both of the tables.

If the two tables have asymmetric data, then we would have to use *LEFT JOIN, RIGHT
JOIN* or *FULL JOIN* instead to ensure that the data you need is not left out of the
results.

```sql
SELECT column, another_column, …
FROM mytable
INNER/LEFT/RIGHT/FULL JOIN another_table
    ON mytable.id = another_table.matching_id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

Like the *INNER JOIN* these three new joins have to specify which column to join the
data on.
When joining table A to table B, a *LEFT JOIN* simply includes rows from A regardless
whether a matching row is found in B. The *RIGHT JOIN* is the same, but reversed,
keeping rows in B regardless of whether a match is found in A. Finally, a *FULL JOIN*
simply means that rows from both tables are kept, regardless of whether a matching row
exists in the other table.

#box(
  [
    We might see queries with these joins written a *LEFT OUTER JOIN*, *RIGHT OUTER JOIN*,
    or *FULL OUTER JOIN*, but the *OUTER* keyword is really kept for SQL-92 compatibility.
  ],
  theme: "highlight",
)

== A short note on NULLs

It's always good to reduce the possibility of *NULL* values in databases because they
require special attention when constructing queries, constraints (certain functions
behave differently with  null values) and when processing the results.

An alternative to *NULL* values in your database is to have *data-type appropriate
default values*, like 0 for numerical data, empty strings for text data, etc. But if
your database needs to store incomplete data, then *NULL* values can be appropriate if
the default values will skew later analysis.

Sometimes, it's also not possible to avoid *NULL* values. In these cases, you can test a
column for *NULL* values in a *WHERE* clause by using *IS NULL* or *IS NOT NULL*
constraint.

```sql
SELECT column, another_column, …
FROM mytable
WHERE column IS/IS NOT NULL
AND/OR another_condition
AND/OR …;
```

== Queries with expressions

In addition to querying and referencing raw column data with SQL, you can also use
_expressions_ to write more complex logic on column values in a query. These expressions
can use mathematical and string functions along with basic arithmetic to transform
values when querying is executed, as shown in this physics example.

```sql
SELECT particle_speed / 2.0 AS half_particle_speed
FROM physics_data
WHERE ABS(particle_position) * 10.0 > 500;
```

#box(
  [
    Each database has its own supported set of mathematical, string, and date functions
    that can be use in a query.
  ],
  theme: "important",
)

The use of expressions can save time and extra post-processing of the result data, but
can also make the query harder to read, so we recommend that when expressions are used
in the *SELECT* part of the query, you assign a descriptive _alias_ using the *AS* keyword.

#c(
  "
    SELECT col_expression AS expr_description, …
    FROM mytable;
  ",
  lang: "sql",
)

In addition to expressions, regular columns and even tables can also have aliases to
make them easier to reference in the output and as a part of simplifying more complex queries.

#c(
  "
    SELECT column AS better_column_name, …
    FROM a_long_widgets_table_name AS mywidgets
    INNER JOIN widget_sales
      ON mywidgets.id = widget_sales.widget_id;
  ",
  lang: "sql",
)

== Queries with aggregates

SQL also supports the use of aggregate expressions (or functions) that allow you to
summarize information about a group of rows of data.

```sql
SELECT AGG_FUNC(column_or_expression) AS aggregate_description, ...
FROM mytable
WHERE constraint_expression;
```

Without a specified grouping, each aggregate function is going to run on the whole set
of result rows and return a single value. And like normal expressions, giving your
aggregate functions an alias ensures that the results will be easier to read and process.

=== Common aggregate functions


#table(
  columns: (auto, auto),
  align: horizon,
  table.header([*Function*], [Description]),
  [#c("COUNT(*)", lang: "sql") \ #c("COUNT(column)", lang: "sql")],
  [A common function
    use to count the number of rows in the group if no column name is specified.
    Otherwise, count the number of rows in the group with non-NULL values in the specified
    column.],

  [#c("MIN(column)", lang: "sql")],
  [Finds the smallest numerical value in the specified
    column for all rows in the group.],

  [#c("MAX(column)", lang: "sql")],
  [Finds the largest numerical value in the specified
    column for all rows in the group.],

  [#c("AVG(column)", lang: "sql")],
  [Finds the average numerical value in the specified
    column for all rows in the group.],

  [#c("SUM(column)", lang: "sql")],
  [Finds the sum of all numerical values in the specified
    column for the rows in the group.],
)

=== Grouped aggregate functions

Instead of the default behavior of aggregate functions, you can instead apply them to
individual groups of data within that group.
This would then create as many results as there are unique groups defined as by the
*GROUP BY* clause.

```sql
SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
FROM mytable
WHERE constraint_expression
GROUP BY column;
```

#note([The #c("GROUP BY", lang: "sql") clause works by grouping rows that have the same
  value in the column specified.])

=== *HAVING* clause

The *HAVING* clause is used specifically with the *GROUP BY* clause to allow us to
filter grouped rows from the result set.

```sql
SELECT group_by_column, AGG_FUNC(column_expression) AS aggregate_result_alias, …
FROM mytable
WHERE condition
GROUP BY column
HAVING group_condition;
```

The clause constraints are written the same way as the *WHERE* clause constraints, and
are applied to the grouped rows.

== Order of execution of a query

Each query begins with finding the data that we need in a database, and then filtering
that data down into something that can be processed and understood as quickly as
possible. Because each part of the query is executed sequentially, it's important to
understand the order of execution so that you know what result are accessible where.

```sql
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;
```

=== Query order of execution

1. *FROM* and *JOIN* s

The *FROM* clause and subsequent *JOIN* s are first executed to determine the total
working set of data that is being queried. This includes subqueries in this clause and
can cause temporary tables to be created under the hood containing all the columns and
rows of the tables being joined.

2. *WHERE*

Once we have the total working data, the first-pass *WHERE* constraints are applied to
the individual rows and rows that do not satisfy the constraint are discarded. Each of
the constraints can only access columns directly from the tables requested in the *FROM*
clause. Aliases in the *SELECT* part of the query are not accessible in most databases
since they may include expressions dependent on parts of the query that haven not yet
executed.

3. *GROUP BY*

The remaining rows after the *WHERE* constraints are applied and then grouped based on
common values in the column specified in the *GROUP BY* clause. As a result of the
grouping, there will only be as many rows as there are unique values in that column.
Implicitly, this means that you should only need to use this when you have aggregate
function in your query.

4. *HAVING*

If the query ha a *GROUP BY* clause, then the constraints in the *HAVING* clause are
then applied to the grouped rows, discard the grouped rows that don't satisfy this
constraint. Like the *WHERE* clause, aliases are not accessible from this step in most databases.

5. *SELECT*

Any expressions in the *SELECT* part of the query are finally computed.

6. *DISTINCT*

Of the remaining rows with duplicate values in the column marked as *DISTINCT* will be
discarded.

7. *ORDER BY*

If an order is specified by the *ORDER BY* clause, the rows are then sorted by the
specified data in either ascending or descending order. Since all the expressions in the
*SELECT* part of the query have been computed, you can reference aliases in this clause.

8. *LIMIT*\/*OFFSET*

Finally, the rows that fall outside the range specified by the *LIMIT* and *OFFSET* are
discarded, leaving the final set of rows to be returned from the query.
