unit jjFormControllers;

interface

uses
    Vcl.ComCtrls
  , System.UITypes
  , Vcl.Controls
  , jjPlayers
  , jjBoards
  , jjConsts
  , jjMoves
  , System.Generics.Collections
  ;

type
  TjjLogMessage = record
    Contents: String;
    Style: TFontStyles;

  public
    constructor Create(Contents: String; Style: TFontStyles); overload;
    constructor Create(Contents: String); overload;
  end;

  TjjUiEvent = (
    uiStartGame,
    uiDisableBoard,
    uiUpdateBoard,
    uiGameOver,
    uiClearGame
  );

  TjjUiEventCallback = reference to procedure(Event: TjjUiEvent);
  TjjGameEventCallback = reference to procedure(Event: TjjUiEvent);

  TjjFormController = class(TObject)
  private
    FLog: TRichEdit;
    FUiEvent: TjjUiEventCallback;
    FPlayerWhite: TjjPlayer;
    FPlayerBlack: TjjPlayer;
    FBoard: TjjBoard;
    FCurrentPlayer: TjjColor;
    FTurnCount: Integer;

    function GetCurrentPlayerObject: TjjPlayer;

    procedure AwaitMove;

  public
    constructor Create(Log: TRichEdit; UiEvent: TjjUiEventCallback);
    destructor Destroy; override;

    procedure CenterControl(Control: TControl);
    procedure WriteMessageToLog(Messages: TArray<TjjLogMessage>);

    procedure StartGame(PlayerWhite: TjjPlayer; PlayerBlack: TjjPlayer);
    procedure MakeMove(Move: TjjMove);
    procedure EndGame;
    procedure ClearGame;

    function IsCurrentPlayerHuman: Boolean;
    function GetMovesAt(Row: Integer; Column: Integer): TObjectList<TjjMove>;

    property Board: TjjBoard read FBoard;
    property CurrentPlayer: TjjColor read FCurrentPlayer;
  end;

implementation

uses
    Vcl.Graphics
  , Winapi.Messages
  , System.SysUtils
  , jjGuiHumanPlayers
  , jjGuiComputerPlayers
  , System.Threading
  , System.Classes
  ;

//______________________________________________________________________________
//
// TjjLogMessage
//______________________________________________________________________________

constructor TjjLogMessage.Create(Contents: String; Style: TFontStyles);
begin
  Self.Contents := Contents;
  Self.Style := Style;
end;

//______________________________________________________________________________

constructor TjjLogMessage.Create(Contents: String);
begin
  Self.Contents := Contents;
  Self.Style := [];
end;

//______________________________________________________________________________
//
// TjjFormController
//______________________________________________________________________________

constructor TjjFormController.Create(
  Log: TRichEdit;
  UiEvent: TjjUiEventCallback
);
begin
  FLog := Log;
  FUiEvent := UiEvent;
end;

//______________________________________________________________________________

destructor TjjFormController.Destroy;
begin
  FreeAndNil(FPlayerWhite);
  FreeAndNil(FPlayerBlack);
  FreeAndNil(FBoard);

  inherited;
end;

//______________________________________________________________________________

procedure TjjFormController.CenterControl(Control: TControl);
begin
  Control.Left := (Control.Parent.ClientWidth - Control.Width) div 2;
  Control.Top := (Control.Parent.ClientHeight - Control.Height) div 2;
end;

//______________________________________________________________________________

procedure TjjFormController.WriteMessageToLog(
  Messages: TArray<TjjLogMessage>
);
var
  LogMessage: TjjLogMessage;
begin
  Messages := [TjjLogMessage.Create('> ')] + Messages;

  FLog.SelStart := FLog.GetTextLen;

  for LogMessage in Messages do begin
    FLog.SelAttributes.Style := LogMessage.Style;
    FLog.SelAttributes.Color := TColors.Black;
    FLog.SelText := LogMessage.Contents;
  end;

  FLog.SelText := NL + NL;

  FLog.SetFocus;
  FLog.Perform(EM_SCROLLCARET, 0, 0);
end;

//______________________________________________________________________________

procedure TjjFormController.StartGame(
  PlayerWhite: TjjPlayer;
  PlayerBlack: TjjPlayer
);
begin
  FPlayerWhite := PlayerWhite;
  FPlayerBlack := PlayerBlack;
  FCurrentPlayer := TjjColor.clWhite;
  FTurnCount := 1;
  FBoard := TjjBoard.Create;

  WriteMessageToLog([TjjLogMessage.Create('The game has started!')]);

  FUiEvent(uiStartGame);

  AwaitMove;
end;

