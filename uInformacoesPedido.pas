unit uInformacoesPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FMX.Objects, FMX.ScrollBox,
  FMX.Memo, FMX.Layouts, FMX.Memo.Types, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TCadastro = record
    id : integer;
    usuario : string;
    senha : string;
  end;

type
  TfrmInfoPedido = class(TForm)
    edtData: TEdit;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    FDQCadastro: TFDQuery;
    FDConnection1: TFDConnection;
    Rectangle1: TRectangle;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    edtValorTotal: TEdit;
    edt_formaPagamento: TEdit;
    Layout1: TLayout;
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInfoPedido: TfrmInfoPedido;

implementation

{$R *.fmx}

// Botão para fechar form
procedure TfrmInfoPedido.Image1Click(Sender: TObject);
begin
  Close;
end;

end.
