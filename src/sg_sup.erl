
-module(sg_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?SERVER, []).


%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    Server = {sg_world, {sg_world, start_link, []},
              permanent, 5000, worker, [sg_world]},

    PlayerSup = {sg_player_sup, {sg_player_sup, start_link, []},
                 permanent, 5000, supervisor, [sg_player]},

    Children = [Server, PlayerSup],
    RestartStrategy = {one_for_one, 0, 1},
    {ok, {RestartStrategy, Children}}.
