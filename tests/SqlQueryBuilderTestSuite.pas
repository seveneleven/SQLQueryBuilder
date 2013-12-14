unit SqlQueryBuilderTestSuite;

interface

uses TestFramework,
     InsertQueryTests,
     UpdateQueryTests,
     WhereClauseTests;

type
  TSqlQueryBuilderTestSuite = class(TTestSuite)
  public
    class function suite(): ITestSuite;
  end;

implementation

{ TSqlQueryBuilderTestSuite }

class function TSqlQueryBuilderTestSuite.suite: ITestSuite;
begin
  Result:= TTestSuite.Create('SqlQueryBuilder Test Suite');
  Result.AddSuite(TInsertQueryTests.Suite);
  Result.AddSuite(TUpdateQueryTests.Suite);
  Result.AddSuite(TWhereClauseTests.Suite);

end;

initialization
  RegisterTest(TSqlQueryBuilderTestSuite.suite);


end.