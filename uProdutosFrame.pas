unit uProdutosFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TFrmListaProdutos = class(TFrame)
    edtQtde: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    lblNome: TLabel;
    lblCodigo: TLabel;
    lblValor: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uPedidos;

// Botão de Diminuir qtde de Produtos
procedure TFrmListaProdutos.SpeedButton1Click(Sender: TObject);
var
  qtde : Float64;
  produto : TProduto;
begin
  // Converte o texto e armazena em qtde
  qtde := StrToFloat(edtQtde.Text);

  // Verifica se a qtde > 0, diminui 1, se ñ, define 0
  // Garante que a qtde nunca seja menor que 0
  if qtde > 0 then
    qtde := qtde-1
  else
    qtde := 0;

  // Atualiza o texto da qtde
  edtQtde.Text := qtde.ToString;

  // Onde preenche os campos do produto
  produto.codigo := StrToInt(lblCodigo.Text);
  produto.nome := lblNome.Text;
  produto.valorUnit := StrToFloat(lblValor.Text);
  produto.qtde :=  qtde;
  Frm_Pedidos.inserirProdutonoVetor(produto);
end;

// Botão de Add qtde de Produtos
procedure TFrmListaProdutos.SpeedButton2Click(Sender: TObject);
var
  qtde: Float64;
  produto: TProduto;
begin
  // Converte o texto e armazena em qtde
  qtde := StrToFloat(edtQtde.Text);

  qtde := qtde + 1;

  // Atualiza o texto da edtQtde com o novo valor de qtde
  edtQtde.Text := qtde.ToString;

  // Preenche os campos do produto com os valores
  produto.codigo := StrToInt(lblCodigo.Text);
  produto.nome := lblNome.Text;
  produto.valorUnit := StrToFloat(lblValor.Text);
  produto.qtde := qtde;

  // Insere o produto no vetor de produtos em uPedidos
  Frm_Pedidos.inserirProdutonoVetor(produto);
end;


end.
