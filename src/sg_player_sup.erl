-module(sg_player_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?SERVER, []).

start_child(Name) ->
    supervisor:start_child(?SERVER, [Name]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    PlayerProces = {sg_player, {sg_player, start_link, []},
                    temporary, brutal_kill, worker, [sg_player]},

    % simple_one_for_one: All child processes are dynamically added instances of the same process.
    RestartStrategy = {simple_one_for_one, 0, 1},
    {ok, {RestartStrategy, [PlayerProces]}}.

