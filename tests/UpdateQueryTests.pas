unit UpdateQueryTests;

interface

uses
  TestFrameWork,
  SqlQueryBuilder;

type
  TUpdateQueryTests = class(TTestCase)
  private
    queryBuilder: TSqlQueryBuilder;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestThatUpdateQueryTakesATable;
    procedure TestThatStringValueGetsAdded;
    procedure TestThatIntegerValueGetsAdded;
    procedure TestThatMultipleValuesAreAdded;
    procedure TestThatWhereClauseIsAppended;
    procedure TestThatUpdateQueryIsBuiltFromScratch;
  end;


implementation


procedure TUpdateQueryTests.SetUp;
begin
  queryBuilder:= TSqlQueryBuilder.Create;
end;

procedure TUpdateQueryTests.TearDown;
begin
  queryBuilder.Free;
  queryBuilder:= nil;
  inherited;
end;

procedure TUpdateQueryTests.TestThatUpdateQueryTakesATable;
begin
  CheckEqualsString('UPDATE table SET ', queryBuilder.Update('table').build());
end;

procedure TUpdateQueryTests.TestThatStringValueGetsAdded;
begin
  CheckEqualsString('UPDATE table SET col="value"',
    queryBuilder.Update('table').
      SetValue('col', 'value').
        build());
end;

procedure TUpdateQueryTests.TestThatIntegerValueGetsAdded;
begin
  CheckEqualsString('UPDATE table SET col=15',
    queryBuilder.Update('table').
      SetValue('col', 15).
        build());
end;

procedure TUpdateQueryTests.TestThatMultipleValuesAreAdded;
begin
  CheckEqualsString('UPDATE table SET col=7.11, col1=21474836480, col2=1, col3=0',
    queryBuilder.Update('table').
      SetValue('col', 7.11).
      SetValue('col1', 21474836480).
      SetValue('col2', True).
      SetValue('col3', False).
        build());
end;

procedure TUpdateQueryTests.TestThatWhereClauseIsAppended;
begin
  CheckEqualsString('UPDATE table SET col=10 WHERE id=20',
    queryBuilder.
      Update('table').
        SetValue('col', 10).
      Where('id').
        Equals(20).
        build());
end;

procedure TUpdateQueryTests.TestThatUpdateQueryIsBuiltFromScratch;
begin
  TestThatStringValueGetsAdded();
  TestThatStringValueGetsAdded();
end;

end.