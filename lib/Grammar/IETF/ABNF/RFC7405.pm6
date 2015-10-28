grammar Gramamr::IETF::ABNF::RFC7405 is Grammar::IETF::ABNF::RFC5234 {
    token char-val { <.case-insensitive-string> | <.case-sensitive-string> }

    token case-insensitive-string { '%i'? <.quoted-string> }
    token case-sensitive-string   { '%s' <.quoted-string>  }
}
