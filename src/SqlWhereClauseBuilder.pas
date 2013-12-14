unit SqlWhereClauseBuilder;

interface

uses
  SysUtils, Variants;

type
  TSqlWhereClauseBuilder = class;

  IWhereColumn = interface
    function Equals(value: Variant): TSqlWhereClauseBuilder;
  end;

  TWhereColumn = class(TInterfacedObject, IWhereColumn)
  private
    Owner: TSqlWhereClauseBuilder;
    Column: String;
  public
    constructor Create(withOwner: TSqlWhereClauseBuilder; andColumn: String);
    function Equals(value: Variant): TSqlWhereClauseBuilder;
  end;

  ISqlWhereClauseBuilder = interface
    function Where(column: String): IWhereColumn;
    function build: String;
  end;

  TSqlWhereClauseBuilder = class(TInterfacedObject, ISqlWhereClauseBuilder)
  private
    Query: String;
    WhereConditions: String;
  public
    constructor Create(withQuery: String);
    function Where(column: String): IWhereColumn;
    procedure addCondition(condition: String);
    function build: String;
  end;

implementation

{ TSqlWhereClauseBuilder }

constructor TSqlWhereClauseBuilder.Create(withQuery: String);
begin
  Query:= withQuery;
end;

function TSqlWhereClauseBuilder.Where(column: String): IWhereColumn;
begin
  Result:= TWhereColumn.Create(Self, column);
end;

procedure TSqlWhereClauseBuilder.addCondition(condition: String);
begin
  WhereConditions:= condition;
end;

function TSqlWhereClauseBuilder.build: String;
begin
  Result:= Trim(Query + ' WHERE ' + WhereConditions);
end;


{ TWhereColumn }

constructor TWhereColumn.Create(withOwner: TSqlWhereClauseBuilder; andColumn: String);
begin
  Owner:= withOwner;
  Column:= andColumn;
end;

function TWhereColumn.Equals(value: Variant): TSqlWhereClauseBuilder;
var val: String;
begin

  case VarType(value) of
    varString, varUString: val:= '"' + value + '"';
    else
      val:= value;
  end;

  owner.addCondition(Column+'='+val);
  Result:= Owner;
end;

end.
