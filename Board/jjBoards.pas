unit jjBoards;

interface

uses
    System.Generics.Collections
  , jjMoves
  , jjConsts
  ;

type 
	
{$REGION 'Core classes interface'}

  TjjBoard = class;
       
  TjjPiece = class(TObject)
  protected
    FColor: TjjColor;
    FHasMoved: Boolean;
    FPieceType: TjjPieceType;

    constructor Create(Color: TjjColor; PieceType: TjjPieceType);

    function IsInBounds(Row: Integer; Column: Integer): Boolean;

  public
    function Clone: TjjPiece; virtual; abstract;
    function GetMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer
    ): TObjectList<TjjMove>; virtual; abstract;

    property Color: TjjColor read FColor;
    property HasMoved: Boolean read FHasMoved write FHasMoved;
    property PieceType: TjjPieceType read FPieceType write FPieceType;
  end;       
    
//______________________________________________________________________________

  TjjTile = class(TObject)
  private
    FOccupant: TjjPiece;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    property Occupant: TjjPiece read FOccupant write FOccupant;
  end; 
    
//______________________________________________________________________________
  
  TjjBoard = class(TObject)
  private
    FTiles: TObjectList<TObjectList<TjjTile>>;

    procedure InitialiseTiles;
    procedure InitialisePieces;

    function GetTile(OriginRow: Integer; OriginColumn: Integer): TjjTile;

  public const
    C_Rows = 8;
    C_Columns = 8;

  public
    constructor Create; overload;
    constructor Create(Board: TjjBoard); overload;
    destructor Destroy; override;

    function StateBoard(
      Moves: TObjectList<TjjMove> = nil;
      OriginRow: Integer = -1;
      OriginColumn: Integer = -1
    ): String;
    procedure MovePiece(Move: TjjMove);
    class procedure RemoveCheckedMoves(
      Board: TjjBoard;
      Color: TjjColor;
      Moves: TObjectList<TjjMove>
    );
    function GetAllMoves(
      Color: TjjColor;
      IgnoreKing: Boolean;
      RemoveChecked: Boolean
    ): TObjectList<TjjMove>;

    function IsCheck(Color: TjjColor): Boolean;
    function IsCheckmate(Color: TjjColor): Boolean;
    function IsStalemate(Color: TjjColor): Boolean;
    function IsDraw: Boolean;

    function GetAllPieceValues(Color: TjjColor): Integer;
    function GetAllMobilityValues(Color: TjjColor): Integer;
    function GetAllPawnValues(Color: TjjColor): Integer;

    property Tile[OriginRow: Integer; OriginColumn: Integer]: TjjTile
      read GetTile;
  end;

//______________________________________________________________________________
  
{$ENDREGION} 

{$REGION 'Pieces interface'}

  TjjBishop = class(TjjPiece)
  private type
    TjjBishopMoveType = (
      bmtNorthWest,
      bmtNorthEast,
      bmtSouthWest,
      bmtSouthEast
    );

  public
    constructor Create(Color: TjjColor);

    function Clone: TjjPiece; override;
    function GetMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer
    ): TObjectList<TjjMove>; override;
  end;

//______________________________________________________________________________

  TjjKing = class(TjjPiece)
  private type
    TjjKingMoveType = (
      kmtNorth,
      kmtNorthEast,
      kmtEast,
      kmtSouthEast,
      kmtSouth,
      kmtSouthWest,
      kmtWest,
      kmtNorthWest
    );

  private
    procedure DoMove(
      MoveType: TjjKingMoveType;
      var DestinationRow: Integer;
      var DestinationColumn: Integer
    );
    procedure AddCastleMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer;
      Moves: TObjectList<TjjMove>
    );
    procedure RemoveAdjacentKingMoves(
      Board: TjjBoard;
      Moves: TObjectList<TjjMove>
    );

  public
    constructor Create(Color: TjjColor);

    function Clone: TjjPiece; override;
    function GetMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer
    ): TObjectList<TjjMove>; override;
  end;

//______________________________________________________________________________

  TjjKnight = class(TjjPiece)
  private type
    TjjKnightMoveType = (
      nmtNorthNorthEast,
      nmtNorthNorthWest,
      nmtEastEastNorth,
      nmtEastEastSouth,
      nmtSouthSouthEast,
      nmtSouthSouthWest,
      nmtWestWestNorth,
      nmtWestWestSouth
    );

  public
    constructor Create(Color: TjjColor);

    function Clone: TjjPiece; override;
    function GetMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer
    ): TObjectList<TjjMove>; override;
  end;

//______________________________________________________________________________

  TjjPawn = class(TjjPiece)
  private type
    TjjPawnMoveType = (
      pmtOneSpace,
      pmtTwoSpaces,
      pmtLeftDiagonal,
      pmtRightDiagonal
    );

  public
    constructor Create(Color: TjjColor);

    function Clone: TjjPiece; override;
    function GetMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer
    ): TObjectList<TjjMove>; override;
  end;

//______________________________________________________________________________

  TjjQueen = class(TjjPiece)
  private type
    TjjQueenMoveType = (
      qmtNorth,
      qmtNorthEast,
      qmtEast,
      qmtSouthEast,
      qmtSouth,
      qmtSouthWest,
      qmtWest,
      qmtNorthWest
    );

  public
    constructor Create(Color: TjjColor);

    function Clone: TjjPiece; override;
    function GetMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer
    ): TObjectList<TjjMove>; override;
  end;

