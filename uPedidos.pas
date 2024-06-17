unit uPedidos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.ListView, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
  FMX.TabControl, Data.DB, FireDAC.Comp.Client, FMX.Objects, FMX.DateTimeCtrls,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FMX.Memo.Types, FMX.ListBox, FMX.ScrollBox, FMX.Memo, IOUtils, System.Generics.Collections,
  System.Actions, FMX.ActnList, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TCliente = record
    codigo : Integer;
    nome : string;
  end;

  TProduto = record
    codigo  : Integer;
    nome : string;
    valorUnit, qtde, vTotal : Float32;
  end;

  TPedido = record
    id, id_cliente, id_formapgto : Integer;
    nome_cliente, forma_pgto : string;
    data_pedido : TDate;
    valor_total : Float32;
  end;

  TFrm_Pedidos = class(TForm)
    Image1: TImage;
    Image2: TImage;
    ImageControl1: TImageControl;
    imgCliente: TImage;
    FDConnection1: TFDConnection;
    TabControl1: TTabControl;
    tbConsultarPedidos: TTabItem;
    Layout1: TLayout;
    Label1: TLabel;
    Layout2: TLayout;
    edtPesquisa: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    tbInserePedido: TTabItem;
    Layout4: TLayout;
    Label2: TLabel;
    Layout5: TLayout;
    edt_data: TDateEdit;
    FDQuery1: TFDQuery;
    Layout8: TLayout;
    Image3: TImage;
    TabControl2: TTabControl;
    tbCliente: TTabItem;
    tbProdutos: TTabItem;
    tbPgto: TTabItem;
    Layout6: TLayout;
    Layout7: TLayout;
    edtDataPedido: TDateEdit;
    Memo1: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Layout9: TLayout;
    edtCliente: TEdit;
    SpeedButton2: TSpeedButton;
    Layout10: TLayout;
    Layout11: TLayout;
    lvProdutosPedido: TListView;
    Layout12: TLayout;
    Label6: TLabel;
    Layout13: TLayout;
    Label7: TLabel;
    ComboBoxFormasPgto: TComboBox;
    StyleBook1: TStyleBook;
    Label8: TLabel;
    tbListaProdutos: TTabItem;
    ListBox1: TListBox;
    edtPesquisaItemPedido: TEdit;
    Layout14: TLayout;
    Label9: TLabel;
    Button2: TButton;
    ActionList1: TActionList;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    rt_salvarPedido: TRectangle;
    Label10: TLabel;
    Rectangle4: TRectangle;
    rt_addProduto: TRectangle;
    Label11: TLabel;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    Rectangle8: TRectangle;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    function geraCodigoPedido:integer;
    function geraCodigoItemPedido:integer;
    function ajustaEstoque(qtde:double;id_produto:integer): double;
    procedure atualizaEstoque(id_produto:integer;qtde:double);
    procedure atualizaPedidosBanco();
    procedure inserePedidoNaLista(pedido : TPedido);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure inserirProdutonoVetor(produto: TProduto);
    procedure Button2Click(Sender: TObject);
    procedure rt_salvarPedidoClick(Sender: TObject);
    procedure rt_addProdutoClick(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);

  private
    procedure atualizarListBox;
    procedure inserirItemListBox(id_produto, estoque: integer;
      nome_produto: string; valor: double);
    procedure consultarProdutosBanco;
    procedure inserirProdutosnoPedido(id_produto: integer; nome: string; qtde,
      valorunit: double);
    procedure inserePedidonoBanco;
    { Private declarations }
  public
    { Public declarations }
    idClientePedido : Integer;
    nomeClientePedido : string;

    vProdutosPedido : Array of TProduto;

  end;

var
  Frm_Pedidos: TFrm_Pedidos;

implementation

{$R *.fmx}

uses uClientes, uProdutosFrame, uInformacoesPedido;


