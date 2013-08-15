
use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 2;

my $package = 'SQL::QueryBuilder';
use_ok($package);


{
    my $b = $package
        ->select('u.name')
        ->from('user', 'u')
        ->from('group', 'g')
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT u.name FROM user u, group g',
        'checking multi FROM'
    ;
}

done_testing();
