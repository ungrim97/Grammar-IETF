use Grammar::IETF::ABNF::RFC7405;

grammar Grammar::IETF::URI::RFC3986 does Grammar::IETF::ABNF::RFC7405_Core {
    rule TOP { ^ <URI> | <relative-ref> $ }

    rule URI       { <scheme> ':' <hier-part> ['?' <query>]? ['#' <fragment>]?                         }
    rule hier-part { '//' <authority> <path-abempty> | <path-absolute> | <path-rootless> | <path-empty> }

    rule absolute-URI  { <scheme> ':' <hier-part> [ '?' <query> ]?                                         }
    rule relative-ref  { <relative-part> [ '?' <query> ]? [ '#' <fragment> ]?                               }
    rule relative-part { '//' <authority> <path-abempty> | <path-absolute> | <path-noscheme> | <path-empty> }

    rule authority     { [ <userinfo> '@' ]? <host> [ ':' <port> ]? }
    rule host      { <IP-literal> | <IPv4address> | <reg-name>      }

    rule reserved   { <.gen-delims> | <.sub-delims>       }

    rule path { <path-abempty> | <path-absolute> | <path-noscheme> | <path-rootless> | <path-empty> }
    rule path-abempty { [ '/' <segment> ]* }
    rule path-absolute { '/' [ <segment-nz> [ '/' <segment> ]* ]? }
    rule path-noscheme { <segment-nz-nc> [ '/' <segment> ]* }
    rule path-rootless { <segment-nz> [ '/' <segment> ]* }
    rule path-empty { <.pchar> ** 0 }

    rule query { [ <.pchar> | '/' | '?' ]* }

    token fragment { [ <.pchar> | '/' | '?' ]* }

    # External tokens
    token scheme   { <.ALPHA> [ <.ALPHA> | <DIGIT> | <[ + _ . ]> ]*       }
    token userinfo { [ <.unreserved> | <.pct-encoded> | <.sub-delims> | ':' ]* }

    token IP-literal  { '[' [ <.IPv6address> | <.IPvFuture> ] ']' }
    token IPvFuture   { v <.HEXDIG>+ '.' [ <.unreserved> | <.sub-delims> | ':' ]+ }

    token IPv4address { <.dec-octet> '.' <.dec-octet> '.' <.dec-octet> '.' <.dec-octet> }
    token IPv6address {
                                                [<.h16>   ':'] ** 6 <.ls32>
        |                                  '::' [<.h16>   ':'] ** 5 <.ls32>
        |  [ <.h16>                     ]? '::' [<.h16>   ':'] ** 4 <.ls32>
        |  [[<.h16> ':'] ** 0..1 <.h16> ]? '::' [<.h16>   ':'] ** 3 <.ls32>
        |  [[<.h16> ':'] ** 0..2 <.h16> ]? '::' [<.h16>   ':'] ** 2 <.ls32>
        |  [[<.h16> ':'] ** 0..3 <.h16> ]? '::'  <.h16>   ':'       <.ls32>
        |  [[<.h16> ':'] ** 0..4 <.h16> ]? '::'                     <.ls32>
        |  [[<.h16> ':'] ** 0..5 <.h16> ]? '::'  <.h16>
        |  [[<.h16> ':'] ** 0..6 <.h16> ]? '::'

    }

    token port { <.DIGIT>* }
    token reg-name { [ <.unreserved> | <.pct-encoded> | <.sub-delims> ]* }

    # Internal tokens
    token ls32 { [ <.h16> ':' <.h16> ] | <.IPv4address> }
    token h16  { <.HEXDIG> ** 1..4                      }
    token dec-octet { ^255 }
    token gen-delims  { <[ : / ? # [ \] @ ]> }
    token sub-delims  { <[ ! $ & \ ( ) * + , ; = ]> }
    token pct-encoded { '%' <.HEXDIG> <.HEXDIG> }
    token segment { <.pchar>* }
    token unreserved { <.ALPHA> | <.DIGIT> | <[ - . _ ~ ]> }
    token segment-nz { <.pchar>+ }
    token segment-nz-nc { [ <.unreserved> | <.pct-encoded> | <.sub-delims> | '@' ]* }
    token pchar { <.unreserved> | <.pct-encoded> | <.sub-delims> | ':' | '@' }
}
