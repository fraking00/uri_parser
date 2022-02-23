
[library(dcg/basic)].

%recognizer

recognize_equal(Equal) --> [Equal], { Equal =:= "=" }.
recognize_open_bracket(Bracket) --> [Bracket], { Bracket =:= "(" }.
recognize_close_bracket(Bracket) --> [Bracket], { Bracket =:= ")" }.
recognize_underscore(Underscore) --> [Underscore], { Underscore =:= "_" }.
recognize_dot(Dot)     --> [Dot],   {Dot =:= "." }.
recognize_slash(Slash) --> [Slash], { Slash =:= "/"}.
recognize_qmark(Qmark) --> [Qmark], { Qmark =:= "?" }.
recognize_hash(Hash)   --> [Hash],  { Hash =:= "#"}.
recognize_at(At)       --> [At],    { At =:= "@"}.
recognize_colon(Colon) --> [Colon], { Colon =:= ":"}.
other_recognize_colon(Colon) --> [Colon], { Colon =:= 83 }.

%elements of syntax

any_digit(C) --> [C], { code_type(C, digit) }.

% la funzione letter serve per verificare che un determinato
% carattere sia una lettera
% possiamo passargli il carattere ascii (come per esempio 97
% che equivale ad una a minuscola)
% possiamo in realtà anche passare la lista contenente la stringa effettiva


% quello che devo fare adesso è trovare un modo di analizzare la prima
% lettera di id44 e di id8 in modo ma controllare che siano
% lettere e non numeri

letter([Let]) --> [Let], { char_type(Let, alpha) }.

letter([Let | Ls]) --> [Let], { char_type(Let, alpha) }, !,
                       letter(Ls).


characters([C]) --> [C], { code_type(C, ascii) }.

characters([C | Cs]) -->
    [C], { code_type(C, ascii) },
    !, characters(Cs).


control_dot([C]) --> [C], { code_type(C, alnum) }.

control_dot([C | Cs]) -->
    [C], { code_type(C, alnum) },
    !, control_dot(Cs).



% identificator type 2

other_identificator([C]) -->
    characters(C),
    {
        subtract(C, [47, 63, 35, 64, 58], Check),
        Check = C
    }.


other_identificator([C | Cs]) -->
    characters(C),
    {
        subtract(C, [47, 63, 35, 64, 58], Check),
        Check = C
    }, !, other_identificator(Cs).




other_host_identificator([C]) -->
    characters(C),
    {
        subtract(C, [46, 47, 63, 35, 64, 58], Check),
        Check = C
    }.

other_host_identificator([C | Cs]) -->
    characters(C),
    {
        subtract(C, [46, 47, 63, 35, 64, 58], Check),
        Check = C
    }, !, other_host_identificator(Cs).


other_id_identificator([C]) -->
    characters(C),
    {
        subtract(C, [40, 41, 47, 63, 35, 64, 58], Check),
        Check = C
    }.

other_id_identificator([C | Cs]) -->
    characters(C),
    {
        subtract(C, [40, 41, 47, 63, 35, 64, 58], Check),
        Check = C
    }, !, other_identificator(Cs).



% posso provare a fare un nuovo identificatore che accetti
% solo le lettere e punti

id44_identificator([C]) -->
    letter(C).


id44_identificator([C]) -->
    any_digit(C).


id44_identificator([C]) -->
    recognize_dot(C).



id44_identificator([C | Cs]) -->
    letter(C),
    !,
    id44_identificator(Cs).


id44_identificator([C | Cs]) -->
    any_digit(C),
    !,
    id44_identificator(Cs).


id44_identificator([C | Cs]) -->
    recognize_dot(C),
    !,
    id44_identificator(Cs).



%IP

sub_IP([D1, D2, D3]) -->
    any_digit(D1), any_digit(D2), any_digit(D3),

    {
        L = [D1, D2, D3],
        string_codes(X, L),
        atom_number(X, Y),
        integer(Y),
        Y =< 255

    }.