function TFrm_Pedidos.ajustaEstoque(qtde:double;id_produto:integer): double;
begin
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('Select * from produtos');
    FDQuery1.SQL.Add('where id = :id_produto');
    FDQuery1.ParamByName('id_produto').AsInteger := id_produto;
    FDQuery1.Open;

    if qtde > FDQuery1.FieldByName('estoque').AsInteger then
      result := FDQuery1.FieldByName('estoque').AsFloat
    else
        result := qtde;
end;

procedure TFrm_Pedidos.atualizaEstoque(id_produto: integer; qtde: double);
var
    t:double;
begin
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('Select * from produtos');
    FDQuery1.SQL.Add('where id = :id_produto');
    FDQuery1.ParamByName('id_produto').AsInteger := id_produto;
    FDQuery1.Open;

    t:=0;
    t:=FDQuery1.FieldByName('estoque').AsFloat - qtde;

    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('update produtos set');
    FDQuery1.SQL.Add('estoque = :qtde');

    FDQuery1.ParamByName('qtde').AsFloat := t;

    FDQuery1.SQL.Add('where id = :id_produto');
    FDQuery1.ParamByName('id_produto').AsInteger := id_produto;
    FDQuery1.ExecSQL;

end;

procedure TFrm_Pedidos.atualizaPedidosBanco;
var vPedido : TPedido;
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT PEDIDO.ID, ');
  FDQuery1.SQL.Add('       PEDIDO.DATA, ');
  FDQuery1.SQL.Add('       PEDIDO.ID_CLIENTE, ');
  FDQuery1.SQL.Add('       CLIENTES.NOME, ');
  FDQuery1.SQL.Add('       PEDIDO.VALOR_TOTAL, ');
  FDQuery1.SQL.Add('       FORMAPGTO.ID AS ID_FORMAPGTO, ');
  FDQuery1.SQL.Add('       FORMAPGTO.DESCRICAO ');
  FDQuery1.SQL.Add('FROM   PEDIDO');
  FDQuery1.SQL.Add('  INNER JOIN CLIENTES');
  FDQuery1.SQL.Add('   ON CLIENTES.CODIGO = PEDIDO.ID_CLIENTE ');
  FDQuery1.SQL.Add('  INNER JOIN FORMAPGTO');
  FDQuery1.SQL.Add('   ON FORMAPGTO.ID = PEDIDO.ID_FORMAPGTO');
  FDQuery1.SQL.Add('where  pedido.data = :data ');

  FDQuery1.ParamByName('data').AsDate := edt_data.Date;

  FDQuery1.Open();

  ListView1.Items.Clear;

  while not FDQuery1.Eof do
  begin
    vPedido.id := FDQuery1.FieldByName('id').AsInteger;
    vPedido.data_pedido := FDQuery1.FieldByName('data').AsDateTime;
    vPedido.id_cliente := FDQuery1.FieldByName('ID_CLIENTE').AsInteger;
    vPedido.nome_cliente := FDQuery1.FieldByName('NOME').AsString;
    vPedido.id_formapgto := FDQuery1.FieldByName('ID_FORMAPGTO').AsInteger;
    vPedido.forma_pgto := FDQuery1.FieldByName('DESCRICAO').AsString;
    vPedido.valor_total := FDQuery1.FieldByName('valor_total').AsFloat;
    inserePedidoNaLista(vPedido);
    FDQuery1.Next;
  end;

end;

procedure TFrm_Pedidos.inserirItemListBox(id_produto,estoque : integer; nome_produto:string; valor:double);
var item : TListBoxItem;
    form : TFrmListaProdutos;
begin

  item := TListBoxItem.Create(ListBox1);
  item.Height := 68;
  item.Tag := id_produto;

  form := TFrmListaProdutos.Create(item);
  form.Align := TAlignLayout.Client;
  form.lblNome.Text := nome_produto;
  form.lblCodigo.Text := IntToStr(id_produto);
  form.lblValor.Text := FloatToStr(valor);
  item.AddObject(form);
  ListBox1.AddObject(item);

end;

procedure TFrm_Pedidos.consultarProdutosBanco();
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from produtos');
  FDQuery1.Open();
end;

