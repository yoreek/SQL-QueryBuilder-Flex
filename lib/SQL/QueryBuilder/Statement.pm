package SQL::QueryBuilder::Statement;

use strict;
use warnings;
use SQL::QueryBuilder::Writer;
use Scalar::Util qw(weaken);

sub new {
	my ($class, @options) = @_;

	my $self = bless {
		parent  => undef,
		_writer => undef,
		@options,
	}, $class;

	weaken( $self->{parent} );

	return $self;
}

sub parent {
	my ($self) = @_;
	return $self->{parent};
}

sub get_writer {
	my ($self) = @_;
	return $self->{_writer} ||= SQL::QueryBuilder::Writer->new();
}

sub set_writer {
	my ($self, $writer) = @_;
	$self->{_writer} = $writer;
	return;
}

sub build {
	my ($self, $writer, $indent) = @_;
	if ($writer) {
		$self->set_writer($writer);
	}
	else {
		$writer = $self->get_writer();
		$writer->clear();
	}
	$self->do_build($writer, $indent);
	return;
}

sub do_build {
	die "Not implemented";
}

sub to_sql {
	my ($self, $indent) = @_;
	$self->build();
	my $writer = $self->get_writer();
	return $writer->to_sql($indent), $writer->get_params();
}

1;
