object jjFormChessGui: TjjFormChessGui
  Left = 0
  Top = 0
  Caption = 'Delphi Chess GUI Edition'
  ClientHeight = 678
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object Splitter: TSplitter
    Left = 306
    Top = 0
    Height = 678
    ExplicitLeft = 185
    ExplicitHeight = 442
  end
  object PanelGame: TPanel
    AlignWithMargins = True
    Left = 312
    Top = 3
    Width = 709
    Height = 672
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 699
    ExplicitHeight = 654
  end
  object PanelEventLog: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 300
    Height = 672
    Align = alLeft
    Constraints.MaxWidth = 600
    Constraints.MinWidth = 300
    TabOrder = 1
    ExplicitHeight = 654
    object RichEditLog: TRichEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 292
      Height = 664
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      HideScrollBars = False
      Lines.Strings = (
        'RichEditLog')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
end
