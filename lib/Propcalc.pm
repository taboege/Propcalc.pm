package Propcalc;

=head1 NAME

Propcalc - Propositional calculus

=head1 VERSION

This is Propcalc version 0.001.

=cut

our $VERSION = '0.001';

=head1 SYNOPSIS

    use Propcalc;
    
    my $fm = Propcalc::Formula->new('1|2->(3^4)=3');
    say $fm->rpn; # reverse polish notation
    #= 1 2 | 3 4 ^ > 3 =

=head1 DESCRIPTION

This module provides a Perl interface to L<libpropcalc|https://github.com/taboege/libpropcalc>,
a propositional calculus package written in C++ for the express purpose
of providing the basis of a Perl module for propositional calculus.

It is inspired by L<sagemath's propcalc|https://doc.sagemath.org/html/en/reference/logic/sage/logic/propcalc.html>
module and its parser accepts the same syntax, but Propcalc.pm aims to
include more gadgets like BDDs and SAT solvers.

=head1 AUTHOR

Tobias Boege <tobs@taboege.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (C) 2019 by Tobias Boege.

This is free software; you can redistribute it and/or modify it under the
same terms as the Perl 5 programming language system itself.

=cut

1;
