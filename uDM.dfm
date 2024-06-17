object DM: TDM
  OnCreate = DataModuleCreate
  Height = 242
  Width = 320
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:/SalesFy/Banco/banco-univel'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    Left = 115
    Top = 38
  end
end
