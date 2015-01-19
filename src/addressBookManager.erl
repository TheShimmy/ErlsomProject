%%%-------------------------------------------------------------------
%%% @author Przemysław
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. sty 2015 17:50
%%%-------------------------------------------------------------------
-module (addressBookManager).

-export ([loadPeople/2, savePeople/2]).
-import(erlsom, []).

-record(contact, {fname, lname, phone = [], email = []}).
-record (peopleType, {anyAttribs, listOfPeople}).
-record (personType, {anyAttribs, firstName, lastNames, listOfPhones, listOfEmails}).
-record (phoneListType, {anyAttribs, list}).
-record (emailListType, {anyAttribs, list}).

loadPeople(XmlFilename, XsdFilename) ->
  Model = loadModel(XsdFilename),
  {ok, Out, _} = erlsom:scan_file(XmlFilename, Model),
  lists:foreach(fun(Contact) -> loadPerson(Contact) end, Out#peopleType.listOfPeople).

loadModel(XsdFilename) ->
  {ok, Model} = erlsom:compile_xsd_file(XsdFilename),
  Model.

loadPerson(#personType{firstName = FName, lastNames = LName, listOfPhones = ListOfPhones, listOfEmails = ListOfEmails}) ->
  addressBookServer:addContact(FName, LName),
  lists:foreach(fun(Phone) -> addressBookServer:addPhone(FName, LName, Phone) end, ListOfPhones#phoneListType.list),
  lists:foreach(fun(Email) -> addressBookServer:addEmail(FName, LName, Email) end, ListOfEmails#emailListType.list).

savePeople(XmlFilename, XsdFilename) ->
  Model = loadModel(XsdFilename),
  {ok, XML} = erlsom:write({peopleType, [], [formatPerson(Contact) || Contact <- addressBookServer:showBook()]}, Model),
  file:write_file(XmlFilename, list_to_binary(XML)).

formatPerson(#contact{fname = FName, lname = LName, phone = Phones, email = Emails}) ->
  {personType, [], FName, LName, {phoneListType, [], [Phone || Phone <- Phones]}, {emailListType, [], [Email || Email <- Emails]}}.

