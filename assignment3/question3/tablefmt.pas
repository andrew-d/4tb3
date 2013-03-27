program tablefmt;

const
    DEBUG = true;
    WHITESPACE = [' ', '	', ''];

type
    Tag = (TableStart, TableClose, TrStart, TrClose, TdStart, TdClose);

var
    look: char;             { current character}
    curr_tag: Tag;          { current tag }
    longest : integer;      { longest string }


{ Debug printing }
procedure DPrint(s: string);
begin
    if DEBUG then
        writeln(s);
end;


{ Get a new character from the input stream }
procedure GetChar;
begin
    read(look);
end;

{ Eat everything in the input stream until a non-whitespace character }
procedure EatWhitespace;
begin
    while look in WHITESPACE do GetChar;
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
    s: string;
    start, ending, len: integer;

begin
    EatWhitespace;
    ReadTag;

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
    DPrint('  raw string: "' + s + '"');

    { Remove beginning / trailing whitespace }
    start := 0;
    ending := len - 1;

    while (s[start] in WHITESPACE) and (start < len) do
        start := start + 1;

    while (s[ending] in WHITESPACE) and (ending > 0) do
        ending := ending - 1;

    { Set new length }
    len := ending - start + 1;

    { Copy out new string }
    s := Copy(s, start, len);
    DPrint('  trimmed string: "' + s + '"');

    { Set longest count }
    if len > longest then longest := len;

    ReadTag;
    if curr_tag <> TdClose then Abort('Expected </TD> tag');
end;

{ Parse a single table row }
procedure TableRow;
begin
    EatWhitespace;
    ReadTag;
    if curr_tag <> TrStart then Abort('Expected <TR> tag');

    DPrint('starting td loop...');

    while curr_tag <> TrClose do
    begin
        TableData;
        ReadTag;
    end;
end;

{ Start parsing by reading a "<TABLE>" from the stream and parsing rows }
procedure Table;
begin
    EatWhitespace;
    ReadTag;
    if curr_tag <> TableStart then Abort('Expected <TABLE> tag at start');

    DPrint('starting table row loop...');

    while curr_tag <> TableClose do
    begin
        TableRow;
        ReadTag;
    end;
end;

{ Write the output }
procedure PrintOutput;
var
    tmp: string;
begin
    Str(longest, tmp);
    DPrint('longest string is: ' + tmp);
end;

{ Initialize }
procedure Init;
begin
    longest := 0;
    GetChar;
end;

begin
    Init;
    Table;
    PrintOutput;
end.
