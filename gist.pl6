use v6;
use Test;

use Grammar::IETF::ABNF::RFC5234;

subtest {
    my $match = Grammar::IETF::ABNF::RFC5234.parse('rulelist       =  1*( rule / (*c-wsp c-nl) )'~"\r\n");
    ok($match, 'Matched single rule');
    $match.say;
}, 'rule';
