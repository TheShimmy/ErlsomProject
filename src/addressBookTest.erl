%%%-------------------------------------------------------------------
%%% @author Przemysław
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. sty 2015 17:50
%%%-------------------------------------------------------------------
-module (addressBookTest).

-export ([start/0, stop/0, showBook/0, loadFromXml/0, loadFromNewXml/0, addNewPerson/0, saveToXml/0]).

start() ->
  addressBookServer:start().

stop() ->
  addressBookServer:stop().

showBook() ->
  addressBookServer:showBook().

loadFromXml() ->
  addressBookManager:loadPeople("data/ab.xml", "data/ab.xsd").

loadFromNewXml() ->
  addressBookManager:loadPeople("new.xml", "data/ab.xsd").

addNewPerson() ->
  addressBookServer:addContact("Jakub", "Dlubak"),
  addressBookServer:addPhone("Jakub", "Dlubak", 235711),
  addressBookServer:addPhone("Jakub", "Dlubak", 117532),
  addressBookServer:addEmail("Jakub", "Dlubak", "jakubdlubak@gmail.com"),

  addressBookServer:addContact("Jan", "Kowalski"),
  addressBookServer:addPhone("Jan", "Kowalski", 235711123),
  addressBookServer:addPhone("Jan", "Kowalski", 117532123),
  addressBookServer:addEmail("Jan", "Kowalski", "jankowalski@gmail.com").

saveToXml() ->
  addressBookManager:savePeople("new.xml", "data/ab.xsd").

