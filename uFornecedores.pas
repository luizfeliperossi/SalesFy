unit uFornecedores;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.ListView, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TFornecedor = record
    id:Integer;
    nome:String;
  end;

type
  Tfrm_fornecedores = class(TForm)
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    Layout1: TLayout;
    Label1: TLabel;
    Layout2: TLayout;
    edtPesquisa: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    tbInserir: TTabItem;
    Layout4: TLayout;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    edt_Nome: TEdit;
    Layout5: TLayout;
    tbEditar: TTabItem;
    Layout6: TLayout;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Layout7: TLayout;
    Label7: TLabel;
    edt_ID_edicao: TEdit;
    Label8: TLabel;
    edtNome: TEdit;
    FDConnection1: TFDConnection;
    FDQFornecedor: TFDQuery;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Label2: TLabel;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Layout8: TLayout;
    Rectangle6: TRectangle;
    Image1: TImage;
    rt_gravar: TRectangle;
    Label3: TLabel;
    edt_ID: TEdit;
    Label12: TLabel;
    Rectangle7: TRectangle;
    Rectangle8: TRectangle;
    rt_deletar: TRectangle;
    Label13: TLabel;
    rt_salvar: TRectangle;
    Label14: TLabel;
    Circle1: TCircle;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;

    function estoque(produto:integer):integer;
    procedure atualizaFornecedorBanco();
    procedure insereFornecedorLista(fornecedor: TFornecedor);
    procedure editaFornecedorNoBanco(fornecedor: TFornecedor);
    procedure deletaFornecedor(id_fornecedor: Integer);
    function buscarFornecedorBanco(id_fornecedor: integer): TFornecedor;
    procedure FDConnection1BeforeCommit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure inserirFornecedorNoBanco(fornecedor: TFornecedor);
    procedure ListView1ItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);

    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure rt_gravarClick(Sender: TObject);
    procedure rt_salvarClick(Sender: TObject);
    procedure rt_deletarClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_fornecedores: Tfrm_fornecedores;

implementation

{$R *.fmx}

uses uClientes, uPedidos;

procedure Tfrm_fornecedores.atualizaFornecedorBanco;
var vFornecedor : TFornecedor;
begin
  FDQFornecedor.Close;
  FDQFornecedor.SQL.Clear;
  FDQFornecedor.SQL.Add('SELECT * FROM FORNECEDORES');

  if edtPesquisa.Text <> '' then
  begin
    FDQFornecedor.SQL.Add('WHERE NOME LIKE :PESQUISA');
    FDQFornecedor.ParamByName('pesquisa').AsString := edtPesquisa.Text;
  end;

  FDQFornecedor.Open();
  FDQFornecedor.First;
  ListView1.Items.Clear;

  while not FDQFornecedor.Eof do
  begin
    vFornecedor.id := FDQFornecedor.FieldByName('id').AsInteger;
    vFornecedor.nome := FDQFornecedor.FieldByName('nome').AsString;

    insereFornecedorLista(vFornecedor);
    FDQFornecedor.Next;
  end;
end;

procedure Tfrm_fornecedores.insereFornecedorLista(fornecedor: TFornecedor);
begin
  with ListView1.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtID')).Text := IntToStr(fornecedor.id);
    TListItemText(Objects.FindDrawable('txtNome')).Text := fornecedor.nome;

    TListItemImage(Objects.FindDrawable('imgEditar')).Bitmap := Image1.Bitmap;
  end;
end;

procedure Tfrm_fornecedores.SpeedButton1Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure Tfrm_fornecedores.SpeedButton2Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure Tfrm_fornecedores.deletaFornecedor(id_fornecedor: Integer);
begin
  FDQFornecedor.Close;
  FDQFornecedor.SQL.Clear;
  FDQFornecedor.SQL.Add('DELETE FROM FORNECEDORES');
  FDQFornecedor.SQL.Add('WHERE ID = :id');

  FDQFornecedor.ParamByName('id').AsInteger := id_fornecedor;

  FDQFornecedor.ExecSQL;
end;

procedure Tfrm_fornecedores.editaFornecedorNoBanco(fornecedor: TFornecedor);
begin
  FDQFornecedor.Close;
  FDQFornecedor.SQL.Clear;
  FDQFornecedor.SQL.Add('UPDATE FORNECEDORES SET ');
  FDQFornecedor.SQL.Add('   nome = :nome ');
  FDQFornecedor.SQL.Add('WHERE ID = :ID');

  FDQFornecedor.ParamByName('id').AsInteger := fornecedor.id;
  FDQFornecedor.ParamByName('nome').AsString := fornecedor.nome;

  FDQFornecedor.ExecSQL;