procedure TFrm_Pedidos.atualizarListBox();
begin
  consultarProdutosBanco();

  while not FDQuery1.Eof do
  begin
    inserirItemListBox(FDQuery1.FieldByName('id').AsInteger,
                      FDQuery1.FieldByName('estoque').AsInteger,
                      FDQuery1.FieldByName('descricao').AsString,
                      FDQuery1.FieldByName('valor').AsFloat);

    FDQuery1.Next;
  end;
end;

procedure TFrm_Pedidos.inserePedidonoBanco();
var
  totalPedido: Float32;
  i: Integer;
  codigo_pedido:integer;
  codigoItem:integer;
begin
  totalPedido := 0;

  for i := 0 to Length(vProdutosPedido) - 1 do
  begin
    totalPedido := totalPedido + (vProdutosPedido[i].qtde * vProdutosPedido[i].valorUnit);
  end;

  codigo_pedido := geraCodigoPedido;

  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('insert into pedido (id, data, id_cliente, valor_total, id_formapgto)');
  FDQuery1.SQL.Add('values (:id, :data, :id_cliente, :valor_total, :id_formapgto)');

  FDQuery1.ParamByName('id').AsInteger := codigo_pedido;
  FDQuery1.ParamByName('data').AsDate := edtDataPedido.Date;
  FDQuery1.ParamByName('id_cliente').AsInteger := idClientePedido;
  FDQuery1.ParamByName('valor_total').AsFloat := totalPedido;
  FDQuery1.ParamByName('id_formapgto').AsFloat := 1;

  FDQuery1.ExecSQL;

  i := 0;
  while i < Length(vProdutosPedido) do
  begin
      //FDQuery1.Params.Clear;

      atualizaEstoque(vProdutosPedido[i].codigo,vProdutosPedido[i].qtde);

      codigoItem := geraCodigoItemPedido;

      //FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('insert into pedidos_prod (id, id_produto, valor_unit, qtde, valor_total, id_pedido)');
      FDQuery1.SQL.Add('values (:id, :id_produto, :valor_unit, :qtde, :valor_total, :id_pedido)');

      FDQuery1.ParamByName('id').AsInteger := codigoItem;
      FDQuery1.ParamByName('id_produto').AsInteger := vProdutosPedido[i].codigo;
      FDQuery1.ParamByName('valor_unit').AsFloat := vProdutosPedido[i].valorUnit;
      FDQuery1.ParamByName('qtde').AsFloat := vProdutosPedido[i].qtde;
      FDQuery1.ParamByName('valor_total').AsFloat := vProdutosPedido[i].vTotal;
      FDQuery1.ParamByName('id_pedido').AsInteger := codigo_pedido;

      FDQuery1.ExecSQL;

      inc(i);
  end;

end;


procedure TFrm_Pedidos.Button2Click(Sender: TObject);
var
  i : Integer;
  total:real;
begin
  i := 0;
  total := 0;
  lvProdutosPedido.Items.Clear;

  while i < Length(vProdutosPedido) do
  begin
    total := total + vProdutosPedido[i].vTotal;
    inserirProdutosnoPedido(vProdutosPedido[i].codigo, vProdutosPedido[i].nome,
                            vProdutosPedido[i].qtde , vProdutosPedido[i].valorUnit);

    inc(i);
  end;
  Label6.Text := 'Valor Total : '+FormatFloat('0.00',total);
  TabControl1.TabIndex := 1;
end;

procedure TFrm_Pedidos.inserirProdutosnoPedido(id_produto: integer; nome : string; qtde, valorunit : double);
begin

  if qtde > 0 then
    with lvProdutosPedido.Items.Add do
    begin
      qtde := ajustaEstoque(qtde,id_produto);

      TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(id_produto);
      TListItemText(Objects.FindDrawable('txtNome')).Text := nome;
      TListItemText(Objects.FindDrawable('txtValorUnit')).Text := FloatToStr(valorunit);
      TListItemText(Objects.FindDrawable('txtQtde')).Text := FloatToStr(qtde);
    end;
