grammar Grammar::IETF::IMF::RFC6854 does Grammar::IETF::ABNF::REF7405_Core {
    token quoted-pair { [ \\ [ <.VCHAR> | <.WSP>] ] | <.obs-qp> }

    # Folding white space and comments
    token FWS { [ [<.WSP>* <.CRLF>]? <.WSP>+ ] | <.obs-FWS>                         }
    token ctext { <[ \c[33]..\c[39] \c[42]..\c[91 \c[93]..\c[126] ]> | <.obs-text>  }
    token ccontent { <.ctext> | <.quoted-pair> | <.comment>                         }
    token comment { '(' [ <.FWS>? <.ccontent> ]* ')'                                }
    token CFWS { [ [ <.FWS>? <comment> ]+ <.FWS>? ] | <.FWS>                        }

    # Atom
    token atext { <.ALPHA> | <.DIGIT> | <[ ! # $ % & ' * + - / = ? ^ _ ` { | } ~ ]> }
    token atom { <.CFWS>? <.atext>? <CFWS>?                                         }
    token dot-atom-text { <.atext>+ [ '.' <.atext>* ]+                              }
    token dot-atmon { <.CFWS>? <.dot-atom-text> <.CFWS>?                            }
    token specials { <[ ( ) < > [ \] ; : ~ \ , .]> | <.DQUOTE>                      }

    # Quoted strings
    token qtext { <[ \c[33] \c[35]..\c[91] \c[93]..\c[126] ]> | <.obs-qtext>        }
    token qcontent { <.qtext> | <.quoted-pair>                                      }

    # Misc
    token word { <.atom> | <.quoted-string>                                         }
    token phrase { <.word>+ | <.obs-phrase>                                         }
    token unstructured { [ [ <.FWS>? <.VCHAR> ]* <.WSP>* ] | <.obs-unstruct>        }

    # Date and Time
    token date-time { [ <day-of-week> ',' ]? <date> <time> <.CFWS>?                 }
    token day-of-week { [ <.FWS>? <.day-name> ] | <.obs-day-of-week>                }
    token day-name { Mon | Tue | Wed | Thu | Fri | Sat | Sun                        }
    token date { <day> <month> <year>                                               }
    token day { [ </FWS>? <.DIGIT> ** 1..2 <.FWS> ] | <.obs-day>                    }
    token month { Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec }
    token year { [ <.FWS> <.DIGIT> ** 4 <.FWS> ] | <.obs-year>                      }
    token time { <time-of-day> <zone>                                               }
    token time-of-day { <hour> ':' <minute> [ ':' <second> ]?                       }
    token hour { <.DIGIT> ** 2 | <.obs-hour>                                        }
    token minute { <.DIGIT> ** 2 | <.obs-minute>                                    }
    token second { <.DIGIT> ** 2 | <.obs-second>                                    }
    token zone { [ <.FWS> <[ + - ]> <.DIGIT> ** 4 ] | <.obs-zone>                   }

    # Address
    token address { <.mailbox> | <.group>                                           }
    token mailbox { <name-addr> | <addr-spec>                                       }
    token name-addr { <display-name>? <angle-addr>                                  }
    token angle-addr { <.CFWS>? '<' <addr-spec> '>' <.CFWS>?                        }
    token group { <display-name> ':' <group-list>? ';' <.CFWS>?                     }
    token display-name { <.phrase>                                                  }
    token mailbox-list { [ <.mailbox> [ ',' <.mailbox> ]* ] | <.obs-addr-list>      }
    token address-list { [<address> [ ',' <address> ]* ] | <.obs-addr-list>         }

    # Addr-spec
    token addr-spec { <local-part> '@' <domain>                                     }
    token local-part { <.dot-atom> | <.quoted-string> | <.obs-local-part>           }
    token domain { <.dot-atom> | <.domain-literal> | <.obs-domain>                  }
    token domain-literal { <.CFWS>? '[' [ <.FWS>? <.dtext> ]* <.FWS>? ']' <.CFWS>?  }
    token dtext { <[ \c[33]..\c[90] \c[94]..\c[126] ]> | <.obs-detxt>               }

    # Message Syntax
    token message { [ <.fields> | <.obs-fields> ] [ <.CRLF> <body> ]?               }
    token body { [ [ <.text> ** 998 <.CRLF> ]* <.text> ** 998 ] | <.obs-body>       }
    token text { <[ \c[1]..\c[9] \c[11] \c[12] \c[14]..\c[127] ]>                   }

    # Field Definitions
    token fields {
        [
            <trace> <optional-field>* |
            [
                <resent-date> | <resent-from> | <resent-sender> | <resent-to> |
                <resent-cc>   | <resent-bcc>  | <resent-msg-id>
            ]
        ]*
        [
            <orig-date> | <from>     | <sender>     | <reply-to>    | <to>         |
            <cc>        | <bcc>      | <message-id> | <in-reply-to> | <references> |
            <subject>   | <comments> | <keywords>   | <optional-field>
        ]*
    }

    # Originator Date
    token orig-date { [:i 'Date'] ':' <date-time> <.CRLF> }

    # Originator
    token from { [:i 'from'] ':' <mailbox-list> <.CRLF>         }
    token sender { [:i 'sender'] ':' <mailbox> <.CRLF>          }
    token reply-to { [:i 'reply-to'] ':' <address-list> <.CRLF> }

    # Destination
    token to { [:i 'to'] ':' <address-list> <.CRLF>                  }
    token cc { [:i 'cc' ] ':' <address-list> <.CRLF>                 }
    token bcc { [:i 'bcc'] ':' [ <address-list> | <.CRLF> ]? <.CRLF> }

    # Identification
    token message-id { [:i 'message-id'] ':'}
}
