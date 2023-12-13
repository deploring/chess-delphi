unit jjComputerPlayers;

interface

uses
    jjPlayers
  , jjMoves
  , jjBoards
  , jjConsts
  , jjNegamaxs
  ;

type
  TjjComputerPlayer = class(TjjPlayer)
  private
    FDepth: Integer;
    FNegamax: TjjNegamax;

  public
    constructor Create(Color: TjjColor; Depth: Integer);
    destructor Destroy; override;

    function PromptMove(Board: TjjBoard): TjjMove; override;
  end;

implementation

uses
    System.SysUtils
  ;

//______________________________________________________________________________
//
// TjjComputerPlayer
//______________________________________________________________________________

constructor TjjComputerPlayer.Create(Color: TjjColor; Depth: Integer);
begin
  inherited Create(Color);

  FDepth := Depth;
  FNegamax := TjjNegamax.Create(Color);
end;

//______________________________________________________________________________

destructor TjjComputerPlayer.Destroy;
begin
  FreeAndNil(FNegamax);

  inherited;
end;

//______________________________________________________________________________

function TjjComputerPlayer.PromptMove(Board: TjjBoard): TjjMove;
begin
  Result := FNegamax.NegamaxHandler(Board, FDepth);

  Writeln(Format(
    '%d game state(s) evaluated; %d pruned.',
    [FNegamax.EvaluationCount, FNegamax.PruneCount]
  ));
  Writeln(Format(
    'Chose move with a score of %d.' + NL,
    [FNegamax.BestMoveValue]
  ));
end;

end.
