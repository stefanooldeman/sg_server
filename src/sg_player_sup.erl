-module(sg_player_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
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
    Childs = [
        ?CHILD(sg_player, worker)
    ],
    % All child processes are dynamically added instances of the same process.
    {ok, { {simple_one_for_one, 0, 1}, Childs} }.

