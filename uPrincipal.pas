unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FMX.Ani, FireDAC.Phys.SQLiteWrapper.Stat;

type
  Tfrm_Principal = class(TForm)
    edtSenha: TEdit;
    PasswordEditButton1: TPasswordEditButton;
    edtUsuario: TEdit;
    Image1: TImage;
    lblBoasVindas: TLabel;
    lblSenha: TLabel;
    lblUsuario: TLabel;
    FDQPrincipal: TFDQuery;
    FDConnection1: TFDConnection;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label1: TLabel;
    RectAnimation1: TRectAnimation;
    rt_acessar: TRectangle;
    Label2: TLabel;
    rt_cadastro: TRectangle;
    Label3: TLabel;
    procedure rt_acessarClick(Sender: TObject);
    procedure rt_cadastroClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;

implementation

{$R *.fmx}

uses uHome,
     uCadastro;

procedure Tfrm_Principal.rt_acessarClick(Sender: TObject);
begin
    if edtUsuario.Text = '' then
    begin
        ShowMessage('USUARIO INVALIDO');
        edtUsuario.SetFocus;
        exit;
    end;

    if edtSenha.Text = '' then
    begin
        ShowMessage('SENHA INVALIDA');
        edtSenha.SetFocus;
        exit;
    end;

    FDQPrincipal.Close;
    FDQPrincipal.SQL.Clear;
    FDQPrincipal.SQL.Add('select * from login ');

    FDQPrincipal.SQL.Add('where usuario like :usuario');
    FDQPrincipal.ParamByName('usuario').AsString := edtUsuario.Text;

    FDQPrincipal.SQL.Add('and senha like :senha');
    FDQPrincipal.ParamByName('senha').AsString := edtSenha.Text;

    FDQPrincipal.Open;

    if FDQPrincipal.RecordCount >= 1 then
      frmHome.Show
    else
      showmessage('LOGIN INVALIDO');
end;

procedure Tfrm_Principal.rt_cadastroClick(Sender: TObject);
begin
    frmCadastro.Show;
end;

end.
