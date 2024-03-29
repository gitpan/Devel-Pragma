use 5.008001;

use strict;
use warnings;

use ExtUtils::MakeMaker;
use ExtUtils::Depends;
use Config;

our $OPTIMIZE;

if ($Config{gccversion}) {
    $OPTIMIZE = '-O3 -Wall';
    $OPTIMIZE .= ' -g -Wextra -Wdeclaration-after-statement' if (-d 'dev');
} elsif ($Config{osname} eq 'MSWin32') {
    $OPTIMIZE = '-O2 -W4';
} else {
    $OPTIMIZE = $Config{optimize};
}

our %XS_PREREQUISITES = (
    'B::Hooks::OP::Annotation' => '0.44',
    'B::Hooks::OP::Check'      => '0.19',
);

our %XS_DEPENDENCIES = ExtUtils::Depends->new(
    'Devel::Pragma',
    keys(%XS_PREREQUISITES),
)->get_makefile_vars();

WriteMakefile(
    NAME          => 'Devel::Pragma',
    VERSION_FROM  => 'lib/Devel/Pragma.pm',
    PREREQ_PM     => {
        'Lexical::SealRequireHints' => '0.007',
        %XS_PREREQUISITES
    },
    ABSTRACT_FROM => 'lib/Devel/Pragma.pm',
    AUTHOR        => 'chocolateboy <chocolate@cpan.org>',
    LIBS          => [''],
    DEFINE        => '',
    INC           => '-I.',
    OPTIMIZE      => $OPTIMIZE,
    ($ExtUtils::MakeMaker::VERSION >= 6.31 ? (LICENSE => 'perl') : ()),
    ($ExtUtils::MakeMaker::VERSION >= 6.46 ?
        (META_MERGE => {
            configure_requires => {
                'ExtUtils::Depends' => '0.302',
                %XS_PREREQUISITES
            },
            resources => {
                repository => 'http://github.com/chocolateboy/Devel-Pragma',
            },
        })
        : ()
    ),
    %XS_DEPENDENCIES,
);
