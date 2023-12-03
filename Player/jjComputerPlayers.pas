unit jjComputerPlayers;

interface

uses
    jjPlayers
  , jjMoves
  , jjBoards
  , jjConsts
  , System.Generics.Collections
  ;

type
  TjjComputerPlayer = class(TjjPlayer)
  private const
    // The following comments are from stratzilla.

    // Heuristic evaluation coefficients, each controls how much import is put
    // upon a specific heuristic, a general guideline is C1 > C3 > C2 with C1
    // being fairly large in comparison and C2 generally being very small; for
    // example: C1 = C12, C2 = 1, C3 = 3 or C1 = 20, C2 = 2, C3 = 5, and so on.
    C_C1 = 12; // Material value.
    C_C2 = 1; // Mobility value.
    C_C3 = 3; // Pawn rank value.

    // Move buffer for AI, prevents move reduplication within the last few
    // moves. This should be relatively small, perhaps ideally in the single
    // digits. Much larger and the AI will tend to forfeit early.
    C_BufferSize = 3;

    C_Stalemate = 0;
    C_Draw = 0;
    C_Check = 2;

    // Concerning checkmate scoring. It needs to be greater than any possible
    // board evaluation. The highest material score for one player is 103,
    // mobility score is 215 and pawn control 48. Multiply these by the
    // coefficients and add one to ensure the evluation is always highest for
    // checkmate. It is multiplied by the value for check as check is equal to
    // double any given board evaluation.
    C_Checkmate = (C_Check * ((C_C1 * 103) + (C_C2 * 215) + (C_C3 * 48))) + 1;

  private
    FDepth: Integer;
    FEvaluationCount: Integer;
    FPruneCount: Integer;
    FBuffer: TList<String>;

    function NegamaxHandler(
      Board: TjjBoard;
      Alpha: Integer;
      Beta: Integer
    ): TjjMove;
    function Negamax(
      Board: TjjBoard;
      Depth: Integer;
      Alpha: Integer;
      Beta: Integer;
      CurrentColor: TjjColor
    ): Integer;
    function EvaluateBoard(Board: TjjBoard): Integer;

  public
    constructor Create(Color: TjjColor; Depth: Integer);

    function PromptMove(Board: TjjBoard): TjjMove; override;
  end;

implementation

uses
    System.SysUtils
  , System.Math
  ;

//______________________________________________________________________________
//
// TjjComputerPlayer
//______________________________________________________________________________

constructor TjjComputerPlayer.Create(Color: TjjColor; Depth: Integer);
begin
  inherited Create(Color);

  FDepth := Depth;
  FBuffer := TList<String>.Create;
end;

//______________________________________________________________________________

function TjjComputerPlayer.PromptMove(Board: TjjBoard): TjjMove;
begin
  Result := NegamaxHandler(Board, -9999, 9999);
end;

//______________________________________________________________________________

function TjjComputerPlayer.NegamaxHandler(
  Board: TjjBoard;
  Alpha: Integer;
  Beta: Integer
): TjjMove;
var
  EligibleMoves: TObjectList<TjjMove>;
  BestMoves: TObjectList<TjjMove>;
  BestMoveValue: Integer;
  EligibleMove: TjjMove;
  BoardClone: TjjBoard;
  MoveValue: Integer;
  MoveToMake: TjjMove;
