unit HeroesUn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls, Spin, Buttons, Grids, ExtCtrls, Mask, ComCtrls;

type
  TForm1 = class(TForm)
    DrawGrid1: TDrawGrid;
    Panel1: TPanel;
    Button1: TButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    slBitMap: TStringList;
  end;

var
  Form1: TForm1;
  GameIsFirst: Boolean = True;
  Params:  array [1..20,0..8] of Integer; // ������� ������ ���������� �������
  record_number: integer; //����� ������ (������) � ���� ����

implementation

uses Unit2;

{$R *.DFM}


procedure TForm1.FormCreate(Sender: TObject);
const
 FNames: array [0..20] of String = ('�����.bmp',
  '����� 01.bmp', '����� 02.bmp', '����� 03.bmp', '����� 04.bmp',
  '����� 05.bmp', '����� 06.bmp', '����� 07.bmp', '����� 08.bmp',
  '����� 09.bmp', '����� 10.bmp', '����� 11.bmp', '����� 12.bmp',
  '����� 13.bmp', '����� 14.bmp', '����� 15.bmp', '����� 16.bmp',
  '����� 17.bmp', '����� 18.bmp', '����� 19.bmp', '����� 20.bmp');
var
 k: Integer;
begin
 slBitMap := TStringList.Create;
 with slBitMap do for k := 0 to 20 do
 begin
  Add(FNames[k]);
  Objects[k] := TBitMap.Create;
  (Objects[k] as TBitMap).LoadFromFile(FNames[k])
 end;
end;


procedure TForm1.FormActivate(Sender: TObject);
begin
 Edit1.SetFocus;
 Application.Title := 'Heroes 0';
end;