//______________________________________________________________________________

  TjjRook = class(TjjPiece)
  private type
    TjjRookMoveType = (rmtNorth, rmtEast, rmtSouth, rmtWest);

  public
    constructor Create(Color: TjjColor);

    function Clone: TjjPiece; override;
    function GetMoves(
      Board: TjjBoard;
      OriginRow: Integer;
      OriginColumn: Integer
    ): TObjectList<TjjMove>; override;
  end;
  
{$ENDREGION} 

implementation

uses
    System.SysUtils
  ;

{$REGION 'Core classes implementation'}

//______________________________________________________________________________
//
// TjjPiece
//______________________________________________________________________________

constructor TjjPiece.Create(Color: TjjColor; PieceType: TjjPieceType);
begin
  FColor := Color;
  FHasMoved := False;
  FPieceType := PieceType;
end;

//______________________________________________________________________________

function TjjPiece.IsInBounds(
  Row: Integer;
  Column: Integer
): Boolean;
begin
  Result := 
    (Row < TjjBoard.C_Rows) and
    (Row >= 0) and
    (Column < TjjBoard.C_Columns) and
    (Column >= 0);
end; 

//______________________________________________________________________________
//
// TjjTile
//______________________________________________________________________________

constructor TjjTile.Create;
begin
  FOccupant := nil;
end;

//______________________________________________________________________________

destructor TjjTile.Destroy;
begin
  FreeAndNil(FOccupant);

  inherited;
end;

//______________________________________________________________________________

procedure TjjTile.Clear;
begin
  FreeAndNil(FOccupant);
end;

//______________________________________________________________________________
//
// TjjBoard
//______________________________________________________________________________

constructor TjjBoard.Create;
begin
  InitialiseTiles;
  InitialisePieces;
end;

//______________________________________________________________________________

constructor TjjBoard.Create(Board: TjjBoard);
var
  Row: Integer;
  Column: Integer;
  Piece: TjjPiece;
begin
  InitialiseTiles;

  for Row := 0 to C_Rows - 1 do begin
    for Column := 0 to C_Columns - 1 do begin
      Piece := Board.Tile[Row, Column].Occupant;

      if not Assigned(Piece) then begin
        Continue;
      end;

      Tile[Row, Column].Occupant := Piece.Clone;
    end;
  end;
end;
             
//______________________________________________________________________________

destructor TjjBoard.Destroy;
begin
  FreeAndNil(FTiles);

  inherited;
end;

//______________________________________________________________________________

procedure TjjBoard.InitialiseTiles;
var
  Row: Integer;
  Column: Integer;
  RowList: TObjectList<TjjTile>;
begin
  Assert(not Assigned(FTiles), 'Tiles already initialised!');

  FTiles := TObjectList<TObjectList<TjjTile>>.Create;
  for Row := 0 to C_Rows - 1 do begin
    RowList := TObjectList<TjjTile>.Create;

    for Column := 0 to C_Columns - 1 do begin
      RowList.Add(TjjTile.Create);
    end;

    FTiles.Add(RowList);
  end;
end;

//______________________________________________________________________________

procedure TjjBoard.InitialisePieces;
var
  Column: Integer;
begin
  Tile[0, 0].Occupant := TjjRook.Create(clWhite);
  Tile[0, 1].Occupant := TjjKnight.Create(clWhite);
  Tile[0, 2].Occupant := TjjBishop.Create(clWhite);
  Tile[0, 3].Occupant := TjjQueen.Create(clWhite);
  Tile[0, 4].Occupant := TjjKing.Create(clWhite);
  Tile[0, 5].Occupant := TjjBishop.Create(clWhite);
  Tile[0, 6].Occupant := TjjKnight.Create(clWhite);
  Tile[0, 7].Occupant := TjjRook.Create(clWhite);

  for Column := 0 to C_Columns - 1 do begin
    Tile[1, Column].Occupant := TjjPawn.Create(clWhite);
  end;

  Tile[7, 0].Occupant := TjjRook.Create(clBlack);
  Tile[7, 1].Occupant := TjjKnight.Create(clBlack);
  Tile[7, 2].Occupant := TjjBishop.Create(clBlack);
  Tile[7, 3].Occupant := TjjQueen.Create(clBlack);
  Tile[7, 4].Occupant := TjjKing.Create(clBlack);
  Tile[7, 5].Occupant := TjjBishop.Create(clBlack);
  Tile[7, 6].Occupant := TjjKnight.Create(clBlack);
  Tile[7, 7].Occupant := TjjRook.Create(clBlack);

  for Column := 0 to C_Columns - 1 do begin
    Tile[6, Column].Occupant := TjjPawn.Create(clBlack);
  end;
end;

//______________________________________________________________________________

function TjjBoard.GetTile(OriginRow: Integer; OriginColumn: Integer): TjjTile;
begin
  Result := FTiles[OriginRow][OriginColumn];
end;

//______________________________________________________________________________

// Supplying moves is optional and will indicate where a piece can move on the
// board. The origin of the piece to move must be supplied for this.
function TjjBoard.StateBoard(
  Moves: TObjectList<TjjMove> = nil;
  OriginRow: Integer = -1;
  OriginColumn: Integer = -1
): String;
const
  C_FileIndicator = '    a   b   c   d   e   f   g   h';
  C_BoardSeparator = '  +---+---+---+---+---+---+---+---+';
