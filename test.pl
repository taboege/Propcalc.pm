#!/usr/bin/env perl

use Modern::Perl;
use Propcalc::Formula;
use Propcalc::FFI;

say "propcalc version: " . sprintf("%06x", Propcalc::FFI::version);

my $f = Propcalc::Formula->new('1&2|~33&4->5=(3^(~4))');
say $f->rpn;
say $f->pn;

my $g = $f <=> (Propcalc::Formula->new("[12|]&[12|3]") >> Propcalc::Formula->new("[13|]|[23|]"));
say $g->rpn;
