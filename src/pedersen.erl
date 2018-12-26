-module(pedersen).

%% API exports
-export([run/0]).

%%====================================================================
%% API functions
%%====================================================================
run() ->
    run(2, 3, 4).

run(Security, Msg1, Msg2) ->
    {ok, {Q, G, H, Verifier}} = pedersen_verifier:new(Security),
    {ok, Prover} = pedersen_prover:new(Q, G, H),
    {ok, {C1, R1}} = pedersen_prover:commit(Prover, Msg1),
    {ok, {C2, R2}} = pedersen_prover:commit(Prover, Msg2),
    {ok, AddCM} = pedersen_verifier:add(Verifier, [C1, C2]),
    Result = pedersen_verifier:open(Verifier,
                                    AddCM,
                                    Msg1 + Msg2,
                                    [R1, R2]),
    Result.

%%====================================================================
%% Internal functions
%%====================================================================
