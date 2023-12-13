unit jjGuiHumanPlayers;

interface

uses
    jjPlayers
  , jjConsts
  , jjBoards
  , jjMoves
  ;

type
  TjjGuiHumanPlayer = class(TjjPlayer)
  public
    constructor Create(Color: TjjColor);

    function PromptMove(Board: TjjBoard): TjjMove; override;
  end;

implementation

uses
    System.SysUtils
  ;

//______________________________________________________________________________
//
// TjjGuiHumanPlayer
//______________________________________________________________________________

constructor TjjGuiHumanPlayer.Create(Color: TjjColor);
begin
  inherited Create(Color);
end;

//______________________________________________________________________________

function TjjGuiHumanPlayer.PromptMove(Board: TjjBoard): TjjMove;
begin
  // Does not apply to the GUI version since the move is prompted on screen.
  raise Exception.Create('Move should be handled by the GUI.');
end;

end.
