
use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 2;

my $package = 'SQL::QueryBuilder';
use_ok($package);

{
    my $b = $package
        ->select(
            'name',
            'email',
        )
        ->from('user', 'u')
        ->left_join('group')->using('group_id')->end
        ->left_join('departament')->using('departament_id')->end
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u LEFT JOIN group USING (group_id) LEFT JOIN departament USING (departament_id)',
        'checking LEFT JOIN + LEFT JOIN'
    ;
}

done_testing();