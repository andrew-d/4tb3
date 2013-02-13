program Question3;

const
    NumberOfStates = 20;

type
    State = 0..20;
    StateSet = set of State;
    StateArray = array of State;
    Token = 'a'..'z';
    Transition = record
                    source : State;
                    token  : Token;
                    target : State;
                 end;
    TransitionList = array of Transition;

var
    initial_state : State;
    final_states  : StateArray;
    transitions   : TransitionList;

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


procedure PrintState();
var
    i : State;

begin
    writeln('------------------------------');
    write('All states: ');
    for i in all_states do
    begin
        write(i, ', ');
    end;
    writeln('');

    writeln('Initial state: ', initial_state);

    writeln('Transitions:');
    for tmp_trans in transitions do
        writeln('  ', tmp_trans.source, ' --> ', tmp_trans.token, ' --> ', tmp_trans.target);

    writeln('Final states:');
    for i in final_states do
    begin
        write(i, ', ');
    end;
    writeln('');
    writeln('------------------------------');
end;


procedure RemoveUnreachable();
var
    reachable_states, new_states : StateSet;
    temp, empty_set : StateSet;
    c : char;
    q : State;
    p : Transition;

    new_transitions : TransitionList;
    new_final       : StateArray;

begin
    reachable_states := [initial_state];
    new_states := [initial_state];
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

        new_states := temp - reachable_states;
        reachable_states := reachable_states + new_states;
    until new_states = empty_set;

    (* Create list of transitions that only include states in the reachable set *)
    SetLength(new_transitions, 0);
    for p in transitions do
    begin
        if (p.source in reachable_states) then
        begin
            SetLength(new_transitions, Length(new_transitions) + 1);
            new_transitions[Length(new_transitions) - 1] := p;
        end;
    end;

    transitions := new_transitions;

    (* Remove all final states that are unreachable. *)
    SetLength(new_final, 0);
    for q in final_states do
    begin
        if (q in reachable_states) then
        begin
            SetLength(new_final, Length(new_final) + 1);
            new_final[Length(new_final) - 1] := q;
        end;
    end;

    final_states := new_final;

    (* Reset set of all states to that of reachable states *)
    all_states := reachable_states;
end;


procedure MinimizeDFA();
var
    mark_list           : array of integer;
    i, j                : State;
    tmp, tmp2           : State;
    unmarked, marked    : integer;

    procedure SetMark(var state1 : State; var state2 : State; var b : integer);
    var
        idx : integer;
    begin
        idx := state1 * NumberOfStates + state2;
        mark_list[idx] := b;

        idx := state2 * NumberOfStates + state1;
        mark_list[idx] := b;
    end;

    function GetMark(var state1 : State; var state2 : State) : integer;
    var
        idx1, idx2 : integer;
    begin
        idx1 := state1 * NumberOfStates + state2;
        idx2 := state2 * NumberOfStates + state1;
        GetMark := mark_list[idx1] or mark_list[idx2];
    end;

begin
    unmarked := 0;
    marked := 1;

    (* All states start as unmarked *)
    SetLength(mark_list, NumberOfStates * NumberOfStates);
    for i := 0 to NumberOfStates - 1 do
    begin
        for j := 0 to NumberOfStates - 1 do
        begin
            tmp := i;
            tmp2 := j;      (* I get a strange error otherwise... *)
            SetMark(tmp, tmp2, unmarked);
        end;
    end;

    (* Mark pairs of final and nonfinal states *)
    for i in final_states do
    begin
        for j in all_states do
        begin
        end;
    end;
end;


begin
    (* The format of the input is as follows:
        initial state
        final state(s), seperated by blanks
        [one or more lines, transition as (source, symbol, target)]
    *)
    ReadInput();

    (* Create set of states *)
    all_states := [initial_state];
    for tmp_state in final_states do
        Include(all_states, tmp_state);

    for tmp_trans in transitions do
        all_states := all_states + [tmp_trans.source, tmp_trans.target];

    PrintState();

    (* Remove unreachable states *)
    writeln('Removing unreachable states...');
    RemoveUnreachable();
    PrintState();

    (* Remove nondistinguishable states *)

end.
