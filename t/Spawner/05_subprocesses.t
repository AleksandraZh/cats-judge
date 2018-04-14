use strict;
use warnings;

use File::Spec;
use constant FS => 'File::Spec';

use FindBin qw($Bin);

BEGIN { require File::Spec->catdir($Bin, 'Common.pm'); Common->import; }

use Test::More tests => 4;
use CATS::Spawner::Const ':all';


run_subtest 'Wait for detached process', compile_plan + items_ok_plan(1) + 1, sub {
    my $sleep = compile('sleep.cpp', 'sleep' . $exe, $_[0], ['-pthread', '-std=c++11']);
    my $fullsrc = FS->catdir($Bin, 'sh', 'run.sh');
    run_sp({ deadline => 3 }, '/bin/sh', [$fullsrc, $sleep]);
    is_deeply $spr->stdout_lines, [ 'aaa' ];
    clear_tmpdir;
};

run_subtest 'Kill detached process after deadline', compile_plan + items_ok_plan(1) + 1, sub {
    my $sleep = compile('sleep.cpp', 'sleep' . $exe, $_[0], ['-pthread', '-std=c++11']);
    my $fullsrc = FS->catdir($Bin, 'sh', 'run.sh');
    run_sp({ deadline => 1 }, '/bin/sh', [$fullsrc, $sleep]);
    is_deeply $spr->stdout_lines_chomp, [ ];
    clear_tmpdir;
};

run_subtest 'Kill detached processes after deadline', compile_plan + items_ok_plan(1) + 1, sub {
    my $sleep = compile('sleep.cpp', 'sleep' . $exe, $_[0], ['-pthread', '-std=c++11']);
    my $sleep5 = compile('sleep_5.cpp', 'sleep' . $exe, $_[0], ['-pthread', '-std=c++11']);
    my $fullsrc = FS->catdir($Bin, 'sh', 'run_many.sh');
    run_sp({ deadline => 3 }, '/bin/sh', [$fullsrc, $sleep, $sleep5]);
    is_deeply $spr->stdout_lines, [ 'aaaaaa' ];
    clear_tmpdir;
};

run_subtest 'Tl for sleeping processes', compile_plan + items_ok_plan(1) + 1, sub {
    my $sleep = compile('sleep.cpp', 'sleep' . $exe, $_[0], ['-pthread', '-std=c++11']);
    my $fullsrc = FS->catdir($Bin, 'sh', 'run_many.sh');
    run_sp({ time_limit => 1 }, '/bin/sh', [$fullsrc, $sleep, $sleep]);
    is_deeply $spr->stdout_lines, [ 'aaaaaaaaaaaa' ];
    clear_tmpdir;
};