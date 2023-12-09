program ChessConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  jjBoards in '..\Common\jjBoards.pas',
  jjConsts in '..\Common\jjConsts.pas',
  jjMoves in '..\Common\jjMoves.pas',
  jjPlayers in '..\Common\jjPlayers.pas',
  jjNegamaxs in '..\Common\jjNegamaxs.pas',
  jjComputerPlayers in 'jjComputerPlayers.pas',
  jjConsoleGames in 'jjConsoleGames.pas',
  jjHumanPlayers in 'jjHumanPlayers.pas';

function AddComputerPlayer(Color: TjjColor): TjjComputerPlayer;
var
  Input: String;
  Depth: Integer;
begin

  while True do begin
    Writeln(
      'Please enter the number of moves that the computer will think ahead.' +
      NL
    );
    Write('Input: ');
    try
      Readln(Input);
      Write(NL);
      Depth := StrToInt(Input);

      if Depth <= 0 then begin
        Writeln('Please enter a number greater than zero.' + NL);
        Continue;
      end;

    except
      on EConvertError do begin
        Writeln('Please enter a valid number.' + NL);
        Continue;
      end;
    end;

    if Depth > 5 then begin
      Writeln(
        'WARNING: Thinking more than 5 moves ahead may produce considerable ' +
        'wait times.' + NL
      );
    end;

    Result := TjjComputerPlayer.Create(Color, Depth);
    Break;
  end;
end;

function AddPlayer(Color: TjjColor): TjjPlayer;
var
  Input: String;
begin
  Writeln(Format(
    'Please select the player type for %s. Type ''human'' for human, and type' +
      ' ''computer'' for computer.' + NL,
    [C_ColorNames[Color]]
  ));

  while True do begin
    Write('Input: ');
    Readln(Input);
    Write(NL);

    if SameText(Input, 'human') then begin
      Result := TjjHumanPlayer.Create(Color);
      Break;
    end
    else if SameText(Input, 'computer') then begin
      Result := AddComputerPlayer(Color);
      Break;
    end
    else begin
      Writeln('Unknown player type. Please try again.' + NL);
    end;
  end;
end;

var
  PlayerWhite: TjjPlayer;
  PlayerBlack: TjjPlayer;
  ConsoleGame: TjjConsoleGame;
  Input: String;
begin
  while True do begin
    Writeln('Welcome to Delphi Chess (Console Edition)!' + NL);

    PlayerWhite := AddPlayer(clWhite);
    PlayerBlack := AddPlayer(clBlack);

    ConsoleGame := TjjConsoleGame.Create(PlayerWhite, PlayerBlack);
    ConsoleGame.Play;

    FreeAndNil(ConsoleGame);

    Writeln(
      'Good game! Please type ''quit'' if you would like to quit, otherwise ' +
        'anything else to play another game.' + NL
    );
    Write('Input: ');
    Readln(Input);
    Write(NL);

    if SameText(Input, 'quit') then begin
      Break;
    end;
  end;
end.
