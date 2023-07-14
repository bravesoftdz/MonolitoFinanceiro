unit MonolitoFinanceiro.Entidades.Usuario;

interface

type
  TModelEntidadeUsuario = class
  private
    FLogin: String;
    FNome: String;
    FID: String;
    FSenha: String;
    FSenhaTemporaria: Boolean;
    FAdministrador: String;
    procedure SetNome(const Value: string);
    procedure SetLogin (const Value: String);
    procedure SetID(const Value: String);
    procedure SetSenha(const Value: String);
    procedure SetSenhaTemporaria(const Value: Boolean);
    procedure SetAdministrador(const Value: Boolean);
  public
    property Nome: String read FNome write FNome;
    property Login: String read FLogin write FLogin;
    property ID: String read FID write FID;
    property Senha: String read FSenha write FSenha;
    property SenhaTemporaria: Boolean read FSenhaTemporaria write FSenhaTemporaria;
    property Administrador: Boolean read FSenhaTemporaria write SetAdministrador;
  end;

implementation

{ TModelEntidadeUsuario }

procedure TModelEntidadeUsuario.SetAdministrador(const Value: Boolean);
begin
  FSenhaTemporaria := Value;
end;

procedure TModelEntidadeUsuario.SetID(const Value: String);
begin
  FID := Value;
end;

procedure TModelEntidadeUsuario.SetLogin(const Value: String);
begin
  FLogin := Value;
end;

procedure TModelEntidadeUsuario.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TModelEntidadeUsuario.SetSenha(const Value: String);
begin
  FSenha := Value;
end;

procedure TModelEntidadeUsuario.SetSenhaTemporaria(const Value: Boolean);
begin
  FSenhaTemporaria := Value;
end;

end.
