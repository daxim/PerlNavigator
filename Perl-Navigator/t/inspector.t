use Capture::Tiny qw(capture_stdout);
use List::Util '1.33', qw(all any);
use Test::More import => [qw(done_testing note ok)];
use YAML::Any qw(Load);

# Need to pass some signal to inquistor to not run during its CHECK block. Alternatively, maybe we can check for the test harness environment variable?
BEGIN {
    $ENV{'PERLNAVIGATORTEST'} = 1;
    require Perl::Navigator;
}

my %t = %{ Load join '', readline *DATA };
for my $file (sort keys %t) {
    note "file $file";
    my $output = Perl::Navigator::tags_to_symbols(capture_stdout {
        Perl::Navigator::run($file)
    });
    for my $symbol (sort keys %{ $t{$file} }) {
        ok $output->{$symbol}, $symbol;
        ok(any {
            my $output_symbol = $_;
            all {
                note "$_ => $t{$file}{$symbol}{$_}";
                exists $output_symbol->{$_} and
                $output_symbol->{$_} eq $t{$file}{$symbol}{$_}
            } sort keys %{ $t{$file}{$symbol} };
        } @{ $output->{$symbol} });
    }
}

done_testing;
__DATA__
---
t/testWorkspace/MyLib/ClassAccessor.pm:
  MyLib::ClassAccessor:
    package_name: MyLib::ClassAccessor
    type: p
  name:
    package_name: MyLib::ClassAccessor
    type: f
  role:
    package_name: MyLib::ClassAccessor
    type: f
  salary:
    package_name: MyLib::ClassAccessor
    type: f
  MyLib::ClassAccessorAntlers:
    package_name: MyLib::ClassAccessorAntlers
    type: p
  name:
    package_name: MyLib::ClassAccessorAntlers
    type: f
  role:
    package_name: MyLib::ClassAccessorAntlers
    type: f
  salary:
    package_name: MyLib::ClassAccessorAntlers
    type: f
t/testWorkspace/MyLib/ClassTiny.pm:
  MyLib::ClassTiny:
    package_name: MyLib::ClassTiny
    type: p
  ssn:
    package_name: MyLib::ClassTiny
    type: t
  timestamp:
    package_name: MyLib::ClassTiny
    type: t
t/testWorkspace/MyLib/DBI.pm:
  MyLib::DBI:
    package_name: MyLib::DBI
    type: p
  MyLib::DBI::connect:
    package_name: MyLib::DBI
    type: t
  MyLib::DBI::db:
    package_name: MyLib::DBI::db
    type: p
  MyLib::DBI::db::ALLCAPS_METHOD:
    package_name: MyLib::DBI::db
    type: t
  MyLib::DBI::db::_private_method:
    package_name: MyLib::DBI::db
    type: t
  MyLib::DBI::db::new:
    package_name: MyLib::DBI::db
    type: t
  MyLib::DBI::db::selectall_array:
    package_name: MyLib::DBI::db
    type: t
t/testWorkspace/MyLib/MooClass.pm:
  MyLib::MooClass:
    package_name: MyLib::MooClass
    type: p
  MyLib::MooClass::moo_sub:
    package_name: MyLib::MooClass
    type: t
  MyLib::MooClass::BUILD:
    package_name: MyLib::MooClass
    type: t
  MyLib::MooClass::moo_attrib:
    package_name: MyLib::MooClass
    type: d
t/testWorkspace/MyLib/MooseClass.pm:
  MyLib::MooseClass:
    package_name: MyLib::MooseClass
    type: p
  MyLib::MooseClass::moose_attrib:
    package_name: MyLib::MooseClass
    type: d
  MyLib::MooseClass::BUILD:
    package_name: MyLib::MooseClass
    type: t
  MyLib::MooseClass::moose_sub:
    package_name: MyLib::MooseClass
    type: t
t/testWorkspace/MyLib/MyClass.pm:
  MyLib::MyClass:
    package_name: MyLib::MyClass
    type: p
  new:
    package_name: MyLib::MyClass
    type: s
  overridden_method:
    package_name: MyLib::MyClass
    type: s
  inherited_method:
    package_name: MyLib::MyClass
    type: s
  duplicate_method_name:
    package_name: MyLib::MyClass
    type: s
t/testWorkspace/MyLib/NamedPackage.pm:
  MyLib::NamedPackage:
    package_name: MyLib::NamedPackage
    type: p
  imported_constant:
    package_name: MyLib::NamedPackage
    type: n
  exported_sub:
    package_name: MyLib::NamedPackage
    type: s
  non_exported_sub:
    package_name: MyLib::NamedPackage
    type: s
  duplicate_sub_name:
    package_name: MyLib::NamedPackage
    type: s
  MyLib::SubPackage:
    package_name: MyLib::SubPackage
    type: p
  new:
    package_name: MyLib::SubPackage
    type: s
  subpackage_mod:
    package_name: MyLib::SubPackage
    type: s
t/testWorkspace/MyLib/MyOtherClass.pm:
  MyLib::MyOtherClass:
    package_name: MyLib::MyOtherClass
    type: p
  MyLib::MyOtherClass::new:
    package_name: MyLib::MyOtherClass
    type: t
  MyLib::MyOtherClass::unique_method_name:
    package_name: MyLib::MyOtherClass
    type: t
  MyLib::MyOtherClass::duplicate_method_name:
    package_name: MyLib::MyOtherClass
    type: t
t/testWorkspace/MyLib/NonPackage.pm:
  duplicate_sub_name:
    type: s
  nonpackage_sub:
    type: s
t/testWorkspace/MyLib/ObjectPad.pm:
  MyLib::ObjectPad:
    package_name: MyLib::ObjectPad
    type: p
  x:
    package_name: MyLib::ObjectPad
    type: f
  y:
    package_name: MyLib::ObjectPad
    type: f
  move:
    package_name: MyLib::ObjectPad
    type: o
  describe:
    package_name: MyLib::ObjectPad
    type: o
t/testWorkspace/MyLib/ObjectTiny.pm:
  MyLib::ObjectTiny:
    package_name: MyLib::ObjectTiny
    type: p
  bar:
    package_name: MyLib::ObjectTiny
    type: t
  baz:
    package_name: MyLib::ObjectTiny
    type: t
t/testWorkspace/mainTest.pl:
  MYCONSTANT:
    type: n
  INIT:
    type: e
  LABEL1:
    type: l
  LABEL2:
    type: l
  same_script_sub:
    type: s
  sub_with_sig:
    type: s
  SameFilePackage:
    package_name: SameFilePackage
    type: p
  same_file_package_sub:
    package_name: SameFilePackage
    type: s
  Foo:
    package_name: Foo
    type: p
  generic_attrib:
    package_name: Foo
    type: f
  baz:
    package_name: Foo
    type: s
t/testWorkspace/MySubClass.pm:
  MySubClass:
    package_name: MySubClass
    type: p
  new:
    package_name: MySubClass
    type: s
  overridden_method:
    package_name: MySubClass
    type: s
