
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
        ->from('group')
        ->from('departament')
    ;
    $q->delete_from('group')->delete_from(qr/^depar/);
    my ($sql, @params) = $q->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u',
        'checking delete_from'
    ;
}

done_testing();
