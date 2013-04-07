program HelloWorld(output);

type
    Color = (green, blue, pink, yellow, black, orange);

var
    alert: Color;

begin
    alert := green;

    if (alert = green) or (alert = pink) or (alert = black) then WriteLn('S OPT') else WriteLn('T OPT')
end.
