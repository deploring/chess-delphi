unit jjGuiComputerPlayers;

interface

uses
    jjPlayers
  , jjMoves
  , jjBoards
  , jjConsts
  , jjNegamaxs
  ;

type
  TjjGuiComputerPlayer = class(TjjPlayer)
  private
    FDepth: Integer;
    FNegamax: TjjNegamax;

  public
    constructor Create(Color: TjjColor; Depth: Integer);
    destructor Destroy; override;

    function PromptMove(Board: TjjBoard): TjjMove; override;

    property Negamax: TjjNegamax read FNegamax;
  end;

implementation

uses
    System.SysUtils
  ;

//______________________________________________________________________________
//
// TjjGuiComputerPlayer
//______________________________________________________________________________

constructor TjjGuiComputerPlayer.Create(Color: TjjColor; Depth: Integer);
begin
  inherited Create(Color);

  FDepth := Depth;
  FNegamax := TjjNegamax.Create(Color);
end;

//______________________________________________________________________________

destructor TjjGuiComputerPlayer.Destroy;
begin
  FreeAndNil(FNegamax);

  inherited;
end;

//______________________________________________________________________________

function TjjGuiComputerPlayer.PromptMove(Board: TjjBoard): TjjMove;
begin
  Result := FNegamax.NegamaxHandler(Board, FDepth);
end;

end.
