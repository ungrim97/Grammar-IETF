use v6;

use Test;
use Grammar::IETF::URI::RFC3986;

subtest {
    my $match = Grammar::IETF::URI::RFC3986.parse('http', :rule<scheme>);
    ok($match);
    is($match<URI><scheme>, 'http', 'Correct Scheme');
}, 'scheme';

subtest {
    my $match = Grammar::IETF::URI::RFC3986.parse(
        'https://example.org/absolute/URI/with/absolute/path/to/resource.txt'
    );
    ok($match, 'URI Matched');
    is($match<URI><scheme>, 'https', ' - scheme matched');
    is($match<URI><hier-part><authority><host>, 'example.org', ' - host matched');

}, 'Absolute URIs';

subtest {

    my $match = Grammar::IETF::URI::RFC3986.parse(
        '/relative/URI/with/absolute/path/to/resource.txt',
    );

    ok($match, 'relative url matched');
}, 'relative uri';

subtest {
    my $match = Grammar::IETF::URI::RFC3986.parse(
        '#frag01'
    );

    $match.say;
}

#sub matching_urls {
#
#    '//example.org/scheme-relative/URI/with/absolute/path/to/resource.txt',
#   'relative/path/to/resource.txt',
#    '../../../resource.txt',
#                        ./resource.txt#frag01
#                            resource.txt
#                                
#                               #-
#}