sub_IP([D1, D2, D3, DOT]) -->
    any_digit(D1), any_digit(D2), any_digit(D3),
    recognize_dot(DOT),
    {
        L = [D1, D2, D3],
        string_codes(X, L),
        atom_number(X, Y),
        integer(Y),
        Y =< 255
    }.

sub_IP([D1, D2, D3, DOT | Ds]) -->
    any_digit(D1), any_digit(D2), any_digit(D3),
    recognize_dot(DOT),
    {
        L = [D1, D2, D3],
        string_codes(X, L),
        atom_number(X, Y),
        integer(Y),
        Y =< 255
    },
    sub_IP(Ds).



ip([D1, D2, D3, DOT, D4, D5, D6, DOT, D7, D8, D9, DOT, D10, D11, D12]) -->
    sub_IP([D1, D2, D3, DOT]), sub_IP([D4, D5, D6, DOT]),
    sub_IP([D7, D8, D9, DOT]), sub_IP([D10, D11, D12]).

%                    SCHEME
scheme([Scheme]) --> other_identificator(Scheme).


%                    USERINFO
userinfo(UserInfo) --> other_identificator(UserInfo).


%                    PORT
port([Port]) --> any_digit(Port).
port([Port | Ps]) --> any_digit(Port), port(Ps).

%                     QUERY
query([Query]) -->
    characters(Query),
    {
        subtract(Query, [35], Check),
        Check = Query
    }.

query([Query | Qs]) -->
    characters(Query),
    {
        subtract(Query, [35], Check),
        Check = Query
    }, !,
    query(Qs).

%                    FRAGMENT
fragment([Fragment]) --> characters(Fragment).
fragment([Fragment | Fs]) -->
    characters(Fragment),
    !, fragment(Fs).

%                    PATH

path([Id]) -->
    other_identificator(Id).

path([Id, Slash | Cs]) -->
    other_identificator(Id),
    recognize_slash(Slash),
    !,
    path(Cs).

%                   HOST

host([Id]) -->
    other_host_identificator(Id).

host([Id, Dot | OtherHost]) -->
    other_host_identificator(Id),
    recognize_dot(Dot),
    !,
    host(OtherHost).


host(Ip) --> ip(Ip).

%                    AUTHORITY

authority([Slash1, Slash2, Host], auth([], RHost, 80)) -->
    recognize_slash(Slash1),
    recognize_slash(Slash2),
    host(Host),
    {
        L = Host,
        appiattisci(L, A),
        atom_codes(RHost, A)
    }.

authority([Slash1, Slash2, UserInfo, At, Host],
          auth(UInfo, RHost, 80)) -->
    recognize_slash(Slash1),
    recognize_slash(Slash2),
    userinfo(UserInfo),
    {
        L = UserInfo,
        appiattisci(L, A),
        atom_codes(UInfo, A)
    },
    recognize_at(At),
    host(Host),
    {
        L2 = Host,
        appiattisci(L2, B),
        atom_codes(RHost, B)
    }.


authority([Slash1, Slash2, Host, Colon, Port],
          auth([], RHost, RPort)) -->
    recognize_slash(Slash1),
    recognize_slash(Slash2),
    host(Host),
    {
        L = Host,
        appiattisci(L, A),
        atom_codes(RHost, A)
    },
    recognize_colon(Colon),
    port(Port),
    {
        L2 = Port,
        appiattisci(L2, B),
        atom_codes(RPort, B)
    }.

authority([Slash1, Slash2, UserInfo, At, Host, Colon, Port],
          auth(Userinfo, RHost, RPort)) -->
    recognize_slash(Slash1),
    recognize_slash(Slash2),
    userinfo(UserInfo),
    {
        L = UserInfo,
        appiattisci(L, A),
        atom_codes(Userinfo, A)
    },
    recognize_at(At),
    host(Host),
    {
        L2 = Host,
        appiattisci(L2, B),
        atom_codes(RHost, B)
    },
    recognize_colon(Colon),
    port(Port),
    {
        L3 = Port,
        appiattisci(L3, C),
        atom_codes(RPort, C)
    }.

