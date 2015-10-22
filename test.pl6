use v6;
use Test;

plan 17;

use Grammar::IETF::ABNF::RFC7405;

subtest {
    plan 5;

    subtest {
        plan 52;

        for "a".."z" -> $letter {
            is_match($letter, 'ALPHA');
        }
    }, 'lowercase';

    subtest {
        plan 52;

        for "A".."Z" -> $letter {
            is_match($letter, 'ALPHA');
        }
    }, 'uppercase';

    subtest {
        plan 9;

        for 1..9 -> $number {
            isnt_match($number, 'ALPHA');
        }
    }, 'not numbers';

    subtest {
        plan 1;

        isnt_match('é', 'ALPHA');
    }, 'not unicode';

    subtest {
        plan 1;

        isnt_match('ab', 'ALPHA');
    }, 'not two letters';
}, 'ALPHA';

subtest {
    plan 4;
    for 0, 1 ->  $binary {
        is_match($binary, 'BIT');
    }
}, 'BIT';

subtest {
    plan 254;
    for "\x[01]".."\x[7F]" -> $char {
        is_match($char, 'CHAR');
    }
}, 'CHAR';

subtest {
    plan 5;
   is_match("\x[0D]", 'CR');
   is_match("\r", 'CR');
   isnt_match("\n", 'CR');
}, 'CR';

subtest {
    plan 7;
    is_match("\x[0D]\x[0A]", 'CRLF');
    is_match("\r\n", 'CRLF');
    isnt_match("\n\r", 'CRLF');
    isnt_match("\n", 'CRLF');
    isnt_match("\r", 'CRLF');
}, 'CRLF';

subtest {
    plan 66;
    for ("\x[00]".."\x[1F]", "\x[7F]").flat -> $control_char {
        is_match($control_char, 'CTL');
    }
}, 'CTL';

subtest {
    subtest {
        plan 18;
        for 1..9 -> $number {
            is_match($number, 'DIGIT');
        }
    }, 'numbers';

    subtest {
        plan 52;
        for ("a".."z", "A".."Z").flat -> $letter {
            isnt_match($letter, 'DIGIT');
        }
    }, 'not letters';

    subtest {
        plan 1;
        isnt_match('二', 'DIGIT'); # Unicode numeral
    }, 'not unicode';
}, 'DIGIT';

subtest {
    is_match('"', 'DQUOTE');

    subtest {
        isnt_match('“', 'DQUOTE');
        isnt_match('“', 'DQUOTE');
    }, 'not unicode';
}, 'DQUOTE';

subtest {}, 'HEXDIG';

subtest {}, 'HTAB';

subtest {}, 'LF';

subtest {}, 'LWSP';

subtest {}, 'OCTET';

subtest {}, 'SP';

subtest {}, 'VCHAR';

subtest {}, 'WSP';

sub is_match (Any:D $string, Str $rule) {
    my $match = Grammar::IETF::ABNF::RFC7405_Core.parse($string, :rule($rule));

    ok($match, "String '{print_safe_string($string)}' matched");
    is($match, $string, " - Matched '{print_safe_string($match.Str)}' for '{print_safe_string($string)}'");
}

sub isnt_match (Any:D $string, Str $rule) {
    my $match = Grammar::IETF::ABNF::RFC7405_Core.parse($string, :rule($rule));

    ok(!$match, "{print_safe_string($string)} didn't matched");
}

sub print_safe_string (Any:D $string) {
    return $string ~~ /<[\x[00]..\x[1F]]> | <[\x[7F]]>/ ?? $string.perl !! $string;
}
