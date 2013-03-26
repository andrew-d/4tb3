program simple;

  var x: integer;

begin
  read(x);
  x := x * 1;
  { write(x); writeln; }
  x := 1 * x;
  { write(x); writeln; }
  x := x div 1;
  { write(x); writeln; }
  x := x + 0;
  { write(x); writeln; }
  x := 0 + x;
  { write(x); writeln; }
  x := x - 0;
  write(x); writeln;
end.
