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
    initial_state : State;
    final_states  : StateSet;
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
    final_states := [];
    repeat
        read(temp_state);
        Include(final_states, temp_state);
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
    exit;

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
    new_final       : StateSet;

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
    new_final := [];
    for q in final_states do
    begin
        if (q in reachable_states) then
        begin
            Include(new_final, q);
        end;
    end;

    final_states := new_final;

    (* Reset set of all states to that of reachable states *)
    all_states := reachable_states;
end;


procedure MinimizeDFA();
type
    DependencyNodePtr = ^DependencyNode;
    DependencyNode = Record
        src1 : State;
        src2 : State;

        dst1 : State;
        dst2 : State;

        next : DependencyNodePtr;
    End;

var
    mark_list           : array of integer;
    p, q, r, s          : State;
    t                   : Transition;
    found_r, found_s    : boolean;
    tmp, tmp2           : State;
    unmarked, marked    : integer;
    a                   : Token;

    dependency_list     : DependencyNodePtr;

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

    procedure InitDependencyList();
    begin
        New(dependency_list);
        dependency_list^.next := nil;
    end;

    procedure AddDependency(var src1 : State; var src2 : State; var dst1 : State; var dst2 : State);
    var
        new_node : DependencyNodePtr;

    begin
        New(new_node);

        new_node^.src1 := src1;
        new_node^.src2 := src2;
        new_node^.dst1 := dst1;
        new_node^.dst2 := dst2;

        (* Prepend this node to the dependency list *)
        new_node^.next := dependency_list^.next;
        dependency_list^.next := new_node;
    end;

    (* Find and remove a dependency of state *)
    function FindDependency(var src1 : State; var src2 : State) : DependencyNodePtr;
    var
        curr, last : DependencyNodePtr;
    begin
        FindDependency := nil;
        curr := dependency_list^.next;
        last := dependency_list;

        while curr <> nil do
        begin
            (* If the current p and q matches. *)
            if ((src1 = curr^.src1) and (src2 = curr^.src2)) then
            begin
                (* Remove from list *)
                last^.next := curr^.next;

                (* Return current pointer *)
                FindDependency := curr;
                Break;
            end;

            (* Next item in list *)
            last := curr;
            curr := curr^.next;
        end;
    end;

    procedure RecursiveMark(var p : State; var q : State);
    var
        next_dep : DependencyNodePtr;

    begin
        SetMark(p, q, marked);

        next_dep := FindDependency(p, q);
        while next_dep <> nil do
        begin
            (* writeln('    recursively marking (', next_dep^.dst1, ', ', next_dep^.dst2, ')'); *)
            RecursiveMark(next_dep^.dst1, next_dep^.dst2);
            next_dep := FindDependency(p, q);
        end;
    end;

    procedure RemoveDuplicateTransitions();
    var
        new_transitions     : TransitionList;
        t, u                : Transition;
        found               : boolean;

    begin
        SetLength(new_transitions, 0);
        for t in transitions do
        begin
            found := false;

            for u in new_transitions do
            begin;
                if ((t.source = u.source) and (t.target = u.target) and (t.token = u.token)) then
                    found := true
            end;

            if (not found) then
            begin
                SetLength(new_transitions, Length(new_transitions) + 1);
                new_transitions[Length(new_transitions) - 1] := t;
            end else
            begin
                (* writeln('Not including duplicate transition ', t.source, ' --> ', t.token, ' --> ', t.target); *)
            end;
        end;

        transitions := new_transitions;
    end;

