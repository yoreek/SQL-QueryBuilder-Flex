
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
        ->options('SQL_NO_CACHE', 'DISTINCT')
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT SQL_NO_CACHE DISTINCT name, email FROM user u',
        'checking SELECT options'
    ;
}

done_testing();
