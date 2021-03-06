use v6;
use Test;
use lib 'lib';
use Log::Async;

plan 1;

my @lines;
my $out = IO::Handle but role { method say($arg) { @lines.push: $arg } };
logger.close-taps;
logger.add-context;
logger.send-to($out,
  formatter => -> $m, :$fh {
    $fh.say: "file { $m<ctx>.file}, line { $m<ctx>.line }, message { $m<msg> }"
    }
  );
my $msg = "yàsu";
trace $msg;
my $line = $?LINE - 1;
logger.done;

my $file = $?FILE.subst(/^^ "{ $*CWD }/" /,'');
is-deeply @lines, [ "file $file, line $line, message $msg" ], "Got context";

