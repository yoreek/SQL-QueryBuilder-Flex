
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
        ->from(
            $package
                ->select('group_name')
                ->from('group')
            ,
            'g'
        )
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u, ( SELECT group_name FROM group ) AS g',
        'checking FROM + subquery'
    ;
}

done_testing();
