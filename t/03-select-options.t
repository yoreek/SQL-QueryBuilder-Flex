
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
        ->options('SQL_NO_CACHE', 'DISTINCT')
    ;
    my ($sql, @params) = $q->to_sql();
    is
        $sql,
        'SELECT DISTINCT SQL_NO_CACHE name, email FROM user u',
        'checking SELECT options'
    ;
}

done_testing();
