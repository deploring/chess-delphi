unit jjGames;

interface

uses
    jjBoards
  , jjPlayers
  , jjMoves
  , jjConsts
  ;

type
  TjjGame = class(TObject)
  private
    FBoard: TjjBoard;
    FPlayerWhite: TjjPlayer;
    FPlayerBlack: TjjPlayer;
    FMoveCount: Integer;

  public
    constructor Create(PlayerWhite: TjjPlayer; PlayerBlack: TjjPlayer);
    destructor Destroy; override;

    procedure Play;
  end;

implementation

uses
    System.SysUtils
  ;

//______________________________________________________________________________
//
// TjjGame
//______________________________________________________________________________

constructor TjjGame.Create(PlayerWhite: TjjPlayer; PlayerBlack: TjjPlayer);
begin
  FBoard := TjjBoard.Create;
  FPlayerWhite := PlayerWhite;
  FPlayerBlack := PlayerBlack;
  FMoveCount := 1;
end;

//______________________________________________________________________________

destructor TjjGame.Destroy;
begin
  FreeAndNil(FBoard);

  inherited;
end;

//______________________________________________________________________________

procedure TjjGame.Play;
var
  Move: TjjMove;
begin
  while True do begin
    Writeln(FBoard.StateBoard);

    if FBoard.IsCheckmate(clWhite) then begin
      Writeln('Black checkmates white!' + NL);
      Break;
    end;

    if FBoard.IsDraw then begin
      Writeln('Draw!' + NL);
      Break;
    end;

    if FBoard.IsStalemate(clWhite) then begin
      Writeln('Stalemate.' + NL);
      Break;
    end;

    if FBoard.IsCheck(clWhite) then begin
      Writeln('White is in check!' + NL);
    end;

    Writeln(Format('Turn %d, white to move...' + NL, [FMoveCount]));

    Move := FPlayerWhite.PromptMove(FBoard);

    if not Assigned(Move) then begin
      Writeln('White forfeits.');
      Break;
    end;

    Writeln(Format('White has moved %s.' + NL, [Move.StateMove]));
    FBoard.MovePiece(Move);
    FreeAndNil(Move);

    FMoveCount := FMoveCount + 1;

    Writeln(FBoard.StateBoard);

    if FBoard.IsCheckmate(clBlack) then begin
      Writeln('White checkmates black!' + NL);
      Break;
    end;

    if FBoard.IsDraw then begin
      Writeln('Draw!' + NL);
      Break;
    end;

    if FBoard.IsStalemate(clBlack) then begin
      Writeln('Stalemate.' + NL);
      Break;
    end;

    if FBoard.IsCheck(clBlack) then begin
      Writeln('Black is in check!' + NL);
    end;

    Writeln(Format('Turn %d, black to move...' + NL, [FMoveCount]));

    Move := FPlayerBlack.PromptMove(FBoard);

    if not Assigned(Move) then begin
      Writeln('Black forfeits.');
      Break;
    end;

    Writeln(Format('Black has moved %s.' + NL, [Move.StateMove]));
    FBoard.MovePiece(Move);
    FreeAndNil(Move);

    FMoveCount := FMoveCount + 1;
  end;
end;

end.
