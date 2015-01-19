%%%-------------------------------------------------------------------
%%% @author Przemysław
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. sty 2015 17:49
%%%-------------------------------------------------------------------
-module(parser).
-export([parse_to_sax/1, parse_to_simple_dom/1]).
-import(erlsom, []).
-import(file, []).

parse_to_sax(File)->
  case file:read_file(File) of
    {error, _} -> {error, "Could not find file"};
    {ok, Xml} ->
      erlsom:parse_sax(Xml, [], fun(Event, Acc) -> io:format("~p~n", [Event]), Acc end)
  end.

parse_to_simple_dom(File)->
  case file:read_file(File) of
    {error, _} -> {error, "Could not find file"};
    {ok, Xml} ->
      erlsom:simple_form(Xml)
  end.
