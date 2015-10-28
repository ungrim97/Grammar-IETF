use v6;

use Test;

use Grammar::IETF::ABNF::RFC7405;

subtest {
    my $match = Grammar::IETF::ABNF::RFC7405.parse('rule = WSP [optional-token] "quoted-string"'~"\r\n");
    ok($match, 'Matched string');

    is($match<rulelist><rule>[0]<rulename>, 'rule', ' - With correct rulename');
}, 'Rulestext';
