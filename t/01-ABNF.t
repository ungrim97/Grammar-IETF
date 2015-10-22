use v6;
use Test;

use Grammar::IETF::ABNF::RFC7405;

my $test_data = q{ALPHA          =  %x41-5A / %x61-7A   ; A-Z / a-z}
     ~ "\r\n" ~ q{BIT            =  "0" / "1"}
     ~ "\r\n" ~ q{CHAR           =  %x01-7F}
     ~ "\r\n" ~ q{                       ; any 7-bit US-ASCII character,}
     ~ "\r\n" ~ q{                       ;  excluding NUL}
     ~ "\r\n";

subtest {
    my Grammar $core_abnf = grammar Dummy does Grammar::IETF::ABNF::RFC7405_Core { rule TOP {<CR>} };

    my $match = $core_abnf.parse("\x{0D}");

    ok($match);
    $match.perl;

}, 'Core';