var
  Row: Integer;
  Column: Integer;
  Piece: TjjPiece;
  PieceDisplayValue: String;
  MoveDisplayValue: String;
  Move: TjjMove;
begin
  Result := C_FileIndicator + NL + C_BoardSeparator + NL;

  for Row := C_Rows - 1 downto 0 do begin
    Result := Result + Format('%d |', [Row + 1]);

    for Column := 0 to C_Columns - 1 do begin
      Piece := Tile[Row, Column].Occupant;
      PieceDisplayValue := ' ';

      if Assigned(Piece) then begin
        if Piece.Color = clWhite then begin
          PieceDisplayValue := C_WhitePieceDisplayValues[Piece.PieceType];
        end
        else begin
          Assert(Piece.Color = clBlack, 'Expected black color.');
          PieceDisplayValue := C_BlackPieceDisplayValues[Piece.PieceType];
        end;
      end;

      MoveDisplayValue := ' ';

      if (OriginRow = Row) and (OriginColumn = Column) then begin
        MoveDisplayValue := '*';
      end
      else if Assigned(Moves) then begin
        for Move in Moves do begin
          if (Move.OriginRow <> OriginRow) or
            (Move.OriginColumn <> OriginColumn) then
          begin
            // This move is not the selected piece being moved, so skip it.
            Continue;
          end;

          if (Move.DestinationRow = Row) and
            (Move.DestinationColumn = Column) then
          begin
            MoveDisplayValue := '!';
            Break;
          end;
        end;
      end;

      Result := Result + Format(
        '%0:s%1:s%0:s|',
        [MoveDisplayValue, PieceDisplayValue]
      );
    end;

    Result := Result + Format(' %d', [Row + 1]) + NL + C_BoardSeparator + NL;
  end;

  Result := Result + C_FileIndicator + NL;
end;

//______________________________________________________________________________

procedure TjjBoard.MovePiece(Move: TjjMove);
var
  OriginTile: TjjTile;
  Color: TjjColor;
  DestinationTile: TjjTile;
begin
  OriginTile := Tile[Move.OriginRow, Move.OriginColumn];
  Assert(
    Assigned(OriginTile.Occupant), 
    'Origin tile does not have an occupant.'
  );
  
  Color := OriginTile.Occupant.Color;
  DestinationTile := Tile[Move.DestinationRow, Move.DestinationColumn];

  if Assigned(DestinationTile.Occupant) and 
    (DestinationTile.Occupant.Color <> Color) then
  begin
    Assert(not (DestinationTile.Occupant is TjjKing), 'Cannot capture king!');
    DestinationTile.Clear;
  end;

  case OriginTile.Occupant.PieceType of
    ptBishop, ptKnight, ptQueen, ptRook: begin
      DestinationTile.Occupant := OriginTile.Occupant.Clone;
    end;
    ptPawn: begin
      // Pawn promotion.
      if ((Move.DestinationRow = C_Rows - 1) and (Color = clWhite)) or
        ((Move.DestinationRow = 0) and (Color = clBlack)) then
      begin
        DestinationTile.Occupant := TjjQueen.Create(Color);
      end
      else begin
        DestinationTile.Occupant := OriginTile.Occupant.Clone;
      end;
    end;
    ptKing: begin
      // Kingside castling check.
      if (Move.OriginColumn = 4) and (Move.DestinationColumn = 6) then begin
        Assert(
          not OriginTile.Occupant.HasMoved,
          'Cannot castle if king has moved!'
        );

        // Swap rook to other side of king.
        Tile[Move.OriginRow, 7].Clear;
        Tile[Move.OriginRow, 5].Occupant := TjjRook.Create(Color);
        Tile[Move.OriginRow, 5].Occupant.HasMoved := True;
      end
      // Queenside castling check.
      else if (Move.OriginColumn = 4) and (Move.DestinationColumn = 2) then
      begin
        Assert(
          not OriginTile.Occupant.HasMoved,
          'Cannot castle if king has moved!'
        );

        // Swap rook to other side of king.
        Tile[Move.OriginRow, 0].Clear;
        Tile[Move.OriginRow, 3].Occupant := TjjRook.Create(Color);
        Tile[Move.OriginRow, 3].Occupant.HasMoved := True;
      end;

      DestinationTile.Occupant := OriginTile.Occupant.Clone;
    end;
  end;

  DestinationTile.Occupant.HasMoved := True;
  OriginTile.Clear;
end;

//______________________________________________________________________________

class procedure TjjBoard.RemoveCheckedMoves(
  Board: TjjBoard;
  Color: TjjColor;
  Moves: TObjectList<TjjMove>
);
var
  MovesToRemove: TObjectList<TjjMove>;
  Move: TjjMove;
  BoardClone: TjjBoard;
begin
  MovesToRemove := TObjectList<TjjMove>.Create(False);

  for Move in Moves do begin
    BoardClone := TjjBoard.Create(Board);
    BoardClone.MovePiece(Move);

    if BoardClone.IsCheck(Color) then begin
      MovesToRemove.Add(Move);
    end;

    FreeAndNil(BoardClone);
  end;

  for Move in MovesToRemove do begin
    Moves.Remove(Move);
  end;

  FreeAndNil(MovesToRemove);
end;

//______________________________________________________________________________

function TjjBoard.GetAllMoves(
  Color: TjjColor;
  IgnoreKing: Boolean;
  RemoveChecked: Boolean
): TObjectList<TjjMove>;
var
  Row: Integer;
  Column: Integer;
  Piece: TjjPiece;
  Moves: TObjectList<TjjMove>;
