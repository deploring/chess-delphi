program ChessGui;

uses
  Vcl.Forms,
  FChessGui in 'Source\FChessGui.pas' {jjFormChessGui},
  jjFormControllers in 'Source\jjFormControllers.pas',
  FrPlayerSelections in 'Source\FrPlayerSelections.pas' {jjFramePlayerSelection: TFrame},
  jjConsts in '..\Common\Source\jjConsts.pas',
  FrGameParamss in 'Source\FrGameParamss.pas' {jjFrameGameParams: TFrame},
  jjMoves in '..\Common\Source\jjMoves.pas',
  jjBoards in '..\Common\Source\jjBoards.pas',
  jjPlayers in '..\Common\Source\jjPlayers.pas',
  jjNegamaxs in '..\Common\Source\jjNegamaxs.pas',
  jjGuiComputerPlayers in 'Source\jjGuiComputerPlayers.pas',
  jjGuiHumanPlayers in 'Source\jjGuiHumanPlayers.pas',
  FrGames in 'Source\FrGames.pas' {jjFrameGame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TjjFormChessGui, jjFormChessGui);
  Application.Run;
end.
