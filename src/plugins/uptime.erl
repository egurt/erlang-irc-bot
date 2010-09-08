-module(plugins.uptime).
-author("gdamjan@gmail.com").

-behaviour(gen_event).
-export([init/1, handle_event/2, terminate/2, handle_call/2, handle_info/2, code_change/3]).

-import(calendar).
-import(io_lib).
-import(lists).

init(_Args) ->
    {ok, []}.

uptime() ->
    {UpTime, _ } = erlang:statistics(wall_clock),
    {D, {H, M, S}} = calendar:seconds_to_daystime(UpTime div 1000),
    lists:flatten(io_lib:format("~p days, ~p hours, ~p minutes and ~p seconds", [D,H,M,S])).

handle_event(Msg, State) ->
    case Msg of
       {in, Ref, [_Sender, _Name, <<"PRIVMSG">>, <<Channel/binary>>, <<"!uptime">>]} ->
            Ref:send_data(["PRIVMSG ", Channel, " :", uptime()]),
            {ok, State};
        _ ->
            {ok, State}
    end.


handle_call(_Request, State) -> {ok, ok, State}.
handle_info(_Info, State) -> {ok, State}.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
terminate(_Args, _State) -> ok.