end;


procedure TFrm_Pedidos.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  id_produto: Integer;
  vProduto: TProduto;
  id:integer;
begin

  id_produto:=1;

  if (ItemObject.Name = 'imgEditar') then
  begin

      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('Select pedido.data,pedido.valor_total,formapgto.descricao from pedido,pedidos_prod,formapgto');
      FDQuery1.SQL.Add('where pedidos_prod.id_pedido = pedido.id');
      FDQuery1.SQL.Add('and pedido.id_formapgto = formapgto.id');
      FDQuery1.SQL.Add('and pedido.ID = :id');

      id := StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtId')).Text);

      FDQuery1.ParamByName('id').AsInteger := id;

      FDQuery1.Open();

      frmInfoPedido.edtData.Text:='';
      frmInfoPedido.edt_formaPagamento.Text:='';
      frmInfoPedido.edtValorTotal.Text:='';
      frmInfoPedido.Memo1.Text:='';

      frmInfoPedido.edtData.Text := FDQuery1.FieldByName('data').AsString;
      frmInfoPedido.edt_formaPagamento.Text := FDQuery1.FieldByName('data').AsString;
      frmInfoPedido.edtValorTotal.Text := FDQuery1.FieldByName('valor_total').AsString;

      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('select produtos.DESCRICAO,PEDIDOS_PROD.QTDE,PEDIDOS_PROD.VALOR_TOTAL from pedidos_prod,produtos');
      FDQuery1.SQL.Add('where pedidos_prod.id_pedido = :id');
      FDQuery1.SQL.Add('and pedidos_prod.ID_PRODUTO = produtos.id');

      FDQuery1.ParamByName('id').AsInteger := id;

      FDQuery1.Open();

      Frm_Pedidos.Memo1.Text := '';

      while not FDQuery1.Eof do
      begin
        frmInfoPedido.Memo1.Lines.Add(FDQuery1.FieldByName('DESCRICAO').AsString+'/ '+
                                    FDQuery1.FieldByName('QTDE').AsString+'/ '+
                                    FDQuery1.FieldByName('VALOR_TOTAL').AsString);

        FDQuery1.Next;
      end;

      frmInfoPedido.Show;

    {edt_ID_edicao.Text := '';
    edt_descricao_edicao.Text := '';
    edt_estoque_edicao.Text := '';
    edt_valor_edicao.Text := '';

    id_produto := StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtID')).Text);
    vProduto := buscarProdutonoBanco(id_produto);
    edt_ID_edicao.Text := IntToStr(vProduto.id);
    edt_descricao_edicao.Text := vProduto.descricao;
    edt_estoque_edicao.Text := IntToStr(vProduto.estoque);
    edt_valor_edicao.Text := FloatToStr(vProduto.valor);
    TabControl1.TabIndex := 2;}
    //estoque(StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtID')).Text)).ToString;
  end;
end;

procedure TFrm_Pedidos.rt_addProdutoClick(Sender: TObject);
begin
    TabControl1.TabIndex := 2;
end;

procedure TFrm_Pedidos.rt_salvarPedidoClick(Sender: TObject);
begin
    inserePedidonoBanco;
    ShowMessage('Pedido realizado com sucesso');
end;

procedure TFrm_Pedidos.FDConnection1BeforeConnect(Sender: TObject);
begin
  //{$IFDEF MSWINDOWS}
  //  FDConnection1.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco\banco-univel';
  //{$ELSE}
  //  FDConnection1.Params.Values['Database'] := System.IOUtils.TPath.Combine(TPath.GetDocumentsPath, 'banco-univel.db');
  //{$ENDIF}
end;

procedure TFrm_Pedidos.inserirProdutonoVetor(produto : TProduto);
var i : integer;
    achou : boolean;
