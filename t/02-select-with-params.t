
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
            [ 'SUBSTRING(note, ?, ?)', 'note', 0, 10 ],
        )
        ->from('user', 'u')
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email, SUBSTRING(note, ?, ?) AS note FROM user u',
        'checking SELECT'
    ;
    is
        join(' ', @params),
        '0 10',
        'checking SELECT params'
    ;
}

1;
