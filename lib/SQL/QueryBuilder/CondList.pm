package SQL::QueryBuilder::CondList;

use strict;
use warnings;
use base 'SQL::QueryBuilder::Statement';

sub new {
    my ($class, @options) = @_;
    my $self = $class->SUPER::new(
        _conditions => [],
        @options,
    );
    return $self;
}

sub is_empty {
    my ($self) = @_;
    return scalar(@{ $self->{_conditions} }) ? 0 : 1;
}

sub or {
    my ($self, $condition, @params) = @_;

    # Create instance if this method has been called directly
    if (!ref $self) {
        $self = __PACKAGE__->new;
    }

    push @{ $self->{_conditions} }, [ 'OR', $condition, @params ];
    return $self;
}

sub or_list {
    my ($self) = @_;
    my $new_cond_list = __PACKAGE__->new(parent => $self);
    push @{ $self->{_conditions} }, [ 'OR', $new_cond_list ];
    return $new_cond_list;
}

sub or_in {
    my ($self, $name, @params) = @_;

    unless (scalar @params) {
        return $self->or('0');
    }

    my $condition = $name .' IN('. join(',', ('?') x @params) .')';

    return $self->or($condition, @params);
}

sub and {
    my ($self, $condition, @params) = @_;

    # Create instance if this method has been called directly
    if (!ref $self) {
        $self = __PACKAGE__->new;
    }

    push @{ $self->{_conditions} }, [ 'AND', $condition, @params ];
    return $self;
}

sub and_list {
    my ($self) = @_;
    my $new_cond_list = __PACKAGE__->new(parent => $self);
    push @{ $self->{_conditions} }, [ 'AND', $new_cond_list ];
    return $new_cond_list;
}

sub and_in {
    my ($self, $name, @params) = @_;

    unless (scalar @params) {
        return $self->and('0');
    }

    my $condition = $name .' IN('. join(',', ('?') x @params) .')';

    return $self->and($condition, @params);
}

sub do_build {
    my ($self, $writer, $indent) = @_;

    $indent ||= 0;

    my $is_first = 1;
    foreach my $aItem (@{ $self->{_conditions} }) {
        my ($op, $condition, @params) = @$aItem;
        if (ref $condition) {
            next if $condition->is_empty();
            my $str = $is_first ? '(' : join(' ', $op, '(');
            $writer->write($str, $indent);
            $condition->build($writer, $indent + 1);
            $writer->write(')', $indent);
        }
        else {
            my $str = $is_first ? $condition : join(' ', $op, $condition);
            $writer->write($str, $indent);
            $writer->add_params(@params);
        }
        undef $is_first;
    }

    return;
}

1;
