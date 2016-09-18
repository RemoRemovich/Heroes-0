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
  Params:  array [1..20,0..8] of Integer; // Главный массив параметров игроков
  record_number: integer; //номер записи (строки) в логе игры

implementation

uses Unit2;

{$R *.DFM}


procedure TForm1.FormCreate(Sender: TObject);
const
 FNames: array [0..20] of String = ('пусто.bmp',
  'игрок 01.bmp', 'игрок 02.bmp', 'игрок 03.bmp', 'игрок 04.bmp',
  'игрок 05.bmp', 'игрок 06.bmp', 'игрок 07.bmp', 'игрок 08.bmp',
  'игрок 09.bmp', 'игрок 10.bmp', 'игрок 11.bmp', 'игрок 12.bmp',
  'игрок 13.bmp', 'игрок 14.bmp', 'игрок 15.bmp', 'игрок 16.bmp',
  'игрок 17.bmp', 'игрок 18.bmp', 'игрок 19.bmp', 'игрок 20.bmp');
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
{Обеспечить нормальный Random!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
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

 function Battle(var pa, pd: Integer): Integer; // Выводит номер игрока-трупа
 var
  k: Integer; // Исп. для переключения ходящих игроков во время битвы
  l: Extended;
  i: integer; //переменная цикла
  winner: integer; //номер игрока-победителя битвы
 begin
  // начало записи лога битвы
  if Form2.StringGrid1.Cells[1,0] <> 'Атака' then
   with Form2.StringGrid1 do
    begin
      Cells[1,0]:='Атака';
      Cells[2,0]:='Защита';
      Cells[3,0]:='Повреждения';
      Cells[4,0]:='Здоровье';
      Cells[5,0]:='Здоровья';
      Cells[6,0]:='Уровень';
    end;


   with Form2.StringGrid1 do
   begin
    inc (record_number);
    RowCount := RowCount + 1;
    Cells[0, record_number] := 'Атакующий';
    for i:=1 to 6 do
      Cells[i, record_number] := IntToStr (Params [pa, i+2]);
    //Cells[7, record_number] := IntToStr(record_number);

    inc (record_number);      
    RowCount := RowCount + 1;
    Cells[0, record_number] := 'Защищающийся';
    for i:=1 to 6 do
      Cells[i, record_number] := IntToStr (Params [pd, i+2]); 
    //Cells[7, record_number] := IntToStr(record_number);
   end;
  // конец записи лога битвы

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
    Cells[0, record_number] := 'Победивший';
    for i:=1 to 6 do
      Cells[i, record_number] := IntToStr (Params [winner, i+2]);

    inc (record_number); // для ввода пустой строки в лог 
    RowCount := RowCount + 1;
   end;
 end;

 procedure OnError1;
 begin
  Application.MessageBox('Введите число от 2 до 20 включительно!',
  'Ошибка', mb_TaskModal+mb_Ok);
 end;

label
 lb1, lb2, lb3, lb4, lb5;
var
 x, y, k: Integer;    // Исп. для рисования картинки игрока
 n2: Integer;         // Исп. для создания массива начальных параметров
 n1: Integer;         // Исп. для проведения паузы (3e8 = 1 секунда)
 n: Integer;          // Исп. для изменения параметров умершего сейчас игрока
 PlrsQuant: Integer;  // Начальное количество игроков
 AlivePlrs: Integer;  // Количество живых игроков
 ActivePlr: Integer;  // Активный в данный момент игрок
 DeadPlr: Integer;    // Игрок, погибший во время битвы
 BattleWinPlr: Integer; // Игрок, выигравший битву
 a, b: Integer;       // Исп. для проверки наложения игроков
 b1: Integer;         // Исп. для изменения параметров погибшего в битве игрока
 x0, y0: Integer;     // Координаты активного игрока перед началом его движения
 Params0: array [1..20,0..8] of Integer; // Массив начальных параметров игроков
 Num: Extended;       // Исп. для округления чисел
 n3, Winner: Integer; // Исп. для определения игрока-победителя
 l: Extended;         // Исп. для функции Trunc
 t: Integer;          // Исп. для создания паузы
// record_number: integer; //номер записи (строки) в логе игры
begin
 // Очистка DrawGrid1, если начинается непервая игра:
{1}lb1: if GameIsFirst = False then DrawGrid1.Repaint;

 record_number := 0;

 // Установка начальных параметров для игры:
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

 // Игра:
 // Установка параметров каждого из игроков:
 for a := 1 to PlrsQuant do
 begin
  Params[a, 0] := a;                   // номер игрока
{2}lb2: Params[a, 1] := Random(10)+1;  // координата X
        Params[a, 2] := Random(10)+1;  // координата Y
  // Проверка наложения одного игрока на другого:   
  if a > 1 then
  for b := 1 to (a - 1) do
  if (Params[b,1]=Params[a,1]) and (Params[b,2]=Params[a,2]) then goto lb2;
  // Рисование игрока в его начальном положении:
  x := Params[a, 1];
  y := Params[a, 2];
  k := a;
  BmpDraw(x, y, k);
  // Продолжение установки параметров игрока:
  Params[a, 3] := Random(9) + 1;       // атака
  Params[a, 4] := 10 - Params[a, 3];   // защита
  Params[a, 5] := Random(6) + 17;     // наносимые повреждения
  Params[a, 6] := Random(21) + 9580;    // здоровье
  Params[a, 7] := Params[a, 6];        // здоровья
  Params[a, 8] := 0;                   // уровень развития
 end;
 // Сохранение параметров игроков в массив их начальных параметров:
 for a := 1 to PlrsQuant do
 for n2 := 0 to 8 do Params0[a, n2] := Params[a, n2];
 // Пауза:
 for n1 := 1 to 400000000 do ;

 // Параметры установлены и сохранены. Игроки начинают ходить по полю:
 repeat
 begin
  ActivePlr := (ActivePlr mod 21);
  if ActivePlr = 0 then inc(ActivePlr);
  if Params[ActivePlr, 7] < 1 then goto lb4;// Если игрок мёртв, то он не ходит
  x0 := Params[ActivePlr, 1]; // Координата X перед началом движения игрока
  y0 := Params[ActivePlr, 2]; // Координата Y перед началом движения игрока
{3}lb3: Params[ActivePlr, 1] := (Params[ActivePlr, 1] + Random(3) - 1); // Новая координата X
        Params[ActivePlr, 2] := (Params[ActivePlr, 2] + Random(3) - 1); // Новая координата Y
  // Проверка возможности перемещения игрока на новые координаты:
  if ((Params[ActivePlr, 1] < 1) or (Params[ActivePlr, 1] > 10)
     or (Params[ActivePlr, 2] < 1) or (Params[ActivePlr, 2] > 10))
     or ((Params[ActivePlr, 1] = x0) and (Params[ActivePlr, 1] = y0))
  then
  begin
   Params[ActivePlr, 1] := x0;
   Params[ActivePlr, 2] := y0;
   goto lb3;
  end;
  // Перерисовка картинки игрока после изменений его координат и после проверки:
  // Удаление картинки игрока на его старых координатах:
  x := x0;
  y := y0;
  k := 0;
  BmpDraw(x, y, k);
  // Рисование картинки игрока на его новых координатах:
  x := Params[ActivePlr, 1];
  y := Params[ActivePlr, 2];
  k := ActivePlr;                                
  BmpDraw(x, y, k);
  // Пауза:
  for n1 := 1 to t do ;
  // Проверка наложения игроков (т.е. возможности начала битвы):
  for b := 1 to PlrsQuant do
  if (Params[b,1]=Params[ActivePlr,1]) and (Params[b,2]=Params[ActivePlr,2])
  and (b <> ActivePlr)
  then
   begin
    b1 := b;
    DeadPlr := Battle(ActivePlr, b1); // <-- Битва
    for n := 0 to 8 do       // <-- Изменение параметров умершего игрока
    Params[DeadPlr, n] := 0; // <-- Изменение параметров умершего игрока
    dec(AlivePlrs);         // <-- Уменьшение количества активных игроков
    // Рисование картинки выжившего игрока:
    if DeadPlr = ActivePlr then BattleWinPlr := b1 else BattleWinPlr := ActivePlr;
    x := Params[BattleWinPlr, 1];
    y := Params[BattleWinPlr, 2];
    k := BattleWinPlr;
    BmpDraw(x, y, k);
    // Пауза:
    for n1 := 1 to t do ;
    // Изменение параметров выжившего игрока:
    if BattleWinPlr = b1 then
    inc(Params[BattleWinPlr, 4]) else inc(Params[BattleWinPlr, 3]); // ЗА/АТ
    l := (Params[BattleWinPlr, 6])*1.02;
    Params[BattleWinPlr, 6] := Trunc(l);                            // Увел. ЗЕ
    Params[BattleWinPlr, 7] := Params[BattleWinPlr, 6];             // Восст. ЗЯ
    l := (Params[BattleWinPlr, 5])*1.02;
    Params[BattleWinPlr, 5] := Trunc(l);                            // Увел. НП
    inc(Params[BattleWinPlr, 8]);                                   // Увел. УР
   end;
{4}lb4: inc(ActivePlr);
 // Пауза:
// for n1 := 1 to t do ;
 end
 until AlivePlrs = 1;

 // Определяется игрок-победитель:
 for n3 := 1 to PlrsQuant do if Params[n3, 7] > 0 then Winner := n3;

 //Выдаются начальные и конечные параметры игрока-победителя:
 Form2.ShowModal;
{
 Application.MessageBox(PChar('Победил игрок под номером '+
 IntToStr(Params[Winner, 0])+'!  '+#13#10+
 'Его начальные параметры: '+
 IntToStr(Params0[Winner, 3])+'(АТ), '+
 IntToStr(Params0[Winner, 4])+'(ЗА), '+
 IntToStr(Params0[Winner, 5])+'(НП), '+
 IntToStr(Params0[Winner, 6])+'(ЗЕ), '+
 IntToStr(Params0[Winner, 8])+'(УР).'+#13#10+
 'Его конечные параметры: '+
 IntToStr(Params[Winner, 3])+'(АТ), '+
 IntToStr(Params[Winner, 4])+'(ЗА), '+
 IntToStr(Params[Winner, 5])+'(НП), '+
 IntToStr(Params[Winner, 6])+'(ЗЕ), '+
 IntToStr(Params[Winner, 8])+'(УР), '),
 PChar('Результаты'),
 mb_TaskModal+mb_Ok);
                       }
 // После окончания игры:
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
