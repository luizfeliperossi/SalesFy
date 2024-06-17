unit uProdutos;

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
  TProduto = record
    id, estoque: Integer;
    descricao: String;
    valor: Double;
    fornecedor:integer;
    nomeFornecedor:string;
  end;

type
  Tfrm_produtos = class(TForm)
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    Layout1: TLayout;
    btnVoltar: TSpeedButton;
    btnInserirProduto: TSpeedButton;
    Label1: TLabel;
    Layout2: TLayout;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    tbInserir: TTabItem;
    Layout4: TLayout;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    edt_nome: TEdit;
    Label5: TLabel;
    edt_QtdeEstoque: TEdit;
    Layout5: TLayout;
    tbEditar: TTabItem;
    Layout6: TLayout;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Layout7: TLayout;
    Label7: TLabel;
    edt_ID_edicao: TEdit;
    Label8: TLabel;
    edt_descricao_edicao: TEdit;
    Label9: TLabel;
    edt_estoque_edicao: TEdit;
    Label10: TLabel;
    edt_Valor: TEdit;
    Label11: TLabel;
    edt_valor_edicao: TEdit;
    FDConnection1: TFDConnection;
    FDQProdutos: TFDQuery;
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
    edtFornecedor: TEdit;
    Label15: TLabel;
    edtFornecedorEdicao: TEdit;
    Label16: TLabel;

    function estoque(produto:integer):integer;
    procedure atualizaProdutosBanco();
    procedure insereProdutonaLista(produto: TProduto);
    procedure editaProdutoNoBanco(produto: TProduto);
    procedure deletaProduto(id_produto: Integer);
    function buscarProdutonoBanco(id_produto : integer): TProduto;
    procedure FDConnection1BeforeCommit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure inserirProdutoNoBanco(produto: TProduto);
    procedure ListView1ItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);

    procedure btnVoltarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnInserirProdutoClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure rt_gravarClick(Sender: TObject);
    procedure rt_salvarClick(Sender: TObject);
    procedure rt_deletarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_produtos: Tfrm_produtos;

implementation

{$R *.fmx}

uses uClientes, uPedidos;

// Atualiza a lista de produtos na ListView
procedure Tfrm_produtos.atualizaProdutosBanco;
var vProduto : TProduto;
begin
  // SQL para consultar Produtos e Fornecedores
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('SELECT produtos.id,produtos.DESCRICAO,produtos.estoque,produtos.valor,fornecedores.id as id2,fornecedores.nome FROM PRODUTOS,FORNECEDORES');
  FDQProdutos.SQL.Add('WHERE PRODUTOS.ID_FORNECEDOR = FORNECEDORES.ID');

  // Verifica o que foi digitado e busca no BD
  if edtPesquisa.Text <> '' then
  begin
    FDQProdutos.SQL.Add('AND PRODUTOS.DESCRICAO LIKE :PESQUISA');
    FDQProdutos.ParamByName('pesquisa').AsString := edtPesquisa.Text;
  end;

  FDQProdutos.Open();
  FDQProdutos.First;
  ListView1.Items.Clear;

  while not FDQProdutos.Eof do
  begin
    // Preenche os campos do Produto
    vProduto.id := FDQProdutos.FieldByName('id').AsInteger;
    vProduto.descricao := FDQProdutos.FieldByName('descricao').AsString;
    vProduto.estoque := FDQProdutos.FieldByName('estoque').AsInteger;
    vProduto.valor := FDQProdutos.FieldByName('valor').AsFloat;
    vProduto.fornecedor := FDQProdutos.FieldByName('id2').AsInteger;
    vProduto.nomeFornecedor := FDQProdutos.FieldByName('nome').AsString;

    // Chama função de Add Produto na ListView
    insereProdutonaLista(vProduto);
    FDQProdutos.Next;
  end;
end;

