program tablefmt;

const
    DEBUG = true;

type
    Tag = (TableStart, TableClose, TrStart, TrClose, TdStart, TdClose);
    RowEntry = record
                 s: string;
                 next: ^RowEntry;
               end;
    TableEntry = record
                   row: ^RowEntry;
                   next: ^TableEntry;
                 end;

var
    look: char;                 { current character}
    curr_tag: Tag;              { current tag }
    longest : integer;          { longest string }

    table_head: ^TableEntry;    { head of tree }
    curr_table: ^TableEntry;    { current table entry }
    curr_row: ^RowEntry;        { current row }


{ Debug printing }
procedure DPrint(s: string);
begin
    if DEBUG then
        writeln(s);
end;

{ Add a new string to the current row }
procedure NewRowEntry(s: string);
var
    tmp, n: ^RowEntry;
begin
    { Create new entry }
    New(n);
    n^.s := s;
    n^.next := nil;

    { If the current row entry is nil, we add it and set it }
    if curr_row = nil then
    begin
        curr_table^.row := n;
        curr_row := n;
    end
    else
    begin
        { Find the end of the current row entry }
        tmp := curr_row;
        while tmp^.next <> nil do
            tmp := tmp^.next;

        { Put the next entry in }
        tmp^.next := n;
    end;
end;

{ Add a new row }
procedure NewRow;
var
    n: ^TableEntry;
begin
    { Create the new entry. }
    New(n);
    n^.row := nil;
    n^.next := nil;

    { Append to the current table entry }
    curr_table^.next := n;

    { Set the current pointer to this one }
    curr_table := n;

    { Zero out the current row so it gets created in NewRowEntry }
    curr_row := nil;
end;

{ Get a new character from the input stream }
procedure GetChar;
begin
    read(look);
end;

{ Eat everything in the input stream until a non-whitespace character }
procedure EatWhitespace;
begin
    while look <= ' ' do GetChar;
end;

{ Report an error }
procedure Error(s: string);
begin
    writeln;
    writeln('Error: ', s, '.');
end;

{ Report an error and halt the progrma }
procedure Abort(s: string);
begin
    Error(s);
    Halt;
end;

{ Match a specific input character or exit the program }
procedure Match(c: char);
begin
    if look = c then GetChar
    else Abort('Expected "' + c + '", not "' + look + '"');
end;

{ Match a specific input string }
procedure MatchString(s: string);
var
    c: char;
begin
    for c in s do Match(c);
end;

{ Read a single tag from the input stream }
procedure ReadTag;
var
    s: string;
begin
    Match('<');

    s := '';
    while look <> '>' do
    begin
        s := s + look;
        GetChar
    end;

    GetChar;

    case s of
      'TABLE': begin curr_tag := TableStart end;
      '/TABLE': begin curr_tag := TableClose end;
      'TR': begin curr_tag := TrStart end;
      '/TR': begin curr_tag := TrClose end;
      'TD': begin curr_tag := TdStart end;
      '/TD': begin curr_tag := TdClose end;
    otherwise
      begin Abort('Unknown tag: ' + s) end
    end;
end;

{ Parse a single table data entry }
procedure TableData;
var
    s, tmp: string;
    start, ending, len: integer;

begin
    if curr_tag <> TdStart then Abort('Expected <TD> tag');

    { Read until a "<" }
    s := '';
    len := 0;
    while look <> '<' do
    begin
        s := s + look;
        len := len + 1;
        GetChar;
    end;
    Str(len, tmp);
    DPrint('  raw string: "' + s + '", len = ' + tmp);

    { Remove beginning / trailing whitespace }
    start := 1;
    ending := len;

    while (s[start] <= ' ') and (start < len) do
    begin
        DPrint('Character "' + s[start] + '" is in whitespace, trimming from front...');
        start := start + 1;
    end;

    while (s[ending] <= ' ') and (ending > 0) do
        ending := ending - 1;

    { Set new length }
    len := ending - start + 1;

    { Copy out new string }
    s := Copy(s, start, len);
    DPrint('  trimmed string: "' + s + '"');

    { Set longest count }
    if len > longest then longest := len;

    { Save this string }
    NewRowEntry(s);

    ReadTag;
    if curr_tag <> TdClose then Abort('Expected </TD> tag');
    DPrint('  done handling td');
end;

{ Parse a single table row }
procedure TableRow;
begin
    if curr_tag <> TrStart then Abort('Expected <TR> tag');
    EatWhitespace; ReadTag;

    DPrint('starting td loop...');
    NewRow;

    while curr_tag <> TrClose do
    begin
        DPrint(' handling td...');
        TableData;
        EatWhitespace; ReadTag;
    end;
end;

{ Start parsing by reading a "<TABLE>" from the stream and parsing rows }
procedure Table;
begin
    DPrint('starting parsing table');
    EatWhitespace; ReadTag;
    if curr_tag <> TableStart then Abort('Expected <TABLE> tag at start');

    DPrint('starting parsing table row...');
    EatWhitespace; ReadTag;

    DPrint('starting table row loop...');

    while curr_tag <> TableClose do
    begin
        TableRow;
        EatWhitespace; ReadTag;
    end;

    DPrint('done processing input!');
    DPrint('');
end;

{ Write the output }
procedure PrintOutput;
var
    tmp: string;
    row_ptr: ^TableEntry;
    entry_ptr: ^RowEntry;
    i: integer;
begin
    Str(longest, tmp);
    DPrint('longest string is: ' + tmp);

    { Traverse the parse tree to output each row }
    row_ptr := table_head^.next;
    while row_ptr <> nil do
    begin
        { Output beginning }
        write('| ');

        { Traverse each row }
        entry_ptr := row_ptr^.row;
        while entry_ptr <> nil do
        begin
            { Output this entry }
            write(entry_ptr^.s);

            { Output padding }
            for i := Length(entry_ptr^.s) to longest do
                write(' ');

            { Output separator }
            write('| ');

            { Next entry }
            entry_ptr := entry_ptr^.next;
        end;

        { Output final newline }
        writeln;

        { Next row }
        row_ptr := row_ptr^.next;
    end;
end;

{ Initialize }
procedure Init;
begin
    { Initialize variables }
    longest := 0;

    { Set up parse tree }
    New(table_head);
    table_head^.row := nil;
    table_head^.next := nil;
    curr_table := table_head;

    { Finally, get the first character }
    GetChar;
end;

begin
    Init;
    Table;
    PrintOutput;
end.