//______________________________________________________________________________

procedure TjjFormController.AwaitMove;
var
  CurrentPlayerObject: TjjPlayer;
  Task: ITask;
begin
  WriteMessageToLog([TjjLogMessage.Create(Format(
    'Turn %d, %s to move...',
    [FTurnCount, C_ColorNamesLowerCase[FCurrentPlayer]]
  ))]);

  CurrentPlayerObject := GetCurrentPlayerObject;

  if CurrentPlayerObject is TjjGuiComputerPlayer then begin
    FUiEvent(uiDisableBoard);

    Task := TTask.Create(
      procedure
      var
        Move: TjjMove;
      begin
        Move := CurrentPlayerObject.PromptMove(FBoard);

        // Calls to the UI must be synchronized.
        TThread.Synchronize(
          nil,
          procedure
          begin
            MakeMove(Move);
            FreeAndNil(Move);
          end
        );
      end
    );
    Task.Start;
  end;

  // Human players move using the GUI.
end;

//______________________________________________________________________________

procedure TjjFormController.MakeMove(Move: TjjMove);
begin
  FUiEvent(uiDisableBoard);

  if not Assigned(Move) then begin
    WriteMessageToLog([TjjLogMessage.Create(
      Format('%s forfeits.', [C_ColorNames[FCurrentPlayer]]),
      [fsUnderline]
    )]);

    EndGame;
    Exit;
  end;

  WriteMessageToLog([TjjLogMessage.Create(Format(
    '%s has moved %s.',
    [C_ColorNames[FCurrentPlayer], Move.StateMove]
  ))]);

  FBoard.MovePiece(Move);
  FCurrentPlayer := C_ColorInverts[FCurrentPlayer];
  FTurnCount := FTurnCount + 1;

  FUiEvent(uiUpdateBoard);

  if FBoard.IsCheckmate(FCurrentPlayer) then begin
    WriteMessageToLog([TjjLogMessage.Create(
      Format(
        '%s checkmates %s!',
        [
          C_ColorNames[C_ColorInverts[FCurrentPlayer]],
          C_ColorNamesLowerCase[FCurrentPlayer]
        ]
      ),
      [fsUnderline]
    )]);

    EndGame;
    Exit;
  end;

  if FBoard.IsDraw then begin
    WriteMessageToLog([TjjLogMessage.Create('Draw.', [fsUnderline])]);

    EndGame;
    Exit;
  end;

  if FBoard.IsStalemate(FCurrentPlayer) then begin
    WriteMessageToLog([TjjLogMessage.Create('Stalemate.', [fsUnderline])]);

    EndGame;
    Exit;
  end;

  if FBoard.IsCheck(FCurrentPlayer) then begin
    WriteMessageToLog([TjjLogMessage.Create(
      Format('%s is in check!', [C_ColorNames[FCurrentPlayer]]),
      [fsBold]
    )]);
  end;

  AwaitMove;
end;

//______________________________________________________________________________

procedure TjjFormController.EndGame;
begin
  FUiEvent(uiGameOver);

  FreeAndNil(FPlayerWhite);
  FreeAndNil(FPlayerBlack);
  FreeAndNil(FBoard);
end;

//______________________________________________________________________________

procedure TjjFormController.ClearGame;
begin
  EndGame;

  WriteMessageToLog([TjjLogMessage.Create(
    'You have gone back to the player selection menu.'
  )]);

  FUiEvent(uiClearGame);
end;

//______________________________________________________________________________

function TjjFormController.GetCurrentPlayerObject: TjjPlayer;
begin
  if FCurrentPlayer = TjjColor.clWhite then begin
    Result := FPlayerWhite;
  end
  else begin
    Result := FPlayerBlack;
  end;
end;

//______________________________________________________________________________

function TjjFormController.IsCurrentPlayerHuman: Boolean;
begin
  Result := GetCurrentPlayerObject is TjjGuiHumanPlayer;
end;

//______________________________________________________________________________

function TjjFormController.GetMovesAt(
  Row: Integer;
  Column: Integer
): TObjectList<TjjMove>;
var
  MovesToRemove: TObjectList<TjjMove>;
  Move: TjjMove;
begin
  MovesToRemove := TObjectList<TjjMove>.Create(False);

  Result := Board.GetAllMoves(FCurrentPlayer, False, True);

  for Move in Result do begin
    if (Move.OriginRow <> Row) or (Move.OriginColumn <> Column) then begin
      MovesToRemove.Add(Move);
    end;
  end;

  for Move in MovesToRemove do begin
    Result.Remove(Move);
  end;

  FreeAndNil(MovesToRemove);
end;

end.
