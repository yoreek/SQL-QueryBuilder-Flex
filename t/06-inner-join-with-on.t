
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
        ->inner_join('group', 'g')
            ->on
                ->and('g.group_id = u.group_id')
                ->and('g.group_id = u.departament_id')
        ->get_query
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u INNER JOIN group g ON g.group_id = u.group_id AND g.group_id = u.departament_id',
        'checking INNER JOIN with ON'
    ;
}

done_testing();