// Insere um produto na ListView
procedure Tfrm_produtos.insereProdutonaLista(produto: TProduto);
begin
  with ListView1.Items.Add do
  begin
    // Define o texto dos subitens da ListView com os dados dos produtos
    TListItemText(Objects.FindDrawable('txtID')).Text := IntToStr(produto.id);
    TListItemText(Objects.FindDrawable('txtDescricao')).Text := produto.descricao;
    TListItemText(Objects.FindDrawable('txtEstoque')).Text := IntToStr(produto.estoque);
    TListItemText(Objects.FindDrawable('txtValor')).Text := FloatToStr(produto.valor);
    TListItemText(Objects.FindDrawable('txtFornecedor')).Text := produto.nomeFornecedor;
    TListItemImage(Objects.FindDrawable('imgEditar')).Bitmap := Image1.Bitmap;
  end;
end;

procedure Tfrm_produtos.SpeedButton1Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure Tfrm_produtos.SpeedButton2Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure Tfrm_produtos.btnInserirProdutoClick(Sender: TObject);
begin
  TabControl1.TabIndex := 1;
end;

// Exclui produto do BD pelo ID
procedure Tfrm_produtos.deletaProduto(id_produto: Integer);
begin
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;

  // SQL para excluir pelo ID
  FDQProdutos.SQL.Add('DELETE FROM PRODUTOS');
  FDQProdutos.SQL.Add('WHERE ID = :id');

  // Onde é definido o parametro do ID do produto
  FDQProdutos.ParamByName('id').AsInteger := id_produto;
  FDQProdutos.ExecSQL;
end;

// Edição de Produto no BD
procedure Tfrm_produtos.editaProdutoNoBanco(produto: TProduto);
begin
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;

  // SQL para att pelo ID
  FDQProdutos.SQL.Add('UPDATE PRODUTOS SET ');
  FDQProdutos.SQL.Add('   descricao = :descricao, ');
  FDQProdutos.SQL.Add('   estoque = :estoque, ');
  FDQProdutos.SQL.Add('   valor = :valor, ');
  FDQProdutos.SQL.Add('   id_fornecedor = :id_fornecedor');
  FDQProdutos.SQL.Add('WHERE ID = :ID');

  // Define os parametros do produto que será atualizado
  FDQProdutos.ParamByName('id').AsInteger := produto.id;
  FDQProdutos.ParamByName('descricao').AsString := produto.descricao;
  FDQProdutos.ParamByName('estoque').AsInteger := produto.estoque;
  FDQProdutos.ParamByName('valor').AsFloat := produto.valor;
  FDQProdutos.ParamByName('id_fornecedor').AsFloat := produto.fornecedor;

  FDQProdutos.ExecSQL;
end;

// Retorna o estoque via ID
function Tfrm_produtos.estoque(produto: integer):integer;
begin
    // SQL para selecionar o estoque o produto via ID
    FDQProdutos.Close;
    FDQProdutos.SQL.Add('Select estoque from produtos');
    FDQProdutos.SQL.Add('where id = :id');
    FDQProdutos.ParamByName('id').AsInteger := produto;

    result := FDQProdutos.FieldByName('estoque').AsInteger;
end;

// Chama função de mostrar produtos na ListView
procedure Tfrm_produtos.btnPesquisarClick(Sender: TObject);
begin
  atualizaProdutosBanco;
end;

procedure Tfrm_produtos.btnVoltarClick(Sender: TObject);
begin
  Close;
end;

// Busca de Produto no BD via ID
function Tfrm_produtos.buscarProdutonoBanco(id_produto : integer): TProduto;
var vProduto : TProduto;
begin
  // SQL busca produto pelo ID
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('SELECT * FROM PRODUTOS ');
  FDQProdutos.SQL.Add('WHERE ID = :ID');
  FDQProdutos.ParamByName('id').AsInteger := id_produto;

  FDQProdutos.Open();

  // Preenche o vProduto com os dados achados
  vProduto.id := id_produto;
  vProduto.descricao := FDQProdutos.FieldByName('descricao').AsString;
  vProduto.estoque := FDQProdutos.FieldByName('estoque').AsInteger;
  vProduto.valor := FDQProdutos.FieldByName('valor').AsFloat;
  Result := vProduto;
end;

