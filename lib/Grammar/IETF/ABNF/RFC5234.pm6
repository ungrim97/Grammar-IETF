use Grammar::IETF::ABNF;

grammar Grammar::IETF::ABNF::RFC5234 is Grammar::IETF::ABNF {
    rule TOP            { ^ <rulelist> $                                               }

    token rulelist      { [ <rule> | [ <.c-wsp>* <.c-nl> ] ]+                          }
    token rule          { <rulename> <defined-as> <elements> <.c-nl>                   }
    token c-wsp         { <.WSP> | [ <c-nl> <.WSP> ]                                   }
    token c-nl          { <.comment> | <.CRLF>                                         }
    token comment       { ';' [ <.WSP> | <.VCHAR> ]* <.CRLF>                           }
    token alternation   { <concatenation> [ <.c-wsp>* '/' <.c-wsp>* <concatenation> ]* }
    token concatenation { <repetition> [ <.c-wsp>+ <repetition> ]*                     }
    token repetition    { <repeat>? <element>                                          }
    token elements      { <alternation> <.c-wsp>*                                      }
    token rulename      { <.ALPHA> [ <.ALPHA> | <.DIGIT> | '-' ]*                      }
    token defined-as    { <.c-wsp>* [ '=' | '=/' ] <.c-wsp>*                           }
    token repeat        { <.DIGIT>+ | [ <.DIGIT>* '*' <.DIGIT>* ]                      }
    token element       {
        <rulename> | <group> | <option> | <char-val> | <num-val> | <prose-val>
    }
    token group         { '(' <.c-wsp>* <alternation> <.c-wsp>* ')'                        }
    token option        { '[' <.c-wsp>* <alternation> <.c-wsp>* ']'                        }
    token char-val      { <.DQUOTE> [ <[\x[20] \x[21] \x[23]..\x[7E] ]> ]* <.DQUOTE>       }
    token num-val       { '%' [<.bin-val> | <.dec-val> | <.hex-val>]                       }
    token bin-val       { <[bB]> <.BIT>+    [ ['.' <.BIT>+    ]+ | ['-' <.BIT>+    ] ]?    }
    token dec-val       { <[dD]> <.DIGIT>+  [ ['.' <.DIGIT>+  ]+ | ['-' <.DIGIT>+  ] ]?    }
    token hex-val       { <[xX]> <.HEXDIG>+ [ ['.' <.HEXDIG>+ ]+ | ['-' <.HEXDIG>+ ] ]?    }
    token prose-val     { '<' [ <[\x[20]..\x[3D]]> | <[\x[3F]..\x[7E]]> ]* '>'             }
}
