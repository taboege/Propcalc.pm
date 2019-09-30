package Propcalc::FFI;

use Modern::Perl;
use utf8;

use FFI::Platypus 0.20;
use FFI::CheckLib qw(find_lib_or_die);
use FFI::Platypus::Memory qw(free);

my $ffi = FFI::Platypus->new;
$ffi->lib(find_lib_or_die lib => 'propcalc');
$ffi->mangler(sub {
    "propcalc_" . shift
});

$ffi->attach(version => [] => 'unsigned int',
    sub { shift->() },
);

$ffi->attach(formula_new => ['string'] => 'opaque',
    sub {
        my $sub = shift;
        $sub->(@_)
    },
);

$ffi->attach(formula_rpn => ['opaque'] => 'opaque',
    sub {
        my $sub = shift;
        my $ptr = $sub->(@_);
        my $str = $ffi->cast('opaque' => 'string', $ptr);
        free $ptr;
        $str
    },
);

$ffi->attach(formula_pn => ['opaque'] => 'opaque',
    sub {
        my $sub = shift;
        my $ptr = $sub->(@_);
        my $str = $ffi->cast('opaque' => 'string', $ptr);
        free $ptr;
        $str
    },
);

$ffi->attach(formula_destroy => ['opaque'] => 'void',
    sub {
        my $sub = shift;
        $sub->(@_)
    },
);

1;
