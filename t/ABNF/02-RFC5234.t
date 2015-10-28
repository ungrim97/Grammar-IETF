use v6;

use Test;
plan => 23;

use Grammar::IETF::ABNF::RFC5234;

subtest {
    for "\x[20]".."\x[3D]" -> $string {
        is_match( '<'~$string~'>', 'prose-val' );
    }

    for "\x[3f]".."\x[7E]" -> $string {
        is_match('<'~$string~'>', 'prose-val');
    }

    is_match('<'~'this is a test {vchars} and [sp] without angles!'~'>', 'prose-val');

    isnt_match()
}, 'prose-val';

subtest {
    my $match = Grammar::IETF::ABNF::RFC5234.parse('rule = WSP [optional-token] "quoted-string"'~"\r\n");
    ok($match, 'Matched string');
}, 'rule';

sub is_match (Any:D $string, Str $rule) {
    ok(
        Grammar::IETF::ABNF::RFC5234.parse($string, :rule($rule)),
        "{print_safe_string($string)} matched for $rule");
}

sub isnt_match (Any:D $string, Str $rule) {
    ok(
        !Grammar::IETF::ABNF::RFC5234.parse($string, :rule($rule)),
        "{print_safe_string($string)} didn't match $rule");
}

sub print_safe_string (Any:D $string) {
    return $string ~~ /<[\x[00]..\x[1F]]> | <[\x[7F]]>/ ?? $string.perl !! $string;
}