end;

function Tfrm_fornecedores.estoque(produto: integer):integer;
begin
    FDQFornecedor.Close;
    FDQFornecedor.SQL.Add('Select estoque from produtos');
    FDQFornecedor.SQL.Add('where id = :id');
    FDQFornecedor.ParamByName('id').AsInteger := produto;

    result := FDQFornecedor.FieldByName('estoque').AsInteger;
end;

function Tfrm_fornecedores.buscarFornecedorBanco(id_fornecedor: integer): TFornecedor;
var vFornecedor: TFornecedor;
begin
  FDQFornecedor.Close;
  FDQFornecedor.SQL.Clear;
  FDQFornecedor.SQL.Add('SELECT * FROM FORNECEDORES ');
  FDQFornecedor.SQL.Add('WHERE ID = :ID');
  FDQFornecedor.ParamByName('id').AsInteger := id_fornecedor;

  FDQFornecedor.Open();

  vFornecedor.id := id_fornecedor;
  vFornecedor.nome := FDQFornecedor.FieldByName('nome').AsString;
  Result := vFornecedor;
end;

procedure Tfrm_fornecedores.FDConnection1BeforeCommit(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    FDConnection1.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco\banco-univel.db';
  {$ELSE}
    FDConnection1.Params.Values['Database'] := System.IOUtils.TPath.Combine(TPath.GetDocumentsPath, 'banco-univel.db');
  {$ENDIF}
end;

procedure Tfrm_fornecedores.FormShow(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure Tfrm_fornecedores.Image2Click(Sender: TObject);
begin
  frm_fornecedores.edt_ID.Text:='';
  frm_fornecedores.edt_Nome.Text:='';
  TabControl1.TabIndex := 1;
end;

procedure Tfrm_fornecedores.Image3Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_fornecedores.Image4Click(Sender: TObject);
begin
  atualizaFornecedorBanco;
end;

procedure Tfrm_fornecedores.inserirFornecedorNoBanco(fornecedor: TFornecedor);
begin
  FDQFornecedor.Close;
  FDQFornecedor.SQL.Clear;
  FDQFornecedor.SQL.Add('INSERT INTO FORNECEDORES (ID, NOME)');
  FDQFornecedor.SQL.Add(' VALUES (:ID, :NOME)');
  FDQFornecedor.ParamByName('id').AsInteger := fornecedor.id;
  FDQFornecedor.ParamByName('nome').AsString := fornecedor.nome;
  FDQFornecedor.ExecSQL;
end;

procedure Tfrm_fornecedores.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  id_fornecedor: Integer;
  vFornecedor: TFornecedor;
begin

  id_fornecedor:=1;

  if (ItemObject.Name = 'imgEditar') then
  begin
    edt_ID_edicao.Text := '';
    edtNome.Text:='';

    id_fornecedor := StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtID')).Text);
    vFornecedor := buscarFornecedorBanco(id_fornecedor);
    edt_ID_edicao.Text := IntToStr(vFornecedor.id);
    edtNome.Text := vFornecedor.nome;

    TabControl1.TabIndex := 2;
  end;
end;


procedure Tfrm_fornecedores.rt_deletarClick(Sender: TObject);
var id_fornecedor: integer;
begin
  id_fornecedor := StrToInt(edt_ID_edicao.Text);
  deletaFornecedor(id_fornecedor);
  ShowMessage('Produto deletado!');
  TabControl1.TabIndex := 0;
  atualizaFornecedorBanco
end;

procedure Tfrm_fornecedores.rt_gravarClick(Sender: TObject);
var vFornecedor: TFornecedor;
begin
  vFornecedor.id := StrToInt(edt_ID.Text);
  vFornecedor.nome := edt_nome.Text;

  insereFornecedorLista(vFornecedor);
  inserirFornecedorNoBanco(vFornecedor);
  ShowMessage('Produto adicionado!');
end;

procedure Tfrm_fornecedores.rt_salvarClick(Sender: TObject);
var vFornecedor : TFornecedor;
begin
  vFornecedor.id := StrToInt(edt_ID_edicao.Text);
  vFornecedor.nome := edtNome.Text;

  editaFornecedorNoBanco(vFornecedor);
  ShowMessage('Produto alterado');

  TabControl1.TabIndex := 0;
  atualizaFornecedorBanco;
end;

end.
