package Propcalc::Formula;

use Modern::Perl;
use utf8;

use Propcalc::FFI;

sub new {
    my ($class, $str) = @_;
    my $fm = Propcalc::FFI::formula_new $str;
    bless [$fm], $class
}

sub rpn {
    Propcalc::FFI::formula_rpn shift->[0]
}

sub pn {
    Propcalc::FFI::formula_pn shift->[0]
}

sub DESTROY {
    Propcalc::FFI::formula_destroy shift->[0]
}

1;
