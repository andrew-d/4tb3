program HelloWorld(output);

type
    Color = (green, blue, pink, yellow, black, orange);

var
    alert: Color;

begin
    alert := green;

    if alert in [green, pink, black] then WriteLn('S OPT') else WriteLn('T OPT')
end.
