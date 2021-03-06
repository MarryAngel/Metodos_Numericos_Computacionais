unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioButtonQualquerClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public
    { public declarations }
    function VerificaDados(k: Byte): Boolean;
    procedure DesenhaGrafico(k: Byte);
    procedure DesenhaRaiz;
    procedure Derivada;
    procedure UniformeSepara;
    procedure Uniforme;
    procedure Bissecao;
    procedure Cordas;
    procedure CordasModificado;
    procedure Newton;
    procedure NewtonModificado;
  end;

var
  Form1: TForm1;

implementation
uses
  Grafico, Windows, LCLIntf;            //para usar rotinas GetSystemMetrics e OpenDocument
{$R *.lfm}
var
  Metodo: Byte;
  f: string;
  a, b, Delta, Epsilon: Extended;
  //p, q, f_p, f_q: Extended;           //pode ser que use
  Raiz, f_Raiz: Extended;
  //Sinal1, Sinal2, Iteracao: Integer;  //pode ser que use
  //EncontrouRaiz: Boolean;             //pode ser que use
  //ResultadoFxR1: Word                 //pode ser que use
  VerIteracoes, VerGrafico, Interrompe: Boolean;

function FxR1(f: String; x: Extended; var y: Extended): Word; stdcall; external 'Interpretador.dll';

function TForm1.VerificaDados(k: Byte): Boolean;
begin
  //Parte superior da f??rma (k=1 => Gr??fico e k=2 => Separa????o)
  if (k=1) then       //Verifica entrada de dados para o gr??fico (f, a, b)
  begin
    Result:=False;
    f:=Trim(Edit1.Text);
    if (f='') then
    begin
      ShowMessage('Informe uma fun????o.');
      Edit1.SetFocus;
      Exit;
    end;
    try
      a:=StrToFloat(Edit2.Text);
    except
      ShowMessage('Valor de a incorreto.');
      Edit2.SetFocus;
      Exit;
    end;
    try
      b:=StrToFloat(Edit3.Text);
    except
      ShowMessage('Valor de b incorreto.');
      Edit3.SetFocus;
      Exit;
    end;
    if b<=a then
    begin
      ShowMessage('Valor de b deve ser maior que valor de a');
      Edit3.SetFocus;
      Exit;
    end;
    //Se passou por tudo e k=1 => f, a, b est??o corretos
    Result:=True;
    Exit;
  end;

  if k=2 then       //Verificar f, a, b anterior e Delta
  begin
    Result:=False;
    if not VerificaDados(1) then
       Exit;
    try
      Delta:=StrToFloat(Edit4.Text);
    except
      ShowMessage('Valor de Delta incorreto');
      Edit4.SetFocus;
      Exit;
    end;
    if ( (Delta-(b-a)/1000) < 0 ) or ((Delta-(b-a)/20) > 1E-10) then
    begin
      ShowMessage('O menor valor admiss??vel para Delta ?? (b-a)/1000 (1000 avalia????es da fun????o).'+#10#10+
                  'O maior valor admiss??vel para Delta ?? (b-a)/20 (20 avalia????es da fun????o).');
      Edit4.SetFocus;
      Exit;
    end;
    //Se passou por tudo e k=2 => f, a, b, Delta est??o corretos
    Result:=True;
  end;

  //Parte inferior da f??rma (k=3 => Gr??fico e k=4 => Raiz)
  if (k=3) then       //Verifica entrada de dados para gr??fico (f, a, b)
  begin
    Result:=False;
    f:=Trim(Edit5.Text);
    if (f='') then
    begin
      ShowMessage('Informe uma fun????o.');
      Edit5.SetFocus;
      Exit;
    end;
    try
      a:=StrToFloat(Edit6.Text);
    except
      ShowMessage('Valor de a incorreto!');
      Edit6.SetFocus;
      Exit;
    end;
    try
      b:=StrToFloat(Edit7.Text);
    except
      ShowMessage('Valor de b incorreto.');
      Edit7.SetFocus;
      Exit;
    end;
    if b<=a then
    begin
      ShowMessage('Valor de b deve ser maior que valor de a.');
      Edit7.SetFocus;
      Exit;
    end;
    //Se passou por tudo e k=3 => f, a, b est??o corretos
    Result:=True;
    Exit;
  end;

  if k=4 then       //Verifica f, a, b anteriores e Epsilon
  begin
    Result:=False;
    if not VerificaDados(3) then
       Exit;
    try
      Epsilon:=StrToFloat(Edit8.Text);
    except
      ShowMessage('Valor de Epsilon incorreto.');
      Edit8.SetFocus;
      Exit;
    end;
    if (Epsilon-(b-a)/20) > 1E-10 then
    begin
      ShowMessage('O m??ximo admiss??vel para Epsilon ?? (b-a)/20.');
      Edit4.SetFocus;
      Exit;
    end;
    //Se passou por tudo e k=4 => f, a, b, Epsilon est??o corretos
    Result:=True;
  end;
end;

procedure TForm1.DesenhaGrafico(k: Byte);
var
  i: Integer;
  x, y: Extended;
