%% @author Stefano Oldeman <stefano.oldeman@spilgames.com>
%% @copyright 2013 SpilGames.

-module(slayer).

-behaviour(gen_server).

-export([start_link/0, join/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-type proplist() :: [{atom(), term()}].

-record(state, {
        players :: [string()]
}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

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

-spec join(atom()) -> {ok, proplist()}.
join(PlayerName) ->
    lager:log(info, [], "[~s] joined the game~n", [PlayerName]),
    Stats=gen_server:call(?MODULE, {player_add, PlayerName}),
    {ok, Stats}.


%%--------------------------------------------------------------------
%%  %% Callback functions for gen_server
%%--------------------------------------------------------------------
%%
handle_call({player_add, Name}, _From, #state{players=Players}=State) ->
    Stats=[{players_online, 1+length(Players)}],
    NewList=[Name|Players],
    {reply, Stats, State#state{players=NewList}};

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
