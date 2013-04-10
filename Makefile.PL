# Makefile.PL for SQL::QueryBuilder.
#
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.
# Copyright 2013 Yuriy Ustushenko, all rights reserved.

use 5.008008;
use warnings;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME          => 'SQL::QueryBuilder',
	VERSION_FROM  => 'lib/SQL/QueryBuilder.pm',
	ABSTRACT_FROM => 'lib/SQL/QueryBuilder.pm',
	AUTHOR        => 'Yuriy Ustushenko <yoreek@yahoo.com>',
	LICENSE       => "perl",
	PREREQ_PM     => {
		'List::Util'   => 0,
		'Scalar::Util' => 0,
		'Test::More'   => 0,
	},
);
