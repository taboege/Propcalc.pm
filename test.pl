#!/usr/bin/env perl

use Modern::Perl;
use Propcalc::Formula;
use Propcalc::FFI;

say "propcalc version: " . sprintf("%06x", Propcalc::FFI::version);

my $f = Propcalc::Formula->new('1&2|~33&4->5=(3^(~4))');
say $f->rpn;
say $f->pn;
