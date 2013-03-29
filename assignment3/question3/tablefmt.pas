program tablefmt;

const
    DEBUG = false;

type
    Tag = (TableStart, TableClose, TrStart, TrClose, TdStart, TdClose);

    NodeType = (NodeHead, TableNode, MultiRowsNode, RowNode, MultiElemNode, ElemNode);
    Node = record
            ty: NodeType;
            child: ^Node;
            child_len: integer;

            { optional }
            s: string;
           end;
    NodePtr = ^Node;


var
    look: char;                 { current character}
    curr_tag: Tag;              { current tag }

    head_node: NodePtr;         { head of parse tree }
    curr_node: NodePtr;         { current node }



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
    while look <= ' ' do GetChar;
end;

{ Add a new node to the parse tree }
function NewNode(ty: NodeType) : NodePtr;
var
    n: NodePtr;
begin
    { Initialize new element }
    New(n);
    n^.ty := ty;
    n^.child := nil;
    n^.child_len := 0;
    n^.s := '';

    { Place on parse tree }
    curr_node^.child := n;

    { Update current }
    curr_node := n;
    NewNode := n;
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

    { Lower-case the string so we can handle mixed-case tags }
    s := LowerCase(s);
    case s of
      'table': begin curr_tag := TableStart end;
      '/table': begin curr_tag := TableClose end;
      'tr': begin curr_tag := TrStart end;
      '/tr': begin curr_tag := TrClose end;
      'td': begin curr_tag := TdStart end;
      '/td': begin curr_tag := TdClose end;
    otherwise
      begin Abort('Unknown tag: ' + s) end
    end;
end;

{ Parse a single table data entry }
function TableData : NodePtr;
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
        DPrint('  character "' + s[start] + '" is in whitespace, trimming from front...');
        start := start + 1;
    end;

    while (s[ending] <= ' ') and (ending > 0) do
    begin
        DPrint('  character "' + s[ending] + '" is in whitespace, trimming from end...');
        ending := ending - 1;
    end;

    { Set new length }
    len := ending - start + 1;

    { Copy out new string }
    s := Copy(s, start, len);
    DPrint('  trimmed string: "' + s + '"');

    { Add a new node to the parse tree }
    TableData := NewNode(ElemNode);
    curr_node^.s := s;
    curr_node^.child_len := Length(s);

    ReadTag;
    if curr_tag <> TdClose then Abort('Expected </TD> tag');
    DPrint('  done handling td');
end;

function MultiElem : NodePtr;
var
    max_len: integer;
    curr: NodePtr;

begin
    MultiElem := NewNode(MultiElemNode);
    max_len := 0;

    DPrint('starting td loop...');
    while curr_tag <> TrClose do
    begin
        DPrint(' handling td...');
        curr := TableData;
        if curr^.child_len > max_len then max_len := curr^.child_len;

        EatWhitespace; ReadTag;
    end;

    MultiElem^.child_len := max_len;
end;

{ Parse a single table row }
function TableRow : NodePtr;
var
    curr: NodePtr;
begin
    if curr_tag <> TrStart then Abort('Expected <TR> tag');
    EatWhitespace; ReadTag;

    { Add a new node to the parse tree }
    TableRow := NewNode(RowNode);

    { Parse multiple table elements }
    curr := MultiElem;
    TableRow^.child_len := curr^.child_len;

    DPrint('done parsing table row...');
end;

{ Parse until we reach something that's not a row any more }
function MultiRows : NodePtr;
var
    row_node: NodePtr;
    max_len: integer;

begin
    DPrint('starting parsing table rows...');
    EatWhitespace; ReadTag;

    MultiRows := NewNode(MultiRowsNode);
    max_len := 0;

    DPrint('starting table row loop...');
    while curr_tag <> TableClose do
    begin
        { Parse the current row }
        row_node := TableRow;

        { Get max length }
        if max_len < row_node^.child_len then max_len := row_node^.child_len;

        { Read next tag }
        EatWhitespace; ReadTag;
    end;

    { Save the length }
    MultiRows^.child_len := max_len;
end;

{ Start parsing by reading a "<TABLE>" from the stream and parsing rows }
procedure Table;
var
    curr, this: NodePtr;

begin
    DPrint('starting parsing table');
    EatWhitespace; ReadTag;
    if curr_tag <> TableStart then Abort('Expected <TABLE> tag at start');

    { New node }
    this := NewNode(TableNode);

    { Parse rows }
    curr := MultiRows;

    { Set length }
    this^.child_len := curr^.child_len;

    DPrint('done processing input!');
    DPrint('');
end;

{ Write the output }
procedure PrintOutput;
var
    curr: NodePtr;
    max_len, row_count, i: integer;

begin
    { Recursively parse the parse tree }
    curr := head_node^.child;
    max_len := curr^.child_len;
    row_count := 0;

    repeat
    begin
        { If this is an element... }
        if curr^.ty = ElemNode then
        begin
            write('| ', curr^.s);

            for i := Length(curr^.s) to max_len do
                write(' ');
        end
        else if curr^.ty = RowNode then
        begin
            if row_count > 0 then write('|');
            row_count := row_count + 1;
            writeln;
        end;

        { Next element }
        curr := curr^.child;
    end
    until curr = nil;

    writeln('|');
end;

{ Debug helper - prints parse tree }
procedure WriteTree;
var
    curr: NodePtr;

begin
    { Recursively parse the parse tree }
    curr := head_node^.child;

    writeln('Maximum length is ', head_node^.child_len);

    repeat
    begin
        case curr^.ty of
            TableNode: begin
                writeln('TableNode');
            end;
            RowNode: begin writeln(' RowNode (', curr^.child_len, ')') end;
            ElemNode: begin
                writeln('  ElemNode (', curr^.child_len, ') = "', curr^.s, '"');
            end;
        end;

        curr := curr^.child;
    end
    until curr = nil;
end;

{ Initialize }
procedure Init;
begin
    { Set up parse tree }
    New(head_node);
    head_node^.ty := NodeHead;
    head_node^.child := nil;
    head_node^.child_len := 0;

    curr_node := head_node;

    { Finally, get the first character }
    GetChar;
end;

begin
    Init;
    Table;
    if DEBUG then WriteTree;
    PrintOutput;
end.
