unit uCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FMX.Objects,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TCadastro = record
    id : integer;
    usuario : string;
    senha : string;
  end;

type
  TfrmCadastro = class(TForm)
    edtSenha: TEdit;
    PasswordEditButton1: TPasswordEditButton;
    edtUsuario: TEdit;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    FDQCadastro: TFDQuery;
    FDConnection1: TFDConnection;
    Rectangle1: TRectangle;
    rt_gravarcadastrar: TRectangle;
    Label3: TLabel;
    Image1: TImage;
    function geraNovoCodigo:integer;
    procedure rt_gravarcadastrarClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.fmx}

function TfrmCadastro.geraNovoCodigo: integer;
begin
    FDQCadastro.SQL.Clear;
    FDQCadastro.SQL.Add('Select max(id)as m from login');
    FDQCadastro.Open();

    if FDQCadastro.FieldByName('m').AsString = '' then
    begin
        result := 1;
        exit;
    end;

    result := FDQCadastro.FieldByName('m').AsInteger + 1;
end;

procedure TfrmCadastro.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastro.rt_gravarcadastrarClick(Sender: TObject);
var
    cadastro:TCadastro;
begin
    cadastro.id := geraNovoCodigo;
    cadastro.usuario := edtUsuario.Text;
    cadastro.senha := edtSenha.Text;

    FDQCadastro.Close;
    FDQCadastro.SQL.Clear;
    FDQCadastro.SQL.Add('INSERT INTO LOGIN (ID, USUARIO, SENHA)');
    FDQCadastro.SQL.Add(' VALUES (:ID, :USUARIO, :SENHA)');
    FDQCadastro.ParamByName('id').AsInteger := cadastro.id;
    FDQCadastro.ParamByName('usuario').AsString := cadastro.usuario;
    FDQCadastro.ParamByName('senha').AsString := cadastro.senha;
    FDQCadastro.ExecSQL;

    ShowMessage('USUAROI CADASTRADO');

    Close;
end;

end.