begin
  Result := TObjectList<TjjMove>.Create;

  for Row := 0 to C_Rows - 1 do begin
    for Column := 0 to C_Columns - 1 do begin
      Piece := Tile[Row, Column].Occupant;

      if not Assigned(Piece) or (Piece.Color <> Color) then begin
        // Only existing enemy pieces are relevant.
        Continue;
      end;

      if IgnoreKing and (Piece is TjjKing) then begin
        // This is to prevent infinite recursion when calculating check. As a
        // result, a king's moves must always be checked such that they do not
        // place two kings adjacent to each other.
        Continue;
      end;


      Moves := Piece.GetMoves(Self, Row, Column);
      Moves.OwnsObjects := False;

      Result.AddRange(Moves);

      FreeAndNil(Moves);
    end;
  end;

  if RemoveChecked then begin
    RemoveCheckedMoves(Self, Color, Result);
  end;
end;

//______________________________________________________________________________

function TjjBoard.IsCheck(Color: TjjColor): Boolean;
var
  Moves: TObjectList<TjjMove>;
  Move: TjjMove;
  DestinationPiece: TjjPiece;
begin
  Result := False;

  Moves := GetAllMoves(C_ColorInverts[Color], True, False);

  for Move in Moves do begin
    DestinationPiece :=
      Tile[Move.DestinationRow, Move.DestinationColumn].Occupant;

    if Assigned(DestinationPiece) and (DestinationPiece is TjjKing) then begin
      Result := True;
      Break;
    end;
  end;

  FreeAndNil(Moves);
end;

//______________________________________________________________________________

function TjjBoard.IsCheckmate(Color: TjjColor): Boolean;
var
  Moves: TObjectList<TjjMove>;
begin
  Result := False;

  if not IsCheck(Color) then begin
    Exit;
  end;

  Moves := GetAllMoves(Color, False, True);

  Result := Moves.Count = 0;

  FreeAndNil(Moves);
end;

//______________________________________________________________________________

function TjjBoard.IsStalemate(Color: TjjColor): Boolean;
var
  Moves: TObjectList<TjjMove>;
begin
  Result := False;

  if IsCheck(Color) then begin
    Exit;
  end;

  Moves := GetAllMoves(Color, False, True);

  Result := Moves.Count = 0;

  FreeAndNil(Moves);
end;

//______________________________________________________________________________

function TjjBoard.IsDraw: Boolean;
var
  Row: Integer;
  Column: Integer;
  Piece: TjjPiece;
begin
  Result := True;

  for Row := 0 to C_Rows - 1 do begin
    for Column := 0 to C_Columns - 1 do begin
      Piece := Tile[Row, Column].Occupant;

      if Assigned(Piece) and not (Piece is TjjKing) then begin
        Result := False;
        Break;
      end;
    end;
  end;
end;

//______________________________________________________________________________

function TjjBoard.GetAllPieceValues(Color: TjjColor): Integer;
var
  Row: Integer;
  Column: Integer;
  Piece: TjjPiece;
begin
  Result := 0;

  for Row := 0 to C_Rows - 1 do begin
    for Column := 0 to C_Columns - 1 do begin
      Piece := Tile[Row, Column].Occupant;

      if Assigned(Piece) then begin
        if Piece.Color = Color then begin
          Result := Result + C_PieceValues[Piece.PieceType];
        end
        else begin
          Result := Result - C_PieceValues[Piece.PieceType];
        end;
      end;
    end;
  end;
end;

//______________________________________________________________________________

function TjjBoard.GetAllMobilityValues(Color: TjjColor): Integer;
var
  Row: Integer;
  Column: Integer;
  Piece: TjjPiece;
  Moves: TObjectList<TjjMove>;
begin
  Result := 0;

  for Row := 0 to C_Rows - 1 do begin
    for Column := 0 to C_Columns - 1 do begin
      Piece := Tile[Row, Column].Occupant;

      if not Assigned(Piece) then begin
        Continue;
      end;

      Moves := Piece.GetMoves(Self, Row, Column);

      if Piece.Color = Color then begin
        Result := Result + Moves.Count;
      end
      else begin
        Result := Result - Moves.Count;
      end;

      FreeAndNil(Moves);
    end;
  end;
end;

//______________________________________________________________________________

// This number is based on how far one's pawns are pushed forward compared to
// the other player.
function TjjBoard.GetAllPawnValues(Color: TjjColor): Integer;
var
  Row: Integer;
  Column: Integer;
  Piece: TjjPiece;
begin
  Result := 0;

  for Row := 0 to C_Rows - 1 do begin
    for Column := 0 to C_Columns - 1 do begin
      Piece := Tile[Row, Column].Occupant;

      if not Assigned(Piece) or not (Piece is TjjPawn) then begin
        Continue;
      end;

      if Piece.Color = Color then begin
        if Color = clWhite then begin
          Result := Result + (Row - 1);
        end
        else begin
          Result := Result + (6 - Row);
        end;
      end
      else begin
        if Color = clWhite then begin
          Result := Result - (6 - Row);
        end
        else begin
          Result := Result - (Row - 1);
        end;
      end;
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TjjBishop'}

//______________________________________________________________________________
//
// TjjBishop
//______________________________________________________________________________

constructor TjjBishop.Create(Color: TjjColor);
begin
  inherited Create(Color, ptBishop);
