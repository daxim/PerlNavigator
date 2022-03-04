package MyLib::NamedPackage;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(exported_sub imported_constant $our_variable);

use constant imported_constant => "I'm an imported constant";

our $our_variable = "The World is ours";

sub exported_sub {
    print "In Dir::NamedPackage, sub exported_sub\n";
}

sub non_exported_sub {
    print "In Dir::NamedPackage, sub non_exported_sub\n";
}

sub duplicate_sub_name {
    print "In nonpackage duplicate_sub_name\n";
}


package MyLib::SubPackage;

sub new {
    return bless {};
}

sub subpackage_mod {
    print "in subpackage_mod\n";
}


1;