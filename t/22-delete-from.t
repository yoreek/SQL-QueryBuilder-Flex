
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
        ->from('group')
        ->from('departament')
    ;
    $b->delete_from('group')->delete_from(qr/^depar/);
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u',
        'checking delete_from'
    ;
}

done_testing();