begin
  //Desenhando o gr??fico de uma fun????o
  //Existem dados necess??rios para desenhar o gr??fico?
  //Gr??fico da parte superior (separa????o das ra??zes)
  if k=1 then
     if not VerificaDados(1) then
        Exit;
  //Gr??fico da parte inferior (c??lculo de uma raiz)
  if k=2 then
     if not VerificaDados(3) then
        Exit;
  with Form2 do
  begin
    Chart1LineSeries1.Clear;
    Chart1.Title.Text[0]:='Gr??fico da fun????o'+f;
    Delta:=(b-a)/1000;
    for i:=0 to 1000 do
    begin
      try
        x:=a+i*Delta;
        FxR1(f, x, y);
        Chart1LineSeries1.AddXY(x, y, '');
      except
        Exit;
      end;
    end;
  end;
end;

procedure TForm1.DesenhaRaiz;
begin
  //Desenhando a raiz de uma fun????o
  with Form2 do
  begin
    ChartLineSeries2.Clear;
    ChartLineSeries2.AddXY(Raiz, f_Raiz, '');
  end;
end;

procedure TForm1.Derivada;
begin
  //Calcular derivada requerida nos M??todos de Newton (pode ser procedure ou function)
end;

procedure TForm1.UniformeSepara;
var
  i, j: Integer;
  p, q, f_p, f_q: Extended;
  Erro: Word;
begin
  //M??todo da busca uniforme para separar ra??zes
  Interrompe:=False;         //Utilizado para controlar o bot??o do p??nico
  with StringGrid1 do
  begin
    ColCount:=9;
    for i:=1 to ColCount-1 do
    begin
      Cells[i,0]:='';
      Cells[i,1]:='';
      Cells[i,2]:='';
    end;
  end;
  i:=0;
  j:=0;
  p:=a;
  FxR1(f, q, f_q);
  while (p<=b) do
  begin
    Application.ProcessMessages;
    if Interrompe then
    begin
      ShowMessage('Usu??rio cancelou.');
      Exit;
    end;
    if f_p*f_q <= 0 then
    begin
      Inc(i);
      with StringGrid1 do
      begin
        if ColCount < i+1 then
           ColCount := i+1 then;
        Cells[i,0]:=IntToStr(i);
        Cells[i,1]:=FloatToStr(p);
        Cells[i,2]:=FloatToStr(q);
      end;
      if f_q=0 then
      begin
        Inc(j);
        q:=a+j*Delta;
        FxR1(f, q, f_q);
      end;
    end;
    p:=q;
    f_p:=f_q;
    Inc(j);
    q:=a+j*Delta;       //q:=p+Delta;
    try
      Erro:=FxR1(f, q, f_q);
    except
      ShowMessage(IntToStr(Erro)+' - '+FloatToStr(q)+' - '+FloatToStr(f_q));
    end;
  end;
  if i=0 then
  begin
    ShowMessage('N??o foram encontradas regi??es com ind??cio de conter ra??zes.');
    Exit;
  end;
end;

procedure TForm1.Uniforme;
var
  k: Integer;
  p, q, f_p, f_q: Extended;
  Erro: Word;
