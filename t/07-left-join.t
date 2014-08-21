
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
        ->left_join('group')->using('group_id')
        ->get_query
    ;
    my ($sql, @params) = $q->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u LEFT JOIN group USING (group_id)',
        'checking LEFT JOIN'
    ;
}

done_testing();