begin
  EligibleMoves := Board.GetAllMoves(Color, False, True);
  BestMoves := TObjectList<TjjMove>.Create(False);
  BestMoveValue := -9999;

  for EligibleMove in EligibleMoves do begin
    // From stratzilla:
    // To avoid threefold repetition, we need to handle cases where a move is
    // repeated. Mostly evident in AI vs. AI games where it will go on forever
    // as they move pieces back and forth ad infinitum. This prevents reuse of
    // the previous moves the amount of which is determined by a buffer. Added
    // benefits of less negamax calls meaning faster speed.
    if FBuffer.Contains(EligibleMove.StateMove) then begin
      Continue;
    end;

    BoardClone := TjjBoard.Create(Board);
    BoardClone.MovePiece(EligibleMove);

    MoveValue :=
      -Negamax(BoardClone, FDepth - 1, -Beta, -Alpha, C_ColorInverts[Color]);
    FreeAndNil(BoardClone);

    if (MoveValue = BestMoveValue) or (EligibleMoves.Count < C_BufferSize) then
    begin
      BestMoves.Add(EligibleMove);
    end
    else if MoveValue > BestMoveValue then begin
      BestMoveValue := MoveValue;
      BestMoves.Clear;
      BestMoves.Add(EligibleMove);
    end;

    if BestMoveValue > Alpha then begin
      Alpha := BestMoveValue;
    end;

    if Alpha >= Beta then begin
      FPruneCount := FPruneCount + 1;
      Break;
    end;
  end;

  if BestMoves.Count = 0 then begin
    Result := nil;
    Exit;
  end;

  MoveToMake := BestMoves[RandomRange(0, BestMoves.Count)];
  FBuffer.Add(MoveToMake.StateMove);

  if FBuffer.Count > C_BufferSize then begin
    FBuffer.Delete(0);
  end;

  BoardClone := TjjBoard.Create(Board);
  BoardClone.MovePiece(MoveToMake);

  if BoardClone.IsCheckmate(C_ColorInverts[Color]) then begin
    BestMoveValue := C_Checkmate;
  end
  else if BoardClone.IsStalemate(C_ColorInverts[Color]) then begin
    BestMoveValue := C_Stalemate;
  end
  else if BoardClone.IsDraw then begin
    BestMoveValue := C_Draw;
  end
  else if BoardClone.IsCheck(C_ColorInverts[Color]) then begin
    BestMoveValue := C_Check * EvaluateBoard(BoardClone);
  end
  else begin
    BestMoveValue := EvaluateBoard(BoardClone);
  end;

  FreeAndNil(BoardClone);

  Writeln(Format(
    '%d game state(s) evaluated; %d pruned.',
    [FEvaluationCount, FPruneCount]
  ));

  if BestMoves.Count > 1 then begin
    Writeln(Format(
      'Found %d equivalent moves; chose one randomly.',
      [BestMoves.Count]
    ));
  end;

  Writeln(Format('Chose move with a score of %d.' + NL, [BestMoveValue]));

  Result := TjjMove.Create(
    MoveToMake.OriginRow,
    MoveToMake.OriginColumn,
    MoveToMake.DestinationRow,
    MoveToMake.DestinationColumn
  );

  FreeAndNil(EligibleMoves);
  FreeAndNil(BestMoves);

  FEvaluationCount := 0;
  FPruneCount := 0;
end;

//______________________________________________________________________________

function TjjComputerPlayer.Negamax(
  Board: TjjBoard;
  Depth: Integer;
  Alpha: Integer;
  Beta: Integer;
  CurrentColor: TjjColor
): Integer;
var
  Offset: Integer;
  MoveValue: Integer;
  EligibleMoves: TObjectList<TjjMove>;
  EligibleMove: TjjMove;
  BoardClone: TjjBoard;
  NegamaxValue: Integer;
begin
  FEvaluationCount := FEvaluationCount + 1;

  if Self.Color = CurrentColor then begin
    Offset := 1;
  end
  else begin
    Offset := -1;
  end;

  if Depth = 0 then begin
    Result := Offset * EvaluateBoard(Board);
    Exit;
  end;

  if Board.IsCheckmate(CurrentColor) then begin
    Result := Offset * C_Checkmate;
    Exit;
  end;

  if Board.IsStalemate(CurrentColor) then begin
    Result := C_Stalemate;
    Exit;
  end;

  if Board.IsDraw then begin
    Result := C_Draw;
    Exit;
  end;

  MoveValue := -9999;
  EligibleMoves := Board.GetAllMoves(CurrentColor, False, True);

  for EligibleMove in EligibleMoves do begin
    BoardClone := TjjBoard.Create(Board);
    BoardClone.MovePiece(EligibleMove);

    NegamaxValue := -Negamax(
      BoardClone,
      Depth - 1,
      -Beta,
      -Alpha,
      C_ColorInverts[CurrentColor]
    );

    if BoardClone.IsCheck(CurrentColor) then begin
      NegamaxValue := C_Check * NegamaxValue;
    end;

    FreeAndNil(BoardClone);

    MoveValue := Max(MoveValue, NegamaxValue);
    Alpha := Max(Alpha, MoveValue);

    if Alpha > Beta then begin
      FPruneCount := FPruneCount + 1;
      Break;
    end;
  end;

  Result := MoveValue;

  FreeAndNil(EligibleMoves);
end;

//______________________________________________________________________________

function TjjComputerPlayer.EvaluateBoard(Board: TjjBoard): Integer;
begin
  // See stratzilla's GitHub README for more information about these
  // coefficients.
  Result :=
    (C_C1 * Board.GetAllPieceValues(Self.Color)) +
    (C_C2 * Board.GetAllMobilityValues(Self.Color)) +
    (C_C3 * Board.GetAllPawnValues(Self.Color));
end;

end.
