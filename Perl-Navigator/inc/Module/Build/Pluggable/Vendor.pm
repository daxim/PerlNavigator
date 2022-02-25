package Module::Build::Pluggable::Vendor;
use strict;
use warnings;
use base 'Module::Build::Pluggable::Base';
require App::cpanminus; # command `cpanm`
require lib;
use App::FatPacker qw();
use Cwd qw(cwd);
use Distribution::Metadata qw();
use ExtUtils::Packlist qw();
use Module::CPANfile qw();
use Path::Tiny qw(path);
use version qw();

sub vendor_targets {
    keys %{ Module::CPANfile->load->{_prereqs}->specs->{vendor}{requires} }
}

sub assert_build_dir {
    warn 'cannot find _build directory, change directory to dist root and try again'
        unless -d path('_build');
}

sub HOOK_build {
    my ($self) = @_;
    $self->add_action(extlib => sub {
        $self->assert_build_dir;
        # using cpanm makes sure we have packlist and MYMETA.json files installed
        $self->builder->do_system(qw(cpanm -n -q -L), 'extlib', $self->vendor_targets);
    });
    $self->add_action(vendor => sub {
        $self->assert_build_dir;
        # skip some work if extlib already exists.
        # in case the cache gets out of sync, run ./Build distclean
        $self->builder->dispatch('extlib') unless -d path('extlib');
        my $extlib_inc = path(qw(extlib lib perl5));
        my $mymeta = Distribution::Metadata->new_from_module(
            'Perl::Critic', inc => [$extlib_inc->stringify]
        )->mymeta_json_hash;
        my @modules = grep { $_ ne 'perl' } keys %{ $mymeta->{prereqs}{runtime}{requires} };
        if (version->parse($mymeta->{version}) <= version->parse('1.140')) {
            # guard against bug: deps that are too broad for runtime phase
            # fixed in https://github.com/Perl-Critic/Perl-Critic/commit/26efc02f
            @modules = grep { $_ ne 'Module::Build' } @modules;
        }
        my $fp = App::FatPacker->new;
        lib->import($extlib_inc->stringify);
        my @packlist = $fp->packlists_containing([
            map { s|::|/|g; $_ .= '.pm' } @modules, $self->vendor_targets
        ]);
        for my $p (@packlist) {
            for my $file (sort keys %{ ExtUtils::Packlist->new($p) }) {
                my $from = path($file)->relative(cwd);
                my $extlib = path('extlib');
                if ($extlib->subsumes($from)) {
                    if (path('bin')->subsumes($from->relative($extlib))) {
                        my $to = path(qw(vendor bin))->child($from->relative($extlib->child('bin')));
                        $to->parent->mkpath;
                        $from->copy($to);
                        # don't leak hashbang from build machine
                        $self->builder->do_system(
                            $^X, qw(-0 -i -p -e), 's/^#![^\n]+/#!perl/', $to->stringify
                        );
                    } elsif ($from =~ /.pm$/) {
                        my $to = path(qw(vendor lib))->child($from->relative($extlib_inc));
                        $to->parent->mkpath;
                        $from->copy($to);
                    } else {
                        print "not vendoring: $from\n";
                    }
                }
            }
        }
    });
}

1;

__END__

=encoding UTF-8

=head1 NAME

Module::Build::Pluggable::Vendor - populate a separate vendor/{bin,lib} from cpanfile

=head1 SYNOPSIS

    $ perl Build.PL
    $ ./Build help
    $ ./Build vendor
    $ ./Build vendor --verbose=1
    $ ./Build distclean
