unit FrGameParamss;

interface

uses
    Vcl.Forms
  , Vcl.Controls
  , Vcl.StdCtrls
  , System.Classes
  , Vcl.ExtCtrls
  , FrPlayerSelection
  , jjFormControllers
  ;

type
  TjjFrameGameParams = class(TFrame)
    PanelIntro: TPanel;
    LabelIntro: TLabel;
    PanelPlayerSelection: TPanel;
    PanelStart: TPanel;
    ButtonStart: TButton;
    procedure ButtonStartClick(Sender: TObject);

  private
    FController: TjjFormController;
    FWhiteSelection: TjjFramePlayerSelection;
    FBlackSelection: TjjFramePlayerSelection;

  public
    constructor CreateNew(Owner: TComponent; Controller: TjjFormController);

    procedure Reset;
  end;

implementation

{$R *.dfm}

uses
    jjConsts
  ;

//______________________________________________________________________________
//
// TjjFrameGameParams
//______________________________________________________________________________

constructor TjjFrameGameParams.CreateNew(
  Owner: TComponent;
  Controller: TjjFormController
);
begin
  inherited Create(Owner);

  FController := Controller;

  FWhiteSelection := TjjFramePlayerSelection.CreateNew(Self, clWhite);
  FWhiteSelection.Parent := PanelPlayerSelection;
  FWhiteSelection.Align := alLeft;
  FWhiteSelection.Name := 'WhitePlayerSelection';
  FWhiteSelection.Reset;

  FBlackSelection := TjjFramePlayerSelection.CreateNew(Self, clBlack);
  FBlackSelection.Parent := PanelPlayerSelection;
  FBlackSelection.Align := alLeft;
  FBlackSelection.Name := 'BlackPlayerSelection';
  FBlackSelection.Reset;
end;

//______________________________________________________________________________

procedure TjjFrameGameParams.Reset;
begin
  FWhiteSelection.Reset;
  FBlackSelection.Reset;
end;

//______________________________________________________________________________

procedure TjjFrameGameParams.ButtonStartClick(Sender: TObject);
begin
  if not FWhiteSelection.Validate then begin
    Exit;
  end;

  if not FBlackSelection.Validate then begin
    Exit;
  end;

  FController.StartGame(FWhiteSelection.MakePlayer, FBlackSelection.MakePlayer);
end;

end.
