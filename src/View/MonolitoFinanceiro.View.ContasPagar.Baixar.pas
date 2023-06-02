unit MonolitoFinanceiro.View.ContasPagar.Baixar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList;

type
  TfrmContasPagarBaixar = class(TForm)
    pnlPrincipal: TPanel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblDocumento: TLabel;
    lblParcela: TLabel;
    lblValorParcela: TLabel;
    lblVencimento: TLabel;
    lblValorAbatido: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    edtObservacao: TEdit;
    edtValor: TEdit;
    Panel3: TPanel;
    btnCancelar: TButton;
    btnBaixar: TButton;
    ImageList1: TImageList;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnBaixarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
  private
    { Private declarations }
    FID : String;
  public
    { Public declarations }
    procedure BaixarContaPagar(ID: String);
  end;

var
  frmContasPagarBaixar: TfrmContasPagarBaixar;

implementation

uses
  MonolitoFinanceiro.Entidades.ContaPagar,
  MonolitoFinanceiro.Model.ContasPagar, Monolito.Financeiro.Utilitarios,
  MonolitoFinanceiro.Entidades.ContaPagar.Detalhes,
  Monolito.Financeiro.Model.Usuarios;

{$R *.dfm}

{ TfrmContasPagarBaixar }

procedure TfrmContasPagarBaixar.BaixarContaPagar(ID: String);
var
  ContaPagar : TModelContaPagar;
begin
  FID := Trim(ID);
  if FID.IsEmpty then
    raise Exception.Create('ID do contas a pagar inv�lido');

  ContaPagar := dmContasPagar.GetContaPagar(FID);
  try
    if ContaPagar.Status = 'B' then
      raise Exception.Create('N�o � poss�vel baixar um documento baixado');

    if ContaPagar.Status = 'C' then
      raise Exception.Create('N�o � poss�vel baixar um documento cancelado');

    lblDocumento.Caption := ContaPagar.Documento;
    lblParcela.Caption := IntToStr(ContaPagar.Parcela);
    lblVencimento.Caption := FormatDateTime('dd/mm/yyyy', ContaPagar.DataVencimento);
    lblValorAbatido.Caption := TUtilitarios.FormatarValor(ContaPagar.ValorAbatido);
    lblValorParcela.Caption := TUtilitarios.FormatarValor(ContaPagar.ValorParcela);
    edtObservacao.Text := '';
    edtValor.Text := '';

    Self.ShowModal;
  finally
    ContaPagar.Free
  end;
end;

procedure TfrmContasPagarBaixar.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmContasPagarBaixar.edtValorExit(Sender: TObject);
begin
  edtValor.Text := TUtilitarios.FormatarValor(edtValor.Text);
end;

procedure TfrmContasPagarBaixar.FormCreate(Sender: TObject);
begin
  edtValor.OnKeyPress := TUtilitarios.KeyPressValor;
end;

procedure TfrmContasPagarBaixar.btnBaixarClick(Sender: TObject);
var
  ContaPagarDetalhe : TModelContaPagarDetalhe;
  ValorAbater : Currency;
begin
  if Trim(edtObservacao.Text) = '' then
  begin
    edtObservacao.SetFocus;
    Application.MessageBox('A observa��o n�o pode ser vazia', 'Aten��o', MB_OK + MB_ICONWARNING);
    abort;
  end;

  ValorAbater := 0;
  TryStrToCurr(edtValor.Text, ValorAbater);

  if ValorAbater <= 0 then
  begin
    edtValor.SetFocus;
    Application.MessageBox('Valor inv�lido', 'Aten��o', MB_OK + MB_ICONWARNING);
    abort;
  end;

  ContaPagarDetalhe := TModelContaPagarDetalhe.Create;
  try
    ContaPagarDetalhe.IDContaPagar := FID;
    ContaPagarDetalhe.Detalhes := edtObservacao.Text;
    ContaPagarDetalhe.Valor := ValorAbater;
    ContaPagarDetalhe.Data := Now;
    ContaPagarDetalhe.Usuario := dmUsuarios.GetUsuarioLogado.ID;

    try
      dmContasPagar.BaixarContaPagar(ContaPagarDetalhe);
      Application.MessageBox('Documento baixado com sucesso', 'Sucesso', MB_OK + MB_ICONINFORMATION);
      ModalResult := mrOk;
    except on E : Exception do
      Application.MessageBox(PWideChar(E.Message), 'Erro ao baixar documento', MB_OK + MB_ICONWARNING);
    end;
  finally
    ContaPagarDetalhe.Free;
  end;

end;

end.

