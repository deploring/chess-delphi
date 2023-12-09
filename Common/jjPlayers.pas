unit jjPlayers;

interface

uses
    jjConsts
  , jjMoves
  , jjBoards
  ;

type
  TjjPlayer = class(TObject)
  private
    FColor: TjjColor;

  public
    constructor Create(Color: TjjColor);

    function PromptMove(Board: TjjBoard): TjjMove; virtual; abstract;

    property Color: TjjColor read FColor;
  end;

implementation

//______________________________________________________________________________
//
// TjjPlayer
//______________________________________________________________________________

constructor TjjPlayer.Create(Color: TjjColor);
begin
  FColor := Color;
end;

end.
