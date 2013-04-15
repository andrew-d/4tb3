program simple;

  var x: integer;

begin
  read(x);
  if false then
  begin
    x := x + 1;
    x := 2 * x;
  end;
  write(x);
  writeln;
end.
