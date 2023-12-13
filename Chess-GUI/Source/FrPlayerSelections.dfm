object jjFramePlayerSelection: TjjFramePlayerSelection
  Left = 0
  Top = 0
  Width = 218
  Height = 211
  TabOrder = 0
  object PanelMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 212
    Height = 205
    Align = alClient
    TabOrder = 0
    object LabelColor: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 204
      Height = 19
      Align = alTop
      Alignment = taCenter
      Caption = 'Color'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlBottom
      ExplicitWidth = 37
    end
    object LabelDepth: TLabel
      Left = 16
      Top = 136
      Width = 154
      Height = 30
      Caption = 'Number of moves computer should think ahead:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ButtonHuman: TButton
      Left = 16
      Top = 29
      Width = 177
      Height = 41
      Caption = 'Human'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ButtonHumanClick
    end
    object ButtonComputer: TButton
      Left = 16
      Top = 76
      Width = 177
      Height = 41
      Caption = 'Computer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonComputerClick
    end
    object EditDepth: TEdit
      Left = 16
      Top = 173
      Width = 177
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      NumbersOnly = True
      ParentFont = False
      TabOrder = 2
    end
  end
end
