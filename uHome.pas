unit uHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TfrmHome = class(TForm)
    Label1: TLabel;
    rt_fundo: TRectangle;
    Image1: TImage;
    rt_produtos: TRectangle;
    Label2: TLabel;
    rt_clientes: TRectangle;
    Label3: TLabel;
    rt_pedidos: TRectangle;
    Label4: TLabel;
    rt_fornecedores: TRectangle;
    Label5: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    procedure rt_produtosClick(Sender: TObject);
    procedure rt_clientesClick(Sender: TObject);
    procedure rt_pedidosClick(Sender: TObject);
    procedure rt_fornecedoresClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHome: TfrmHome;

implementation

{$R *.fmx}

uses uClientes, uPedidos, uProdutos, uFornecedores;

procedure TfrmHome.rt_clientesClick(Sender: TObject);
begin
    frmClientes.Show;
end;

procedure TfrmHome.rt_fornecedoresClick(Sender: TObject);
begin
    frm_fornecedores.Show;
end;

procedure TfrmHome.rt_pedidosClick(Sender: TObject);
begin
    // Limpar campos
    Frm_Pedidos.edtCliente.Text:='';
    Frm_Pedidos.Memo1.Text:='';
    Frm_Pedidos.ListView1.Items.Clear;
    Frm_Pedidos.lvProdutosPedido.Items.Clear;

    // Chama Form
    Frm_Pedidos.Show;
end;

procedure TfrmHome.rt_produtosClick(Sender: TObject);
begin
    frm_produtos.Show;
end;

end.
