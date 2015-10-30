use v6;

use Test;
use TestLocal::Grammar;

plan 160;

use Grammar::IETF::IMF::RFC5322;

my Grammar $grammar = Grammar::IETF::IMF::RFC5322.new;

subtest {
    is_match('\\A', 'quoted-pair', $grammar);
    is_match('\\ ', 'quoted-pair', $grammar);

    not_match('\\ A'), 'quoted-pair', $grammar);
    not_match('AA'), 'quoted-pair', $grammar);
}, 'quoted-pair';

subtest {
    is_match(' ', 'FWS', $grammar);
    is_match("\r\n", 'FWS', $grammar);
    is_match("     \r\n", 'FWS', $grammar);
    is_match('     ', 'FWS', $grammar);

    not_match('', 'FWS', $grammar)
}, 'FWS';

subtest {
    for flat "\c[33]".."\c[39]", "\c[42]",,"\c[91]", "\c[93]",,"\c[126]" -> $char {
        is_match($char, 'ctext', $grammar);
    }
}, 'ctext';
