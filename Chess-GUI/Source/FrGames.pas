unit FrGames;

interface

uses
    Vcl.Forms
  , jjFormControllers
  , System.Classes
  , Vcl.Controls
  , Vcl.StdCtrls
  , System.Generics.Collections
  , jjBoards
  , jjMoves
  ;

type
  TjjTileButton = class(TButton)
  private type
    TjjTileClickEventCallback = reference to procedure(
      Row: Integer;
      Column: Integer
    );

  private
    FRow: Integer;
    FColumn: Integer;
    FTileClickEvent: TjjTileClickEventCallback;

    procedure ClickHandler(Sender: TObject);

  public
    constructor CreateNew(
      Owner: TComponent;
      Row: Integer;
      Column: Integer;
      TileClickEvent: TjjTileClickEventCallback
    );

    procedure UpdatePiece(Piece: TjjPiece);
  end;

//______________________________________________________________________________

  TjjFrameGame = class(TFrame)
    ButtonResign: TButton;
    ButtonBack: TButton;
    procedure ButtonResignClick(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);

  private
    FController: TjjFormController;
    FTiles: TArray<TArray<TjjTileButton>>;
    FFocusedRow: Integer;
    FFocusedColumn: Integer;
    FFocusedMoves: TObjectList<TjjMove>;

  public
    constructor CreateNew(Owner: TComponent; Controller: TjjFormController);

    procedure Reset;
    procedure DisableBoard;
    procedure UpdateBoard;
    procedure GameOver;

    procedure OnTileClick(Row: Integer; Column: Integer);
  end;

implementation

{$R *.dfm}

uses
    jjConsts
  , System.SysUtils
  , Vcl.Graphics
  ;

//______________________________________________________________________________
//
// TjjTileButton
//______________________________________________________________________________

constructor TjjTileButton.CreateNew(
  Owner: TComponent;
  Row: Integer;
  Column: Integer;
  TileClickEvent: TjjTileClickEventCallback
);
begin
  inherited Create(Owner);

  FRow := Row;
  FColumn := Column;
  FTileClickEvent := TileClickEvent;
  OnClick := ClickHandler;
end;

//______________________________________________________________________________

procedure TjjTileButton.ClickHandler(Sender: TObject);
begin
  FTileClickEvent(FRow, FColumn);
end;

//______________________________________________________________________________

procedure TjjTileButton.UpdatePiece(Piece: TjjPiece);
const
  C_WhitePieceDisplayValues: array[TjjPieceType] of String = (
    '♗',
    '♔',
    '♘',
    '♙',
    '♕',
    '♖'
  );
  C_BlackPieceDisplayValues: array[TjjPieceType] of String = (
    '♝',
    '♚',
    '♞',
    '♟',
    '♛',
    '♜'
  );
begin
  if not Assigned(Piece) then begin
    Caption := '';
  end
  else if Piece.Color = TjjColor.clWhite then begin
    Caption := C_WhitePieceDisplayValues[Piece.PieceType];
  end
  else begin
    Caption := C_BlackPieceDisplayValues[Piece.PieceType];
  end;
end;

//______________________________________________________________________________
//
// TjjFrameGameParams
//______________________________________________________________________________

constructor TjjFrameGame.CreateNew(
  Owner: TComponent;
  Controller: TjjFormController
);
const
  C_ButtonSize = 64;
var
  Row: Integer;
  Column: Integer;
  RowTiles: TArray<TjjTileButton>;
  Button: TjjTileButton;
  GuiRow: Integer;
  BoardSize: Integer;
begin
  inherited Create(Owner);

  FController := Controller;

  FTiles := [];

  for Row := 0 to TjjBoard.C_Rows - 1 do begin
    RowTiles := [];

    for Column := 0 to TjjBoard.C_Columns - 1 do begin
      Button := TjjTileButton.CreateNew(Self, Row, Column, OnTileClick);
      Button.Width := 64;
      Button.Height := 64;
      Button.Font.Size := 20;
      Button.Parent := Self;

      // The board renders backward unless this is accounted for.
      GuiRow := TjjBoard.C_Rows - Row - 1;

      Button.Left := 4 + (Column * C_ButtonSize) + Column;
      Button.Top := 4 + (GuiRow * C_ButtonSize) + GuiRow;

      RowTiles := RowTiles + [Button];
    end;

    FTiles := FTiles + [RowTiles];
    RowTiles := [];
  end;

  BoardSize := 8 + (TjjBoard.C_Columns * C_ButtonSize) + (TjjBoard.C_Columns);
  Self.Constraints.MinWidth := BoardSize;
  Self.Constraints.MinHeight := BoardSize;

  ButtonResign.Left := 4;
  ButtonResign.Top := BoardSize;

  ButtonBack.Left := 8 + ButtonResign.Width;
  ButtonBack.Top := BoardSize;

  Reset;
end;

//______________________________________________________________________________

procedure TjjFrameGame.Reset;
var
  Row: Integer;
  Column: Integer;