procedure Tfrm_produtos.FDConnection1BeforeCommit(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    FDConnection1.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco\banco-univel.db';
  {$ELSE}
    FDConnection1.Params.Values['Database'] := System.IOUtils.TPath.Combine(TPath.GetDocumentsPath, 'banco-univel.db');
  {$ENDIF}
end;

procedure Tfrm_produtos.FormShow(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

// Adiciona um novo produto no BD
procedure Tfrm_produtos.inserirProdutoNoBanco(produto: TProduto);
begin

  // SQL para Add no BD
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('INSERT INTO PRODUTOS (ID, DESCRICAO, ESTOQUE, VALOR, ID_FORNECEDOR)');
  FDQProdutos.SQL.Add(' VALUES (:ID, :DESCRICAO, :ESTOQUE, :VALOR, :ID_FORNECEDOR)');

  // Define os parametros que serão passados como parametros
  FDQProdutos.ParamByName('id').AsInteger := produto.id;
  FDQProdutos.ParamByName('descricao').AsString := produto.descricao;
  FDQProdutos.ParamByName('estoque').AsInteger := produto.estoque;
  FDQProdutos.ParamByName('valor').AsFloat := produto.valor;
  FDQProdutos.ParamByName('id_fornecedor').AsInteger := produto.fornecedor;
  FDQProdutos.ExecSQL;
end;

// Evento de clicar em item na ListView
procedure Tfrm_produtos.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  id_produto: Integer;
  vProduto: TProduto;
begin
  // Definido como 1 por segurança
  id_produto := 1;

  if (ItemObject.Name = 'imgEditar') then
  begin
    // Limpa os campos de edição no form de edição
    edt_ID_edicao.Text := '';
    edt_descricao_edicao.Text := '';
    edt_estoque_edicao.Text := '';
    edt_valor_edicao.Text := '';
    edtFornecedorEdicao.Text := '';

    // Pega o ID do produto selecionado
    id_produto := StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtID')).Text);

    // Busca o produto no BD pelo ID
    vProduto := buscarProdutonoBanco(id_produto);

    // Preenche os campos de edição com os dados do produto
    edt_ID_edicao.Text := IntToStr(vProduto.id);
    edt_descricao_edicao.Text := vProduto.descricao;
    edt_estoque_edicao.Text := IntToStr(vProduto.estoque);
    edt_valor_edicao.Text := FloatToStr(vProduto.valor);
    edtFornecedorEdicao.Text := TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtFornecedor')).Text;

    // Aba de edição
    TabControl1.TabIndex := 2;
  end;
end;

// Botão de deletar produto
procedure Tfrm_produtos.rt_deletarClick(Sender: TObject);
var id_produto : integer;
begin
  // Pega o ID do Produto no campo de edição
  id_produto := StrToInt(edt_ID_edicao.Text);

  // Função de Deletar Produto
  deletaProduto(id_produto);
  ShowMessage('Produto deletado!');
  TabControl1.TabIndex := 0;

  // Atualiza a ListView
  atualizaProdutosBanco;
end;

// Botão de Add Produto
procedure Tfrm_produtos.rt_gravarClick(Sender: TObject);
var vProduto : TProduto;
begin
  // Campos com dados do novo Produto
  vProduto.id := StrToInt(edt_ID.Text);
  vProduto.descricao := edt_nome.Text;
  vProduto.estoque := StrToInt(edt_QtdeEstoque.Text);
  vProduto.valor := StrToFloat(edt_Valor.Text);
  vProduto.fornecedor := StrToInt(edtFornecedor.Text);

  // Add na ListView
  insereProdutonaLista(vProduto);

  // Add no BD
  inserirProdutoNoBanco(vProduto);
  ShowMessage('Produto adicionado!');
end;

// Salvar edição de Produto
procedure Tfrm_produtos.rt_salvarClick(Sender: TObject);
var vProduto : TProduto;
begin
  // Campos com dados do produto editado
  vProduto.id := StrToInt(edt_ID_edicao.Text);
  vProduto.descricao := edt_descricao_edicao.Text;
  vProduto.estoque := StrToInt(edt_estoque_edicao.Text);
  vProduto.valor := StrToFloat(edt_valor_edicao.Text);
  vProduto.fornecedor := StrToInt(edtFornecedorEdicao.Text);

  // Att produto no BD
  editaProdutoNoBanco(vProduto);
  ShowMessage('Produto alterado');

  TabControl1.TabIndex := 0;

  // Att na ListView
  atualizaProdutosBanco;
end;

end.
