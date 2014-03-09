
-module(slayer_game).

-export([join/1, list/0, attack/2, test/0]).


join(PlayerName) ->
    {ok, Pid}=sg_player:create(PlayerName),
    {ok, NrOfPlayers}=sg_world:add_player(PlayerName, Pid),
    lager:log(info, [], "~s is playing with ~p others", [PlayerName, NrOfPlayers]).

list() ->
    sg_world:get_players_list().

attack(Player1, Player2) ->
    sg_world:attack_player(Player1, Player2).

test() ->
    join(a), join(b), attack(a, b), attack(a, b).
