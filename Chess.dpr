program Chess;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  jjConsts in 'Board\jjConsts.pas',
  jjBoards in 'Board\jjBoards.pas',
  jjMoves in 'Game\jjMoves.pas',
  jjPlayers in 'Player\jjPlayers.pas',
  jjHumanPlayers in 'Player\jjHumanPlayers.pas',
  jjGames in 'Game\jjGames.pas',
  jjComputerPlayers in 'Player\jjComputerPlayers.pas';

var
  Game: TjjGame;
begin
  Randomize;
  Game := TjjGame.Create(TjjComputerPlayer.Create(clWhite, 2), TjjComputerPlayer.Create(clBlack, 4));
  Game.Play;

  while True do begin end;

end.
