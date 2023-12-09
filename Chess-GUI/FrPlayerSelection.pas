unit FrPlayerSelection;

interface

uses
    Vcl.Forms
  , Vcl.Controls
  , Vcl.StdCtrls
  , System.Classes
  , Vcl.ExtCtrls
  , jjConsts
  , jjPlayers
  , jjGuiHumanPlayers
  , jjGuiComputerPlayers
  ;

type
  TjjFramePlayerSelection = class(TFrame)
    PanelMain: TPanel;
    LabelColor: TLabel;
    ButtonHuman: TButton;
    ButtonComputer: TButton;
    LabelDepth: TLabel;
    EditDepth: TEdit;
    procedure ButtonComputerClick(Sender: TObject);
    procedure ButtonHumanClick(Sender: TObject);

  private
    FColor: TjjColor;

  public
    constructor CreateNew(Owner: TComponent; Color: TjjColor);

    procedure Reset;
    function Validate: Boolean;
    function MakePlayer: TjjPlayer;
  end;

implementation

{$R *.dfm}

uses
    Vcl.Dialogs
  , System.SysUtils
  , System.UITypes
  ;

//______________________________________________________________________________
//
// TjjFramePlayerSelection
//______________________________________________________________________________

constructor TjjFramePlayerSelection.CreateNew(
  Owner: TComponent;
  Color: TjjColor
);
begin
  inherited Create(Owner);

  FColor := Color;
  LabelColor.Caption := C_ColorNames[Color];
end;

//______________________________________________________________________________

procedure TjjFramePlayerSelection.Reset;
begin
  ButtonHuman.Enabled := True;
  ButtonComputer.Enabled := True;
  EditDepth.Enabled := False;
  EditDepth.Text := '';
end;

//______________________________________________________________________________

function TjjFramePlayerSelection.Validate: Boolean;
begin
  Result := True;

  if ButtonHuman.Enabled and ButtonComputer.Enabled then begin
    MessageDlg(
      Format('Please select a player type for %s.', [C_ColorNames[FColor]]),
      mtError,
      [mbOK],
      0
    );
    Result := False;
    Exit;
  end;

  if not ButtonComputer.Enabled then begin
    if (EditDepth.Text = '') then begin
      MessageDlg(
        Format(
          'Please enter the number of moves the computer will think ahead for ' +
            '%s.',
          [C_ColorNames[FColor]
        ]),
        mtError,
        [mbOK],
        0
      );
      Result := False;
    end
    else if StrToInt(EditDepth.Text) = 0 then begin
      MessageDlg(
        Format(
          'Please enter a number greater than zero for the number of moves ' +
            'the computer will think ahead for %s.',
          [C_ColorNames[FColor]
        ]),
        mtError,
        [mbOK],
        0
      );
      Result := False;
    end;
  end;
end;

//______________________________________________________________________________

function TjjFramePlayerSelection.MakePlayer: TjjPlayer;
begin
  Assert(
    ButtonHuman.Enabled xor ButtonComputer.Enabled,
    'Unexpected player configuration.'
  );

  if not ButtonHuman.Enabled then begin
    Result := TjjGuiHumanPlayer.Create(FColor);
  end
  else begin
    Result := TjjGuiComputerPlayer.Create(FColor, StrToInt(EditDepth.Text));
  end;
end;

//______________________________________________________________________________

procedure TjjFramePlayerSelection.ButtonComputerClick(Sender: TObject);
begin
  ButtonHuman.Enabled := True;
  ButtonComputer.Enabled := False;
  EditDepth.Enabled := True;
end;

//______________________________________________________________________________

procedure TjjFramePlayerSelection.ButtonHumanClick(Sender: TObject);
begin
  ButtonHuman.Enabled := False;
  ButtonComputer.Enabled := True;
  EditDepth.Enabled := False;
end;

end.
