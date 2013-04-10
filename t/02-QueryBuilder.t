
use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 36;

my $package = 'SQL::QueryBuilder';
use_ok($package);

can_ok($package, qw/
	parent
	get_writer
	set_writer
	build
	do_build
	to_sql
	options
	select
	from
	where
	having
	group_by
	order_by
	order_by_asc
	order_by_desc
	limit
	offset
	inner_join
	left_join
	right_join
	clear_options
	clear_select
	clear_from
	clear_join
	clear_where
	clear_having
	clear_order_by
	clear_group_by
	delete_column
	delete_from
	delete_join
/);

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
		[ 'SUBSTRING(note, ?, ?)', 'note', 0, 10 ],
	)->from(
		'user', 'u'
	);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email, SUBSTRING(note, ?, ?) AS note FROM user u',
		'checking SELECT'
	;
	is
		join(' ', @params),
		'0 10',
		'checking SELECT params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->options('SQL_NO_CACHE', 'DISTINCT');
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT SQL_NO_CACHE DISTINCT name, email FROM user u',
		'checking SELECT options'
	;
}

{
	my $b = $package->new();
	$b->select(
		'u.name',
	)->from(
		'user', 'u'
	)->from(
		'group', 'g'
	);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT u.name FROM user u, group g',
		'checking multi FROM'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->inner_join('group')->using('group_id', 'departament_id');

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u INNER JOIN group USING (group_id, departament_id)',
		'checking INNER JOIN with USING'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->inner_join('group', 'g')
		->on->and('g.group_id = u.group_id')
			->and('g.group_id = u.departament_id');

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u INNER JOIN group g ON g.group_id = u.group_id AND g.group_id = u.departament_id',
		'checking INNER JOIN with ON'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->left_join('group')->using('group_id');

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u LEFT JOIN group USING (group_id)',
		'checking LEFT JOIN'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->right_join('group')->using('group_id');

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u RIGHT JOIN group USING (group_id)',
		'checking RIGHT JOIN'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->left_join('group')->using('group_id')
		->parent
	->left_join('departament')->using('departament_id');

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u LEFT JOIN group USING (group_id) LEFT JOIN departament USING (departament_id)',
		'checking LEFT JOIN + LEFT JOIN'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->from(
		$package->new()->select(
			'group_name',
		)->from(
			'group',
		),
		'g'
	);

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u, ( SELECT group_name FROM group ) AS g',
		'checking FROM + subquery'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->left_join(
		$package->new()->select(
			'group_id',
			'group_name',
		)->from(
			'group',
		),
		'g'
	)->using('group_id');

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u LEFT JOIN ( SELECT group_id, group_name FROM group ) AS g USING (group_id)',
		'checking FROM + LEFT JOIN + subquery'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->where->or('a = 1')
			->or('b > ?', 2);

	$b->where->and('c < ?', 3);

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u WHERE a = 1 OR b > ? AND c < ?',
		'checking WHERE'
	;
	is
		join(' ', @params),
		'2 3',
		'checking WHERE params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->where->or('a = 1')
			->or('b > ?', 2)
			->and(SQL::QueryBuilder::CondList->new
				->or('c != ?', 10)
				->or('c != ?', 12)
			);

	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u WHERE a = 1 OR b > ? AND ( c != ? OR c != ? )',
		'checking WHERE complex conditions'
	;
	is
		join(' ', @params),
		'2 10 12',
		'checking WHERE complex conditions params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->where->or('a = 1')
		->parent
	->having->or('b = 2');
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u WHERE a = 1 HAVING b = 2',
		'checking HAVING'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->group_by('name');
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u GROUP BY name',
		'checking GROUP BY'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->group_by('name', 'ASC');
	$b->group_by('email', 'DESC');
	$b->group_by('SUBTRING(note, 0, ?)', 'DESC', 10);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u GROUP BY name ASC, email DESC, SUBTRING(note, 0, ?) DESC',
		'checking GROUP BY complex'
	;
	is
		join(' ', @params),
		'10',
		'checking GROUP BY complex params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->order_by('name');
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u ORDER BY name',
		'checking ORDER BY'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->order_by_asc('name')->order_by('email', 'DESC')->order_by_desc('SUBSTRING(note, ?, ?)', 0, 10);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u ORDER BY name ASC, email DESC, SUBSTRING(note, ?, ?) DESC',
		'checking ORDER BY complex'
	;
	is
		join(' ', @params),
		'0 10',
		'checking ORDER BY complex params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->limit(0, 10);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u LIMIT ?, ?',
		'checking LIMIT'
	;
	is
		join(' ', @params),
		'0 10',
		'checking LIMIT params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->limit(10);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u LIMIT ?',
		'checking LIMIT 2'
	;
	is
		join(' ', @params),
		'10',
		'checking LIMIT 2 params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->limit(10)->offset(0);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u LIMIT ?, ?',
		'checking LIMIT + OFFSET'
	;
	is
		join(' ', @params),
		'0 10',
		'checking LIMIT + OFFSET params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->offset(0)->limit(1, 10);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u LIMIT ?, ?',
		'checking OFFSET + LIMIT'
	;
	is
		join(' ', @params),
		'1 10',
		'checking OFFSET + LIMIT params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
		[ 'SUBSTRING(note, ?, ?)', 'note', 0, 10 ],
	)->from(
		'user', 'u'
	);
	$b->delete_column('name')->delete_column(qr/note/);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT email FROM user u',
		'checking delete_column'
	;
	is
		join(' ', @params),
		'',
		'checking delete_column params'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from(
		'user', 'u'
	)->from(
		'group'
	)->from(
		'departament'
	);
	$b->delete_from('group')->delete_from(qr/^depar/);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u',
		'checking delete_from'
	;
}

{
	my $b = $package->new();
	$b->select(
		'name',
		'email',
	)->from('user', 'u'	)
	->left_join('group', 'g')->using('group_id')->parent
	->right_join('departament')->using('departament_id');
	$b->delete_join('g')->delete_join(qr/^depar/);
	my ($sql, @params) = $b->to_sql();
	is
		$sql,
		'SELECT name, email FROM user u',
		'checking delete_join'
	;
}

1;
