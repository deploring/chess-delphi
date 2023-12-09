unit FChessGui;

interface

uses
    Vcl.Forms
  , jjFormControllers
  , Vcl.Controls
  , Vcl.ExtCtrls
  , System.Classes
  , Vcl.StdCtrls
  , Vcl.ComCtrls
  , FrGameParamss
  , FrGames
  ;

type
  TjjFormChessGui = class(TForm)
    Splitter: TSplitter;
    PanelGame: TPanel;
    PanelEventLog: TPanel;
    RichEditLog: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    FController: TjjFormController;
    FGameParams: TjjFrameGameParams;
    FGame: TjjFrameGame;

    procedure OnUiEvent(Event: TjjUiEvent);

  public
    { Public declarations }
  end;

var
  jjFormChessGui: TjjFormChessGui;

implementation

{$R *.dfm}

uses
    System.SysUtils
  , jjConsts
  ;

//______________________________________________________________________________
//
// TjjFormChessGui
//______________________________________________________________________________

procedure TjjFormChessGui.FormShow(Sender: TObject);
begin
  FController := TjjFormController.Create(RichEditLog, OnUiEvent);

  RichEditLog.ScrollBars := ssVertical;
  RichEditLog.Clear;

  FGameParams := TjjFrameGameParams.CreateNew(Self, FController);
  FGameParams.Parent := PanelGame;
  FGameParams.Align := alClient;

  FGame := TjjFrameGame.CreateNew(Self, FController);
  FGame.Parent := PanelGame;
  FGame.Align := alClient;
  FGame.Visible := False;

  FController.WriteMessageToLog([TjjLogMessage.Create(
    'Welcome Chess Delphi GUI Edition! Please select your player types to ' +
    'begin.'
  )]);
end;

//______________________________________________________________________________

procedure TjjFormChessGui.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FController);
end;

//______________________________________________________________________________

procedure TjjFormChessGui.OnUiEvent(Event: TjjUiEvent);
begin
  case Event of
    uiStartGame: begin
      FGameParams.Visible := False;
      FGame.Visible := True;
      FGame.UpdateBoard;
    end;
    uiDisableBoard: begin
      FGame.DisableBoard;
    end;
    uiUpdateBoard: begin
      FGame.UpdateBoard;
    end;
    uiGameOver: begin
      FGame.GameOver;
    end;
    uiClearGame: begin
      FGameParams.Reset;
      FGameParams.Visible := True;

      FGame.Visible := False;
      FGame.Reset;
    end;
  end;
end;

end.