end;

//______________________________________________________________________________

function TjjBishop.Clone: TjjPiece;
begin
  Result := TjjBishop.Create(FColor);
  Result.HasMoved := FHasMoved;
end;

//______________________________________________________________________________

function TjjBishop.GetMoves(
  Board: TjjBoard;
  OriginRow: Integer;
  OriginColumn: Integer
): TObjectList<TjjMove>;
var
  MoveType: TjjBishopMoveType;
  Distance: Integer;
  DestinationRow: Integer;
  DestinationColumn: Integer;
  DestinationPiece: TjjPiece;
begin
  Result := TObjectList<TjjMove>.Create;

  for MoveType := Low(TjjBishopMoveType) to High(TjjBishopMoveType) do begin
    // Check the maximum distance for all four directions until a piece is
    // encountered or the end of the board is reached.
    for Distance := 1 to 7 do begin
      DestinationRow := OriginRow;
      DestinationColumn := OriginColumn;

      case MoveType of
        bmtNorthWest: begin
          DestinationRow := DestinationRow + Distance;
          DestinationColumn := DestinationColumn - Distance;
        end;
        bmtNorthEast: begin
          DestinationRow := DestinationRow + Distance;
          DestinationColumn := DestinationColumn + Distance;
        end;
        bmtSouthWest: begin
          DestinationRow := DestinationRow - Distance;
          DestinationColumn := DestinationColumn - Distance;
        end;
        bmtSouthEast: begin
          DestinationRow := DestinationRow - Distance;
          DestinationColumn := DestinationColumn + Distance;
        end;
      end;

      if IsInBounds(DestinationRow, DestinationColumn) then begin
        DestinationPiece :=
          Board.Tile[DestinationRow, DestinationColumn].Occupant;

        if Assigned(DestinationPiece) then begin
          if DestinationPiece.Color <> FColor then begin
            // Capturing the enemy piece is a valid move.
            Result.Add(TjjMove.Create(
              OriginRow,
              OriginColumn,
              DestinationRow,
              DestinationColumn
            ));
          end;

          // Cannot move over pieces.
          Break;
        end
        else begin
          // Tile is not occupied, this is a valid move.
          Result.Add(TjjMove.Create(
            OriginRow,
            OriginColumn,
            DestinationRow,
            DestinationColumn
          ));
        end;
      end
      else begin
        // Cannot move out of bounds.
        Break;
      end;
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TjjKing'}

//______________________________________________________________________________
//
// TjjKing
//______________________________________________________________________________

constructor TjjKing.Create(Color: TjjColor);
begin
  inherited Create(Color, ptKing);
end;

//______________________________________________________________________________

function TjjKing.Clone: TjjPiece;
begin
  Result := TjjKing.Create(FColor);
  Result.HasMoved := FHasMoved;
end;

//______________________________________________________________________________

procedure TjjKing.DoMove(
  MoveType: TjjKingMoveType;
  var DestinationRow: Integer;
  var DestinationColumn: Integer
);
begin
  case MoveType of
    kmtNorth: begin
      DestinationRow := DestinationRow + 1;
    end;
    kmtNorthEast: begin
      DestinationRow := DestinationRow + 1;
      DestinationColumn := DestinationColumn + 1;
    end;
    kmtEast: begin
      DestinationColumn := DestinationColumn + 1;
    end;
    kmtSouthEast: begin
      DestinationRow := DestinationRow - 1;
      DestinationColumn := DestinationColumn + 1;
    end;
    kmtSouth: begin
      DestinationRow := DestinationRow - 1;
    end;
    kmtSouthWest: begin
      DestinationRow := DestinationRow - 1;
      DestinationColumn := DestinationColumn - 1;
    end;
    kmtWest: begin
      DestinationColumn := DestinationColumn - 1;
    end;
    kmtNorthWest: begin
      DestinationRow := DestinationRow + 1;
      DestinationColumn := DestinationColumn - 1;
    end;
  end;
end;

//______________________________________________________________________________

function TjjKing.GetMoves(
  Board: TjjBoard;
  OriginRow: Integer;
  OriginColumn: Integer
): TObjectList<TjjMove>;
var
  MoveType: TjjKingMoveType;
  DestinationRow: Integer;
  DestinationColumn: Integer;
  DestinationPiece: TjjPiece;
begin
  Result := TObjectList<TjjMove>.Create;

  for MoveType := Low(TjjKingMoveType) to High(TjjKingMoveType) do begin
    DestinationRow := OriginRow;
    DestinationColumn := OriginColumn;

    DoMove(MoveType, DestinationRow, DestinationColumn);

    if IsInBounds(DestinationRow, DestinationColumn) then begin
      DestinationPiece := Board.Tile[DestinationRow, DestinationColumn].Occupant;

      if Assigned(DestinationPiece) then begin
       if (DestinationPiece.Color <> FColor) then begin
          // Capturing the enemy piece is a valid move.
          Result.Add(TjjMove.Create(
            OriginRow,
            OriginColumn,
            DestinationRow,
            DestinationColumn
          ));
       end;
      end
      else begin
        // Tile is not occupied, this is a valid move.
        Result.Add(TjjMove.Create(
          OriginRow,
          OriginColumn,
          DestinationRow,
          DestinationColumn
        ));
      end;
    end;
  end;

  AddCastleMoves(Board, OriginRow, OriginColumn, Result);

  TjjBoard.RemoveCheckedMoves(Board, Color, Result);
  RemoveAdjacentKingMoves(Board, Result);
