program HelloWorld(output);

type
    Color = (green, blue, pink, yellow, black, orange);

var
    alert: Color;

begin
    alert := green;

    case alert of
        green, pink, black: WriteLn('S OPT');
        blue, yellow, orange: WriteLn('T OPT')
    end
end.
