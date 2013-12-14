unit WhereClauseTests;

interface

uses
  TestFrameWork,
  SqlWhereClauseBuilder;

type
  TWhereClauseTests = class(TTestCase)
  private
    builder: TSqlWhereClauseBuilder;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestThatStringEqualsConditionIsAdded;
    procedure TestThatIntegerEqualsConditionIsAdded;
  end;


implementation


procedure TWhereClauseTests.SetUp;
begin
  builder:= TSqlWhereClauseBuilder.Create('');
end;

procedure TWhereClauseTests.TearDown;
begin
  builder.Free;
  builder:= nil;
  inherited;
end;

procedure TWhereClauseTests.TestThatStringEqualsConditionIsAdded;
begin
  CheckEqualsString('WHERE col="name"', builder.Where('col').Equals('name').build);
end;

procedure TWhereClauseTests.TestThatIntegerEqualsConditionIsAdded;
begin
  CheckEqualsString('WHERE col=15', builder.Where('col').Equals(15).build);
end;

end.