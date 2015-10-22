role Grammar::IETF::ABNF::RFC7405_Core is Grammar {
    token ALPHA  { <[\x[41]..\x[5A]]> | <[\x[61]..\x[7A]]> }
    token BIT    { 0 | 1                                   }
    token CHAR   { <[\x[01]..\x[7F]]>                      }
    token CR     { \x[0D]                                  }
    token CRLF   { [<.CR> <.LF>]                           }
    token CTL    { <[\x[00]..\x[1F]]> | \x[7F]             }
    token DIGIT  { <[\x[30]..\x[39]]>                      }
    token DQUOTE { \x[22]                                  }
    token HEXDIG { <.DIGIT> | <[a..fA..F]>                 }
    token HTAB   { \x[09]                                  }
    token LF     { \x[0A]                                  }
    token LWSP   { [<.WSP> | <.CRLF> <.WSP>]*              }
    token OCTET  { <[\x[00]..\x[FF]]>                      }
    token SP     { \x[20]                                  }
    token VCHAR  { <[\x[21]..\x[7E]]>                      }
    token WSP    { <SP> | <HTAB>                         }
}

role Grammar::IETF::ABNF::RFC7405_Rules does Grammar::IETF::ABNF::RFC7405_Core {
    rule TOP           { ^ <rulelist> $ }

    rule rulelist      { [<rule> | [.<c-wsp>* <.c-nl>]]+                              }
    rule rule          { <rulename> <defined-as> <elements> <.c-nl>                   }
    rule c-wsp         { <.WSP> | [<c-nl> <.WSP>]                                     }
    rule c-nl          { <.comment> | <.CRLF>                                         }
    rule comment       { ';' [<.WSP> | <.VCHAR>]* <.CRLF>                             }
    rule alternation   { <.concatenation> [<.c-wsp>* '/' <.c-wsp>* <.concatenation>]* }
    rule concatenation { <.repetition> [<.c-wsp>+ <.repetition>]*                     }
    rule repetition    { <.repeat>? <.element>                                        }
    rule repeat        { <.DIGIT>+ | [<.DIGIT>* '*' <.DIGIT>*]                        }
    rule group         { '(' <.c-wsp>* <.alternation> <.c-wsp>* ')'                   }
    rule option        { '[' <.c-wsp>* <.alternation> <.c-wsp>* ']'                   }
    rule char-val      { <.case-insensitive-string> | <.case-sensitive-string>        }

    rule case-insensitive-string { '%i'? <.quoted-string> }
    rule case-sensitive-string   { '%s' <.quoted-string>  }

    rule element {
        <.rulename> | <.group> | <.option> | <.char-val> | <.num-val> | <.prose-val>
    }

    token elements      { <.alternation> <.c-wsp>*                                         }
    token rulename      { <.ALPHA> [<.ALPHA> | <.DIGIT> | '-']*                            }
    token defined-as    { <.c-wsp>* ['=' | '=/'] <.c-wsp>*                                 }
    token quoted-string { <.DQUOTE> [ <[\x[20]..\x[21]]> | <[\x[23]..\x[7E]]> ]* <.DQUOTE> }
    token num-val       { '%' [<.bin-val> | <.dec-val> | <.hex-val>]                       }
    token bin-val       { 'b' <.BIT>+    [ ['.' <.BIT>+]+    | ['-' <.BIT>+]   ]?          }
    token dec-val       { 'd' <.DIGIT>+  [ ['.' <.DIGIT>+]+  | ['-' <.DIGIT>+] ]?          }
    token hex-val       { 'x' <.HEXDIG>+ [ ['.' <.HEXDIG>+]+ | ['-' <.HEXDIG>] ]?          }
    token prose-val     { '<' [ <[\x[20]..\x[3D]]> | <[\x[3F]..\x[7E]]> ]* '>'             }
}
