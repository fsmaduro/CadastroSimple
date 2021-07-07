object frmViewCliente: TfrmViewCliente
  Left = 0
  Top = 0
  Caption = 'Cadastro de Cliente'
  ClientHeight = 372
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 352
    Top = 328
    Width = 410
    Height = 2
  end
  object edtCodigo: TLabeledEdit
    Left = 353
    Top = 24
    Width = 121
    Height = 21
    TabStop = False
    Color = clBtnFace
    EditLabel.Width = 33
    EditLabel.Height = 13
    EditLabel.Caption = 'C'#243'digo'
    ReadOnly = True
    TabOrder = 14
  end
  object edtNome: TLabeledEdit
    Left = 353
    Top = 64
    Width = 406
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Nome'
    TabOrder = 0
  end
  object edtIdentidade: TLabeledEdit
    Left = 353
    Top = 104
    Width = 200
    Height = 21
    EditLabel.Width = 52
    EditLabel.Height = 13
    EditLabel.Caption = 'Identidade'
    TabOrder = 1
  end
  object edtCPF: TLabeledEdit
    Left = 559
    Top = 104
    Width = 200
    Height = 21
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = 'CPF'
    TabOrder = 2
  end
  object edtTelefone: TLabeledEdit
    Left = 353
    Top = 144
    Width = 200
    Height = 21
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'Telefone'
    TabOrder = 3
  end
  object edtEmail: TLabeledEdit
    Left = 559
    Top = 144
    Width = 200
    Height = 21
    EditLabel.Width = 24
    EditLabel.Height = 13
    EditLabel.Caption = 'Email'
    TabOrder = 4
  end
  object edtCEP: TLabeledEdit
    Left = 353
    Top = 184
    Width = 112
    Height = 21
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = 'CEP'
    TabOrder = 5
    OnEnter = edtCEPEnter
    OnExit = edtCEPExit
  end
  object edtLogradouro: TLabeledEdit
    Left = 471
    Top = 184
    Width = 288
    Height = 21
    EditLabel.Width = 55
    EditLabel.Height = 13
    EditLabel.Caption = 'Logradouro'
    TabOrder = 6
  end
  object edtComplemento: TLabeledEdit
    Left = 423
    Top = 224
    Width = 129
    Height = 21
    EditLabel.Width = 65
    EditLabel.Height = 13
    EditLabel.Caption = 'Complemento'
    TabOrder = 8
  end
  object edtNumero: TLabeledEdit
    Left = 353
    Top = 224
    Width = 64
    Height = 21
    EditLabel.Width = 37
    EditLabel.Height = 13
    EditLabel.Caption = 'Numero'
    TabOrder = 7
  end
  object edtBairro: TLabeledEdit
    Left = 560
    Top = 224
    Width = 199
    Height = 21
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Bairro'
    TabOrder = 9
  end
  object edtPais: TLabeledEdit
    Left = 641
    Top = 265
    Width = 118
    Height = 21
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = 'Pais'
    TabOrder = 12
  end
  object edtEstado: TLabeledEdit
    Left = 584
    Top = 265
    Width = 49
    Height = 21
    EditLabel.Width = 33
    EditLabel.Height = 13
    EditLabel.Caption = 'Estado'
    TabOrder = 11
  end
  object edtCidade: TLabeledEdit
    Left = 353
    Top = 265
    Width = 225
    Height = 21
    EditLabel.Width = 33
    EditLabel.Height = 13
    EditLabel.Caption = 'Cidade'
    TabOrder = 10
  end
  object DBGrid1: TDBGrid
    Left = 1
    Top = 4
    Width = 346
    Height = 364
    TabStop = False
    DataSource = dsClientes
    ReadOnly = True
    TabOrder = 16
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'codigo'
        Title.Caption = 'C'#243'digo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Title.Caption = 'Nome'
        Width = 245
        Visible = True
      end>
  end
  object btnNovo: TButton
    Left = 353
    Top = 298
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 15
    OnClick = btnNovoClick
  end
  object btnGravar: TButton
    Left = 685
    Top = 298
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 13
    OnClick = btnGravarClick
  end
  object btnPrimeiro: TButton
    Left = 497
    Top = 22
    Width = 56
    Height = 25
    Caption = '<<'
    TabOrder = 17
    TabStop = False
    OnClick = btnPrimeiroClick
  end
  object btnRetornar: TButton
    Left = 559
    Top = 22
    Width = 55
    Height = 25
    Caption = '<'
    TabOrder = 18
    TabStop = False
    OnClick = btnRetornarClick
  end
  object btnAvancar: TButton
    Left = 618
    Top = 22
    Width = 54
    Height = 25
    Caption = '>'
    TabOrder = 19
    TabStop = False
    OnClick = btnAvancarClick
  end
  object btnUltimo: TButton
    Left = 678
    Top = 22
    Width = 54
    Height = 25
    Caption = '>>'
    TabOrder = 20
    TabStop = False
    OnClick = btnUltimoClick
  end
  object btnEnviarEmail: TButton
    Left = 648
    Top = 339
    Width = 112
    Height = 25
    Caption = 'Enviar por Email'
    TabOrder = 21
    OnClick = btnEnviarEmailClick
  end
  object edtEmailPara: TLabeledEdit
    Left = 361
    Top = 347
    Width = 281
    Height = 21
    EditLabel.Width = 22
    EditLabel.Height = 13
    EditLabel.Caption = 'Para'
    TabOrder = 22
  end
  object dsClientes: TDataSource
    Left = 296
    Top = 304
  end
end
