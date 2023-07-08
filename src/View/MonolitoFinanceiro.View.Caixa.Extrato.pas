unit MonolitoFinanceiro.View.Caixa.Extrato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Data.DB, Vcl.Grids,
  Vcl.DBGrids, MonolitoFinanceiro.Entidades.Caixa.Resumo;

type
  TfrmCaixaExtrato = class(TForm)
    ImageList1: TImageList;
    pnlPrincipal: TPanel;
    pnlPesquisar: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    dateInicial: TDateTimePicker;
    dateFinal: TDateTimePicker;
    pnlContent: TPanel;
    pnlPesquisaBotoes: TPanel;
    btnFechar: TButton;
    btnImprimir: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    lblSaldoFinal: TLabel;
    lblTotalSaidas: TLabel;
    lblTotalEntradas: TLabel;
    lblSaldoAnterior: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure btnFecharClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FResumoCaixa : TModelResumoCaixa;
    procedure Pesquisar;
  public
    { Public declarations }
  end;

var
  frmCaixaExtrato: TfrmCaixaExtrato;

implementation

{$R *.dfm}

uses MonolitoFinanceiro.Model.Caixa, Monolito.Financeiro.Utilitarios,
  MonolitoFinanceiro.View.Relatorios.Caixa.Extrato,
  DateUtils;

procedure TfrmCaixaExtrato.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCaixaExtrato.btnImprimirClick(Sender: TObject);
begin
  relCaixaExtrato.DataSet(DataSource1.DataSet);
  relCaixaExtrato.ResumoCaixa(FResumoCaixa);
  relCaixaExtrato.Preview;
end;

procedure TfrmCaixaExtrato.Button1Click(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmCaixaExtrato.FormDestroy(Sender: TObject);
begin
  FResumoCaixa.Free;
end;

procedure TfrmCaixaExtrato.FormShow(Sender: TObject);
begin
  dateInicial.Date := IncDay(Now, - 7);
  dateFinal.Date := Now;
  Pesquisar;
end;

procedure TfrmCaixaExtrato.Pesquisar;
var
  SQL: string;
begin
  SQL := 'SELECT DATA_CADASTRO, NUMERO_DOCUMENTO, DESCRICAO,' +
        ' CASE TIPO' +
            ' WHEN "D" THEN CAST (-VALOR AS REAL)' +
            ' WHEN "R" THEN CAST (VALOR AS REAL)' +
        ' END VALOR' +
        ' FROM CAIXA' +
        ' WHERE DATA_CADASTRO BETWEEN :DATAINICIO AND :DATAFINAL';

  dmCaixa.sqlCaixaExtrato.Close;
  dmCaixa.sqlCaixaExtrato.SQL.Clear;
  dmCaixa.sqlCaixaExtrato.SQL.Add(SQL);
  dmCaixa.sqlCaixaExtrato.ParamByName('DATAINICIO').AsDate := dateInicial.Date;
  dmCaixa.sqlCaixaExtrato.ParamByName('DATAFINAL').AsDate := dateFinal.Date;
  dmCaixa.sqlCaixaExtrato.Open;

  if Assigned(FResumoCaixa) then
    FResumoCaixa.Free;

  FResumoCaixa := dmCaixa.ResumoCaixa(dateInicial.Date, dateFinal.Date);

  lblSaldoAnterior.Caption := TUtilitarios.FormatoMoeda(FResumoCaixa.SaldoInicial);
  lblTotalEntradas.Caption := TUtilitarios.FormatoMoeda(FResumoCaixa.TotalEntradas);
  lblTotalSaidas.Caption := TUtilitarios.FormatoMoeda(FResumoCaixa.TotalSaidas);
  lblSaldoFinal.Caption := TUtilitarios.FormatoMoeda(FResumoCaixa.SaldoFinal);
end;

end.
