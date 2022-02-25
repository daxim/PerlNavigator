use lib 'inc';
use Module::Build::Pluggable qw(CPANfile Vendor);

Module::Build::Pluggable->new(
    add_to_cleanup => [qw(Perl-Navigator-* extlib vendor)],
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
)->create_build_script;
