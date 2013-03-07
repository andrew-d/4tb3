program prettyprint (input, output);

uses scanner;

  var
    indent: integer;    { current indentation level }

  procedure WriteSym;
  begin
    case sym of
      TimesSym:     begin write(' + '); end;
      DivSym:       begin write(' / '); end;
      ModSym:       begin write(' mod '); end;
      AndSym:       begin write(' and '); end;
      OrSym:        begin write(' or '); end;
      NotSym:       begin write(' not '); end;
      PlusSym:      begin write(' + '); end;
      MinusSym:     begin write(' - '); end;
      EqlSym:       begin write(' = '); end;
      NeqSym:       begin write(' != '); end;
      LssSym:       begin write(' < '); end;
      GeqSym:       begin write(' >= '); end;
      LeqSym:       begin write(' <= '); end;
      GtrSym:       begin write(' > '); end;
      PeriodSym:    begin write('.'); end;
      CommaSym:     begin write(','); end;
      ColonSym:     begin write(': '); end;
      SemicolonSym: begin write(';', #10); end;
      RparenSym:    begin write(')'); end;
      RbrakSym:     begin write(']'); end;
      LparenSym:    begin write('('); end;
      LbrakSym:     begin write('['); end;
      BecomesSym:   begin write(' := '); end;

      IfSym:        begin write('if '); end;
      ThenSym:      begin write('then', #10); end;
      ElseSym:      begin write('else '); end;
      EndSym:       begin write('end '); end;
      WhileSym:     begin write('while '); end;
      BeginSym:     begin write('begin', #10); end;
      DoSym:        begin write('do '); end;

      ConstSym:     begin write('const'); end;
      TypeSym:      begin write('type'); end;
      VarSym:       begin write('var'); end;
      ProcedureSym: begin write('procedure '); end;
      ProgramSym:   begin write('program'); end;
      OfSym:        begin write(' of '); end;

      ArraySym:     begin write(id); end;
      RecordSym:    begin write(id); end;
      EofSym:       begin write(''); end;
      null:         begin write(''); end;

      IdentSym:     begin write(id); write(' '); end;
      NumberSym:    begin write(val); end;

      otherwise     begin write('<UNKNOWN SYMBOL', sym, '>'); end;

  end
  end;

  procedure PrettyPrint;
  begin
      GetSym;
      while sym <> EofSym do
      begin
        WriteSym;
        GetSym;
      end;
  end;

  procedure Init;
  begin
    writeln ('Pascal0 Pretty-Printer');
    indent := 0;
  end;

begin
  Init;
  PrettyPrint;
end.