procedure TForm1.Button1Click(Sender: TObject);
{���������� ���������� Random!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
 procedure BmpDraw(var x, y, k: Integer);
 begin
  with DrawGrid1.Canvas, slBitMap do
  Draw(32*(x - 1), 32*(y - 1), (Objects[k] as TBitMap));
 end;

 function Trunc(var Num: Extended): Integer;
 begin
  Result := -1001;
  repeat
   if Num < Result then Exit;
   inc(Result);
  until Num < Result;
 end;

 function Battle(var pa, pd: Integer): Integer; // ������� ����� ������-�����
 var
  k: Integer; // ���. ��� ������������ ������� ������� �� ����� �����
  l: Extended;
  i: integer; //���������� �����
  winner: integer; //����� ������-���������� �����
 begin
  // ������ ������ ���� �����
  if Form2.StringGrid1.Cells[1,0] <> '�����' then
   with Form2.StringGrid1 do
    begin
      Cells[1,0]:='�����';
      Cells[2,0]:='������';
      Cells[3,0]:='�����������';
      Cells[4,0]:='��������';
      Cells[5,0]:='��������';
      Cells[6,0]:='�������';
    end;


   with Form2.StringGrid1 do
   begin
    inc (record_number);
    RowCount := RowCount + 1;
    Cells[0, record_number] := '���������';
    for i:=1 to 6 do
      Cells[i, record_number] := IntToStr (Params [pa, i+2]);
    //Cells[7, record_number] := IntToStr(record_number);

    inc (record_number);      
    RowCount := RowCount + 1;
    Cells[0, record_number] := '������������';
    for i:=1 to 6 do
      Cells[i, record_number] := IntToStr (Params [pd, i+2]); 
    //Cells[7, record_number] := IntToStr(record_number);
   end;
  // ����� ������ ���� �����

  k := 2;
  while not (Params[pa, 7] < 1) or not (Params[pd, 7] < 1) do
   if (k mod 2) = 0 then
    begin
     l := (Params[pa, 5])*(1 + Params[pa, 3]/100)*(1 - Params[pd, 4]/100);
     Params[pd, 7] := (Params[pd, 7] - Trunc(l));
     inc(k);
    end
   else
    begin
     l := (Params[pd, 5])*(1 + Params[pd, 3]/100)*(1 - Params[pa, 4]/100);
     Params[pa, 7] := (Params[pa, 7] - Trunc(l));
     inc(k);
    end;

  if
    Params[pd, 7] < 1
  then
    begin
      Result := pd; winner := pa;
    end
  else
    begin
      Result := pa;
      winner := pd;
    end;

   with Form2.StringGrid1 do
   begin
    inc (record_number);   
    RowCount := RowCount + 1;
    Cells[0, record_number] := '����������';
    for i:=1 to 6 do
      Cells[i, record_number] := IntToStr (Params [winner, i+2]);

    inc (record_number); // ��� ����� ������ ������ � ��� 
    RowCount := RowCount + 1;
   end;
 end;

 procedure OnError1;
 begin
  Application.MessageBox('������� ����� �� 2 �� 20 ������������!',
  '������', mb_TaskModal+mb_Ok);
 end;

label
 lb1, lb2, lb3, lb4, lb5;
var
 x, y, k: Integer;    // ���. ��� ��������� �������� ������
 n2: Integer;         // ���. ��� �������� ������� ��������� ����������
 n1: Integer;         // ���. ��� ���������� ����� (3e8 = 1 �������)
 n: Integer;          // ���. ��� ��������� ���������� �������� ������ ������
 PlrsQuant: Integer;  // ��������� ���������� �������
 AlivePlrs: Integer;  // ���������� ����� �������
 ActivePlr: Integer;  // �������� � ������ ������ �����
 DeadPlr: Integer;    // �����, �������� �� ����� �����
 BattleWinPlr: Integer; // �����, ���������� �����
 a, b: Integer;       // ���. ��� �������� ��������� �������
 b1: Integer;         // ���. ��� ��������� ���������� ��������� � ����� ������
 x0, y0: Integer;     // ���������� ��������� ������ ����� ������� ��� ��������
 Params0: array [1..20,0..8] of Integer; // ������ ��������� ���������� �������
 Num: Extended;       // ���. ��� ���������� �����
 n3, Winner: Integer; // ���. ��� ����������� ������-����������
 l: Extended;         // ���. ��� ������� Trunc
 t: Integer;          // ���. ��� �������� �����
// record_number: integer; //����� ������ (������) � ���� ����
begin
 // ������� DrawGrid1, ���� ���������� �������� ����:
{1}lb1: if GameIsFirst = False then DrawGrid1.Repaint;

 record_number := 0;

 // ��������� ��������� ���������� ��� ����:
 Label1.Enabled := False;
 Button1.Enabled := False;
 CheckBox1.Enabled := False;
 Edit1.Enabled := False;
 if Edit1.Text = '' then
  begin
   OnError1;
   goto lb5;
  end;
 PlrsQuant := StrToInt(Trim(Edit1.Text));
 if (PlrsQuant > 20) or (PlrsQuant < 2) then
  begin
   OnError1;
   goto lb5;
  end; 
 AlivePlrs := PlrsQuant;
 ActivePlr := 1;
// if CheckBox1.Checked then t := 60000000 else t := 4000000;
 t := StrToInt (Edit2.Text) * 1000000;

 // ����:
 // ��������� ���������� ������� �� �������:
 for a := 1 to PlrsQuant do
 begin
  Params[a, 0] := a;                   // ����� ������
{2}lb2: Params[a, 1] := Random(10)+1;  // ���������� X
        Params[a, 2] := Random(10)+1;  // ���������� Y
  // �������� ��������� ������ ������ �� �������:   
  if a > 1 then
  for b := 1 to (a - 1) do
  if (Params[b,1]=Params[a,1]) and (Params[b,2]=Params[a,2]) then goto lb2;
  // ��������� ������ � ��� ��������� ���������:
  x := Params[a, 1];
  y := Params[a, 2];
  k := a;
  BmpDraw(x, y, k);
  // ����������� ��������� ���������� ������:
  Params[a, 3] := Random(9) + 1;       // �����
  Params[a, 4] := 10 - Params[a, 3];   // ������
  Params[a, 5] := Random(6) + 17;     // ��������� �����������
  Params[a, 6] := Random(21) + 9580;    // ��������
  Params[a, 7] := Params[a, 6];        // ��������
  Params[a, 8] := 0;                   // ������� ��������
 end;
 // ���������� ���������� ������� � ������ �� ��������� ����������:
 for a := 1 to PlrsQuant do
 for n2 := 0 to 8 do Params0[a, n2] := Params[a, n2];
 // �����:
 for n1 := 1 to 400000000 do ;

 // ��������� ����������� � ���������. ������ �������� ������ �� ����:
 repeat
 begin
  ActivePlr := (ActivePlr mod 21);
  if ActivePlr = 0 then inc(ActivePlr);
  if Params[ActivePlr, 7] < 1 then goto lb4;// ���� ����� ����, �� �� �� �����
  x0 := Params[ActivePlr, 1]; // ���������� X ����� ������� �������� ������
  y0 := Params[ActivePlr, 2]; // ���������� Y ����� ������� �������� ������
{3}lb3: Params[ActivePlr, 1] := (Params[ActivePlr, 1] + Random(3) - 1); // ����� ���������� X
        Params[ActivePlr, 2] := (Params[ActivePlr, 2] + Random(3) - 1); // ����� ���������� Y
  // �������� ����������� ����������� ������ �� ����� ����������:
  if ((Params[ActivePlr, 1] < 1) or (Params[ActivePlr, 1] > 10)
     or (Params[ActivePlr, 2] < 1) or (Params[ActivePlr, 2] > 10))
     or ((Params[ActivePlr, 1] = x0) and (Params[ActivePlr, 1] = y0))
  then
  begin
   Params[ActivePlr, 1] := x0;
   Params[ActivePlr, 2] := y0;
   goto lb3;
  end;
  // ����������� �������� ������ ����� ��������� ��� ��������� � ����� ��������:
  // �������� �������� ������ �� ��� ������ �����������:
  x := x0;
  y := y0;
  k := 0;
  BmpDraw(x, y, k);
  // ��������� �������� ������ �� ��� ����� �����������:
  x := Params[ActivePlr, 1];
  y := Params[ActivePlr, 2];
  k := ActivePlr;                                
  BmpDraw(x, y, k);
  // �����:
  for n1 := 1 to t do ;
  // �������� ��������� ������� (�.�. ����������� ������ �����):
  for b := 1 to PlrsQuant do
  if (Params[b,1]=Params[ActivePlr,1]) and (Params[b,2]=Params[ActivePlr,2])
  and (b <> ActivePlr)
  then
   begin
    b1 := b;
    DeadPlr := Battle(ActivePlr, b1); // <-- �����
    for n := 0 to 8 do       // <-- ��������� ���������� �������� ������
    Params[DeadPlr, n] := 0; // <-- ��������� ���������� �������� ������
    dec(AlivePlrs);         // <-- ���������� ���������� �������� �������
    // ��������� �������� ��������� ������:
    if DeadPlr = ActivePlr then BattleWinPlr := b1 else BattleWinPlr := ActivePlr;
    x := Params[BattleWinPlr, 1];
    y := Params[BattleWinPlr, 2];
    k := BattleWinPlr;
    BmpDraw(x, y, k);
    // �����:
    for n1 := 1 to t do ;
    // ��������� ���������� ��������� ������:
    if BattleWinPlr = b1 then
    inc(Params[BattleWinPlr, 4]) else inc(Params[BattleWinPlr, 3]); // ��/��
    l := (Params[BattleWinPlr, 6])*1.02;
    Params[BattleWinPlr, 6] := Trunc(l);                            // ����. ��
    Params[BattleWinPlr, 7] := Params[BattleWinPlr, 6];             // �����. ��
    l := (Params[BattleWinPlr, 5])*1.02;
    Params[BattleWinPlr, 5] := Trunc(l);                            // ����. ��
    inc(Params[BattleWinPlr, 8]);                                   // ����. ��
   end;
{4}lb4: inc(ActivePlr);
 // �����:
// for n1 := 1 to t do ;
 end
 until AlivePlrs = 1;

 // ������������ �����-����������:
 for n3 := 1 to PlrsQuant do if Params[n3, 7] > 0 then Winner := n3;

 //�������� ��������� � �������� ��������� ������-����������:
 Form2.ShowModal;
{
 Application.MessageBox(PChar('������� ����� ��� ������� '+
 IntToStr(Params[Winner, 0])+'!  '+#13#10+
 '��� ��������� ���������: '+
 IntToStr(Params0[Winner, 3])+'(��), '+
 IntToStr(Params0[Winner, 4])+'(��), '+
 IntToStr(Params0[Winner, 5])+'(��), '+
 IntToStr(Params0[Winner, 6])+'(��), '+
 IntToStr(Params0[Winner, 8])+'(��).'+#13#10+
 '��� �������� ���������: '+
 IntToStr(Params[Winner, 3])+'(��), '+
 IntToStr(Params[Winner, 4])+'(��), '+
 IntToStr(Params[Winner, 5])+'(��), '+
 IntToStr(Params[Winner, 6])+'(��), '+
 IntToStr(Params[Winner, 8])+'(��), '),
 PChar('����������'),
 mb_TaskModal+mb_Ok);
                       }
 // ����� ��������� ����:
{5}lb5: Label1.Enabled := True;
 Button1.Enabled := True;
 CheckBox1.Enabled := True;
 Edit1.Enabled := True;
 Edit1.SetFocus;
 GameIsFirst := False;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
 slBitMap.Free;
end;


end.