% ZOS

get_length([_], Length) :- Length is 1, !.

get_length([_ | Xs], Length) :-
    get_length(Xs, L),
    Length is 1 + L.


get_first_char([F], [F]) :- !.

get_first_char([F | _], [F]) :- !.



get_last_char([F], [F]) :- !.

get_last_char([_ | Fs], L) :-
    get_last_char(Fs, L).


id44([X], Res) -->
    id44_identificator(X),
    { Res = X }.

id44([X | Xs], Res) -->
    id44_identificator(X),
    !,
    id44(Xs, L),
    { Res = [X, L] }.


id8([X], Res) -->
    other_id_identificator(X),
    {Res = X}.

id8([X | Xs], Res) -->
    other_id_identificator(X),
    !,
    id8(Xs, L),
    { Res = [X, L] }.


zos([Id44]) -->
    id44(Id44, Y),
    {appiattisci(Y, B)},
    {
        get_length(B, L1),
        L1 =< 44,
        get_first_char(B, A),
        phrase(letter(_), A),
        get_last_char(B, LChar),
        phrase(control_dot(_), LChar)
    }.



zos([Id44, Obracket, Id8, Cbracket]) -->
    id44(Id44, Y),
    { appiattisci(Y, B) },
    recognize_open_bracket(Obracket),
    !,
    id8(Id8, Z),
    { appiattisci(Z, C) },
    recognize_close_bracket(Cbracket),
    !,
    {
        get_length(B,L1),
        get_length(C,L2),
        L1 =< 44,
        L2 =< 8,
        % A e D saranno i primi char
        % di id44 e id8
        get_first_char(B, A),
        get_first_char(C, D),
        phrase(letter(_), A),
        phrase(letter(_), D),
        get_last_char(B, LCId44),
        phrase(control_dot(_), LCId44)
    }.




% URI

