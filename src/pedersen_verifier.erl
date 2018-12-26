-module(pedersen_verifier).

%% API exports
-export([new/1, add/2, open/4]).

-record(verifier, {
          p,
          q,
          g,
          h
         }).

%%====================================================================
%% API functions
%%====================================================================
new(_Security) ->
    %% TODO: Generate a large 2*Security Bit prime number
    P = prime:get_random(),
    Q = 2 * P + 1,
    G = rand:uniform(Q - 1),
    H = rand:uniform(Q - 1),
    {ok, {Q, G, H, #verifier{p=P, q=Q, g=G, h=H}}}.

add(_Verifier = #verifier{p=P}, CList) ->
    AddCM = lists:foldl(fun(C, Acc) -> Acc * C end, 1, CList),
    {ok, (AddCM rem P)}.

open(_Verifier = #verifier{g=G, h=H, q=Q}, C, X, RList) ->
    Sum = lists:foldl(fun(R, Acc) -> Acc + R end, 0, RList),
    Res = ((math:pow(G, X) rem Q) * (math:pow(H, Sum) rem Q)) rem Q,
    case Res == C of
        true -> true;
        _ -> false
    end.

%%====================================================================
%% Internal functions
%%====================================================================
