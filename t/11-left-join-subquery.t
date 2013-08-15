
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
        ->left_join(
            $package
                ->select(
                    'group_id',
                    'group_name',
                )
                ->from('group')
            ,
            'g'
        )->using('group_id')->end
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u LEFT JOIN ( SELECT group_id, group_name FROM group ) AS g USING (group_id)',
        'checking FROM + LEFT JOIN + subquery'
    ;
}

done_testing();
