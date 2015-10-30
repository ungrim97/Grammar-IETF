unit module TestLocal::Grammar;

use Test;

sub is_match (Mu:D $string, Str $rule, Grammar $grammar) is export {
    my $match = $grammar.parse($string, :rule($rule));

    ok($match, "{$string.gist} matched rule: $rule");
    is($match.Str, $string, " - {$match.Str.gist} returned for match of $string");

    return $match;
}

sub not_match ( Mu:D $string, Str $rule, Grammar $grammar ) is export {
    my $match = $grammar.parse($string, :rule($rule));

    ok(!$match, "{$string.gist} didn't match rule: $rule");
}