begin
  FFocusedRow := -1;
  FFocusedColumn := -1;
  FreeAndNil(FFocusedMoves);

  for Row := 0 to TjjBoard.C_Rows - 1 do begin
    for Column := 0 to TjjBoard.C_Columns - 1 do begin
      FTiles[Row][Column].UpdatePiece(nil);
    end;
  end;

  ButtonResign.Enabled := True;
end;

//______________________________________________________________________________

procedure TjjFrameGame.DisableBoard;
var
  Row: Integer;
  Column: Integer;
begin
  for Row := 0 to TjjBoard.C_Rows - 1 do begin
    for Column := 0 to TjjBoard.C_Columns - 1 do begin
      FTiles[Row][Column].Enabled := False;
    end;
  end;

  ButtonResign.Enabled := False;
  ButtonBack.Enabled := False;
end;

//______________________________________________________________________________

procedure TjjFrameGame.UpdateBoard;
var
  Row: Integer;
  Column: Integer;
  IsCurrentPlayerHuman: Boolean;
  CanMove: Boolean;
  Button: TjjTileButton;
  Piece: TjjPiece;
  IsFocusedTile: Boolean;
  Move: TjjMove;
begin
  Assert(Assigned(FController.Board), 'Board does not exist!');

  ButtonResign.Enabled := True;
  ButtonBack.Enabled := True;

  IsCurrentPlayerHuman := FController.IsCurrentPlayerHuman;

  for Row := 0 to TjjBoard.C_Rows - 1 do begin
    for Column := 0 to TjjBoard.C_Columns - 1 do begin
      CanMove := IsCurrentPlayerHuman;

      Button := FTiles[Row][Column];
      Button.Font.Style := [];

      Piece := FController.Board.Tile[Row, Column].Occupant;
      Button.UpdatePiece(Piece);

      IsFocusedTile := False;

      if Assigned(FFocusedMoves) then begin
        for Move in FFocusedMoves do begin
          if ((Move.OriginRow = Row) and (Move.OriginColumn = Column)) or
            (
              (Move.DestinationRow = Row) and
              (Move.DestinationColumn = Column)
            ) then
          begin
            IsFocusedTile := True;
            Break;
          end;
        end;
      end;

      if not IsFocusedTile then begin
        CanMove :=
          CanMove and
          Assigned(Piece) and
          (Piece.Color = FController.CurrentPlayer);
      end
      else begin
        if not Assigned(Piece) then begin
          Button.Caption := '*';
        end
        else begin
          Button.Font.Style := [fsUnderline];
        end;
      end;

      Button.Enabled := CanMove;
    end;
  end;
end;

//______________________________________________________________________________

procedure TjjFrameGame.GameOver;
begin
  DisableBoard;

  ButtonBack.Enabled := True;
end;

//______________________________________________________________________________

procedure TjjFrameGame.OnTileClick(Row: Integer; Column: Integer);

  procedure SetFocusedMove;
  var
    MovesToFocus: TObjectList<TjjMove>;
  begin
    FFocusedRow := -1;
    FFocusedColumn := -1;
    FreeAndNil(FFocusedMoves);

    MovesToFocus := FController.GetMovesAt(Row, Column);

    if MovesToFocus.Count = 0 then begin
      FreeAndNil(MovesToFocus);
    end
    else begin
      FFocusedRow := Row;
      FFocusedColumn := Column;
      FFocusedMoves := MovesToFocus;
    end;

    UpdateBoard;
  end;

var
  Move: TjjMove;
  MoveToMake: TjjMove;
begin
  Assert(FTiles[Row][Column].Enabled, 'Button not enabled!');
  Assert(FController.IsCurrentPlayerHuman, 'It is the computer''s turn!');

  if Assigned(FFocusedMoves) then begin
    for Move in FFocusedMoves do begin
      if (Move.DestinationRow = Row) and (Move.DestinationColumn = Column) then
      begin
        MoveToMake := Move.Clone;
        FFocusedRow := -1;
        FFocusedColumn := -1;
        FreeAndNil(FFocusedMoves);

        FController.MakeMove(MoveToMake);
        FreeAndNil(MoveToMake);
        Exit;
      end;
    end;
  end;

  if FFocusedRow = -1 then begin
    Assert(FFocusedColumn = -1, 'Invalid state!');

    SetFocusedMove;
  end
  else begin
    Assert(Assigned(FFocusedMoves), 'Invalid state!');

    if (FFocusedRow = Row) and (FFocusedColumn = Column) then begin
      FFocusedRow := -1;
      FFocusedColumn := -1;
      FreeAndNil(FFocusedMoves);

      UpdateBoard;
    end
    else begin
      SetFocusedMove;
    end;
  end;
end;

//______________________________________________________________________________

procedure TjjFrameGame.ButtonBackClick(Sender: TObject);
begin
  FController.ClearGame;
end;

//______________________________________________________________________________

procedure TjjFrameGame.ButtonResignClick(Sender: TObject);
begin
  FController.MakeMove(nil);
end;

end.