end;

//______________________________________________________________________________

procedure TjjKing.AddCastleMoves(
  Board: TjjBoard;
  OriginRow: Integer;
  OriginColumn: Integer;
  Moves: TObjectList<TjjMove>
);
var
  CanCastle: Boolean;
  Column: Integer;
  Piece: TjjPiece;
  BoardClone: TjjBoard;
  Move: TjjMove;
begin
  if FHasMoved then begin
    // Castling cannot be done if the king has already moved.
    Exit;
  end;

  Assert(OriginColumn = 4, 'King should not have moved!');

  if Board.IsCheck(FColor) then begin
    // Castling cannot be done if the king is in check.
    Exit;
  end;

  CanCastle := True;

  // Castle kingside check.
  for Column := OriginColumn + 1 to TjjBoard.C_Columns - 1 do begin
    Piece := Board.Tile[OriginRow, Column].Occupant;

    if Column < TjjBoard.C_Columns - 1 then begin
      if Assigned(Piece) then begin
        // Castling cannot be done if the space between the king and the rook is
        // not clear.
        CanCastle := False;
        Break;
      end;
    end;

    if Column = OriginColumn + 1 then begin
      BoardClone := TjjBoard.Create(Board);
      Move := TjjMove.Create(OriginRow, OriginColumn, OriginRow, Column);
      BoardClone.MovePiece(Move);

      FreeAndNil(Move);

      if BoardClone.IsCheck(FColor) then begin
        // Castling cannot be done if the king moves through check.
        CanCastle := False;
      end;

      FreeAndNil(BoardClone);

      if not CanCastle then begin
        Break;
      end;
    end;

    if Column = TjjBoard.C_Columns - 1 then begin
      if not Assigned(Piece) or Piece.HasMoved then begin
        // Castling cannot be done if the rook has moved.
        CanCastle := False;
      end;
    end;
  end;

  if CanCastle then begin
    Moves.Add(TjjMove.Create(
      OriginRow,
      OriginColumn,
      OriginRow,
      OriginColumn + 2
    ));
  end;

  CanCastle := True;

  // Castle queenside check.
  for Column := OriginColumn - 1 downto 0 do begin
    Piece := Board.Tile[OriginRow, Column].Occupant;

    if Column > 0 then begin
      if Assigned(Piece) then begin
        // Castling cannot be done if the space between the king and the rook is
        // not clear.
        CanCastle := False;
        Break;
      end;
    end;

    if Column = OriginColumn - 1 then begin
      BoardClone := TjjBoard.Create(Board);
      Move := TjjMove.Create(OriginRow, OriginColumn, OriginRow, Column);
      BoardClone.MovePiece(Move);

      FreeAndNil(Move);

      if BoardClone.IsCheck(FColor) then begin
        // Castling cannot be done if the king moves through check.
        CanCastle := False;
      end;

      FreeAndNil(BoardClone);

      if not CanCastle then begin
        Break;
      end;
    end;

    if Column = 0 then begin
      if not Assigned(Piece) or Piece.HasMoved then begin
        // Castling cannot be done if the rook has moved.
        CanCastle := False;
      end;
    end;
  end;

  if CanCastle then begin
    Moves.Add(TjjMove.Create(
      OriginRow,
      OriginColumn,
      OriginRow,
      OriginColumn - 2
    ));
  end;
end;

//______________________________________________________________________________

// Removes moves which would put a king adjacent to another king as these cannot
// be detected elsewhere.
procedure TjjKing.RemoveAdjacentKingMoves(
  Board: TjjBoard;
  Moves: TObjectList<TjjMove>
);
var
  MovesToRemove: TObjectList<TjjMove>;
  Move: TjjMove;
  MoveType: TjjKingMoveType;
  DestinationRow: Integer;
  DestinationColumn: Integer;
  Piece: TjjPiece;
begin
  MovesToRemove := TObjectList<TjjMove>.Create(False);

  for Move in Moves do begin
    for MoveType := Low(TjjKingMoveType) to High(TjjKingMoveType) do begin
      DestinationRow := Move.DestinationRow;
      DestinationColumn := Move.DestinationColumn;

      DoMove(MoveType, DestinationRow, DestinationColumn);

      if IsInBounds(DestinationRow, DestinationColumn) then begin
        Piece := Board.Tile[DestinationRow, DestinationColumn].Occupant;

        if Assigned(Piece) and
          (Piece.Color <> FColor) and
          (Piece is TjjKing) then
        begin
          MovesToRemove.Add(Move);
        end;
      end;
    end;
  end;

  for Move in MovesToRemove do begin
    Moves.Remove(Move);
  end;

  FreeAndNil(MovesToRemove);
end;

{$ENDREGION}

{$REGION 'TjjKnight'}

//______________________________________________________________________________
//
// TjjKnight
//______________________________________________________________________________

constructor TjjKnight.Create(Color: TjjColor);
begin
  inherited Create(Color, ptKnight);
end;

//______________________________________________________________________________

function TjjKnight.Clone: TjjPiece;
begin
  Result := TjjKnight.Create(FColor);
  Result.HasMoved := FHasMoved;
end;

//______________________________________________________________________________

function TjjKnight.GetMoves(
  Board: TjjBoard;
  OriginRow: Integer;
  OriginColumn: Integer
): TObjectList<TjjMove>;
var
  MoveType: TjjKnightMoveType;
  DestinationRow: Integer;
  DestinationColumn: Integer;
  DestinationPiece: TjjPiece;
