unit InsertQueryTests;

interface

uses
  TestFrameWork,
  SqlQueryBuilder;

type
  TInsertQueryTests = class(TTestCase)
  private
    queryBuilder: TSqlQueryBuilder;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestThatInsertQueryContainsATable;
    procedure TestThatStringValueGetsAddedToInsertQuery;
    procedure TestThatIntegerValueGetsAddedToInsertQuery;
    procedure TestThatInt64ValueGetsAddedToInsertQuery;
    procedure TestThatQueryCanTakeMultipleValues;
    procedure TestThatFalseBooleanGetsConvertedToZero;
    procedure TestThatTrueBooleanGetsConvertedToOne;
    procedure TestThatASecondQueryIsBuiltFromScratch;
  end;



implementation

{ TInsertQueryTests }

procedure TInsertQueryTests.SetUp;
begin
  queryBuilder:= TSqlQueryBuilder.Create;
end;

procedure TInsertQueryTests.TearDown;
begin
  queryBuilder.Free;
  queryBuilder:= nil;
  inherited;
end;

procedure TInsertQueryTests.TestThatInsertQueryContainsATable;
begin
  CheckEqualsString('INSERT INTO table () VALUES ()', queryBuilder.Insert.Into('table').build());
end;

procedure TInsertQueryTests.TestThatStringValueGetsAddedToInsertQuery;
begin
  CheckEqualsString('INSERT INTO table (`col`) VALUES ("text")',
    queryBuilder.Insert.Into('table').
      value('col', 'text').
        build());
end;

procedure TInsertQueryTests.TestThatIntegerValueGetsAddedToInsertQuery;
begin
  CheckEqualsString('INSERT INTO table (`col`) VALUES (711)',
    queryBuilder.Insert.Into('table').
      value('col', 711).
        build());
end;

procedure TInsertQueryTests.TestThatInt64ValueGetsAddedToInsertQuery;
begin
  CheckEqualsString('INSERT INTO table (`col`) VALUES (2147483648)',
    queryBuilder.Insert.Into('table').
      value('col', 2147483648).
        build());
end;

procedure TInsertQueryTests.TestThatQueryCanTakeMultipleValues;
begin
  CheckEqualsString('INSERT INTO table (`col1`, `col2`, `col3`) VALUES (711, "a name", 12.5)',
    queryBuilder.Insert.Into('table').
      value('col1', 711).
      value('col2', 'a name').
      value('col3', 12.5).
        build());
end;

procedure TInsertQueryTests.TestThatFalseBooleanGetsConvertedToZero;
begin
  CheckEqualsString('INSERT INTO table (`boolean`) VALUES (0)',
    queryBuilder.Insert.Into('table').
      value('boolean', False).
        build());
end;

procedure TInsertQueryTests.TestThatTrueBooleanGetsConvertedToOne;
begin
  CheckEqualsString('INSERT INTO table (`boolean`) VALUES (1)',
    queryBuilder.Insert.Into('table').
      value('boolean', True).
        build());
end;

procedure TInsertQueryTests.TestThatASecondQueryIsBuiltFromScratch;
begin
  TestThatStringValueGetsAddedToInsertQuery();
  TestThatStringValueGetsAddedToInsertQuery();
end;

end.