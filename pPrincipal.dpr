program pPrincipal;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {frm_Principal},
  uClientes in 'uClientes.pas' {frmClientes},
  uPedidos in 'uPedidos.pas' {Frm_Pedidos},
  uFornecedores in 'uFornecedores.pas' {frm_fornecedores},
  uHome in 'uHome.pas' {frmHome},
  uInformacoesPedido in 'uInformacoesPedido.pas' {frmInfoPedido},
  uCadastro in 'uCadastro.pas' {frmCadastro},
  uProdutos in 'uProdutos.pas' {frm_produtos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Principal, frm_Principal);
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.CreateForm(TFrm_Pedidos, Frm_Pedidos);
  Application.CreateForm(Tfrm_fornecedores, frm_fornecedores);
  Application.CreateForm(TfrmHome, frmHome);
  Application.CreateForm(TfrmInfoPedido, frmInfoPedido);
  Application.CreateForm(TfrmCadastro, frmCadastro);
  Application.CreateForm(Tfrm_produtos, frm_produtos);
  Application.Run;
end.
