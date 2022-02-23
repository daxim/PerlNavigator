package Perl::Navigator::Devel::Symdump::Export;
require Perl::Navigator::Devel::Symdump;
require Exporter;
use Carp;
use strict;
use vars qw($VERSION @ISA @EXPORT_OK $AUTOLOAD);

$VERSION = '3.000';
@ISA=('Exporter');
 
@EXPORT_OK=(
        'packages'      ,
        'scalars'       ,
        'arrays'        ,
        'hashes'        ,
        'functions'     ,
        'filehandles'   ,
        'dirhandles'    ,
        'ios'           ,
        'unknowns'      ,
);
my %OK;
@OK{@EXPORT_OK}=(1) x @EXPORT_OK;
 
push @EXPORT_OK, "symdump";
 
# undocumented feature symdump() -- does it save enough typing?
sub symdump {
    my @packages = @_;
    Perl::Navigator::Devel::Symdump->new(@packages)->as_string;
}
 
AUTOLOAD {
    my @packages = @_;
    (my $auto = $AUTOLOAD) =~ s/.*:://;
    confess("Unknown function call $auto") unless $OK{$auto};
    my @ret = Perl::Navigator::Devel::Symdump->new->$auto(@packages);
    return @ret;
}
 
1;