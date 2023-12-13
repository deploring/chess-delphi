object jjFrameGame: TjjFrameGame
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object ButtonResign: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Resign'
    TabOrder = 0
    OnClick = ButtonResignClick
  end
  object ButtonBack: TButton
    Left = 97
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Back'
    TabOrder = 1
    OnClick = ButtonBackClick
  end
end