begin
  Result := TObjectList<TjjMove>.Create;

  for MoveType := Low(TjjKnightMoveType) to High(TjjKnightMoveType) do begin
    DestinationRow := OriginRow;
    DestinationColumn := OriginColumn;

    case MoveType of
      nmtNorthNorthEast: begin
        DestinationRow := DestinationRow + 2;
        DestinationColumn := DestinationColumn + 1;
      end;
      nmtNorthNorthWest: begin
        DestinationRow := DestinationRow + 2;
        DestinationColumn := DestinationColumn - 1;
      end;
      nmtEastEastNorth: begin
        DestinationRow := DestinationRow + 1;
        DestinationColumn := DestinationColumn + 2;
      end;
      nmtEastEastSouth: begin
        DestinationRow := DestinationRow - 1;
        DestinationColumn := DestinationColumn + 2;
      end;
      nmtSouthSouthEast: begin
        DestinationRow := DestinationRow - 2;
        DestinationColumn := DestinationColumn + 1;
      end;
      nmtSouthSouthWest: begin
        DestinationRow := DestinationRow - 2;
        DestinationColumn := DestinationColumn - 1;
      end;
      nmtWestWestNorth: begin
        DestinationRow := DestinationRow + 1;
        DestinationColumn := DestinationColumn - 2;
      end;
      nmtWestWestSouth: begin
        DestinationRow := DestinationRow - 1;
        DestinationColumn := DestinationColumn - 2;
      end;
    end;

    if IsInBounds(DestinationRow, DestinationColumn) then begin
      DestinationPiece :=
        Board.Tile[DestinationRow, DestinationColumn].Occupant;

      if Assigned(DestinationPiece) then begin
        if DestinationPiece.Color <> FColor then begin
          // Capturing the enemy piece is a valid move.
          Result.Add(TjjMove.Create(
            OriginRow,
            OriginColumn,
            DestinationRow,
            DestinationColumn
          ));
        end;
      end
      else begin
        // Tile is not occupied, this is a valid move.
        Result.Add(TjjMove.Create(
          OriginRow,
          OriginColumn,
          DestinationRow,
          DestinationColumn
        ));
      end;
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TjjPawn'}

//______________________________________________________________________________
//
// TjjPawn
//______________________________________________________________________________

constructor TjjPawn.Create(Color: TjjColor);
begin
  inherited Create(Color, ptPawn);
end;

//______________________________________________________________________________

function TjjPawn.Clone: TjjPiece;
begin
  Result := TjjPawn.Create(FColor);
  Result.HasMoved := FHasMoved;
  Result.PieceType := FPieceType;
end;       

//______________________________________________________________________________

function TjjPawn.GetMoves(
  Board: TjjBoard; 
  OriginRow: Integer; 
  OriginColumn: Integer
): TObjectList<TjjMove>;
var
  Offset: Integer;
  MoveType: TjjPawnMoveType;
  DestinationRow: Integer;
  DestinationColumn: Integer;
  DestinationPiece: TjjPiece;
begin
  Result := TObjectList<TjjMove>.Create;
  Offset := C_ColorOffsets[FColor];

  for MoveType := Low(TjjPawnMoveType) to High(TjjPawnMoveType) do begin
    if (MoveType = pmtTwoSpaces) and FHasMoved then begin
      Continue;
    end;

    DestinationRow := OriginRow;
    DestinationColumn := OriginColumn;

    case MoveType of
      pmtOneSpace: begin
        DestinationRow := DestinationRow + (1 * Offset);
      end;
      pmtTwoSpaces: begin
        DestinationRow := DestinationRow + (2 * Offset);
      end;
      pmtLeftDiagonal: begin
        DestinationRow := DestinationRow + (1 * Offset);
        DestinationColumn := DestinationColumn - 1;
      end;
      pmtRightDiagonal: begin
        DestinationRow := DestinationRow + (1 * Offset);
        DestinationColumn := DestinationColumn + 1;
      end;
    end;

    if IsInBounds(DestinationRow, DestinationColumn) then begin
      if (MoveType in [pmtOneSpace, pmtTwoSpaces]) and
        Assigned(Board.Tile[DestinationRow, DestinationColumn].Occupant) then
      begin
        // Pawn cannot capture moving forward.
        Continue;
      end;

      if (MoveType = pmtTwoSpaces) and
        Assigned(
          Board.Tile[DestinationRow - (1 * Offset), DestinationColumn].Occupant
        ) then
      begin
        // Pawn cannot jump over a piece.
        Continue;
      end;

      DestinationPiece :=
        Board.Tile[DestinationRow, DestinationColumn].Occupant;

      if (MoveType in [pmtLeftDiagonal, pmtRightDiagonal]) and
        Assigned(DestinationPiece) then
      begin
        if DestinationPiece.Color <> FColor then begin
          // Enemy piece positioned diagonally to this pawn can be captured.
          Result.Add(TjjMove.Create(
            OriginRow,
            OriginColumn,
            DestinationRow,
            DestinationColumn
          ));
        end;
      end
      else if not (MoveType in [pmtLeftDiagonal, pmtRightDiagonal]) then begin
        // Space is not occupied, pawn can move forward.
        Result.Add(TjjMove.Create(
          OriginRow,
          OriginColumn,
          DestinationRow,
          DestinationColumn
        ));
      end;
    end;
  end;
