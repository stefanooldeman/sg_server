%% @author Stefano Oldeman <stefano.oldeman@gmail.com>
%% @copyright 2013-2014.

-module(sg_player).

-behaviour(gen_server).

-export([start_link/1,
         create/1,
         attack/2,
         incr_kills/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
    name :: string(),
    hp :: integer(),
    kills :: integer()
}).

start_link(Name) ->
    %% Note: Name is omitted, the gen_server is not registered.
    %% (where usually Name={local, ?SERVER})
    %% Instead its pid must be used!!!
    gen_server:start_link(?SERVER, [Name], []).

init([Name]) ->
    State=#state{name=Name,
                 hp=100,
                 kills=0},
    lager:log(info, [], "~s created~n", [Name]),
    {ok, State}.


%%--------------------------------------------------------------------
%%  %% API (delegated to sync | async calls)
%%--------------------------------------------------------------------

create(Name) ->
    sg_player_sup:start_child(Name).

attack(Pid, Damage) ->
    Status=gen_server:call(Pid, {damage, Damage}),
    %% Status=(integer() | dead)
    {ok, Status}.

incr_kills(Pid) ->
    Nr=gen_server:call(Pid, incr_kills),
    {ok, Nr}.

%%--------------------------------------------------------------------
%%  %% Callback functions for gen_server
%%--------------------------------------------------------------------
handle_call({damage, Damage}, _From, #state{hp=Hp}=State) ->
    NewHp=Hp-Damage,
    if
        NewHp > 0 ->
            {reply, NewHp, State#state{hp=NewHp}};
        true ->
            {stop, normal, dead, State}
    end;

handle_call(incr_kills, _From, State) ->
    Nr=State#state.kills+1,
    {reply, Nr, State#state{kills=Nr}};

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    io:format("terminate called for player ~p~n", [State#state.name]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
