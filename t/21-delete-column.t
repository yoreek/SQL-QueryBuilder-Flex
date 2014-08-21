
use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 3;

my $package = 'SQL::QueryBuilder::Flex';
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
    $b->delete_column('name')->delete_column(qr/note/);
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT email FROM user u',
        'checking delete_column'
    ;
    is
        join(' ', @params),
        '',
        'checking delete_column params'
    ;
}

done_testing();
