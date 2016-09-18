object Form1: TForm1
  Left = 235
  Top = 110
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Heroes 0'
  ClientHeight = 324
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object DrawGrid1: TDrawGrid
    Left = 0
    Top = 0
    Width = 328
    Height = 324
    Align = alClient
    Color = clSilver
    ColCount = 10
    DefaultColWidth = 31
    DefaultRowHeight = 31
    FixedColor = clSilver
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 328
    Top = 0
    Width = 177
    Height = 324
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 3
      Top = 0
      Width = 105
      Height = 33
      AutoSize = False
      Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1083'-'#1074#1086' '#1080#1075#1088#1086#1082#1086#1074' ('#1086#1090' 2 '#1076#1086' 20):'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 79
      Height = 13
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1080#1075#1088#1099':'
    end
    object Button1: TButton
      Left = 40
      Top = 64
      Width = 75
      Height = 25
      Caption = '&'#1053#1086#1074#1072#1103' '#1080#1075#1088#1072
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object BitBtn1: TBitBtn
      Left = 64
      Top = 296
      Width = 75
      Height = 25
      Caption = '&'#1042#1099#1093#1086#1076
      TabOrder = 1
      Kind = bkClose
    end
    object Edit1: TEdit
      Left = 112
      Top = 8
      Width = 25
      Height = 21
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 0
      Top = 96
      Width = 137
      Height = 17
      Alignment = taLeftJustify
      Caption = #1048#1075#1088#1072' '#1089' '#1055#1072#1091#1079#1072#1084#1080
      TabOrder = 3
      Visible = False
    end
    object Edit2: TEdit
      Left = 96
      Top = 32
      Width = 41
      Height = 21
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 4
      Text = '10'
    end
    object UpDown1: TUpDown
      Left = 137
      Top = 32
      Width = 12
      Height = 21
      Associate = Edit2
      Min = 1
      Max = 200
      Position = 10
      TabOrder = 5
    end
  end
end
