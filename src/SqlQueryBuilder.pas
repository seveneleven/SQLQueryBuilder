unit SqlQueryBuilder;

interface

uses
  SysUtils,
  SqlWhereClauseBuilder;

type
  TInsertBuilder = class(TObject)
  private
    Columns: String;
    Values: String;
    QueryTable: String;
    procedure addValue(column, value: String);
  public
    function Into(table: String): TInsertBuilder;
    function Value(column: String; value: String): TInsertBuilder; overload;
    function Value(column: String; value: Integer): TInsertBuilder; overload;
    function Value(column: String; value: Int64): TInsertBuilder; overload;
    function Value(column: String; value: Extended): TInsertBuilder; overload;
    function Value(column: String; value: Boolean): TInsertBuilder; overload;
    function build: String;
  end;

  TUpdateQueryBuilder = class(TObject)
  private
    SetQuery: String;
    QueryTable: String;
    WhereClauseBuilder: ISqlWhereClauseBuilder;
    procedure addValue(column, value: String);
  public
    procedure setTable(table: String);
    function SetValue(column: String; value: String): TUpdateQueryBuilder; overload;
    function SetValue(column: String; value: Integer): TUpdateQueryBuilder; overload;
    function SetValue(column: String; value: Int64): TUpdateQueryBuilder; overload;
    function SetValue(column: String; value: Extended): TUpdateQueryBuilder; overload;
    function SetValue(column: String; value: Boolean): TUpdateQueryBuilder; overload;
    function Where(column: String): IWhereColumn;
    function build: String;
  end;

  TSqlQueryBuilder = class(TObject)
  private
    InsertBuilder: TInsertBuilder;
    UpdateBuilder: TUpdateQueryBuilder;
  public
    constructor Create;
    destructor Destroy; override;
    function Update(table: String): TUpdateQueryBuilder;
    property Insert: TInsertBuilder read InsertBuilder;
  end;

implementation

{ TSqlQueryBuilder }

constructor TSqlQueryBuilder.Create;
begin
  InsertBuilder:= TInsertBuilder.Create;
  UpdateBuilder:= TUpdateQueryBuilder.Create;
end;

destructor TSqlQueryBuilder.Destroy;
begin
  FreeAndNil(InsertBuilder);
  FreeAndNil(UpdateBuilder);

  inherited;
end;

function TSqlQueryBuilder.Update(table: String): TUpdateQueryBuilder;
begin
  UpdateBuilder.setTable(table);
  Result:= UpdateBuilder;
end;

{ TInsertBuilder }

function TInsertBuilder.Into(table: String): TInsertBuilder;
begin
  QueryTable:= table;
  Result:= Self;
end;

function TInsertBuilder.Value(column, value: String): TInsertBuilder;
begin
  addValue(column, '"'+value+'"');
  Result:= Self;
end;

function TInsertBuilder.Value(column: String; value: Integer): TInsertBuilder;
begin
  addValue(column, IntToStr(value));
  Result:= Self;
end;

function TInsertBuilder.Value(column: String; value: Int64): TInsertBuilder;
begin
  addValue(column, IntToStr(value));
  Result:= Self;
end;


function TInsertBuilder.Value(column: String; value: Extended): TInsertBuilder;
begin
  FormatSettings.DecimalSeparator:= '.';
  addValue(column, FloatToStr(value));
  Result:= Self;
end;

function TInsertBuilder.Value(column: String; value: Boolean): TInsertBuilder;
begin
  if(value) then begin
    addValue(column, '1');
  end else begin
    addValue(column, '0');
  end;
  Result:= Self;
end;

procedure TInsertBuilder.addValue(column, value: String);
begin
  if(Length(Columns) > 0) then begin
    Columns:= Columns + ', ';
  end;
  Columns:= Columns + '`'+column+'`';

  if(Length(Values) > 0) then begin
    Values:= Values + ', ';
  end;
  Values:= Values + value;
end;

function TInsertBuilder.build: String;
begin
  Result:= Format('INSERT INTO %s (%s) VALUES (%s)', [QueryTable, Columns, Values]);
end;

{ TUpdateQueryBuilder }

procedure TUpdateQueryBuilder.setTable(table: String);
begin
  QueryTable:= table;
end;

function TUpdateQueryBuilder.SetValue(column: String; value: String): TUpdateQueryBuilder;
begin
  addValue(column, '"'+value+'"');
  Result:= Self;
end;

function TUpdateQueryBuilder.SetValue(column: String; value: Integer): TUpdateQueryBuilder;
begin
  addValue(column, IntToStr(value));
  Result:= Self;
end;

function TUpdateQueryBuilder.SetValue(column: String; value: Int64): TUpdateQueryBuilder;
begin
  addValue(column, IntToStr(value));
  Result:= Self;
end;

function TUpdateQueryBuilder.SetValue(column: String; value: Extended): TUpdateQueryBuilder;
begin
  FormatSettings.DecimalSeparator:= '.';
  addValue(column, FloatToStr(value));
  Result:= Self;
end;

function TUpdateQueryBuilder.SetValue(column: String; value: Boolean): TUpdateQueryBuilder;
var val: String;
begin
  val:= '0';
  if value then begin
    val:= '1';
  end;
  addValue(column, val);
  Result:= Self;
end;

function TUpdateQueryBuilder.Where(column: String): IWhereColumn;
begin
  WhereClauseBuilder:= TSqlWhereClauseBuilder.Create(build());
  Result:= WhereClauseBuilder.Where(column);
end;

procedure TUpdateQueryBuilder.addValue(column, value: String);
begin
  if SetQuery <> '' then begin
    SetQuery:= SetQuery + ', ';
  end;
  SetQuery:= SetQuery + column + '=' + value;

end;

function TUpdateQueryBuilder.build: String;
begin
  Result:= 'UPDATE ' + QueryTable + ' SET ' + SetQuery;
end;


end.
