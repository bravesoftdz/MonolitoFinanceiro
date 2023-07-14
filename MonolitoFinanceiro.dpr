program MonolitoFinanceiro;

uses
  Vcl.Forms,
  MonolitoFinanceiro.View.Principal in 'src\View\MonolitoFinanceiro.View.Principal.pas' {frmPrincipal},
  MonolitoFinanceiro.View.CadastroPadrao in 'src\View\MonolitoFinanceiro.View.CadastroPadrao.pas' {frmCadastroPadrao},
  MonolitoFinanceiro.View.Splash in 'src\View\MonolitoFinanceiro.View.Splash.pas' {frmSplash},
  MonolitoFinanceiro.Model.Conexao in 'src\Model\MonolitoFinanceiro.Model.Conexao.pas' {dmConexao: TDataModule},
  MonolitoFinanceiro.View.Usuario in 'src\View\MonolitoFinanceiro.View.Usuario.pas' {frmUsuarios},
  Monolito.Financeiro.Model.Usuarios in 'src\Model\Monolito.Financeiro.Model.Usuarios.pas' {dmUsuarios: TDataModule},
  Monolito.Financeiro.Utilitarios in 'src\Util\Monolito.Financeiro.Utilitarios.pas',
  MonolitoFinanceiro.View.Login in 'src\View\MonolitoFinanceiro.View.Login.pas' {frmLogin},
  MonolitoFinanceiro.Entidades.Usuario in 'src\Model\Entidades\MonolitoFinanceiro.Entidades.Usuario.pas',
  MonolitoFinanceiro.Model.Sistema in 'src\Model\MonolitoFinanceiro.Model.Sistema.pas' {dmSistema: TDataModule},
  MonolitoFinanceiro.View.RedefinirSenha in 'src\View\MonolitoFinanceiro.View.RedefinirSenha.pas' {frmRedefinirSenha},
  MonolitoFinanceiro.Model.Caixa in 'src\Model\MonolitoFinanceiro.Model.Caixa.pas' {dmCaixa: TDataModule},
  MonolitoFinanceiro.View.Caixa in 'src\View\MonolitoFinanceiro.View.Caixa.pas' {frmCaixa},
  MonolitoFinanceiro.View.Caixa.Saldo in 'src\View\MonolitoFinanceiro.View.Caixa.Saldo.pas' {frmCaixaSaldo},
  MonolitoFinanceiro.Entidades.Caixa.Resumo in 'src\Model\Entidades\MonolitoFinanceiro.Entidades.Caixa.Resumo.pas',
  MonolitoFinanceiro.Model.ContasPagar in 'src\Model\MonolitoFinanceiro.Model.ContasPagar.pas' {dmContasPagar: TDataModule},
  MonolitoFinanceiro.View.ContasPagar in 'src\View\MonolitoFinanceiro.View.ContasPagar.pas' {frmContasPagar},
  MonolitoFinanceiro.Model.ContasReceber in 'src\Model\MonolitoFinanceiro.Model.ContasReceber.pas' {dmContasReceber: TDataModule},
  MonolitoFinanceiro.View.ContasReceber in 'src\View\MonolitoFinanceiro.View.ContasReceber.pas' {frmContasReceber},
  MonolitoFinanceiro.View.ContasReceber.Baixar in 'src\View\MonolitoFinanceiro.View.ContasReceber.Baixar.pas' {frmContasReceberBaixar},
  MonolitoFinanceiro.Entidades.ContaPagar in 'src\Model\Entidades\MonolitoFinanceiro.Entidades.ContaPagar.pas',
  MonolitoFinanceiro.Entidades.ContaPagar.Detalhes in 'src\Model\Entidades\MonolitoFinanceiro.Entidades.ContaPagar.Detalhes.pas',
  MonolitoFinanceiro.Entidades.ContaReceber in 'src\Model\Entidades\MonolitoFinanceiro.Entidades.ContaReceber.pas',
  MonolitoFinanceiro.Entidades.ContaReceber.Detalhes in 'src\Model\Entidades\MonolitoFinanceiro.Entidades.ContaReceber.Detalhes.pas',
  MonolitoFinanceiro.View.ContasPagar.Baixar in 'src\View\MonolitoFinanceiro.View.ContasPagar.Baixar.pas' {frmContasPagarBaixar},
  MonolitoFinanceiro.View.ContasPagar.Consultar in 'src\View\MonolitoFinanceiro.View.ContasPagar.Consultar.pas' {frmContasPagarConsultar},
  MonolitoFinanceiro.View.ContasPagar.Detalhes in 'src\View\MonolitoFinanceiro.View.ContasPagar.Detalhes.pas' {frmContasPagarDetalhes},
  MonolitoFinanceiro.View.ContasReceber.Consultar in 'src\View\MonolitoFinanceiro.View.ContasReceber.Consultar.pas' {frmContasReceberConsultar},
  MonolitoFinanceiro.View.ContasReceber.Detalhes in 'src\View\MonolitoFinanceiro.View.ContasReceber.Detalhes.pas' {frmContasReceberDetalhes},
  MonolitoFinanceiro.Entidades.Caixa.Lancamento in 'src\Model\Entidades\MonolitoFinanceiro.Entidades.Caixa.Lancamento.pas',
  MonolitoFinanceiro.View.Relatorios.Padrao in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.Padrao.pas' {relPadrao},
  MonolitoFinanceiro.View.Relatorios.Usuarios in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.Usuarios.pas' {relUsuarios},
  MonolitoFinanceiro.View.Relatorios.ContasReceber in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.ContasReceber.pas' {relContasReceber},
  MonolitoFinanceiro.View.Relatorios.PadraoAgrupado in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.PadraoAgrupado.pas' {relPadraoAgrupado},
  MonolitoFinanceiro.View.Relatorios.ContasReceberDetalhado in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.ContasReceberDetalhado.pas' {relContasReceberDetalhado},
  MonolitoFinanceiro.View.Caixa.Extrato in 'src\View\MonolitoFinanceiro.View.Caixa.Extrato.pas' {frmCaixaExtrato},
  MonolitoFinanceiro.View.Relatorios.Caixa.Extrato in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.Caixa.Extrato.pas' {relCaixaExtrato},
  MonolitoFinanceiro.View.Relatorios.Caixa in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.Caixa.pas' {relCaixa},
  MonolitoFinanceiro.View.Relatorios.ContasPagar in 'src\View\Relatorios\MonolitoFinanceiro.View.Relatorios.ContasPagar.pas' {relContasPagar},
  MonolitoFinanceiro.View.CadastrarAdmin in 'src\View\MonolitoFinanceiro.View.CadastrarAdmin.pas' {frmCadastrarAdmin};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TdmUsuarios, dmUsuarios);
  Application.CreateForm(TdmCaixa, dmCaixa);
  Application.CreateForm(TdmSistema, dmSistema);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCadastroPadrao, frmCadastroPadrao);
  Application.CreateForm(TfrmUsuarios, frmUsuarios);
  Application.CreateForm(TfrmCaixa, frmCaixa);
  Application.CreateForm(TfrmCaixaSaldo, frmCaixaSaldo);
  Application.CreateForm(TdmContasPagar, dmContasPagar);
  Application.CreateForm(TfrmContasPagar, frmContasPagar);
  Application.CreateForm(TdmContasReceber, dmContasReceber);
  Application.CreateForm(TfrmContasReceber, frmContasReceber);
  Application.CreateForm(TfrmContasReceberBaixar, frmContasReceberBaixar);
  Application.CreateForm(TfrmContasPagarBaixar, frmContasPagarBaixar);
  Application.CreateForm(TfrmContasPagarConsultar, frmContasPagarConsultar);
  Application.CreateForm(TfrmContasPagarDetalhes, frmContasPagarDetalhes);
  Application.CreateForm(TfrmContasReceberConsultar, frmContasReceberConsultar);
  Application.CreateForm(TfrmContasReceberDetalhes, frmContasReceberDetalhes);
  Application.CreateForm(TrelPadrao, relPadrao);
  Application.CreateForm(TrelUsuarios, relUsuarios);
  Application.CreateForm(TrelContasReceber, relContasReceber);
  Application.CreateForm(TrelPadraoAgrupado, relPadraoAgrupado);
  Application.CreateForm(TrelContasReceberDetalhado, relContasReceberDetalhado);
  Application.CreateForm(TfrmCaixaExtrato, frmCaixaExtrato);
  Application.CreateForm(TrelCaixaExtrato, relCaixaExtrato);
  Application.CreateForm(TrelCaixa, relCaixa);
  Application.CreateForm(TrelContasPagar, relContasPagar);
  Application.Run;
end.
