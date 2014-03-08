
-module(slayer_game).

-export([join/1]).


join(PlayerName) ->
    {ok, NrOfPlayers}=sg_world:add_player(PlayerName),
    lager:log(info, [], "~s is playing with ~p others", [PlayerName, NrOfPlayers]).
