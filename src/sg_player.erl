%% @author Stefano Oldeman <stefano.oldeman@gmail.com>
%% @copyright 2013-2014.

-module(sg_player).

-behaviour(gen_server).

-export([start_link/1, create/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

start_link(Name) ->
    %% Note: Name is omitted, the gen_server is not registered.
    %% (where usually Name={local, ?SERVER})
    %% Instead its pid must be used!!!
    gen_server:start_link(?SERVER, [Name], []).

init([Name]) ->
    State={},
    lager:log(info, [], "~s created~n", [Name]),
    {ok, State}.


%%--------------------------------------------------------------------
%%  %% API (delegated to sync | async calls)
%%--------------------------------------------------------------------

create(Name) ->
    sg_player_sup:start_child(Name).

%%--------------------------------------------------------------------
%%  %% Callback functions for gen_server
%%--------------------------------------------------------------------
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