end; 

{$ENDREGION}

{$REGION 'TjjQueen'}

//______________________________________________________________________________
//
// TjjQueen
//______________________________________________________________________________

constructor TjjQueen.Create(Color: TjjColor);
begin
  inherited Create(Color, ptQueen);
end;

//______________________________________________________________________________

function TjjQueen.Clone: TjjPiece;
begin
  Result := TjjQueen.Create(FColor);
  Result.HasMoved := FHasMoved;
end;

//______________________________________________________________________________

function TjjQueen.GetMoves(
  Board: TjjBoard;
  OriginRow: Integer;
  OriginColumn: Integer
): TObjectList<TjjMove>;
var
  MoveType: TjjQueenMoveType;
  Distance: Integer;
  DestinationRow: Integer;
  DestinationColumn: Integer;
  DestinationPiece: TjjPiece;
begin
  Result := TObjectList<TjjMove>.Create;

  for MoveType := Low(TjjQueenMoveType) to High(TjjQueenMoveType) do begin
    // Check the maximum distance for all eight directions until a piece is
    // encountered or the end of the board is reached.
    for Distance := 1 to 7 do begin
      DestinationRow := OriginRow;
      DestinationColumn := OriginColumn;

      case MoveType of
        qmtNorth: begin
          DestinationRow := DestinationRow + Distance;
        end;
        qmtNorthEast: begin
          DestinationRow := DestinationRow + Distance;
          DestinationColumn := DestinationColumn + Distance;
        end;
        qmtEast: begin
          DestinationColumn := DestinationColumn + Distance;
        end;
        qmtSouthEast: begin
          DestinationRow := DestinationRow - Distance;
          DestinationColumn := DestinationColumn + Distance;
        end;
        qmtSouth: begin
          DestinationRow := DestinationRow - Distance;
        end;
        qmtSouthWest: begin
          DestinationRow := DestinationRow - Distance;
          DestinationColumn := DestinationColumn - Distance;
        end;
        qmtWest: begin
          DestinationColumn := DestinationColumn - Distance;
        end;
        qmtNorthWest: begin
          DestinationRow := DestinationRow + Distance;
          DestinationColumn := DestinationColumn - Distance;
        end;
      end;

      if IsInBounds(DestinationRow, DestinationColumn) then begin
        DestinationPiece :=
          Board.Tile[DestinationRow, DestinationColumn].Occupant;

        if Assigned(DestinationPiece) then begin
          if DestinationPiece.Color <> FColor then begin
            // Capturing the enemy piece is a valid move.
            Result.Add(TjjMove.Create(
              OriginRow,
              OriginColumn,
              DestinationRow,
              DestinationColumn
            ));
          end;

          // Cannot move over pieces.
          Break;
        end
        else begin
          // Tile is not occupied, this is a valid move.
          Result.Add(TjjMove.Create(
            OriginRow,
            OriginColumn,
            DestinationRow,
            DestinationColumn
          ));
        end;
      end
      else begin
        // Cannot move out of bounds.
        Break;
      end;
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TjjRook'}

//______________________________________________________________________________
//
// TjjRook
//______________________________________________________________________________

constructor TjjRook.Create(Color: TjjColor);
begin
  inherited Create(Color, ptRook);
end;

//______________________________________________________________________________

function TjjRook.Clone: TjjPiece;
begin
  Result := TjjRook.Create(FColor);
  Result.HasMoved := FHasMoved;
end;

//______________________________________________________________________________

function TjjRook.GetMoves(
  Board: TjjBoard;
  OriginRow: Integer;
  OriginColumn: Integer
): TObjectList<TjjMove>;
var
  MoveType: TjjRookMoveType;
  Distance: Integer;
  DestinationRow: Integer;
  DestinationColumn: Integer;
  DestinationPiece: TjjPiece;
begin
  Result := TObjectList<TjjMove>.Create;

  for MoveType := Low(TjjRookMoveType) to High(TjjRookMoveType) do begin
    // Check the maximum distance for all four directions until a piece is
    // encountered or the end of the board is reached.
    for Distance := 1 to 7 do begin
      DestinationRow := OriginRow;
      DestinationColumn := OriginColumn;

      case MoveType of
        rmtNorth: begin
          DestinationRow := DestinationRow + Distance;
        end;
        rmtEast: begin
          DestinationColumn := DestinationColumn + Distance;
        end;
        rmtSouth: begin
          DestinationRow := DestinationRow - Distance;
        end;
        rmtWest: begin
          DestinationColumn := DestinationColumn - Distance;
        end;
      end;

      if IsInBounds(DestinationRow, DestinationColumn) then begin
        DestinationPiece :=
          Board.Tile[DestinationRow, DestinationColumn].Occupant;

        if Assigned(DestinationPiece) then begin
          if DestinationPiece.Color <> FColor then begin
            // Capturing the enemy piece is a valid move.
            Result.Add(TjjMove.Create(
              OriginRow,
              OriginColumn,
              DestinationRow,
              DestinationColumn
            ));
          end;

          // Cannot move over pieces.
          Break;
        end
        else begin
          // Tile is not occupied, this is a valid move.
          Result.Add(TjjMove.Create(
            OriginRow,
            OriginColumn,
            DestinationRow,
            DestinationColumn
          ));
        end;
      end
      else begin
        // Cannot move out of bounds.
        Break;
      end;
    end;
  end;
end;

{$ENDREGION}

end.