begin
  //M??todo da Busca Uniforme para calcular ra??zes
  Interrompe:=False;         //Utilizado para controlar o Bot??o do p??nico
  Memo1.Clear;
  Memo1.Lines.Add('k'+#09+'p'+#09+'f(p)'+#09#09#09+'q'+#09+'f(q)');
  k:=1;
  p:=a;
  FxR1(f, p, f_p);
  q:=p+Epsilon;
  FxR1(f, q, f_q);
  Memo1.Lines.Add(IntToStr(k)+#09+FloatToStr(p)+#09+FloatToStr(f_p)+#09+FloatToStr(q)+#09+FloatToStr(f_q));
  while (p<=b) and (f_p * f_q > 0) do
  begin
    Application.ProcessMessages;
    if Interrompe then
    begin
      ShowMessage('Usu??rio cancelou');
      Exit;
    end;
    Inc(k);
    p:=q;
    f_p:=f_q;
    q:=p+Epsilon;
    FxR1(f, q, f_q);
    Label9.Caption:=InttoStr(k);      //Como coment??rio, n??o exibe a cada itera????o
    Memo1.Lines.Add(IntToStr(k)+#09+FloatToStr(p)+#09+FloatToStr(f_p)+#09+FloatToStr(q)+#09+FloatToStr(f_q));
  end;
  Raiz:=(p+q)/2;
  FxR1(f, Raiz, f_Raiz);
  Memo1.Lines.Add('Resultado: x = '+FloatToStr(Raiz)+'; f(x) = '+FloatToStr(f_Raiz));
  Edit9.Text:=FloatToStr(Raiz);
  Edit10.Text:=FloatToStr(f_Raiz);
  //Label9.Caption:=IntToStr(k);      //Sem coment??rio, exibe ao terminar
  if VerIteracoes then
     ClientHeight:=480;
  if VerGrafico then
  begin
    //Calcula e apresenta o gr??fico da fun????o e a raiz
    DesenhaGrafico(2);
    DesenhaRaiz;
    Form2.Show;
  end;
end;

procedure TForm1.Bissecao;
begin
  //M??todo da Bisse????o
  ShowMessage('Implementar a Bisse????o.');
end;

procedure TForm1.Cordas;
begin
   //M??todo das Cordas
  ShowMessage('Implementar Cordas.');
end;

procedure TForm1.CordasModificado;
begin
  //M??todo das Cordas Modificado
  ShowMessage('Implementar Cordas Modificado.');
end;

procedure TForm1.Newton;
begin
  //M??todo de Newton
  ShowMessage('Implementar Newton.');
end;

procedure TForm1.NewtonModificado;
begin
  //M??todo de Newton Modificado
  ShowMessage('Implementar Newton Modificado.');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //Atribuir tamanhos e posi????es        {uses Windows para GetSystemMetrics}
  ClientHeight := 324;
  StringGrid1.Height := 62+GetSystemMetrics(SM_CYHSCROLL)+GetSystemMetrics(SM_CYFRAME);
  StringGrid1.Cells[0,0] := 'i';
  StringGrid1.Cells[0,1]:='a[i]';
  StringGrid1.Cells[0,2]:='b[i]';
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  //Apresentar ou n??o as itera????es
  VerIteracoes:=not VerIteracoes;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  //Apresentar ou n??o o gr??fico
  VerGrafico:=not VerGrafico;
end;

procedure TForm1.RadioButtonQualquerClick(Sender: TObject);
begin
  //Seleciona o M??todo
  Metodo:=0;
  if RadioButton1.Checked then Metodo:=1;
  if RadioButton2.Checked then Metodo:=2;
  if RadioButton3.Checked then Metodo:=3;
  if RadioButton4.Checked then Metodo:=4;
  if RadioButton5.Checked then Metodo:=5;
  if RadioButton6.Checked then Metodo:=6;
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
  //Apresentar arquivo de ajuda
  if not openDocument('Ra??zes.chm') then
     ShowMessage('Infelizmete este programa n??o cont??m arquivo de ajuda.');
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  //Existem dados necess??rios para desenhar o gr??fico?
  //Verifica entrada de dados (f, a, b)
  if not VerificaDados(1) then
     Exit;
  Form2.Chart1LineSeries2.Clear;
  DesenhaGrafico(1);
  Form2.Show;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  //Exitem dados necess??rios para separar as ra??zes?
  //Verifica entrada de dados (f, a, b, Delta)
  if not VerificaDados(2) then
     Exit;
  UniformeSepara;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  //Bot??o p??nico
  Interrompe:=True;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  i: Integer;
begin
  Edit1.Text:='';
  Edit2.Text:='';
  Edit3.Text:='';
  Edit4.Text:='';
  with StringGrid1 do
  begin
    ColCount:=9;
    for i:=1 to ColCount-1 do
    begin
      Cells[i,0]:='';
      Cells[i,1]:='';
      Cells[i,2]:='';
    end;
  end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  Edit5.Text:=Edit1.Text;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  //Existem dados necess??rios para desenhar gr??fico?
  //Verifica dados de entrada (f, a, b)
  if not VerificaDados(3) then
     Exit;
  Form2.Chart1LineSeries2.Clear;
  DesenhaGrafico(2);
  Form2.Show;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
  //Calcular a raiz
  Interrompe:=False;    //Utilizado para controlar o Bot??o do p??nico
  //Limpa resposta anterior
  Edit9.Text:='';
  Edit10.Text:='';
  //Verifica entrada de dados
  //Existem dados necess??rios para calcular a raiz?
  if not VerificaDados(4) then
     Exit;
  ClientHeight:=324;
  //Existe m??todo selecionado?
  if Metodo=0 then
     begin
       ShowMessage('?? necess??rio escolher um M??todo!');
       Exit;
     end;
  //Executa m??todo selecionado
  if Metodo=1 then        //Busca Uniforme
     begin
       Uniforme;
       Exit;
     end;
  if Metodo=2 then        //M??todo da Bisse????o
     begin
       Bissecao;
       Exit;
     end;
  if Metodo=3 then        //M??todo das Cordas
     begin
       Cordas;
       Exit;
     end;
  if Metodo=4 then        //M??todo das Cordas Modificado
     begin
       CordasModificado;
       Exit;
     end;
  if Metodo=5 then        //M??todo de Newton
     begin
       Newton;
       Exit;
     end;
  if Metodo=6 then        //M??todo de Newton Modificado
     begin
       NewtonModificado;
       Exit;
     end;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  //Bot??o do p??nico
  Interrompe:=True;
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
  Edit5.Text:='';
  Edit6.Text:='';
  Edit7.Text:='';
  Edit8.Text:='';
  Edit9.Text:='';
  Edit10.Text:='';
  Label9.Caption:='0';
  ClientHeight:=324;
end;

procedure TForm1.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  CellCol, CellRow: Integer;
begin
  StringGrid1.MouseToCell(x, y, CellCol, CellRow);
  if CellCol=0 then
     Exit;
  Edit6.Text:=StringGrid1.Cells[CellCol,1];
  Edit7.Text:=StringGrid1.Cells[CellCol,2];
end;

end.

