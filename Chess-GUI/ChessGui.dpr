program ChessGui;

uses
  Vcl.Forms,
  FChessGui in 'FChessGui.pas' {jjFormChessGui},
  jjFormControllers in 'jjFormControllers.pas',
  FrPlayerSelection in 'FrPlayerSelection.pas' {jjFramePlayerSelection: TFrame},
  jjConsts in '..\Common\jjConsts.pas',
  FrGameParamss in 'FrGameParamss.pas' {jjFrameGameParams: TFrame},
  jjMoves in '..\Common\jjMoves.pas',
  jjBoards in '..\Common\jjBoards.pas',
  jjPlayers in '..\Common\jjPlayers.pas',
  jjNegamaxs in '..\Common\jjNegamaxs.pas',
  jjGuiComputerPlayers in 'jjGuiComputerPlayers.pas',
  jjGuiHumanPlayers in 'jjGuiHumanPlayers.pas',
  FrGames in 'FrGames.pas' {jjFrameGame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TjjFormChessGui, jjFormChessGui);
  Application.Run;
end.
