-module(addressBook).
-author("kurtz").

%% API
-export([createAddressBook/0, addContact/3, addEmail/4, addPhone/4, isExist/3]).
-record(contact, {fname, lname, phone = [], email = []}).

createAddressBook() -> [].

isExist(_, List, Fun) -> lists:any(Fun, List).

addContact(FName, LName, AB) ->
  case isExist([FName, LName], AB, fun(X) -> X == #contact{fname = FName, lname = LName} end) of
    false ->[#contact{fname = FName, lname = LName} | AB];
    true -> {error, "Contact ["++FName++", "++LName++"] already exist"}
  end.

add(_, _, _, [], _) -> [];
add(FName, LName, _, [H= #contact{fname = FName, lname = LName} | R], Fun) -> [Fun(H) | R];
add(FName, LName, Value, [H | R], Fun) -> [H | add(FName, LName, Value, R, Fun)].

addEmail(FName, LName, Email, AB) ->
  case {isExist(Email, AB, fun(X) -> isExist(Email, X#contact.email, fun(Y) -> Email == Y end) end),
        isExist([FName, LName], AB, fun(X) -> X#contact.fname==FName andalso X#contact.lname==LName  end)} of
    {true, _} -> {error, "Email ["++Email++"] already exist"};
    {false, false} -> {error, "Contact ["++FName++", "++LName++"] doesn't exist"};
    {false, true} -> add(FName, LName, Email, AB,
      fun(X) -> X#contact{fname = FName, lname = LName, phone = X#contact.phone, email = X#contact.email++[Email]} end)
  end.

addPhone(FName, LName, Phone, AB) ->
  case {isExist(Phone, AB, fun(X) -> isExist(Phone, X#contact.phone, fun(Y) -> Phone == Y end) end),
        isExist([FName, LName], AB, fun(X) -> X#contact.fname==FName andalso X#contact.lname==LName end)} of
    {true, _} -> {error, "Phone ["++Phone++"] already exist"};
    {false, false} -> {error, "Contact ["++FName++", "++LName++"] doesn't exist"};
    {false, true} -> add(FName, LName, Phone, AB,
      fun(X) -> X#contact{fname = FName, lname = LName, phone = X#contact.phone++[Phone], email = X#contact.email} end)
  end.

