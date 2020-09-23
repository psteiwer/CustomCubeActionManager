Class CustomCubeActions.Actions Extends %Persistent
{

Property Name As %String;

Property Class As %String;

Property Method As %String;

Property Cubes As list Of %String;

Storage Default
{
<Data name="ActionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Class</Value>
</Value>
<Value name="4">
<Value>Method</Value>
</Value>
<Value name="5">
<Value>Cubes</Value>
</Value>
</Data>
<DataLocation>^CustomCubeActions.ActionsD</DataLocation>
<DefaultData>ActionsDefaultData</DefaultData>
<IdLocation>^CustomCubeActions.ActionsD</IdLocation>
<IndexLocation>^CustomCubeActions.ActionsI</IndexLocation>
<StreamLocation>^CustomCubeActions.ActionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