begin

  i := 0;
  achou := false;

  if Length(vProdutosPedido) = 0 then
  begin
    SetLength(vProdutosPedido, Length(vProdutosPedido) + 1);

    vProdutosPedido[Length(vProdutosPedido) - 1].codigo := produto.codigo;
    vProdutosPedido[Length(vProdutosPedido) - 1].nome := produto.nome;
    vProdutosPedido[Length(vProdutosPedido) - 1].qtde := produto.qtde;
    vProdutosPedido[Length(vProdutosPedido) - 1].valorUnit := produto.valorUnit;
    vProdutosPedido[Length(vProdutosPedido) - 1].vTotal := produto.qtde * produto.valorUnit;
  end
  else
  begin

    while i < Length(vProdutosPedido) do
    begin

      if vProdutosPedido[i].codigo = produto.codigo then
      begin
        vProdutosPedido[i].codigo := produto.codigo;
        vProdutosPedido[i].nome := produto.nome;
        vProdutosPedido[i].qtde := produto.qtde;
        vProdutosPedido[i].valorUnit := produto.valorUnit;
        vProdutosPedido[i].vTotal := produto.qtde * produto.valorUnit;
        achou := true;
      end;
      inc(i);
    end;

    if not achou then
    begin
      SetLength(vProdutosPedido, Length(vProdutosPedido) + 1);

      vProdutosPedido[Length(vProdutosPedido) - 1].codigo := produto.codigo;
      vProdutosPedido[Length(vProdutosPedido) - 1].nome := produto.nome;
      vProdutosPedido[Length(vProdutosPedido) - 1].qtde := produto.qtde;
      vProdutosPedido[Length(vProdutosPedido) - 1].valorUnit := produto.valorUnit;
      vProdutosPedido[Length(vProdutosPedido) - 1].vTotal := produto.qtde * produto.valorUnit;
    end;
  end;

end;


procedure TFrm_Pedidos.FormShow(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
  edt_data.Date := Date;
  edtDataPedido.Date := Date;
end;

function TFrm_Pedidos.geraCodigoItemPedido: integer;
begin
    FDQuery1.SQL.Clear ;
    FDQuery1.SQL.Add('Select max(id) as m from pedidos_prod');
    FDQuery1.Open();

    if FDQuery1.FieldByName('m').AsString = '' then
    begin
        result := 1;
        exit;
    end;

    result := FDQuery1.FieldByName('m').AsInteger+1;
end;

function TFrm_Pedidos.geraCodigoPedido: integer;
begin
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('Select max(id) as m from pedido');
    FDQuery1.Open();

    if FDQuery1.FieldByName('m').AsString = '' then
    begin
        result := 1;
        exit;
    end;

    result := FDQuery1.FieldByName('m').AsInteger+1;
end;

procedure TFrm_Pedidos.Image4Click(Sender: TObject);
begin
  Frm_Pedidos.Close;
end;

procedure TFrm_Pedidos.Image5Click(Sender: TObject);
begin
  TabControl1.TabIndex := 1;
end;

procedure TFrm_Pedidos.Image6Click(Sender: TObject);
begin
  atualizaPedidosBanco;
end;

procedure TFrm_Pedidos.Image7Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure TFrm_Pedidos.Image8Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure TFrm_Pedidos.Image9Click(Sender: TObject);
begin
  atualizarListBox();
end;

procedure TFrm_Pedidos.inserePedidoNaLista(pedido: TPedido);
begin
  with ListView1.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtId')).Text := IntToStr(pedido.id);
    TListItemText(Objects.FindDrawable('txtNome')).Text := pedido.nome_cliente;
    TListItemText(Objects.FindDrawable('txtData')).Text := DateToStr(pedido.data_pedido);
    TListItemText(Objects.FindDrawable('txtValor')).Text := FloatToStr(pedido.valor_total);
    TListItemImage(Objects.FindDrawable('imgEditar')).Bitmap := Image3.Bitmap;
  end;

end;

procedure TFrm_Pedidos.SpeedButton2Click(Sender: TObject);
begin
  if not Assigned(frmClientes) then
  frmClientes := TfrmClientes.Create(self);
  frmClientes.atravesPedido := true;
  frmClientes.ShowModal;
  edtCliente.Text := nomeClientePedido;

end;

end.