uri_p([Scheme, Colon],
      uri(RScheme, [], [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon).



uri_p([Scheme, Colon, Slash],
      uri(RScheme, [], [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash).



uri_p([Scheme, Colon, Auth],
      uri(Atom, Userinfo, RHost, RPort, [], [], [])) -->
    scheme(Scheme),
    {
        L2 = Scheme,
        appiattisci(L2, A),
        atom_codes(Atom, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(UserInfo, Host, Port)),
    {
        Userinfo = UserInfo,
        RHost = Host,
        RPort = Port
    }.




% URI TOTALE
uri_p([Scheme, Colon, Auth, Slash, Path, Qmark, Query, Hash, Frag],
      uri(RScheme, Userinfo, RHost, RPort, RPath, RQuery, RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    },
    recognize_qmark(Qmark),
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L3 = Frag,
        appiattisci(L3, D),
        atom_codes(RFrag, D)
    }.


uri_p([Scheme, Colon, Auth, Slash],
      uri(RScheme, Userinfo, RHost, RPort, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash).


uri_p([Scheme, Colon, Auth, Slash, Path],
      uri(RScheme, Userinfo, RHost, RPort, RPath, [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    }.

uri_p([Scheme, Colon, Slash, Path],
      uri(RScheme, [], [], 80,  RPath, [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    }.



uri_p([Scheme, Colon, Slash, Qmark, Query],
      uri(RScheme, [], [], 80, [], RQuery, [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    recognize_qmark(Qmark),
    query(Query),
    {
        L1 = Query,
        appiattisci(L1, B),
        atom_codes(RQuery, B)
    }.

uri_p([Scheme, Colon, Slash, Hash, Frag],
      uri(RScheme, [], [], 80, [], [], RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    recognize_hash(Hash),
    fragment(Frag),
    {
        L1 = Frag,
        appiattisci(L1, B),
        atom_codes(RFrag, B)
    }.

uri_p([Scheme, Colon, Slash, Path, Qmark, Query],
      uri(RScheme, [], [], 80, RPath, RQuery, [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    },
    recognize_qmark(Qmark),
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    }.

uri_p([Scheme, Colon, Slash, Path, Hash, Frag],
      uri(RScheme, [], [], 80, RPath, [], RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L2 = Frag,
        appiattisci(L2, C),
        atom_codes(RFrag, C)
    }.



uri_p([Scheme, Colon, Auth, Slash, Qmark, Query],
      uri(RScheme, Userinfo, RHost, RPort, [], RQuery, [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash),
    recognize_qmark(Qmark),
    query(Query),
    {
        L1 = Query,
        appiattisci(L1, B),
        atom_codes(RQuery, B)
    }.

uri_p([Scheme, Colon, Auth, Slash, Hash, Frag],
      uri(RScheme, Userinfo, RHost, RPort, [], [], RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash),
    recognize_hash(Hash),
    fragment(Frag),
    {
        L1 = Frag,
        appiattisci(L1, B),
        atom_codes(RFrag, B)
    }.

uri_p([Scheme, Colon, Auth, Slash, Path, Qmark, Query],
      uri(RScheme, Userinfo, RHost, RPort, RPath, RQuery, [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    },
    recognize_qmark(Qmark),
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    }.

uri_p([Scheme, Colon, Slash, Qmark, Query, Hash, Frag],
      uri(RScheme, [], [], 80, [], RQuery, RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    recognize_qmark(Qmark),
    query(Query),
    {
        L1 = Query,
        appiattisci(L1, B),
        atom_codes(RQuery, B)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L2 = Frag,
        appiattisci(L2, C),
        atom_codes(RFrag, C)
    }.

uri_p([Scheme, Colon, Slash, Path, Qmark, Query, Hash, Frag],
      uri(RScheme, [], [], 80, RPath, RQuery, RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    },
    recognize_qmark(Qmark),
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L3 = Frag,
        appiattisci(L3, D),
        atom_codes(RFrag, D)
    }.


uri_p([Scheme, Colon, Auth, Slash, Path, Hash, Frag],
      uri(RScheme, Userinfo, RHost, RPort, RPath, [], RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash),
    path(Path),
    {
        L1 = Path,
        appiattisci(L1, B),
        atom_codes(RPath, B)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L2 = Frag,
        appiattisci(L2, C),
        atom_codes(RFrag, C)
    }.

uri_p([Scheme, Colon, Auth, Slash, Qmark, Query, Hash, Frag],
      uri(RScheme, Userinfo, RHost, RPort, [], RQuery, RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(Userinfo, RHost, RPort)),
    recognize_slash(Slash),
    recognize_qmark(Qmark),
    query(Query),
    {
        L1 = Query,
        appiattisci(L1, B),
        atom_codes(RQuery, B)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L2 = Frag,
        appiattisci(L2, C),
        atom_codes(RFrag, C)
    }.

% MAILTO
uri_pm([Scheme, Colon],
       uri(RScheme, [], [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon).

uri_pm([Scheme, Colon, UserInfo],
       uri(RScheme, Userinfo, [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    userinfo(UserInfo),
    {
        L1 = UserInfo,
        appiattisci(L1, B),
        atom_codes(Userinfo, B)
    }.


uri_pm([Scheme, Colon, UserInfo, At, Host],
       uri(RScheme, Userinfo, RHost, 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    !,
    userinfo(UserInfo),
    {
        L1 = UserInfo,
        appiattisci(L1, B),
        atom_codes(Userinfo, B)
    },
    recognize_at(At),
    host(Host),
    {
        L2 = Host,
        appiattisci(L2, C),
        atom_codes(RHost, C)
    }.

% NEWS
uri_pn([Scheme, Colon],
       uri(RScheme, [], [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon).


uri_pn([Scheme, Colon, Host],
       uri(RScheme, [], RHost, 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    !,
    host(Host),
    {
        L1 = Host,
        appiattisci(L1, B),
        atom_codes(RHost, B)
    }.



% TEL E FAX
uri_pt([Scheme, Colon],
       uri(RScheme, [], [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon).


uri_pt([Scheme, Colon, UserInfo],
       uri(RScheme, Userinfo, [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    !,
    userinfo(UserInfo),
    {
        L1 = UserInfo,
        appiattisci(L1, B),
        atom_codes(Userinfo, B)
    }.


%ZOS
uri_pz([Scheme, Colon],
       uri(RScheme, [], [], 80, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon).


uri_pz([Scheme, Colon, Slash, Zos],
       uri(RScheme, [], [], 80, RZos, [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    }.


uri_pz([Scheme, Colon, Auth],
       uri(RScheme, RUserinfo, RHost, RPort, [], [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(RUserinfo, RHost, RPort)).


uri_pz([Scheme, Colon, Auth, Slash, Zos],
       uri(RScheme, RUserinfo, RHost, RPort, RZos, [], [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(RUserinfo, RHost, RPort)),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    }.


uri_pz([Scheme, Colon,Auth, Slash, Zos, Qmark, Query],
       uri(RScheme, RUserinfo, RHost, RPort, RZos, RQuery, [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(RUserinfo, RHost, RPort)),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    },
    recognize_qmark(Qmark),
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    }.


uri_pz([Scheme, Colon, Slash, Zos, Qmark, Query],
       uri(RScheme, [], [], 80, RZos, RQuery, [])) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    },
    recognize_qmark(Qmark),
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    }.


uri_pz([Scheme, Colon, Slash, Zos, Hash, Frag],
       uri(RScheme, [], [], 80, RZos, [], RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L2 = Frag,
        appiattisci(L2, C),
        atom_codes(RFrag, C)
    }.


uri_pz([Scheme, Colon, Auth, Slash, Zos, Hash, Frag],
       uri(RScheme, RUserinfo, RHost, RPort, RZos, [], RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    authority(Auth, auth(RUserinfo, RHost, RPort)),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L2 = Frag,
        appiattisci(L2, C),
        atom_codes(RFrag, C)
    }.

uri_pz([Scheme, Colon, Slash, Zos, Qmark, Query, Hash, Frag],
       uri(RScheme, [], [], 80, RZos, RQuery, RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    },
    recognize_qmark(Qmark), !,
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L3 = Frag,
        appiattisci(L3, D),
        atom_codes(RFrag, D)
    }.



uri_pz([Scheme, Colon, Auth, Slash, Zos, Qmark, Query, Hash, Frag],
       uri(RScheme, RUserinfo, RHost, RPort, RZos, RQuery, RFrag)) -->
    scheme(Scheme),
    {
        L = Scheme,
        appiattisci(L, A),
        atom_codes(RScheme, A)
    },
    recognize_colon(Colon),
    !,
    authority(Auth, auth(RUserinfo, RHost, RPort)),
    recognize_slash(Slash),
    zos(Zos),
    {
        L1 = Zos,
        appiattisci(L1, B),
        atom_codes(RZos, B)
    },
    recognize_qmark(Qmark),
    query(Query),
    {
        L2 = Query,
        appiattisci(L2, C),
        atom_codes(RQuery, C)
    },
    recognize_hash(Hash),
    fragment(Frag),
    {
        L3 = Frag,
        appiattisci(L3, D),
        atom_codes(RFrag, D)
    }.


%                   URI_DISPLAY

uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)
            , FilePath) :-
    open(FilePath, write, File),
    write(File, "Scheme: "),
    write(File, Scheme),
    nl(File),
    write(File, "Userinfo:"),
    write(File, Userinfo),
    nl(File),
    write(File, "Host:\t"),
    write(File, Host),
    nl(File),
    write(File, "Port:\t"),
    write(File, Port),
    nl(File),
    write(File, "Path:\t"),
    write(File, Path),
    nl(File),
    write(File, "Query:\t"),
    write(File, Query),
    nl(File),
    write(File, "Fragment: "),
    write(File, Fragment),
    !,
    close(File).

uri_display(String, FilePath):-
    atom_string(String, X),
    atom_codes(X, Y),
    phrase(uri_p(_, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment) ),
           Y),
    !,
    open(FilePath, write, File),
    write(File, "Scheme: "),
    write(File, Scheme),
    nl(File),
    write(File, "Userinfo:"),
    write(File, Userinfo),
    nl(File),
    write(File, "Host:\t"),
    write(File, Host),
    nl(File),
    write(File, "Port:\t"),
    write(File, Port),
    nl(File),
    write(File, "Path:\t"),
    write(File, Path),
    nl(File),
    write(File, "Query:\t"),
    write(File, Query),
    nl(File),
    write(File, "Fragment: "),
    write(File, Fragment),
    close(File).

uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    write("Scheme: "),
    writeln(Scheme),
    write("Userinfo:"),
    writeln(Userinfo),
    write("Host:\t"),
    writeln(Host),
    write("Port:\t"),
    writeln(Port),
    write("Path:\t"),
    writeln(Path),
    write("Query:\t"),
    writeln(Query),
    write("Fragment: "),
    writeln(Fragment),
    !.

uri_display(String) :-
    atom_string(String, X),
    atom_codes(X, Y),
    phrase(uri_p(_, Uri), Y),
    uri_display(Uri),
    !.

% appiattisci

appiattisci([], []) :- !.

appiattisci([L | Ls], ResList) :-
    !,
    appiattisci(L, X),
    appiattisci(Ls, Y),
    append(X, Y, ResList).

appiattisci(L, [L]).

read_s_colon(String, Res) :-
    split_string(String, ":", ":", [L | _]),
    !,
    Res = L.

% uri_parse

uri_parse(String, X) :-
    read_s_colon(String, L),
    string_lower(L, Sch),
    Sch = "zos",
    !,
    uri_parse20(String, X).

uri_parse(String, X) :-
    read_s_colon(String, L),
    string_lower(L, Sch),
    Sch = "fax",
    !,
    uri_parse21(String, X).

uri_parse(String, X) :-
    read_s_colon(String, L),
    string_lower(L, Sch),
    Sch = "tel",
    !,
    uri_parse21(String, X).

uri_parse(String, X) :-
    read_s_colon(String, L),
    string_lower(L, Sch),
    Sch = "news",
    !,
    uri_parse22(String, X).

uri_parse(String, X) :-
    read_s_colon(String, L),
    string_lower(L, Sch),
    Sch = "mailto",
    !,
    uri_parse23(String, X).

uri_parse(String, X) :-
    uri_parse1(String, X).

uri_parse1(String, Z) :-
    atom_string(String, X),
    atom_codes(X, Y),
    phrase(uri_p(_, URI), Y),
    Z = URI,
    !.

uri_parse20(String, Z) :-
    atom_string(String, X),
    atom_codes(X, Y),
    phrase(uri_pz(_, URI), Y),
    Z = URI,
    !.

uri_parse21(String, Z) :-
    atom_string(String, X),
    atom_codes(X, Y),
    phrase(uri_pt(_, URI), Y),
    Z = URI,
    !.


uri_parse22(String, Z) :-
    atom_string(String, X),
    atom_codes(X, Y),
    phrase(uri_pn(_, URI), Y),
    Z = URI,
    !.

uri_parse23(String, Z) :-
    atom_string(String, X),
    atom_codes(X, Y),
    phrase(uri_pm(_, URI), Y),
    Z = URI,
    !.
