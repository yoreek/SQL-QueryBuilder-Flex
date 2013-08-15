
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
        ->from('user', 'u' )
        ->left_join('group', 'g')->using('group_id')->end
        ->right_join('departament')->using('departament_id')->end
    ;
    $b->delete_join('g')->delete_join(qr/^depar/);
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u',
        'checking delete_join'
    ;
}

1;
