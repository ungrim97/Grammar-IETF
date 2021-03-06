use v6;
use Test;

plan 22;

use Grammar::IETF::ABNF::RFC5234;

subtest {
    is_match("\r\n", 'rulelist');
    is_match("rule = foo\r\n", 'rulelist');
    is_match("     \r\n", 'rulelist');
    isnt_match(" foo = bar\r\n", 'rulelist');
}, 'rulelist';

subtest {
    my $match = is_match('rulelist  =  1*( rule / (*c-wsp c-nl) )'~"\r\n", 'rule');
}, 'rule';

subtest {
    is_match(' ', 'c-wsp');
    is_match("\r\n ", 'c-wsp');
    is_match("; A comment here \r\n ", 'c-wsp');
}, 'c-wsp';

subtest {
    is_match("; a comment\r\n", 'c-nl');
    is_match("\r\n", 'c-nl');
}, 'c-nl';

subtest {
    is_match("; This is a comment \r\n", 'comment');
    isnt_match("; Single line comment", 'comment');
}, 'comment';

subtest {
    is_match('foo', 'alternation');
    is_match('bar / foo', 'alternation');
    is_match("bar\r\n ; comment\r\n /foo", 'alternation');
}, 'alternation';

subtest {
    is_match('2*foo', 'concatenation');
    is_match('foo foo       *1bar', 'concatenation');
    is_match("foo bar \r\n *1bar", 'concatenation');
    is_match('*[foo] foo', 'concatenation');
}, 'concatenation';

subtest {
    is_match('2*2foo', 'repetition');
    is_match('1*( foo  foo )', 'repetition');
}, 'repetition';

subtest {
    is_match('foo / bar', 'elements');
    is_match('foo ', 'elements');
}, 'elements';

subtest {
    is_match('a', 'rulename');
    is_match('S', 'rulename');
    is_match('a1-sd', 'rulename');
    is_match('a-', 'rulename');

    isnt_match(1, 'rulename');
    isnt_match('a!', 'rulename');
}, 'rulename';

subtest {
    is_match(" = ", 'defined-as');
    is_match(" =/ ", 'defined-as');
    is_match('=', 'defined-as');
    is_match("\r\n =", 'defined-as');
    is_match("; A comment\r\n = ; another comment\r\n ", 'defined-as');
}, 'defined-as';

subtest {
    is_match('*', 'repeat');
    is_match('1*', 'repeat');
    is_match('*1', 'repeat');
    is_match('2*1', 'repeat');
    is_match('1', 'repeat');
    is_match('200*200', 'repeat');
    is_match('200', 'repeat');
    is_match('200*', 'repeat');
    is_match('*200', 'repeat');
}, 'repeat';

subtest {
    is_match('rulename', 'element');
    is_match('( group )', 'element');
    is_match('[ option ]', 'element');
    is_match('" char "', 'element');
    is_match('%d23-24', 'element');
    is_match('< prose 101 >', 'element');

}, 'element';

subtest {
    is_match('( foo / *bar )', 'group');
    is_match('(groups (all (the (way (down)))))', 'group');
    is_match('(group *(many groups))', 'group');
    isnt_match('foo / bar', 'group');
}, 'group';

subtest {
    is_match('[ foo / *bar ]', 'option');
    is_match('[options [all [the [way [down]]]]]', 'option');
    is_match('[option *[many options]]', 'option');
    isnt_match('foo / bar', 'option');
}, 'option';

subtest {
    for flat ("\x[20]".."\x[21]", "\x[23]".."\x7E") -> $char {
        is_match('"'~$char~'"', 'char-val');
    }
    is_match('"We \are <allowed> angles (in $this) string"', 'char-val');

    isnt_match('"not " quotes" allowed "', 'char-val');
    isnt_match('not "unquoted strings" allowed', 'char-val');

}, 'char-val';

subtest {
    is_match('%b01', 'num-val');
    is_match('%d12', 'num-val');
    is_match('%x2F', 'num-val');

    isnt_match('%t2', 'num-val');
    isnt_match('$d12', 'num-val');
}, 'num-val';

subtest {
    is_match('b1', 'bin-val');
    is_match('b10101101', 'bin-val');

    is_match('b0-1', 'bin-val');
    is_match('b10101011.11001010', 'bin-val');
    is_match('b11.10.11', 'bin-val');

    is_match('B10.11', 'bin-val');

    isnt_match('b22.22', 'bin-val');
    isnt_match('b121212', 'bin-val');
}, 'bin-val';

subtest {
    is_match('d1', 'dec-val');
    is_match('d12123123', 'dec-val');

    is_match('d20-21', 'dec-val');
    is_match('d22.23', 'dec-val');
    is_match('d22.23.24', 'dec-val');

    is_match('D22.23', 'dec-val');

    isnt_match('b22.22', 'dec-val');
    isnt_match('b101010', 'dec-val');
}, 'dec-val';

subtest {
    is_match('xF', 'hex-val');
    is_match('xFF', 'hex-val');

    is_match('x20-21', 'hex-val');
    is_match('x22.23', 'hex-val');
    is_match('x22.23.34', 'hex-val');

    is_match('X22.23', 'hex-val');

    isnt_match('d22.22', 'hex-val');
    isnt_match('xFY', 'hex-val');
}, 'hex-val';

subtest {
    for "\x[20]".."\x[3D]" -> $string {
        is_match( '<'~$string~'>', 'prose-val' );
    }

    for "\x[3f]".."\x[7E]" -> $string {
        is_match('<'~$string~'>', 'prose-val');
    }

    is_match('<'~'this is a test {vchars} and [sp] without angles!'~'>', 'prose-val');

    isnt_match('(no angles)', 'prose-val');
}, 'prose-val';

subtest {
    my $text = "t/ABNF/rfc5234_grammar.txt".IO.slurp;

    # File is \n but the grammar spec is \r\n;
    $text ~~ s:g/\n/\r\n/;

    is_match($text, 'rulelist');
}, 'rules list from file (rfc spec)';

sub is_match (Mu:D $string, Str $rule) {
    ok(
        Grammar::IETF::ABNF::RFC5234.parse($string, :rule($rule)),
        "{print_safe_string($string)} matched for $rule"
    );

    is($/, $string, " - Matched {$/.gist} for $string");
    return $/;
}

sub isnt_match (Mu:D $string, Str $rule) {
    ok(
        !Grammar::IETF::ABNF::RFC5234.parse($string, :rule($rule)),
        "{print_safe_string($string)} didn't match $rule"
    );
}

sub print_safe_string (Mu:D $string) {
    return $string ~~ /<[\x[00]..\x[1F]]> | <[\x[7F]]>/ ?? $string.perl !! $string;
}
