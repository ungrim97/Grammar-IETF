role Grammar::IETF::DNS::RFC1035 {
    token domain      { <subdomain> | ' '                              }
    token subdomain   { <label> | [<subdomain> '.' <label>]            }
    token label       { <.letter> [ <.ldh-str>? <.let-dig> ]?          }
    token ldh-str     { <.let-dig-hyp> | [ <.let-dig-hyp> <.ldh-str> ] }
    token let-dig-hyp { <.let-dig> | '-'                               }
    token let-dig     { <.letter> | <.digit>                           }
    token letter      { <[a..z]> | <[A..Z]>                            }
    token digit       { <[1..9]>                                       }
}

grammar Grammar::IETF::DNS::Domain does Grammar::HTTP::RFC1035 {
    rule TOP { <domain> }
}
