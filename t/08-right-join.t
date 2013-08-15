
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
        ->right_join('group')->using('group_id')->end
    ;
    my ($sql, @params) = $b->to_sql();
    is
        $sql,
        'SELECT name, email FROM user u RIGHT JOIN group USING (group_id)',
        'checking RIGHT JOIN'
    ;
}

done_testing();