begin
    unmarked := 0;
    marked := 1;

    (* All states start as unmarked *)
    SetLength(mark_list, NumberOfStates * NumberOfStates);
    for p := 0 to NumberOfStates - 1 do
    begin
        for q := 0 to NumberOfStates - 1 do
        begin
            tmp := p;
            tmp2 := q;      (* I get a strange error otherwise... *)
            SetMark(tmp, tmp2, unmarked);
        end;
    end;

    (* All dependencies start empty *)
    InitDependencyList();

    (* Mark pairs of final and nonfinal states *)
    for p in final_states do
    begin
        for q in all_states do
        begin
            if (p <> q) then
            begin
                (* writeln(' marking initial (', p, ', ', q, ')'); *)
                SetMark(p, q, marked);
            end;
        end;
    end;

    (* For each unmarked pair (p,q) and symbol a:
        1. Let r = the transition from p given a
           Let s = the transition from q given a
        2. If (r, s) unmarked, add (p, q) to (r, s)'s dependencies
        3. Otherwise, mark (p, q) and recursively mark all dependencies of
           newly-marked entries.
    *)
    (* writeln(' running marking check...'); *)
    for p in all_states do
    begin
        for q in all_states do
        begin
            (* Check if unmarked.  Note the p < q since this is a diagonal matrix *)
            if ((p < q) and (GetMark(p, q) = unmarked)) then
            begin
                (* For each symbol... *)
                for a in Token do
                begin
                    (* Find a transition from the sources, given a *)
                    found_r := false;
                    found_s := false;

                    for t in transitions do
                    begin
                        if ((t.token = a) and (t.source = p)) then
                        begin
                            r := t.target;
                            found_r := true;
                        end;
                        if ((t.token = a) and (t.source = q)) then
                        begin
                            s := t.target;
                            found_s := true;
                        end;
                    end;

                    (* Check the mark for (r, s) *)
                    if (found_r and found_s) then
                    begin
                        (* writeln('  r = ', r, ', s = ', s); *)
                        if (GetMark(r, s) = unmarked) then
                        begin
                            (* writeln('   unmarked, adding dependency from (', r, ', ', s, ') --> (', p, ', ', q, ')'); *)
                            (* (r, s) unmarked *)
                            AddDependency(r, s, p, q);
                        end else
                        begin
                            (* writeln('   marked, recursively marking (', p, ', ', q, ')'); *)
                            (* (r, s) marked, so mark (p, q) and all dependencies
                               of things that are marked
                            *)
                            RecursiveMark(p, q);
                        end;
                    end;
                end;
            end;
        end;
    end;

    (* Coalesce unmarked pairs of states.
       We do this by looping through the mark set and adding all states that are
       marked, and then going through and creating new sets for each pair in increasing
       number from the highest marked set.
    *)
    for p in all_states do
    begin
        for q in all_states do
        begin
            if ((p < q) and (GetMark(p, q) = unmarked)) then
            begin
                (* writeln(' pair (', p, ', ', q, ') is unmarked'); *)

                if (initial_state = q) then
                    initial_state := p;

                (* Remove the higher state (q) from our list of all states *)
                Exclude(all_states, q);

                (* If either is final, then we make the lower one final. *)
                if ((p in final_states) or (q in final_states)) then
                    Include(final_states, p);
                Exclude(final_states, q);

                (* Finally, go through all transitions and make the transition point
                   to the lower state *)
                for i := 1 to Length(transitions) - 1 do
                begin
                    if (transitions[i].source = q) then
                        transitions[i].source := p;
                    if (transitions[i].target = q) then
                        transitions[i].target := p;
                end;
            end;
        end;
    end;

    (* The above coalesceing might have resulted in duplicate transitions.  Fix this. *)
    RemoveDuplicateTransitions();
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

    (* Remove states that are completely unreachable *)
    RemoveUnreachable();
    PrintState();

    (* Remove nondistinguishable states *)
    (* writeln('Minimizing DFA...'); *)
    MinimizeDFA();
    PrintState();

    (* Remove unreachable states *)
    (* writeln('Removing unreachable states...'); *)
    RemoveUnreachable();
    PrintState();

    (* Print final state machine *)
    writeln(initial_state);
    for tmp_state in final_states do
        write(tmp_state, ' ');
    writeln('');
    for tmp_trans in transitions do
        writeln(tmp_trans.source, ' ', tmp_trans.token, ' ', tmp_trans.target);
end.
