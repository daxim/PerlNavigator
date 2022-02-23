package Perl::Navigator::SubUtilPP;

use strict;
use warnings;
use B;

our $VERSION = '3.000';

if ( !eval { require Sub::Util; Sub::Util->import('subname'); 1 } ){
    *subname = sub {
        my ($coderef) = @_;
        ref $coderef or return;
        my $cv = B::svref_2object($coderef);
        $cv->isa('B::CV') or return;
        $cv->GV->isa('B::SPECIAL') and return;
        return $cv->GV->STASH->NAME . '::' . $cv->GV->NAME;
    }
}


1;
# This is to provide a pure perl fallback to Sub::Util for old versions of Perl. It's essentially just Sub::Identify.

# (c) Rafael Garcia-Suarez (rgs at consttype dot org) 2005, 2008, 2012, 2014, 2015
