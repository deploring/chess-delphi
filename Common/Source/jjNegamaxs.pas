unit jjNegamaxs;

interface

uses
    jjBoards
  , jjMoves
  , jjConsts
  , System.Generics.Collections
  ;

type
  TjjNegamax = class(TObject)
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

    // Initial values for alpha and beta.
    C_UpperBound = 99999;
    C_LowerBound = -99999;

  private
    FColor: TjjColor;
    FBuffer: TList<String>;
    FEvaluationCount: Integer;
    FPruneCount: Integer;
    FBestMoveValue: Integer;

    function Negamax(
      Board: TjjBoard;
      Depth: Integer;
      Alpha: Integer;
      Beta: Integer;
      CurrentColor: TjjColor
    ): Integer;
    function EvaluateBoard(Board: TjjBoard): Integer;

  public
    constructor Create(Color: TjjColor);
    destructor Destroy; override;

    function NegamaxHandler(Board: TjjBoard; Depth: Integer): TjjMove;

    property EvaluationCount: Integer read FEvaluationCount;
    property PruneCount: Integer read FPruneCount;
    property BestMoveValue: Integer read FBestMoveValue;
  end;

implementation

uses
    System.Math
  , System.SysUtils
  ;

//______________________________________________________________________________
//
// TjjNegamax
//______________________________________________________________________________

constructor TjjNegamax.Create(Color: TjjColor);
begin
  FColor := Color;
  FBuffer := TList<String>.Create;
end;

//______________________________________________________________________________

destructor TjjNegamax.Destroy;
begin
  FreeAndNil(FBuffer);

  inherited;
end;

//______________________________________________________________________________

function TjjNegamax.NegamaxHandler(
  Board: TjjBoard;
  Depth: Integer
): TjjMove;
var
  Alpha: Integer;
  Beta: Integer;
  EligibleMoves: TObjectList<TjjMove>;
  BestMoves: TObjectList<TjjMove>;
  EligibleMove: TjjMove;
  BoardClone: TjjBoard;
  MoveValue: Integer;
  MoveToMake: TjjMove;
begin
  FEvaluationCount := 0;
  FPruneCount := 0;
  FBestMoveValue := C_LowerBound;

  Alpha := C_LowerBound;
  Beta := C_UpperBound;
  
  EligibleMoves := Board.GetAllMoves(FColor, False, True);
  BestMoves := TObjectList<TjjMove>.Create(False);

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
      -Negamax(BoardClone, Depth - 1, -Beta, -Alpha, C_ColorInverts[FColor]);
    FreeAndNil(BoardClone);

    if (MoveValue = FBestMoveValue) or (EligibleMoves.Count < C_BufferSize) then
    begin
      BestMoves.Add(EligibleMove);
    end
    else if MoveValue > FBestMoveValue then begin
      FBestMoveValue := MoveValue;
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

  if BoardClone.IsCheckmate(C_ColorInverts[FColor]) then begin
    FBestMoveValue := C_Checkmate;
  end
  else if BoardClone.IsStalemate(C_ColorInverts[FColor]) then begin
    FBestMoveValue := C_Stalemate;
  end
  else if BoardClone.IsDraw then begin
    FBestMoveValue := C_Draw;
  end
  else if BoardClone.IsCheck(C_ColorInverts[FColor]) then begin
    FBestMoveValue := C_Check * EvaluateBoard(BoardClone);
  end
  else begin
    FBestMoveValue := EvaluateBoard(BoardClone);
  end;

  FreeAndNil(BoardClone);

  Result := TjjMove.Create(
    MoveToMake.OriginRow,
    MoveToMake.OriginColumn,
    MoveToMake.DestinationRow,
    MoveToMake.DestinationColumn
  );

  FreeAndNil(EligibleMoves);
  FreeAndNil(BestMoves);
end;

//______________________________________________________________________________

function TjjNegamax.Negamax(
  Board: TjjBoard;
  Depth: Integer;
  Alpha: Integer;
  Beta: Integer;
  CurrentColor: TjjColor
): Integer;
var
  Offset: Integer;
  EligibleMoves: TObjectList<TjjMove>;
  EligibleMove: TjjMove;
  BoardClone: TjjBoard;
  NegamaxValue: Integer;
begin
  FEvaluationCount := FEvaluationCount + 1;

  if FColor = CurrentColor then begin
    Offset := 1;
  end
  else begin
    Offset := -1;
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

  if Depth = 0 then begin
    Result := Offset * EvaluateBoard(Board);
    Exit;
  end;

  Result := C_LowerBound;
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

    Result := Max(Result, NegamaxValue);
    Alpha := Max(Alpha, Result);

    if Alpha > Beta then begin
      FPruneCount := FPruneCount + 1;
      Break;
    end;
  end;

  FreeAndNil(EligibleMoves);
end;

//______________________________________________________________________________

function TjjNegamax.EvaluateBoard(Board: TjjBoard): Integer;
begin
  // See stratzilla's GitHub README for more information about these
  // coefficients.
  Result :=
    (C_C1 * Board.GetAllPieceValues(FColor)) +
    (C_C2 * Board.GetAllMobilityValues(FColor)) +
    (C_C3 * Board.GetAllPawnValues(FColor));
end;

end.
