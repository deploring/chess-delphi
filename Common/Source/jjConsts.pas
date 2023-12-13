unit jjConsts;

interface

type
  TjjColor = (clWhite, clBlack);
  TjjPieceType = (ptBishop, ptKing, ptKnight, ptPawn, ptQueen, ptRook);

const
  C_ColorInverts: array[TjjColor] of TjjColor = (clBlack, clWhite);
  // White moves forward on the board; black moves backward.
  C_ColorOffsets: array[TjjColor] of Integer = (1, -1);
  C_ColorNames: array[TjjColor] of String = ('White', 'Black');
  C_ColorNamesLowerCase: array[TjjColor] of String = ('white', 'black');

  C_PieceValues: array[TjjPieceType] of Integer = (3, 100, 3, 1, 9, 5);

  C_WhitePieceDisplayValues: array[TjjPieceType] of String = (
    'B',
    'K',
    'N',
    'P',
    'Q',
    'R'
  );
  C_BlackPieceDisplayValues: array[TjjPieceType] of String = (
    'b',
    'k',
    'n',
    'p',
    'q',
    'r'
  );

  // Newline character.
  NL = sLineBreak;

  function StrToChessFile(Input: String): Integer;
  function ChessFileToStr(Input: Integer): String;

implementation

uses
    System.SysUtils
  ;

function StrToChessFile(Input: String): Integer;
begin
  Assert(Length(Input) = 1, 'Expected one character for file.');

  if SameStr(Input, 'a') then begin
    Result := 0;
  end
  else if SameStr(Input, 'b') then begin
    Result := 1;
  end
  else if SameStr(Input, 'c') then begin
    Result := 2;
  end
  else if SameStr(Input, 'd') then begin
    Result := 3;
  end
  else if SameStr(Input, 'e') then begin
    Result := 4;
  end
  else if SameStr(Input, 'f') then begin
    Result := 5;
  end
  else if SameStr(Input, 'g') then begin
    Result := 6;
  end
  else if SameStr(Input, 'h') then begin
    Result := 7;
  end
  else begin
    raise EInOutError.Create('Unknown file input.');
  end;
end;

//______________________________________________________________________________

function ChessFileToStr(Input: Integer): String;
begin
  case Input of
    0: begin
      Result := 'a';
    end;
    1: begin
      Result := 'b';
    end;
    2: begin
      Result := 'c';
    end;
    3: begin
      Result := 'd';
    end;
    4: begin
      Result := 'e';
    end;
    5: begin
      Result := 'f';
    end;
    6: begin
      Result := 'g';
    end;
    7: begin
      Result := 'h';
    end;
    else begin
      raise EInOutError.Create('Unknown file input.');
    end;
  end;
end;

end.
