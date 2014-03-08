
-module(sg_world_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/0]).

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

start_child() ->
    supervisor:start_child(?SERVER, []).


%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    Childs = [
        ?CHILD(sg_world, worker)
    ],
    {ok, { {one_for_one, 5, 10}, Childs} }.
