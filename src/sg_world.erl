%% @author Stefano Oldeman <stefano.oldeman@gmail.com>
%% @copyright 2012-2013.

-module(sg_world).

-behaviour(gen_server).

-export([start_link/0, add_player/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
        players :: [string()]
}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).

init([]) ->
    State=#state{
        players=[]
        %,monsters=[]
        %,scores=[]
    },
    {ok, State}.

%%--------------------------------------------------------------------
%%  %% API (delegated to sync | async calls)
%%--------------------------------------------------------------------
add_player(Name) ->
    Nr=gen_server:call(?SERVER, {add_player, Name}),
    {ok, Nr}.


%%--------------------------------------------------------------------
%%  %% Callback functions for gen_server
%%--------------------------------------------------------------------
%%
handle_call({add_player, Name}, _From, #state{players=Players}=State) ->
    NewList=[Name|Players],
    {reply, length(NewList), State#state{players=NewList}};

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
