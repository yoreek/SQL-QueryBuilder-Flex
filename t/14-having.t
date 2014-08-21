
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
        ->where('a = 1')
        ->having->or('b = 2')
        ->get_query
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u WHERE a = 1 HAVING b = 2',
        'checking HAVING'
    ;
}

done_testing();
