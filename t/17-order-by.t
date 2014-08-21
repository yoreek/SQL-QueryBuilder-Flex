
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
        ->order_by('name')
    ;
    my ($sql, @params) = $q->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u ORDER BY name',
        'checking ORDER BY'
    ;
}

done_testing();
