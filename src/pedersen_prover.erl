-module(pedersen_prover).

%% API exports
-export([new/3, commit/2]).

-record(prover, {
          q,
          g,
          h
         }).

%%====================================================================
%% API functions
%%====================================================================
new(Q, G, H) ->
    {ok, #prover{q=Q, g=G, h=H}}.

commit(_Prover = #prover{q=Q, g=G, h=H}, Msg) ->
    R = rand:uniform(Q - 1),
    C = ((math:pow(G, Msg) rem Q) * (math:pow(H, R) rem Q)) rem Q,
    {ok, {C, R}}.


%%====================================================================
%% Internal functions
%%====================================================================
