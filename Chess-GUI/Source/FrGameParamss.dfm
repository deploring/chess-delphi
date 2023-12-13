object jjFrameGameParams: TjjFrameGameParams
  Left = 0
  Top = 0
  Width = 640
  Height = 432
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  TabOrder = 0
  object PanelIntro: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 634
    Height = 46
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object LabelIntro: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 578
      Height = 15
      Align = alClient
      Alignment = taCenter
      Caption = 
        'Welcome to Chess Delphi GUI Edition! To start, please select you' +
        'r player types. Once you'#39're ready, click "Start"!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
  object PanelPlayerSelection: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 55
    Width = 634
    Height = 314
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
  object PanelStart: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 375
    Width = 634
    Height = 50
    Align = alTop
    TabOrder = 2
    object ButtonStart: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 75
      Height = 42
      Align = alLeft
      Caption = 'Start'
      TabOrder = 0
      OnClick = ButtonStartClick
    end
  end
end
