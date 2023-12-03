unit jjHumanPlayers;

interface

uses
    jjPlayers
  , jjConsts
  , jjBoards
  , jjMoves
  , System.Generics.Collections
  ;

type
  TjjHumanPlayer = class(TjjPlayer)
  public
    constructor Create(Color: TjjColor);

    function PromptMove(Board: TjjBoard): TjjMove; override;
  end;

implementation

uses
    System.SysUtils
  ;

//______________________________________________________________________________
//
// TjjHumanPlayer
//______________________________________________________________________________

constructor TjjHumanPlayer.Create(Color: TjjColor);
begin
  inherited Create(Color);
end;

//______________________________________________________________________________

function TjjHumanPlayer.PromptMove(Board: TjjBoard): TjjMove;
var
  EligibleMoves: TObjectList<TjjMove>;
  Input: String;
  OriginColumn: Integer;
  OriginRow: Integer;
  DestinationColumn: Integer;
  DestinationRow: Integer;
  OriginPiece: TjjPiece;
  InputMove: TjjMove;
  ValidMove: Boolean;
  EligibleMove: TjjMove;
begin
  EligibleMoves := Board.GetAllMoves(Color, False, True);

  while True do begin
    Writeln('Enter a move in the form of ''a1b2'' (from a1 to b2).');
    Writeln('Or ''a1'' to see moves (moves piece on a1 could make).');
    Writeln('Or ''resign'' to quit game.');
    Write(NL + 'Input: ');
    Readln(Input);
    Write(NL);

    if SameStr(Input, 'resign') then begin
      // Returning nil signifies that the player has resigned.
      Result := nil;
      Break;
    end;

    if (Length(Input) <> 4) and (Length(Input) <> 2) then begin
      Writeln('Your move input should be 2 or 4 characters long.' + NL);
      Continue;
    end;

    try
      OriginColumn := StrToChessFile(Input[1]);
    except
      on EInOutError do begin
        Writeln(Format('Unknown origin chess file ''%s''.' + NL, [Input[1]]));
        Continue;
      end;
    end;

    try
      OriginRow := StrToInt(Input[2]) - 1;

      if (OriginRow < 0) or (OriginRow > 7) then begin
        Writeln(Format('Unknown origin chess rank ''%s''.' + NL, [Input[2]]));
        Continue;
      end;
    except
      on EConvertError do begin
        Writeln(Format('Unknown origin chess rank ''%s''.' + NL, [Input[2]]));
        Continue;
      end;
    end;

    if Length(Input) = 4 then begin
      try
        DestinationColumn := StrToChessFile(Input[3]);
      except
        on EInOutError do begin
          Writeln(Format(
            'Unknown destination chess file ''%s''.' + NL,
            [Input[3]]
          ));
          Continue;
        end;
      end;

      try
        DestinationRow := StrToInt(Input[4]) - 1;

        if (DestinationRow < 0) or (DestinationRow > 7) then begin
          Writeln(Format(
            'Unknown destination chess rank ''%s''.' + NL,
            [Input[2]]
          ));
          Continue;
        end;
      except
        on EConvertError do begin
          Writeln(Format(
            'Unknown destination chess rank ''%s''.' + NL, [Input[4]]
          ));
          Continue;
        end;
      end;
    end
    else begin
      DestinationColumn := -1;
      DestinationRow := -1;
    end;

    OriginPiece := Board.Tile[OriginRow, OriginColumn].Occupant;

    if not Assigned(OriginPiece) then begin
      Writeln(Format('There is no piece at %s%s.' + NL, [Input[1], Input[2]]));
      Continue;
    end;

    if OriginPiece.Color <> Color then begin
      Writeln('This is the opponent''s piece!' + NL);
      Continue;
    end;

    if Length(Input) = 2 then begin
      Writeln(Board.StateBoard(EligibleMoves, OriginRow, OriginColumn));
      Continue;
    end;

    InputMove := TjjMove.Create(
      OriginRow,
      OriginColumn,
      DestinationRow,
      DestinationColumn
    );

    ValidMove := False;

    for EligibleMove in EligibleMoves do begin
      if EligibleMove.IsSameAs(InputMove) then begin
        ValidMove := True;
        Break;
      end;
    end;

    if not ValidMove then begin
      Writeln('This is an illegal move.' + NL);
      FreeAndNil(InputMove);
      Continue;
    end;

    Result := InputMove;
    Break;
  end;

  FreeAndNil(EligibleMoves);
end;

end.
