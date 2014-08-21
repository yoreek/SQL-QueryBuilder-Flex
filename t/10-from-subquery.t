
use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 1;

use SQL::QueryBuilder::Flex 'Q';

{
    my $q = Q
        ->select(
            'name',
            'email',
        )
        ->from('user', 'u')
        ->from(
            Q
                ->select('group_name')
                ->from('group')
            ,
            'g'
        )
    ;
    my ($sql, @params) = $q->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u, ( SELECT group_name FROM group ) AS g',
        'checking FROM + subquery'
    ;
}

done_testing();
