
use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 3;

my $package = 'SQL::QueryBuilder';
use_ok($package);

{
    my $b = $package
        ->select(
            'name',
            'email',
        )
        ->from('user', 'u')
        ->where
            ->or('a = 1')
            ->or('b > ?', 2)
            ->end
    ;
    $b->where->and('c < ?', 3);
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u WHERE a = 1 OR b > ? AND c < ?',
        'checking WHERE'
    ;
    is
        join(' ', @params),
        '2 3',
        'checking WHERE params'
    ;
}

done_testing();
