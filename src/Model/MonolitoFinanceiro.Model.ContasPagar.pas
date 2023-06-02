unit MonolitoFinanceiro.Model.ContasPagar;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Datasnap.DBClient,
  Datasnap.Provider, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  MonolitoFinanceiro.Model.Conexao, MonolitoFinanceiro.Entidades.ContaPagar, 
  MonolitoFinanceiro.Entidades.ContaPagar.Detalhes;

type
  TdmContasPagar = class(TDataModule)
    sqlContasPagar: TFDQuery;
    dspContasPagar: TDataSetProvider;
    cdsContasPagar: TClientDataSet;
    cdsContasPagarid: TStringField;
    cdsContasPagarnumero_documento: TStringField;
    cdsContasPagardescricao: TStringField;
    cdsContasPagarparcela: TIntegerField;
    cdsContasPagarvalor_parcela: TFMTBCDField;
    cdsContasPagarvalor_compra: TFMTBCDField;
    cdsContasPagarvalor_abatido: TFMTBCDField;
    cdsContasPagardata_compra: TDateField;
    cdsContasPagardata_cadastro: TDateField;
    cdsContasPagardata_vencimento: TDateField;
    cdsContasPagardata_pagamento: TDateField;
    cdsContasPagarstatus: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetContaPagar(ID: String): TModelContaPagar;
    procedure BaixarContaPagar(BaixaPagar : TModelContaPagarDetalhe);
  end;

var
  dmContasPagar: TdmContasPagar;

implementation

uses
  Monolito.Financeiro.Utilitarios;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmContasPagar }

procedure TdmContasPagar.BaixarContaPagar(BaixaPagar: TModelContaPagarDetalhe);
var
  ContaPagar : TModelContaPagar;
  SQLGravar : TFDQuery;
  SQL : string;
begin
  ContaPagar := GetContaPagar(BaixaPagar.IDContaPagar);
  try
    if ContaPagar.ID = '' then
      raise Exception.Create('Conta pagar n�o encontrada');
    
    ContaPagar.ValorAbatido := ContaPagar.ValorAbatido + BaixaPagar.Valor;
    if ContaPagar.ValorAbatido >= ContaPagar.ValorParcela then
    begin
      ContaPagar.Status := 'B';
      ContaPagar.DataPagamento := Now;
    end;

    SQLGravar := TFDQuery.Create(nil);
    try
      SQLGravar.Connection := dmConexao.SQLConexao;
      
       SQL := 'UPDATE CONTAS_PAGAR SET VALOR_ABATIDO = :VALORABATIDO,' +
              ' VALOR_PARCELA = :VALORPARCELA,' +
              ' STATUS = :STATUS,' +
              ' DATA_PAGAMENTO = :DATAPAGAMENTO' +
              ' WHERE ID = :IDCONTAPAGAR;';
       SQLGravar.SQL.Clear;
       SQLGravar.SQL.Add(SQL);
       SQLGravar.ParamByName('VALORABATIDO').AsCurrency := ContaPagar.ValorAbatido;
       SQLGravar.ParamByName('VALORPARCELA').AsCurrency := ContaPagar.ValorParcela;
       SQLGravar.ParamByName('STATUS').AsString := ContaPagar.Status;
       SQLGravar.ParamByName('DATAPAGAMENTO').AsDateTime := ContaPagar.DataPagamento;
       SQLGravar.ParamByName('IDCONTAPAGAR').AsString := ContaPagar.ID;

       SQL := 'INSERT INTO CONTAS_PAGAR_DETALHES (ID, ID_CONTA_PAGAR,' +
              ' DETALHES, VALOR, DATA, USUARIO) VALUES (:IDDETALHE,' +
              ' :IDCONTAPAGAR, :DETALHES, :VALOR, :DATA, :USUARIO);';
       SQLGravar.SQL.Add(SQL);
       SQLGravar.ParamByName('IDDETALHE').AsString := TUtilitarios.GETID;
       SQLGravar.ParamByName('DETALHES').AsString := BaixaPagar.Detalhes;
       SQLGravar.ParamByName('VALOR').AsCurrency := BaixaPagar.Valor;
       SQLGravar.ParamByName('DATA').AsDateTime := BaixaPagar.Data;
       SQLGravar.ParamByName('USUARIO').AsString := BaixaPagar.Usuario;

       SQLGravar.Prepare;
       SQLGravar.ExecSQL;
    finally
      SQLGravar.Free;
    end;
    
  finally
    ContaPagar.Free;
  end;
end;

function TdmContasPagar.GetContaPagar(ID: String): TModelContaPagar;
var
  SQLConsulta: TFDQuery;
begin
  SQLConsulta := TFDQuery.Create(nil);
  try
    SQLConsulta.Connection := dmConexao.SQLConexao;
    SQLConsulta.SQL.Clear;
    SQLConsulta.SQL.Add('SELECT * FROM CONTAS_PAGAR WHERE ID = :ID');
    SQLConsulta.ParamByName('ID').AsString := ID;
    SQLConsulta.Open;
    Result := TModelContaPagar.Create;
    try
      Result.ID := SQLConsulta.FieldByName('ID').AsString;
      Result.Documento := SQLConsulta.FieldByName('NUMERO_DOCUMENTO').AsString;
      Result.Descricao := SQLConsulta.FieldByName('DESCRICAO').AsString;
      Result.Parcela := SQLConsulta.FieldByName('PARCELA').AsInteger;
      Result.ValorParcela := SQLConsulta.FieldByName('VALOR_PARCELA').AsCurrency;
      Result.ValorCompra := SQLConsulta.FieldByName('VALOR_COMPRA').AsCurrency;
      Result.ValorAbatido := SQLConsulta.FieldByName('VALOR_ABATIDO').AsCurrency;
      Result.DataCompra := SQLConsulta.FieldByName('DATA_COMPRA').AsDateTime;
      Result.DataCadastro := SQLConsulta.FieldByName('DATA_CADASTRO').AsDateTime;
      Result.DataVencimento := SQLConsulta.FieldByName('DATA_VENCIMENTO').AsDateTime;
      Result.DataPagamento := SQLConsulta.FieldByName('DATA_PAGAMENTO').AsDateTime;
      Result.Status := SQLConsulta.FieldByName('STATUS').AsString;
    except
      Result.Free;
      raise;
    end;
  finally
    SQLConsulta.Free;
  end;
end;

end.
