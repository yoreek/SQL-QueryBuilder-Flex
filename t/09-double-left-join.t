
use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 2;

my $package = 'SQL::QueryBuilder::Flex';
use_ok($package);

{
    my $b = $package
        ->select(
            'name',
            'email',
        )
        ->from('user', 'u')
        ->left_join('group')->using('group_id')
        ->left_join('departament')->using('departament_id')
        ->get_query
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u LEFT JOIN group USING (group_id) LEFT JOIN departament USING (departament_id)',
        'checking LEFT JOIN + LEFT JOIN'
    ;
}

done_testing();
