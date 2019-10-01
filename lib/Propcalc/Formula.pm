package Propcalc::Formula;

=head1 NAME

Propcalc::Formula - Propositional formula

=head1 SYNOPSIS

    use Propcalc::Formula;
    
    # Variables are numbers from 1..N
    my $fm = Propcalc::Formula->new('1|2->(3^4)=3');
    say $fm->rpn; # reverse polish notation
    #= 1 2 | 3 4 ^ > 3 =
    
    # Symbolic variables are supported in brackets
    my $fm = Propcalc::Formula->new('[12|]&[12|3]->[13|]|[23|]');
    say $fm->pn; # polish notation
    #= > & [12|] [12|3] | [13|] [23|]

=cut

use Modern::Perl;
use utf8;

use Propcalc::FFI;

=head1 DESCRIPTION

A Propcalc::Formula object represents a propositional formula,
internally stored as a syntax tree. It can be created by parsing
a string representation in infix notation.

=head2 Formula syntax

A propositional formula is a well-formed infix expression involving

=over

=item B<constants> C<\T> and C<\F> for truth and falsehood.
(Yes, including the leading backslash.)

=item B<variables> which are plain integers of magnitude at least 1.
C<0> denotes an invalid variable number.

=item B<symbolics> which are arbitrary strings between square brackets,
such as C<[12|3]>, or alphanumeric strings outside of square brackets,
such as C<xyz123>, which act as variables. Use these when your variables
have a non-linear structure and it is inconvenient to map them to numbers
at the application level.

=item B<operators> in order of precedence:

=over

=item Negation: C<~> (unary, right-hand side operand, tightest precedence level 1)

=item Conjunction: C<&> (binary, right-associative, precedence level 2)

=item Disjunction: C<|> (binary, right-associative, precedence level 3)

=item Implication: C<< -> >> or C<< > >> (binary, right-associative, precedence level 4)

=item Equivalence: C<< <-> >> or C<=> (binary, right-associative, loosest precedence level 5)

=item Contravalence: C<^> (binary, right-associative, loosest precedence level 5)

=back

=item B<parentheses> and B<whitespace> as usual.

=back

This syntax is compatible with the one understood by L<sage.logic.propcalc|https://doc.sagemath.org/html/en/reference/logic/sage/logic/propcalc.html>
which inspired this module. When rendering the formula to a string,
symolics are always written using square brackets and the shorter
alternatives for Implication and Equivalence, which are B<not>
sage-compatible, are preferred.

=cut

=head2 Overloaded operators

The following operators are overloaded for C<Propcalc::Formula>:

=over

=item C<~$f>: negation of C<$f>

=item C<$f & $g>: conjunction of C<$f> and C<$g>

=item C<$f | $g>: disjunction of C<$f> and C<$g>

=item C<<< $f >> $g >>>: implication of C<$f> to C<$g>

=item C<< $f <=> $g >>: equivalence of C<$f> and C<$g>

=item C<$f ^ $g>: contravalence of C<$f> and C<$g>

=back

TODO: Stringification (infix), Boolification (SAT),
Numification (#SAT), Iterating (AllSAT). All of them
naïvely truth-table based.

=cut

use overload
    '~'   => \&_neg,
    '&'   => \&_and,
    '|'   => \&_or,
    '>>'  => \&_impl,
    '<=>' => \&_eqv,
    '^'   => \&_xor,
;

sub _neg  { Propcalc::FFI::formula_neg  @_ }
sub _and  { Propcalc::FFI::formula_and  @_ }
sub _or   { Propcalc::FFI::formula_or   @_ }
sub _impl { Propcalc::FFI::formula_impl @_ }
sub _eqv  { Propcalc::FFI::formula_eqv  @_ }
sub _xor  { Propcalc::FFI::formula_xor  @_ }

=head2 new

    my $fm = Propcalc::Formula->new($infix);

Constructs a new C<Propcalc::Formula> by parsing the string C<$infix>
expression. For the syntax, see L<above|/Formula syntax>.

=cut

sub new { Propcalc::FFI::formula_new $_[1] }

=head2 rpn

    my $string = $fm->rpn;

Renders the formula in Reverse Polish Notation.

=cut

sub rpn { Propcalc::FFI::formula_rpn $_[0] }

=head2 pn

    my $string = $fm->pn;

Renders the formula in Polish Notation.

=cut

sub pn { Propcalc::FFI::formula_pn $_[0] }

sub DESTROY { Propcalc::FFI::formula_destroy $_[0] }

=head1 AUTHOR

Tobias Boege <tobs@taboege.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (C) 2019 by Tobias Boege.

This is free software; you can redistribute it and/or modify it under the
same terms as the Perl 5 programming language system itself.

=cut

1;
