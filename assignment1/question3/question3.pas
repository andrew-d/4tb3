program Question3;

const
    NumberOfStates = 20;

type
    State = 0..20;
    StateSet = set of State;
    Token = 'a'..'z';
    Transition = record
                    source : State;
                    token  : Token;
                    target : State;
                 end;
    TransitionList = array of Transition;

var
    initial_state : integer;
    final_states  : array of State;
    transitions   : array of Transition;

    all_states    : StateSet;

    i             : integer;
    tmp_state     : State;
    tmp_trans     : Transition;


procedure ReadInput;
var
    temp_state, src, tar : State;
    tok, blank1, blank2 : char;

begin
    (* Read the initial state *)
    readln(initial_state);

    (* Read all final states *)
    SetLength(final_states, 0);
    repeat
        read(temp_state);
        SetLength(final_states, Length(final_states) + 1);
        final_states[Length(final_states) - 1] := temp_state
    until eoln;

    (* Read all transitions *)
    SetLength(transitions, 0);
    repeat
        readln(src, blank1, tok, blank2, tar);
        SetLength(transitions, Length(transitions) + 1);

        transitions[Length(transitions) - 1].source := src;
        transitions[Length(transitions) - 1].token  := tok;
        transitions[Length(transitions) - 1].target := tar;
    until eof;
end;


function RemoveUnreachable(var start : State; var transitions : TransitionList; var all_states : StateSet) : StateSet;
var
    reachable_states, new_states : StateSet;
    temp, empty_set : StateSet;
    c : char;
    q : State;
    p : Transition;

begin
    reachable_states := [start];
    new_states := [start];
    empty_set := [];

    repeat
        temp := empty_set;
        for q in new_states do
        begin
            for c in Token do
            begin
                for p in transitions do
                begin
                    if (p.source = q) and (p.token = c) then
                        Include(temp, p.target);
                end;
            end;
        end;

        new_states := reachable_states - temp;
        reachable_states := reachable_states + new_states;
    until new_states = empty_set;

    (* Return *)
    RemoveUnreachable := reachable_states;
end;


begin
    (* The format of the input is as follows:
        initial state
        final state(s), seperated by blanks
        [one or more lines, transition as (source, symbol, target)]
    *)
    ReadInput();

    (* Print information *)
    writeln('The initial state is: ', initial_state);
    for i := 0 to Length(final_states) - 1 do
    begin
        writeln('Final state ', i, ' is ', final_states[i]);
    end;

    for tmp_trans in transitions do
        writeln(tmp_trans.source, ' --> ', tmp_trans.token, ' --> ', tmp_trans.target);

    (* Create set of states *)
    all_states := [initial_state];
    for tmp_state in final_states do
        Include(all_states, tmp_state);

    for tmp_trans in transitions do
        all_states := all_states + [tmp_trans.source, tmp_trans.target];

    (* Remove unreachable states *)
    all_states := RemoveUnreachable(initial_state, transitions, all_states);

    (* Remove nondistinguishable sets *)

end.
