program Test;

var
  x, y: integer;

begin
  if x = 1 then y := 2
  else if x = 2 then y := 4
  else if x = 3 then y := 8
  else if x = 5 then y := 16
  else if x = 6 then y := 32
  else if x = 7 then y := 64
  else if x = 9 then y := 128
  else if x = 10 then y := 256
  else y := 34;
end.
