use Module::Build 0.4004; # test_requires
Module::Build->new(
    add_to_cleanup => ['Perl-Navigator-*'],
    configure_requires => {
        'Module::Build' => '0.4004',
    },
    dist_author => 'bscan <invalid@example.org>',
    dist_version_from => 'lib/Perl/Navigator.pm',
    license => 'unknown',   # combined work: MIT for most files,
                            # Perl for a few
    meta_merge => {
        resources => {
            bugtracker => {
                web => 'https://github.com/bscan/PerlNavigator/issues',
            },
            repository => {
                type => 'git',
                url => 'git@github.com:bscan/PerlNavigator.git',
                web => 'https://github.com/bscan/PerlNavigator',
            },
        },
    },
    module_name => 'Perl::Navigator',
    recommends => {
        map { $_ => 0 } qw(
            Perl::Critic
        )
    },
    requires => {
        map { $_ => 0 } qw(
            attributes
            B
            base
            Carp
            Config
            constant
            Exporter
            File::Find
            File::Spec
            Filter::Simple
            Getopt::Long
            open
            strict
            Text::Balanced
            Unicode::Normalize
            utf8
            vars
            warnings
        )
    },
    test_requires => {
        map { $_ => 0 } qw(
            attributes
            base
            Class::Accessor
            Class::Tiny
            constant
            Cwd
            Data::Dumper
            experimental
            Exporter
            File::Spec
            FindBin
            MIME::Base64
            Moo
            Moose
            Object::Pad
            Object::Tiny
            strict
            utf8
            warnings
        )
    },
)->create_build_script;
