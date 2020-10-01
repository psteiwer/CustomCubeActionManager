Class CustomCubeActions.Actions Extends %Persistent
{

Property Name As %String;

Property Class As %String;

Property Method As %String;

Property Cubes As list Of %String;

ClassMethod AddAction(pName = "", pClass = "", pMethod = "", pCubes = "") As %Status
{
    Set tSC=$$$OK

    Set tAction=##class(CustomCubeActions.Actions).%New()
    Set tSC=tAction.UpdateAction(pName,pClass,pMethod,pCubes)

    Quit tSC
}

ClassMethod ModifyAction(pID = "", pName = "", pClass = "", pMethod = "", pCubes = "") As %Status
{
    Set tSC=$$$OK

    Set tAction=##class(CustomCubeActions.Actions).%OpenId(pID)
    Set tSC=tAction.UpdateAction(pName,pClass,pMethod,pCubes)

    Quit tSC
}

Method UpdateAction(pName = "", pClass = "", pMethod = "", pCubes = "") As %Status
{
    Set tSC=$$$OK
    
    Set ..Name=pName
    Set ..Class=pClass
    Set ..Method=pMethod
    Set tSC=..Cubes.Clear()
    Quit:$$$ISERR(tSC) tSC
    For tCubeCounter=1:1:$Length(pCubes,",") {
        Set tSC=..Cubes.Insert($Piece(pCubes,",",tCubeCounter))
        Quit:$$$ISERR(tSC)
    }

    Set tSC=..%Save()
    Quit tSC
}

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
