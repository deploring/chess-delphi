unit jjMoves;

interface

type
  TjjMove = class(TObject)
  private
    FOriginRow: Integer;
    FOriginColumn: Integer;
    FDestinationRow: Integer;
    FDestinationColumn: Integer;

  public
    constructor Create(
      OriginRow: Integer;
      OriginColumn: Integer;
      DestinationRow: Integer;
      DestinationColumn: Integer
    );

    function Clone: TjjMove;
    function StateMove: String;

    function IsOriginSameAs(Move: TjjMove): Boolean;
    function IsDestinationSameAs(Move: TjjMove): Boolean;
    function IsSameAs(Move: TjjMove): Boolean;

    property OriginRow: Integer read FOriginRow;
    property OriginColumn: Integer read FOriginColumn;
    property DestinationRow: Integer read FDestinationRow;
    property DestinationColumn: Integer read FDestinationColumn;
  end;

implementation

uses
    System.SysUtils
  ;

//______________________________________________________________________________
//
// TjjMove
//______________________________________________________________________________

constructor TjjMove.Create(
  OriginRow: Integer;
  OriginColumn: Integer;
  DestinationRow: Integer;
  DestinationColumn: Integer
);
begin
  FOriginRow := OriginRow;
  FOriginColumn := OriginColumn;
  FDestinationRow := DestinationRow;
  FDestinationColumn := DestinationColumn;
end;

//______________________________________________________________________________

function TjjMove.Clone: TjjMove;
begin
  Result := TjjMove.Create(
    FOriginRow,
    FOriginColumn,
    FDestinationRow,
    FDestinationColumn
  );
end;

//______________________________________________________________________________

function TjjMove.StateMove: String;
begin
  Result := Format(
    '%s%d -> %s%d',
    [
      Char(Ord('a') + FOriginColumn),
      FOriginRow + 1,
      Char(Ord('a') + FDestinationColumn),
      FDestinationRow + 1
    ]
  );
end;

//______________________________________________________________________________

function TjjMove.IsOriginSameAs(Move: TjjMove): Boolean;
begin
  Result :=
    (Move.OriginRow = FOriginRow) and (Move.OriginColumn = FOriginColumn);
end;

//______________________________________________________________________________

function TjjMove.IsDestinationSameAs(Move: TjjMove): Boolean;
begin
  Result :=
    (Move.DestinationRow = FDestinationRow) and
    (Move.DestinationColumn = FDestinationColumn);
end;

//______________________________________________________________________________

function TjjMove.IsSameAs(Move: TjjMove): Boolean;
begin
  Result := IsOriginSameAs(Move) and IsDestinationSameAs(Move);
end;

end.
