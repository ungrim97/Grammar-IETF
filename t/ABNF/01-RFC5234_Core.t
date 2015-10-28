use v6;
use Test;

plan 16;

use Grammar::IETF::ABNF::RFC5234;

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
        isnt_match('”', 'DQUOTE');
    }, 'not unicode';

    subtest {
        isnt_match("''", 'DQUOTE');
    }, 'not two quotes'
}, 'DQUOTE';

subtest {
    for "A".."F" -> $char {
        is_match($char, 'HEXDIG');
    }

    for "a".."f" -> $char {
        is_match($char, 'HEXDIG');
    }

    is_match(2, 'HEXDIG'); # We've already tested <DIGIT>

    isnt_match('X', 'HEXDIG');
}, 'HEXDIG';

subtest {
    is_match("\t", 'HTAB');
    is_match("	", 'HTAB');

    # Vertical Tab
    isnt_match("", 'HTAB');
}, 'HTAB';

subtest {
    is_match("\n", 'LF');

    isnt_match("\r", 'LF');
    isnt_match("\x[B]", 'LF');
    isnt_match("\x[85]", 'LF');
}, 'LF';

subtest {
    is_match(' ', 'LWSP');
    is_match("\r\n ", 'LWSP')
}, 'LWSP';

subtest {
    plan 512;

    for "\x[00]".."\x[FF]" -> $octet {
        is_match($octet, 'OCTET');
    }
}, 'OCTET';

subtest {
    is_match(" ", 'SP');

    isnt_match("\t", 'SP');
    isnt_match(' ', 'SP'); # nbsp
    isnt_match("\x[1680]", 'SP'); # Ogham Space Mark
    isnt_match("\x[180E]", 'SP'); # Mongolian Vowel Separator
    isnt_match("\x[2000]", 'SP'); # EN Quad
    isnt_match("\x[2001]", 'SP'); # EM Quad
    isnt_match("\x[2002]", 'SP'); # EN Space
    isnt_match("\x[2003]", 'SP'); # EM Space
    isnt_match("\x[2004]", 'SP'); # Three-per-em space
    isnt_match("\x[2005]", 'SP'); # Four-per-em space
    isnt_match("\x[2006]", 'SP'); # Six-per-em Space
    isnt_match("\x[2007]", 'SP'); # Figure Space
    isnt_match("\x[2008]", 'SP'); # Punctuation Space
    isnt_match("\x[2009]", 'SP'); # Thin Space
    isnt_match("\x[200A]", 'SP'); # Hair Space
    isnt_match("\x[200B]", 'SP'); # Zero Width Space
    isnt_match("\x[202F]", 'SP'); # Narrow No-Break Space
    isnt_match("\x[205F]", 'SP'); # Mediam Mathematical Space
    isnt_match("\x[3000]", 'SP'); # Ideographic Space
    isnt_match("\x[FEFF]", 'SP'); # Zerp Wodth No-Break Space
}, 'SP';

subtest {
    for "\x[21]".."\x[7E]" -> $char {
        is_match($char, 'VCHAR');
    }
}, 'VCHAR';

subtest {
    is_match(' ', 'WSP');
    is_match("\t", 'WSP');
}, 'WSP';

sub is_match (Any:D $string, Str $rule) {
    my $match = Grammar::IETF::ABNF::RFC5234_Core.parse($string, :rule($rule));

    ok($match, "String '{print_safe_string($string)}' matched");
    is($match, $string, " - Matched '{print_safe_string($match.Str)}' for '{print_safe_string($string)}'");
}

sub isnt_match (Any:D $string, Str $rule) {
    my $match = Grammar::IETF::ABNF::RFC5234_Core.parse($string, :rule($rule));

     ok(!$match, "{print_safe_string($string)} didn't matched");
}

sub print_safe_string (Any:D $string) {
    return $string ~~ /<[\x[00]..\x[1F]]> | <[\x[7F]]>/ ?? $string.perl !! $string;
}
