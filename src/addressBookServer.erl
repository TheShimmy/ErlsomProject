%%%-------------------------------------------------------------------
%%% @author Przemysław
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. sty 2015 17:46
%%%-------------------------------------------------------------------
-module(addressBookServer).
-export([start/0, stop/0, init/0, loop/1]).
-export([showBook/0, addContact/2, addPhone/3, addEmail/3]).

start() ->
  register(book_server, spawn_link(?MODULE, init, [])).

stop() ->
  book_server ! stop_server,
  unregister(book_server).

init() ->
  loop(addressBook:createAddressBook()).

loop(Book) ->
  receive
    {addContact, Pid, FName, LName} ->
      Result = addressBook:addContact(FName, LName, Book),
      handleResult(Book, Result, Pid);
    {addPhone, Pid, FName, LName, Phone} ->
      Result = addressBook:addPhone(FName, LName, Phone, Book),
      handleResult(Book, Result, Pid);
    {addEmail, Pid, FName, LName, Email} ->
      Result = addressBook:addEmail(FName, LName, Email, Book),
      handleResult(Book, Result, Pid);
    {show_book, Pid} ->
      Pid ! Book,
      loop(Book);
    stop_server ->
      ok
  end.

showBook() ->
  book_server ! {show_book, self()},
  receive
    Book -> Book
  end.

addContact(FName, LName) ->
  book_server ! {addContact, self(), FName, LName},
  handleResponse().

addPhone(FName, LName, Phone) ->
  book_server ! {addPhone, self(), FName, LName, Phone},
  handleResponse().

addEmail(FName, LName, Email) ->
  book_server ! {addEmail, self(), FName, LName, Email},
  handleResponse().

handleResponse() ->
  receive
    {error, Message} -> Message;
    ok -> ok
  end.

handleResult(OldBook, Result, Pid) ->
  case Result of
    {error, Message} ->
      Pid ! {error, Message},
      loop(OldBook);
    NewBook ->
      Pid ! ok,
      loop(NewBook)
  end.