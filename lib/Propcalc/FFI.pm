package Propcalc::FFI;

=head1 NAME

Propcalc::FFI - verbatim libpropcalc

=head1 SYNOPSIS

    use Propcalc::FFI;
    
    say sprintf "%06x", Propcalc::FFI::version;
    #= 000001
    say Propcalc::FFI::formula_new("1&2|3")
    #= 94140690784576 + a memory leak

=cut

use Modern::Perl;
use utf8;

use FFI::Platypus 0.20;
use FFI::CheckLib qw(find_lib_or_die);
use FFI::Platypus::Memory qw(free);

=head1 DESCRIPTION

This module provides an FFI wrapper around the C interface in C<libpropcalc>
which is used to implement the other parts of this module.

You'll excuse that I don't document it thoroughly.

=cut

my $ffi = FFI::Platypus->new;
$ffi->lib(find_lib_or_die lib => 'propcalc');
$ffi->mangler(sub {
    "propcalc_" . shift
});

#
# General
#

$ffi->attach(version => [] => 'unsigned int');

#
# Formula
#

$ffi->custom_type(propform_t => {
    native_type    => 'opaque',
    native_to_perl => sub {
        my $class = 'Propcalc::Formula';
        bless \$_[0], $class
    },
    perl_to_native => sub {
        ${$_[0]}
    },
});

$ffi->attach(formula_new => ['string'] => 'propform_t');
$ffi->attach(formula_destroy => ['propform_t'] => 'void');

sub make_string {
    my $sub = shift;
    my $ptr = $sub->(@_);
    my $str = $ffi->cast('opaque' => 'string', $ptr);
    free $ptr;
    $str
}

$ffi->attach(formula_rpn => ['propform_t'] => 'opaque', \&make_string);
$ffi->attach(formula_pn  => ['propform_t'] => 'opaque', \&make_string);

$ffi->attach(formula_neg  => ['propform_t']               => 'propform_t');
$ffi->attach(formula_and  => ['propform_t', 'propform_t'] => 'propform_t');
$ffi->attach(formula_or   => ['propform_t', 'propform_t'] => 'propform_t');
$ffi->attach(formula_impl => ['propform_t', 'propform_t'] => 'propform_t');
$ffi->attach(formula_eqv  => ['propform_t', 'propform_t'] => 'propform_t');
$ffi->attach(formula_xor  => ['propform_t', 'propform_t'] => 'propform_t');

=head1 AUTHOR

Tobias Boege <tobs@taboege.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (C) 2019 by Tobias Boege.

This is free software; you can redistribute it and/or modify it under the
same terms as the Perl 5 programming language system itself.

=cut

1;
