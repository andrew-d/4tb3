program exponent;

var
  z : integer;

begin
  z := 5 ^ 2 * 3 + 4;
  { should be ((5^2) * 3) + 4, which is 79 }
  write(z); writeln
end.
