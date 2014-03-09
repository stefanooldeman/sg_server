%% @author Stefano Oldeman <stefano.oldeman@gmail.com>
%% @copyright 2013-2014.

-module(sg_world).

-behaviour(gen_server).

-export([start_link/0,
         add_player/2,
         get_players_list/0,
         attack_player/2]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
        players :: [{string(), pid()}]
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
add_player(Name, Pid) ->
    Nr=gen_server:call(?SERVER, {add_player, {Name, Pid}}),
    {ok, Nr}.

get_players_list() ->
    gen_server:call(?SERVER, list_players).

attack_player(Player1, Player2) ->
    gen_server:cast(?SERVER, {attack_player, {Player1, Player2}}).

%%--------------------------------------------------------------------
%%  %% Callback functions for gen_server
%%--------------------------------------------------------------------
%%
handle_call({add_player, Val}, _From, State) ->
    NewList=[Val|State#state.players],
    {reply, length(NewList), State#state{players=NewList}};

handle_call(list_players, _From, State) ->
    Names=proplists:get_keys(State#state.players),
    {reply, Names, State};

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast({attack_player, {Player1, Player2}}, State) ->
    Attacker=proplists:get_value(Player1, State#state.players),
    Defender=proplists:get_value(Player2, State#state.players),
    case sg_player:attack(Defender, 50) of
        {ok, Hp} when is_integer(Hp) ->
            lager:log(info, [], "player ~p has ~p HP ~n", [Player2, Hp]);
        {ok, dead} ->
            {ok, Nr} = sg_player:incr_kills(Attacker),
            lager:log(info, [], "player ~p has ~p kills~n", [Player1, Nr])
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    io:format("terminate called for sg_world...~n"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
